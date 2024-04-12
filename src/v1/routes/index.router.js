"use strict"

const express = require('express');
const router = express.Router();

router.use('/auths', require('./auths'));
router.use('/categories', require('./categories'));
router.use('/products', require('./products'));
router.use('/orders', require('./orders'));


module.exports = router;