const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/user.model');
const {mongoManager} = require('../configs/database.config');
const userCollection = mongoManager.db('Bookology').collection('Users')
const bookCollection = mongoManager.db('Bookology').collection('Books');
const moment = require('moment');
const MailService = require('../services/email.service');
const {verifyToken} = require('../functions/verify.function');
const MongoDB = require('mongodb');

router.post('/signup', async (request, response, next) => {

    const userData = User.setUser({
        username: request.body.username,
        auth_provider: request.body.auth_provider,
        email: request.body.email,
        profile_picture_url: request.body.profile_picture_url,
        first_name: request.body.first_name,
        last_name: request.body.last_name
    });

    if (await userCollection.countDocuments() !== 0) {
        if (await userCollection.findOne({username: request.body.username}) !== null) {
            response.status(409).json({
                result: {
                    message: "The username is already taken. Please choose other username.",
                    status_code: 409
                }
            });

            return false;
        }
    }


    await userCollection.insertOne(userData, async (error, result) => {
        if (error) {
            response.status(500).json({
                result: {
                    message: "An error occurred while creating user.",
                    status_code: 500
                }
            });

            return false;
        }
        jwt.sign({
            user_id: result.insertedId,
            email: request.body.email,
            time: moment().format('dddd DD MM YYYY hh mm ss')
        }, process.env.JWT_SECRET_TOKEN, (err, token) => {
            response.status(201).json({
                result: {
                    message: "User successfully registered.",
                    token: token,
                    status_code: 201
                }
            });

            MailService.sendWelcomeEmail(request.body.username, request.body.email, result.insertedId)

        });
    })
});

router.post('/delete', verifyToken, async (request, response, next) => {
    jwt.verify(request.token, process.env.JWT_SECRET_TOKEN, async (error, authData) => {
        if (error) {
            response.sendStatus(403);
        } else {

            if (await userCollection.findOne({_id: MongoDB.ObjectID(authData.user_id)}) === null) {
                response.status(404).json({
                    result: {
                        message: "User not deleted. user not found.",
                        status_code: 404
                    }
                });
                return false;
            }
            await userCollection.findOneAndDelete({_id: MongoDB.ObjectID(authData.user_id)});
            await bookCollection.deleteMany({uploader_id: MongoDB.ObjectID(authData.user_id)});
            response.status(200).json({
                result: {
                    message: "User successfully deleted.",
                    status_code: 200,
                }
            });

            await MailService.sendDeleteEmail(authData.email, authData.user_id);
        }
    });
});
module.exports = router;