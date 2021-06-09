const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const morgan = require("morgan");
const colors = require("colors");
const RateLimit = require("express-rate-limit");
const server = express();
const databaseManager = require('./configs/database.config');

dotenv.config({path: "api.config.env"});

async function main() {

    if (process.env.NODE_ENV === "development") {
        await server.use(morgan("dev"));
    }


    await databaseManager.connectDatabase();

    const requestLimiter = await new RateLimit({
        windowMs: 60 * 1000,
        max: 100,
        message: {
            error: {
                message: "Too many requests. Try again in few minutes.",
            },
        },
    });


    await server.use(cors());
    await server.use(requestLimiter);
    await server.use(express.json());
    await server.use(express.urlencoded({
        extended: true
    }));


    await server.listen(process.env.SERVER_PORT, () => {
        console.log(
            `Server running in ${process.env.NODE_ENV} on Port ${process.env.SERVER_PORT}`
                .bgGreen.black
        );
    });

}

main();