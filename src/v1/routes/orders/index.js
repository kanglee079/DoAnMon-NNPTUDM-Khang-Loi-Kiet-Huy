// order.routes.js
const express = require('express');
const router = express.Router();
const OrderController = require('../../controller/order.controller');
const asyncHandle = require('../../utils/asyncHandle');
const {checkAuthentication, checkIsAdmin} = require('../../middlewares/index');

// Route để tạo order mới
router.post('/', checkAuthentication, asyncHandle(OrderController.createOrder));

// Route để lấy tất cả order
router.get('/', checkAuthentication, checkIsAdmin, asyncHandle(OrderController.getAllOrders));

// Route để lấy một order cụ thể qua id
router.get('/:id', checkAuthentication, asyncHandle(OrderController.getOrderById));

// Route để cập nhật order
router.put('/:id', checkAuthentication, checkIsAdmin, asyncHandle(OrderController.updateOrder));

// Route để xóa order
router.delete('/:id', checkAuthentication, checkIsAdmin, asyncHandle(OrderController.deleteOrder));

// Route để lấy tất cả đơn hàng của người dùng đã đăng nhập
router.get('/user-orders/:id', checkAuthentication, asyncHandle(OrderController.getOrdersByUser));

module.exports = router;
