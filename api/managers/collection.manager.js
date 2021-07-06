const {mongoManager} = require('../configs/database.config');

function UsersCollection() {
  return mongoManager.db('Bookology').collection('Users');
}

function BooksCollection() {
  return mongoManager.db('Bookology').collection('Books');
}


module.exports = {
  UsersCollection,
  BooksCollection,
};
