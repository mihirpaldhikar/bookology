function verifyUser(req, res, next) {
  const userIdentifierKey = req.headers['user-identifier-key'];

  if (typeof userIdentifierKey !== 'undefined') {
    req.token = userIdentifierKey;
    next();
  } else {
    res.status(403).json({
      result: {
        message: 'User Identifier Key not provided or invalid.',
        status_code: 403,
      },
    });
  }
}

module.exports = {
  verifyUser,
};
