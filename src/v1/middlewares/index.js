const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const KeyTokenModel = require('../models/keytoken.model');

const handleErrorsValidationMongoose = (error,req, res, next) => {
    if (error instanceof mongoose.Error.ValidationError) {
        const e = {};
        for (const key in error.errors) {
            e[key] = error.errors[key].message;
        }
        return res.status(400).json({
            status: 400,
            message: e,
        });
    }
    next(error);
};

const checkAuthentication = async (req, res, next) => {

    const userId = req.headers['x-user-id'];
    if (!userId) res.status(401).json({message: 'Not found user',});
    const keyStore = await KeyTokenModel.findOne({user: userId}).lean();
    if (!keyStore) res.status(401).json({message: 'Not found key',});
    const auth = req.headers['authorization'];
    if (!auth) res.status(401).json({message: 'Unauthorized',});
    const token = auth.split(' ')[1];

    jwt.verify(token, keyStore.publicKey, (err, user) => {
        if (err) res.status(403).json({message: 'Forbidden',});
        req.user = user;
        req.token = token;
        next();
    });
};

const checkIsAdmin = async (req, res, next) => {
    if(req.user && req.user.role === 'admin') {
        return next();
    }
    res.status(403).send('Access denied. Admin privileges required.');
}

module.exports = {
    handleErrorsValidationMongoose,
    checkAuthentication,
    checkIsAdmin
}