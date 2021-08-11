const express = require('express');
const router = express.Router();
const User = require('../models/user.model');
const {UsersCollection, BooksCollection} = require('../managers/collection.manager');
const {verifyUser} = require('../middlewares/verify.middleware');
const jwt = require('jsonwebtoken');
const {firebaseAdmin} = require('../configs/firebase.config');

router.get('/:userID', verifyUser, async (request, response, next) => {
  try {
    if (request.query.with_books === 'true') {
      const user = await UsersCollection.findOne({_id: request.params.userID});

      if (user == null) {
        response.status(404).json({
          result: {
            message: 'User not found with the user ID.',
            status_code: 404,
          },
        });
        return false;
      }

      await BooksCollection.find({uploader_id: user._id}).sort({$natural: -1}).toArray(function(error, result) {
        response.status(200).json(User.getUserWithBooks(user, result));
      });
      return false;
    }

    const user = await UsersCollection.findOne({_id: request.params.userID});
    if (user == null) {
      response.status(404).json({
        result: {
          message: 'User not found with the user ID.',
          status_code: 404,
        },
      });
      return false;
    }

    response.status(200).json(User.getUser(user));
  } catch (error) {
    console.log(error);
    response.status(500).json({
      result: {
        message: 'An error internal error occurred',
        status_code: 500,
      },
    });
  }
});

router.put('/:userID', verifyUser, async (request, response, next) => {
  try {
    jwt.verify(request.token, process.env.JWT_SECRET_TOKEN, async (err, authData) => {
      if (err) {
        response.status(403).json({
          result: {
            message: 'Error in verifying user key. Key Invalid or not provided.',
            status_code: 403,
          },
        });
        return false;
      } else {
        const user = await UsersCollection.findOne({_id: request.params.userID});
        console.log(request.params.userID);
        if (user == null) {
          response.status(404).json({
            result: {
              message: 'No User with the give ID.',
              status_code: 404,
            },
          });
          return false;
        }

        if (user._id !== authData.user_id) {
          response.status(403).json({
            result: {
              message: 'User  Update Forbidden.',
              status_code: 403,
            },
          });
          return false;
        }

        if (user.user_information.username !== request.body.username) {
          const username = await UsersCollection.findOne({'user_information.username': request.body.username});
          if (username !== null) {
            response.status(409).json({
              result: {
                message: 'The username is already taken. Please choose other username.',
                status_code: 409,
              },
            });

            return false;
          }
        }

        const userData = User.updateUser({
          username: request.body.username,
          bio: request.body.bio,
          profile_picture_url: request.body.profile_picture_url,
          first_name: request.body.first_name,
          last_name: request.body.last_name,
          _id: user._id,
          auth_provider: user.providers.auth,
          email: user.user_information.email,
          email_verified: user.additional_information.email_verified,
          date: user.joined_on.date,
          time: user.joined_on.time,
          suspended: user.additional_information.suspended,
          verified: user.user_information.verified,
        });

        await firebaseAdmin.auth().updateUser(authData.user_id, {
          displayName: `${request.body.first_name} ${request.body.last_name}`,
          photoURL: request.body.profile_picture_url,
          emailVerified: user.additional_information.email_verified,
        });

        await UsersCollection.replaceOne({_id: user._id},
          userData,
          function(error, result) {
            if (error) {
              response.status(500).json({
                result: {
                  message: 'An error occurred. User not updated.',
                  status_code: 500,
                },
              });

              return false;
            }
            response.status(200).json({
              result: {
                message: 'User successfully updated.',
                status_code: 200,
              },
            });
          });
      }
    });
  } catch (error) {
    response.status(500).json({
      result: {
        message: 'An error internal error occurred',
        status_code: 500,
      },
    });
  }
});


module.exports = router;
