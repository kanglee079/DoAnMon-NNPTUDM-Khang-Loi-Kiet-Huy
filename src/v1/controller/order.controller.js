// order.controller.js
const OrderService = require('../services/order.service');
const { CREATED, OK } = require('../core/success.response');

class OrderController {
    static createOrder = async (req, res, next) => {
        try {
            const userId = req.user.id; 
            const orderData = req.body;
            const order = await OrderService.createOrder(orderData, userId);
            new CREATED({
                message: "Order created successfully",
                metadata: order,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static getAllOrders = async (req, res, next) => {
        try {
            const orders = await OrderService.getAllOrders();
            new OK({
                message: "Orders retrieved successfully",
                metadata: orders,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static getOrderById = async (req, res, next) => {
        try {
            const order = await OrderService.getOrderById(req.params.id);
            new OK({
                message: "Order retrieved successfully",
                metadata: order,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static updateOrder = async (req, res, next) => {
        try {
            const order = await OrderService.updateOrder(req.params.id, req.body);
            new OK({
                message: "Order updated successfully",
                metadata: order,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static deleteOrder = async (req, res, next) => {
        try {
            await OrderService.deleteOrder(req.params.id);
            new OK({
                message: "Order deleted successfully",
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static getOrdersByUser = async (req, res, next) => {
        try {
            const userId = req.params.id;
            const orders = await OrderService.getOrdersByUser(userId);
            new OK({
                message: "Orders retrieved successfully",
                metadata: orders,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }
    
}

module.exports = OrderController;
