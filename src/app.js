const express = require('express');
const app = express();
const helmet = require('helmet')
const morgan = require('morgan')
const compression = require('compression');
const { mongo, default: mongoose } = require('mongoose');
require('dotenv').config()
const {handleErrorsValidationMongoose} = require('./v1/middlewares/index')


require('./v1/databases/init.mongodb')

//user middleware
// app.use(helmet())
// app.use(morgan('combined'))

// compress responses
app.use(compression())

// add body-parser
app.use(express.json())
app.use(express.urlencoded({
    extended: true
}))

//router
app.use(require('./v1/routes/index.router'))

// Error Handling Middleware mongoose
app.use(handleErrorsValidationMongoose);


// error handler middleware
app.use((error, req, res, next) => {
    res.status(error.status || 500).send({
        error: {
            status: error.status || 500,
            message: error.message || 'Internal Server Error',
        },
    });
});

module.exports = app;