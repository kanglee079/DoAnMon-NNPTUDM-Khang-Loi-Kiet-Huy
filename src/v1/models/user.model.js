const { Schema, model } = require('mongoose');

const COLLECTION_NAME = 'Users';
const DocumentName = 'User';

const userSchema = new Schema({
    username: { type: String, required: true , unique: true},
    password: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    phone: { type: String, },
    address: { type: String },
    fullname: { type: String },
    avatar: { type: String },
    images: { type: Array, default: []},
    status: { type: String, enum: ['active', 'inactive'], default: 'active' },
    ordering: { type: Number, default: 0 },
    role: { type: String, enum: ['admin', 'user'], default: 'user' },
    resetPasswordToken: String,
    resetPasswordExpires: Date,
}, {
    timestamps: true,
    collection: COLLECTION_NAME,
});

userSchema.index({ username: 1, email: 1,  });

module.exports = model(DocumentName, userSchema);