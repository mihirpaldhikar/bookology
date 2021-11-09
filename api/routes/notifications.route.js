const express = require('express');
const router = express.Router();
const {verifyUser} = require('../middlewares/verify.middleware');
const {authorizeKey} = require('../middlewares/authorize.middleware');
const {firebaseAdmin} = require('../configs/firebase.config');
const jwt = require('jsonwebtoken');
const {NotificationsCollection} = require('../managers/collection.manager');
const NotificationModel = require('../models/notification.model');
const apiCache = require('apicache');

const cache = apiCache.middleware;

router.get('/', cache('2 minutes'), verifyUser, async (request, response, next) => {
  try {
    jwt.verify(
      request.token,
      process.env.JWT_SECRET_TOKEN,
      async (err, authData) => {
        if (err) {
          response.status(403).json({
            result: {
              message:
                'Error in verifying user key. Key Invalid or not provided.',
              status_code: 403,
            },
          });
          return false;
        } else {
          const userID = authData.user_id;
          await NotificationsCollection.find({'metadata.receiver_id': userID})
            .sort({$natural: -1})
            .toArray(function(error, notifications) {
              if (notifications.length === 0) {
                response.status(200).json({
                  result: {
                    message: 'No Notifications.',
                    status_code: 200,
                  },
                });

                return false;
              }

              response.status(200).json(
                notifications.map((notification) => {
                  return NotificationModel.getNotification(notification);
                }),
              );
            });
        }
      },
    );
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

router.post(
  '/send',
  authorizeKey,
  verifyUser,
  async (request, response, next) => {
    try {
      const notificationType = request.query.type;
      if (
        notificationType === undefined ||
        notificationType === null ||
        notificationType === ''
      ) {
        response.status(403).json({
          result: {
            message: 'Notification type not provided.',
            status_code: 403,
          },
        });

        return false;
      }

      if (notificationType === 'book_enquiry_notification') {
        const senderUserID = request.headers['sender-user-id'];
        if (
          senderUserID === undefined ||
          senderUserID === null ||
          senderUserID === ''
        ) {
          response.status(403).json({
            result: {
              message: 'User ID of Sender not provided.',
              status_code: 403,
            },
          });

          return false;
        }

        const receiverUserID = request.headers['receiver-user-id'];
        if (
          receiverUserID === undefined ||
          receiverUserID === null ||
          receiverUserID === ''
        ) {
          response.status(403).json({
            result: {
              message: 'User ID of receiver not provided.',
              status_code: 403,
            },
          });

          return false;
        }
        const senderUserName = request.headers['sender-username'];
        if (
          senderUserName === undefined ||
          senderUserName === null ||
          senderUserName === ''
        ) {
          response.status(403).json({
            result: {
              message: 'Sender Username  not provided.',
              status_code: 403,
            },
          });

          return false;
        }

        const notificationData = NotificationModel.setNotification({
          sender_id: senderUserID,
          receiver_id: receiverUserID,
          book_id: request.body.book_id,
          notification_title: 'Book Enquiry Request',
          notification_body: `@${senderUserName} is requesting to enquire about a book.`,
          notification_type: 'book_enquiry_notification',
        });
        await NotificationsCollection.insertOne(
          notificationData,
          async (error, result) => {
            if (error) {
              response.status(500).json({
                result: {
                  message: 'An error occurred while sending notification.',
                  status_code: 500,
                },
              });

              return false;
            }
            const userFcmToken = (
              await firebaseAdmin
                .firestore()
                .collection('users')
                .doc(receiverUserID.toString())
                .get()
            ).data()['secrets']['fcmToken'];


            const notification = {
              data: {
                sender_id: senderUserID,
                receiver_id: receiverUserID,
                notification_type: 'book_enquiry_notification',
                title: 'Book Enquiry Request',
                body: `@${senderUserName} is requesting to enquire about a book.`,
                notification_id: result.insertedId.toString(),
                book_id: request.body.book_id,
                room_icon: request.body.room_icon,
              },
            };

            firebaseAdmin
              .messaging()
              .sendToDevice(userFcmToken.toString(), notification)
              .then((result) => {
                if (
                  result['results']['messageID'] !== null ||
                  result['results']['messageID'] !== undefined ||
                  result['results']['messageID'] !== ''
                ) {
                  response.status(200).json({
                    result: {
                      message: 'Notification Sent Successfully.',
                      status_code: 200,
                    },
                  });
                  return false;
                } else {
                  response.status(500).json({
                    result: {
                      message: 'Error in sending notification.',
                      status_code: 500,
                    },
                  });

                  return false;
                }
              });
          },
        );
      }
    } catch (error) {
      console.log(error);
      response.status(500).json({
        result: {
          message: 'An error internal error occurred',
          status_code: 500,
        },
      });
    }
  },
);

module.exports = router;
