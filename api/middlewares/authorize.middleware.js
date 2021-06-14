function authorizeToken(request, response, next) {
    const token = request.query.token;
    if (token === 'undefined' || token !== process.env.ACCESS_TOKEN) {
        response.sendStatus(403);
    } else {
        next();
    }
}

module.exports = {
    authorizeToken,
};
