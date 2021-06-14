const admin = require('firebase-admin');

const firebaseAdmin = admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

module.exports = {
  firebaseAdmin,
};
