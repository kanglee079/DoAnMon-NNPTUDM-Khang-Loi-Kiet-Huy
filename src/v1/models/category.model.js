const { Schema, model } = require('mongoose');
var slugify = require('slugify')

const COLLECTION_NAME = 'Categories';
const DocumentName = 'Category';

const categorySchema = new Schema({
    name: { type: String, required: true },
    desc: { type: String },
    ordering: { type: Number, default: 0 },
    status: { type: String, enum: ['active', 'inactive'], default: 'active' },
    products: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
    image_url: { type: String },
    slug: { type: String, unique: true }
}, {
    timestamps: true,
    collection: COLLECTION_NAME
});

// Tạo index để tăng hiệu suất tìm kiếm.
// categorySchema.index({ name: 1, slug: 1 }, { unique: true });
categorySchema.pre('save', function (next) {
    this.slug = slugify(this.name, { lower: true });
    next();
});

module.exports = model(DocumentName, categorySchema);
