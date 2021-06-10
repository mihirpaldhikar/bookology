const express = require('express');
const router = express.Router();
const {mongoManager} = require('../configs/database.config');
const User = require('../models/user.model');
const userCollection = mongoManager.db('Bookology').collection('users');


router.get('/', async (request, response, next) => {
  if (request.headers.authorization === undefined ||
        request.headers.authorization !== process.env.ACCESS_TOKEN) {
    response.status(401).json({
      result: {
        message: 'Permission denied. Authorization token undefined or invalid.',
        status_code: 401,
      },
    });

    return false;
  }


  await userCollection.find().toArray(function(error, users) {
    response.json({
      users: users.map((user) => {
        return User.getUser(user);
      }),
    });
  });
});

module.exports = router;
