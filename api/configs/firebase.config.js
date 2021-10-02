const admin = require('firebase-admin');

const firebaseAdmin = admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});
admin.firestore().settings({ignoreUndefinedProperties: true});
module.exports = {
  firebaseAdmin,
};
