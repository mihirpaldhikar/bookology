const crypto = require('crypto-js');

function encrypt(data) {
  return crypto.AES.encrypt(data, process.env.ENCRYPTION_KEY).toString();
}

function decrypt(data) {
  const bytes = crypto.AES.decrypt(data, process.env.ENCRYPTION_KEY);
  return bytes.toString(crypto.enc.Utf8);
}

module.exports = {
  encrypt,
  decrypt,
};
