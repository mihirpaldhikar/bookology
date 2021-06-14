const express = require('express');
const router = express.Router();
const {mongoManager} = require('../configs/database.config');
const User = require('../models/user.model');
const userCollection = mongoManager.db('Bookology').collection('Users');
const {authorizeToken} = require('../middlewares/authorize.middleware');
const Crypto = require('../managers/encryption.manager');
const Book = require('../models/book.model');

router.get('/', authorizeToken, async (request, response, next) => {
  if (request.query.show_books) {
    await userCollection.aggregate([
      {
        $lookup: {
          from: 'Books',
          localField: '_id',
          foreignField: 'uploader_id',
          as: 'books',
        },
      },
    ]).toArray(function (error, results) {
      response.json({
        users: results.map((result) => {
          return {
            user_id: result._id,
            username: result.username,
            auth_provider: result.auth_provider,
            email: Crypto.decrypt(result.email),
            profile_picture_url: Crypto.decrypt(result.profile_picture_url),
            first_name: result.first_name,
            last_name: result.last_name,
            joined_date: result.joined_date,
            joined_time: result.joined_time,
            username_slug: result.username_slug,
            first_name_slug: result.first_name_slug,
            last_name_slug: result.last_name_slug,
            books: result.books.map((book) => {
              return Book.getBooklet(book);
            }),
          };
        }),
      });
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
