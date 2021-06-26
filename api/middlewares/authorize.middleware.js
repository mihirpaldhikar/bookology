function authorizeKey(request, response, next) {
  const accessKey = request.headers['access-key'];
  if (accessKey === 'undefined' || accessKey !== process.env.ACCESS_TOKEN) {
    response.status(403).json({
      result: {
        message: 'Access Key not provided or invalid.',
        status_code: 403,
      },
    });
  } else {
    next();
  }
}

module.exports = {
  authorizeKey,
};
