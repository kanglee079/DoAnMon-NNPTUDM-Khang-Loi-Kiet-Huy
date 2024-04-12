// order.service.js
const Order = require('../models/order.model');
const Product = require('../models/product.model');

class OrderService {
    static createOrder = async (orderData, userId) => {
        // Cập nhật giá cho từng sản phẩm dựa trên thông tin hiện có từ cơ sở dữ liệu (nếu cần)
        const itemsWithPrice = await Promise.all(orderData.items.map(async item => {
            const product = await Product.findById(item.product);
            return {
                ...item,
                price: product.price,
            };
        }));

        // Tính toán tổng giá cho đơn hàng
        const totalPrice = itemsWithPrice.reduce((total, currentItem) => {
            return total + (currentItem.price * currentItem.quantity);
        }, 0);

        // Tạo đơn hàng mới
        const order = new Order({
            ...orderData,
            items: itemsWithPrice,
            total_price: totalPrice,
            user: userId, 
        });

        await order.save();
        return order;
    }

    static getAllOrders = async () => {
        return await Order.find().populate('user', 'username').populate('items.product');
    }

    static getOrderById = async (orderId) => {
        return await Order.findById(orderId).populate('user', 'username').populate('items.product');
    }

    static updateOrder = async (orderId, orderData) => {
        return await Order.findByIdAndUpdate(orderId, orderData, { new: true });
    }

    static deleteOrder = async (orderId) => {
        return await Order.findByIdAndDelete(orderId);
    }

    static getOrdersByUser = async (userId) => {
        return await Order.find({ user: userId })
            .populate('items.product', 'name price')
            .exec();
    }
    
}

module.exports = OrderService;
