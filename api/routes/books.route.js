const express = require('express');
const router = express.Router();
const Book = require('../models/book.model');
const {
  BooksCollection,
  UsersCollection,
  RoomsCollection,
  NotificationsCollection,
} = require('../managers/collection.manager');
const jwt = require('jsonwebtoken');
const {verifyUser} = require('../middlewares/verify.middleware');
const {firebaseAdmin} = require('../configs/firebase.config');
const apiCache = require('apicache');

const cache = apiCache.middleware;

router.get('/', cache('2 minutes'), verifyUser, async (request, response, next) => {
  try {
    const bookDataList = [];
    await BooksCollection.find().sort({$natural: -1}).toArray(async function(error, books) {
      for (let i = 0; i < books.length; i++) {
        const userId = books[i].uploader_id;
        const userData = await UsersCollection.findOne({_id: userId});
        const bookData = Book.getBookletWithUploader(books[i], userData);
        bookDataList.push(bookData);
      }
      response.status(200).json(bookDataList);
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

router.get('/:bookId', cache('2 minutes'), verifyUser, async (request, response, next) => {
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
    console.log(error);
    response.status(500).json({
      result: {
        message: 'An error internal error occurred',
        status_code: 500,
      },
    });
  }
});

router.put('/:bookId', verifyUser, async (request, response, next) => {
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

        if (book.uploader_id !== authData.user_id) {
          response.status(403).json({
            result: {
              message: 'Book Update Forbidden.',
              status_code: 403,
            },
          });
          return false;
        }
        const bookletData = Book.updateBook({
          uploader_id: authData.user_id,
          isbn: request.body.isbn,
          name: request.body.name,
          author: request.body.author,
          publisher: request.body.publisher,
          description: request.body.description,
          original_price: request.body.original_price,
          selling_price: request.body.selling_price,
          currency: book.pricing.currency,
          condition: request.body.condition,
          categories: request.body.categories,
          images_collection_id: request.body.images_collection_id,
          images: request.body.images,
          location: request.body.location,
          date: book.created_on.date,
          time: book.created_on.time,
        });

        await BooksCollection.replaceOne({_id: book._id},
          bookletData,
          function(error, result) {
            if (error) {
              response.status(500).json({
                result: {
                  message: 'An error occurred. Book not updated.',
                  status_code: 500,
                },
              });

              return false;
            }
            response.status(200).json({
              result: {
                message: 'Book successfully updated.',
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
          uploader_id: authData.user_id,
          isbn: request.body.isbn,
          name: request.body.name,
          author: request.body.author,
          publisher: request.body.publisher,
          description: request.body.description,
          original_price: request.body.original_price,
          selling_price: request.body.selling_price,
          currency: request.body.currency,
          condition: request.body.condition,
          categories: request.body.categories,
          images_collection_id: request.body.images_collection_id,
          images: request.body.images,
          location: request.body.location,
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


router.delete('/delete/:bookID', verifyUser, async (request, response, next) => {
  try {
    jwt.verify(request.token, process.env.JWT_SECRET_TOKEN, async (error, authData) => {
      if (error) {
        response.status(403).json({
          result: {
            message: 'Error in verifying user key. Key Invalid or not provided.',
            status_code: 403,
          },
        });
      } else {
        const book = await BooksCollection.findOne({_id: request.params.bookID});
        if (book === null) {
          response.status(404).json({
            result: {
              message: 'An error occurred while deleting Book. Book not found.',
              status_code: 404,
            },
          });
          return false;
        }
        if (book.uploader_id !== authData.user_id) {
          response.status(403).json({
            result: {
              message: 'Authentication failed. This book doesn\'t belong to this user.',
              status_code: 403,
            },
          });

          return false;
        }
        await BooksCollection.findOneAndDelete({_id: request.params.bookID});
        await firebaseAdmin.storage().bucket(process.env.CLOUD_STORAGE_BUCKET_NAME).deleteFiles({
          prefix: `Users/${authData.user_id}/BooksImages/${book.additional_information.images_collection_id}/`,
          force: true,
        });
        await NotificationsCollection.remove({
          'metadata.book_id': request.params.bookID,
        });
        await RoomsCollection.find({book_id: request.params.bookID}).toArray(async function(error, rooms) {
          if (rooms.length > 0 || true || rooms.length !== 0) {
            for (let i = 0; i < rooms.length; i++) {
              const room = rooms[i];
              await firebaseAdmin.firestore().collection('users').doc(room.users[1])
                .collection('requests').doc(request.params.bookID).delete();
              await firebaseAdmin.firestore().collection('users').doc()
                .collection('saved').doc(request.params.bookID).delete();

              await RoomsCollection.findOneAndDelete({_id: room.room_id});

              await firebaseAdmin.storage().bucket(process.env.CLOUD_STORAGE_BUCKET_NAME).deleteFiles({
                prefix: `rooms/${room.room_id}/`,
                force: true,
              });
              await firebaseAdmin.firestore().collection('rooms').doc(room.room_id).delete();
            }
          }
        });
        response.status(200).json({
          result: {
            message: 'Book successfully deleted.',
            status_code: 200,
          },
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
