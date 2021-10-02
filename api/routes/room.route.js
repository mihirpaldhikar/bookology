const express = require('express');
const router = express.Router();
const {verifyUser} = require('../middlewares/verify.middleware');
const jwt = require('jsonwebtoken');
const {RoomsCollection} = require('../managers/collection.manager');
const {firebaseAdmin} = require('../configs/firebase.config');
const Room = require('../models/room.model');
FieldValue = require('firebase-admin').firestore.FieldValue;

router.post('/create', verifyUser, async (request, response, next) => {
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
        const bookID = request.body.book_id;
        const roomOwner = authData.user_id;
        const secondUser = request.body.users[1];
        const room = await firebaseAdmin.firestore().collection('rooms').add({
          'createdAt': FieldValue.serverTimestamp(),
          'imageUrl': request.body.room_icon,
          'name': request.body.title,
          'type': 'group',
          'updatedAt': FieldValue.serverTimestamp(),
          'userIds': request.body.users,
          'userRoles': {
            [roomOwner]: 'admin',
            [secondUser]: 'user',
          },
        });
        const roomData = Room.createRoom({
          room_id: room.id,
          book_id: request.body.book_id,
          title: request.body.title,
          room_icon: request.body.room_icon,
          room_owner: authData.user_id,
          users: request.body.users,
          date: request.body.date,
          time: request.body.time,
        });

        response.status(201).json({
          result: {
            message: 'Room successfully created.',
            status_code: 201,
          },
        });
        await RoomsCollection.insertOne(roomData, async (error, result) => {
          if (error) {
            response.status(500).json({
              result: {
                message: 'An error occurred while creating room.',
                status_code: 500,
              },
            });

            return false;
          }
          await firebaseAdmin.firestore().collection('users').doc(request.body.users[1]).collection('requests').doc(bookID).update({
            accepted: true,
            room_id: room.id,
          });
        });
      }
    });
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


router.delete('/delete/:roomID', verifyUser, async (request, response, next) => {
  try {
    const roomID = request.params.roomID;
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
        await RoomsCollection.findOneAndDelete({_id: roomID});
        await firebaseAdmin.storage().bucket(process.env.CLOUD_STORAGE_BUCKET_NAME).deleteFiles({
          prefix: `rooms/${roomID}/`,
          force: true,
        });
        await firebaseAdmin.firestore().collection('rooms').doc(roomID).delete();

        response.status(200).json({
          result: {
            message: 'Room deleted successfully.',
            status_code: 200,
          },
        });
      }
    });
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

module.exports = router;
