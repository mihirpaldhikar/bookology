const {mongoManager} = require('../configs/database.config');

const UsersCollection = mongoManager.db('Bookology').collection('Users');

const BooksCollection = mongoManager.db('Bookology').collection('Books');

const NotificationsCollection = mongoManager.db('Bookology').collection('Notifications');


module.exports = {
  UsersCollection,
  BooksCollection,
  NotificationsCollection,
};
