const {mongoManager} = require('../configs/database.config');

const UsersCollection = mongoManager.db('Bookology').collection('Users');

const BooksCollection = mongoManager.db('Bookology').collection('Books');


module.exports = {
  UsersCollection,
  BooksCollection,
};
