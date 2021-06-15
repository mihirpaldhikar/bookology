const base64 = require('base64url');

function decode(token) {
  const jwtParts = token.split('.');

  const payloadInBase64UrlFormat = jwtParts[1];


  return base64.decode(payloadInBase64UrlFormat);
}

module.exports = {
  decode,
};


