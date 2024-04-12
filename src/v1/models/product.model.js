const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const slugify = require('slugify');

const COLLECTION_NAME = 'Products';
const DocumentName = 'Product';

const productSchema = new Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    price: { type: Number, required: true },
    category: { type: Schema.Types.ObjectId, ref: 'Category' },
    stock: { type: Number, required: true },
    status: { type: String, enum: ['active', 'inactive'], default: 'active' },
    image: { type: String },
    // images: [{ type: String }], // Mảng URL hình ảnh
    featured: { type: Boolean, default: false },
    rating: { type: Number, default: 0, min: 0, max: 5, set: v => Math.round(v * 10) / 10},
    slug: { type: String, unique: true },
},{
    timestamps: true,
    collection: COLLECTION_NAME
});

// Middleware để tự động tạo slug từ tên sản phẩm
productSchema.pre('save', function(next) {
    this.slug = slugify(this.name, { lower: true });
    next();
});

// Tạo index cho tìm kiếm hiệu quả
productSchema.index({ name: 'text', description: 'text' });

module.exports = mongoose.model(DocumentName, productSchema, COLLECTION_NAME);
