const {mongoManager} = require('../configs/database.config');

function UserCollection() {
  return mongoManager.db('Bookology').collection('Users');
}

function BookCollection() {
  return mongoManager.db('Bookology').collection('Books');
}


module.exports = {
  UserCollection,
  BookCollection,
};
