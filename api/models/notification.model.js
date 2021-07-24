const moment = require('moment');

const setNotification = (notification) => {
  return {
    sender_id: notification.sender_id,
    receiver_id: notification.receiver_id,
    notification_title: notification.notification_title,
    notification_body: notification.notification_body,
    notification_type: notification.notification_type,
    created_on: {
      date: moment().format('dddd DD MMMM YYYY'),
      time: moment().format('hh:mm:ss'),
    },
  };
};

const getNotification = (notification) => {
  return {
    sender_id: notification.sender_id,
    receiver_id: notification.receiver_id,
    notification_title: notification.notification_title,
    notification_body: notification.notification_body,
    notification_type: notification.notification_type,
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
