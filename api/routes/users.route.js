const express = require('express');
const router = express.Router();
const User = require('../models/user.model');
const {UsersCollection, BooksCollection} = require('../managers/collection.manager');
const {verifyUser} = require('../middlewares/verify.middleware');


router.get('/:username', verifyUser, async (request, response, next) => {
  try {
    if (request.query.with_books === 'true') {
      const user = await UsersCollection.findOne({'user_information.username': request.params.username});

      if (user == null) {
        response.status(404).json({
          result: {
            message: 'User not found with the username.',
            status_code: 404,
          },
        });
        return false;
      }

      await BooksCollection.find({uploader_id: user._id}).toArray(function(error, result) {
        response.status(200).json(User.getUserWithBooks(user, result));
      });
      return false;
    }

    const user = await UsersCollection.findOne({username: request.params.username});

    response.status(200).json(User.getUser(user));
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
