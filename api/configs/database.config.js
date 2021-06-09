const {MongoClient} = require('mongodb');
const dotenv = require('dotenv');
dotenv.config({path: "api.config.env"});

const mongoManager = new MongoClient(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});

async function connectDatabase() {

    try {

        await mongoManager.connect();
        console.log(`Successfully connected to the Database.`.bgGreen.black);
    } catch (error) {
        console.error(`Error in connection to the Database. \nLog(s): \n ${error}`.bgRed.black);
        throw error;
    }
}

module.exports = {
    mongoManager,
    connectDatabase
}