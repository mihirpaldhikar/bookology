const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/user.model');
const {mongoManager} = require('../configs/database.config');
const {firebaseAdmin} = require('../configs/firebase.config');
const userCollection = mongoManager.db('Bookology').collection('Users');
const bookCollection = mongoManager.db('Bookology').collection('Books');
const moment = require('moment');
const MailService = require('../services/email.service');
const {verifyToken} = require('../middlewares/verify.middleware');
const {authorizeToken} = require('../middlewares/authorize.middleware');
const Crypto = require('../managers/encryption.manager');


router.post('/signup', authorizeToken, async (request, response, next) => {
  const userData = User.setUser({
    _id: request.body.id,
    username: request.body.username,
    auth_provider: request.query.auth_provider ?? 'unknown',
    bio: '',
    email: request.body.email,
    password: request.body.password,
    profile_picture_url: request.body.profile_picture_url,
    first_name: request.body.first_name,
    last_name: request.body.last_name,
  });

  if (await userCollection.countDocuments() !== 0) {
    if (await userCollection.findOne({username: request.body.username}) !== null) {
      response.status(409).json({
        result: {
          message: 'The username is already taken. Please choose other username.',
          status_code: 409,
        },
      });

      return false;
    }
  }


  await userCollection.insertOne(userData, async (error, result) => {
    if (error) {
      response.status(500).json({
        result: {
          message: 'An error occurred while creating user.',
          status_code: 500,
        },
      });

      return false;
    }
    await jwt.sign({
      user_id: Crypto.encrypt(request.body.id),
      email: Crypto.encrypt(request.body.email),
      email_verified: false,
      password: Crypto.encrypt(request.body.password),
      created_on: moment().format('dddd DD MM YYYY hh mm ss'),
    }, process.env.JWT_EMAIL_VERIFICATION_TOKEN, {expiresIn: '300s'}, async (err, token) => {
      response.status(201).json({
        result: {
          message: 'User successfully registered. Please verify your email',
          status_code: 201,
        },
      });

      await MailService
          .sendWelcomeEmail(request.body.username, request.body.email,
              `http://localhost:3000/auth/verification/${token}`);
    });
  });
});

router.post('/delete', verifyToken, async (request, response, next) => {
  jwt.verify(request.token, process.env.JWT_SECRET_TOKEN, async (error, authData) => {
    if (error) {
      response.sendStatus(403);
    } else {
      if (await userCollection.findOne({_id: Crypto.decrypt(authData.user_id)}) === null) {
        response.status(404).json({
          result: {
            message: 'An error occurred while deleting user. User not found.',
            status_code: 404,
          },
        });
        return false;
      }
      await userCollection.findOneAndDelete({_id: Crypto.decrypt(authData.user_id)});
      await bookCollection.deleteMany({uploader_id: Crypto.decrypt(authData.user_id)});
      await firebaseAdmin.auth().deleteUser(Crypto.decrypt(authData.user_id));
      await firebaseAdmin.firestore().collection('Secrets').doc(Crypto.decrypt(authData.user_id)).delete();
      response.status(200).json({
        result: {
          message: 'User successfully deleted.',
          status_code: 200,
        },
      });

      await MailService.sendDeleteEmail(authData.email, authData.user_id);
    }
  });
});

router.get('/verification/:token', async (request, response, next) => {
  const token = request.params.token;
  jwt.verify(token, process.env.JWT_EMAIL_VERIFICATION_TOKEN, async (error, data) => {
    if (error) {
      response.status(500).json({
        result: {
          message: 'An error occurred while verifying user.',
          status_code: 500,
        },
      });

      return false;
    }


    await userCollection.findOneAndUpdate({_id: Crypto.decrypt(data.user_id)}, {$set: {email_verified: true}});
    const user = await userCollection.findOne({_id: Crypto.decrypt(data.user_id)});
    await firebaseAdmin.auth().updateUser(Crypto.decrypt(data.user_id), {
      displayName: `${user.first_name} ${user.last_name}`,
      photoURL: Crypto.decrypt(user.profile_picture_url),
      emailVerified: true,
    });
    jwt.sign({
      user_id: data.user_id,
      email: data.email,
      password: data.password,
      email_verified: true,
      created_on: moment().format('dddd DD MM YYYY hh mm ss'),
    }, process.env.JWT_SECRET_TOKEN, async (error, token) => {
      await firebaseAdmin.firestore().collection(`Secrets`).doc(Crypto.decrypt(data.user_id)).set({
        user_id: Crypto.decrypt(data.user_id),
        authorizeToken: token,
      });
      response.status(200).json({
        result: {
          message: 'Successfully verified.',
          status_code: 200,
        },
      });
    });
  });
});

router.post('/pub', async (req, res) => {
  await firebaseAdmin.auth().createUser({
    email: 'mihir@google.com',
    displayName: 'Mihir',
    password: '1234567890',
  });

  res.json({
    ok: 'ok',
  });
});
module.exports = router;
