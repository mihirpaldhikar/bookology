const sendGrid = require('@sendgrid/mail');
const API_KEY = process.env.SENDGRID_API_KEY;
const WELCOME_TEMPLATE_ID = process.env.SENDGRID_WELCOME_TEMPLATE_ID;
const DELETE_TEMPLATE_ID = process.env.SENDGRID_DELETE_TEMPLATE_ID;
const SENDER_ID = process.env.SENDER_ID

sendGrid.setApiKey(API_KEY);

function sendWelcomeEmail(username, email, user_id) {
    const data = {
        to: email,
        from: SENDER_ID,
        templateId: WELCOME_TEMPLATE_ID,
        dynamic_template_data: {
            username: username,
            user_id: user_id,
        },
    };

    return sendGrid.send(data);

}

function sendDeleteEmail(email, user_id) {
    const data = {
        to: email,
        from: SENDER_ID,
        templateId: DELETE_TEMPLATE_ID,
        dynamic_template_data: {
            email: email,
            user_id: user_id,
        },
    };

    return sendGrid.send(data);

}

module.exports = {
    sendWelcomeEmail,
    sendDeleteEmail
}