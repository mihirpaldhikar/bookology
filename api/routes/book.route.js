const express = require('express');
const router = express.Router();
const databaseManager = require('../configs/database.config');
const Book = require('../models/book.model');
const booksCollection = databaseManager.mongoManager.db('Bookology').collection('Books');
const jwt = require('jsonwebtoken');
const {verifyToken} = require('../functions/verify.function');

router.get('/', async (request, response, next) => {
    await booksCollection.find().toArray(function (error, booklets) {
        response.json({
            booklets: booklets.map(booklet => {
                return Book.setBooklet(booklet);
            })
        })
    })
});

router.post('/publish', verifyToken, async (request, response, next) => {
    jwt.verify(request.token, process.env.JWT_SECRET_TOKEN, async (err, authData) => {
        if (err) {
            response.sendStatus(403);
            return false;
        } else {
            const bookletData = Book.setBooklet({
                uploader_id: authData.user_id,
                isbn: request.body.isbn,
                book_name: request.body.book_name,
                orignal_price: request.body.orignal_price,
                current_price: request.body.current_price,
                book_condition: request.body.book_condition,
                book_image_url: request.body.book_image_url,
                is_used: request.body.is_used
            });
            await booksCollection.insertOne(bookletData, (error, result) => {
                if (error) {
                    response.status(500).json({
                        result: {
                            message: "An error occurred while creating booklet.",
                            status_code: 500
                        }
                    });

                    return false;
                }
                response.status(201).json({
                    result: {
                        message: "Book successfully registered.",
                        status_code: 201
                    }
                });
            });
        }
    });


});


module.exports = router;