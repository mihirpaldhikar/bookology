const moment = require('moment');

const setNotification = (notification) => {
  return {
    metadata: {
      sender_id: notification.sender_id,
      receiver_id: notification.receiver_id,
    },
    notification: {
      title: notification.notification_title,
      body: notification.notification_body,
      type: notification.notification_type,
      seen: false,
    },
    created_on: {
      date: moment().format('dddd DD MMMM YYYY'),
      time: moment().format('hh:mm:ss'),
    },
  };
};

const getNotification = (notification) => {
  return {
    notification_id: notification._id,
    metadata: {
      sender_id: notification.metadata.sender_id,
      receiver_id: notification.metadata.receiver_id,
    },
    notification: {
      title: notification.notification.title,
      body: notification.notification.body,
      type: notification.notification.type,
      seen: notification.notification.seen,
    },
    created_on: {
      date: notification.created_on.date,
      time: notification.created_on.time,
    },
  };
};

module.exports = {
  setNotification,
  getNotification,
};
