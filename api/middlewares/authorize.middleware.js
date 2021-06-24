function authorizeToken(request, response, next) {
  const token = request.query.token;
  if (token === 'undefined' || token !== process.env.ACCESS_TOKEN) {
    response.status(403).json({
      result: {
        message: 'Access token not provided or invalid.',
        status_code: 403,
      },
    });
  } else {
    next();
  }
}

module.exports = {
  authorizeToken,
};
