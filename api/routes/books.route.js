const express = require('express');
const router = express.Router();
const Book = require('../models/book.model');
const {BooksCollection, UsersCollection} = require('../managers/collection.manager');
const jwt = require('jsonwebtoken');
const {verifyUser} = require('../middlewares/verify.middleware');

router.get('/:bookId', verifyUser, async (request, response, next) => {
  try {
    const book = await BooksCollection.findOne({_id: request.params.bookId});
    if (book == null) {
      response.status(404).json({
        result: {
          message: 'No book with the give ID.',
          status_code: 404,
        },
      });
      return false;
    }

    const user = await UsersCollection.findOne({_id: book.uploader_id});

    response.status(200).json(Book.getBookletWithUploader(book, user));
  } catch (error) {
    response.status(500).json({
      result: {
        message: 'An error internal error occurred',
        status_code: 500,
      },
    });
  }
});

router.post('/publish', verifyUser, async (request, response, next) => {
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
        const bookletData = Book.setBooklet({
          uploader_id: '2720',
          isbn: request.body.isbn,
          book_name: request.body.book_name,
          book_author: request.body.book_author,
          book_publisher: request.body.book_publisher,
          description: request.body.description,
          original_price: request.body.original_price,
          selling_price: request.body.selling_price,
          book_condition: request.body.book_condition,
          book_images_urls: request.body.book_images_urls,
        });
        await BooksCollection.insertOne(bookletData, (error, result) => {
          if (error) {
            response.status(500).json({
              result: {
                message: 'An error occurred while creating booklet.',
                status_code: 500,
              },
            });

            return false;
          }
          response.status(201).json({
            result: {
              message: 'Book successfully registered.',
              status_code: 201,
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
