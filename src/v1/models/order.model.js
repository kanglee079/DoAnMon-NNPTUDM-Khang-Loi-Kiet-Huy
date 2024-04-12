const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const crypto = require('crypto');

const COLLECTION_NAME = 'Orders';
const DocumentName = 'Order';

const orderSchema = new Schema({
    user: { 
        type: Schema.Types.ObjectId, 
        ref: 'User', 
        required: true 
    },
    items: [{
        product: { 
            type: Schema.Types.ObjectId, 
            ref: 'Product', 
            required: true 
        },
        quantity: { 
            type: Number, 
            default: 1 
        },
        price: { 
            type: Number, 
        }
    }],
    total_price: {
        type: Number,
    },
    status: {
        type: String,
        enum: ['pending', 'completed', 'cancelled', 'refunded'],
        default: 'pending',
    },
    method_payment: {
        type: String,
        enum: ['cash', 'credit_card', 'paypal'],
        default: 'cash',
    },
    address_shipping: {
        type: String,
        required: true,
    },
    phone_shipping: {
        type: String,
        required: true,
    },
    datetime: {
        type: Date,
        default: Date.now,
    },
    code_order: {
        type: String,
        unique: true,
    }
}, {
    timestamps: true,
    collection: COLLECTION_NAME 
});

orderSchema.pre('save', function(next) {
    // Tính toán tổng tiền
    this.total_price = this.items.reduce((total, item) => {
        return total + (item.price * item.quantity);
    }, 0);

    // Sinh code_order nếu chưa có
    if (!this.isModified('code_order') && !this.code_order) {
        this.code_order = crypto.randomBytes(10).toString('hex').slice(0, 10);
    }

    next();
});

module.exports = mongoose.model(DocumentName, orderSchema);
