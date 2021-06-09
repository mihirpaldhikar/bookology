const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/user.model');
const {mongoManager} = require('../configs/database.config');
const userCollection = mongoManager.db('Bookology').collection('Users')


router.post('/signup', async (request, response, next) => {
    if (request.headers.authorization === undefined ||
        request.headers.authorization !== process.env.ACCESS_TOKEN) {
        response.status(401).json({
            result: {
                message: "Permission denied. Authorization token undefined or invalid.",
                status_code: 401
            }
        });

        return false;
    }

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
            user_id: result.insertedId
        }, process.env.JWT_SECRET_TOKEN, (err, token) => {
            response.status(201).json({
                result: {
                    message: "User successfully registered.",
                    token: token,
                    status_code: 201
                }
            });

        });
    })
});

module.exports = router;