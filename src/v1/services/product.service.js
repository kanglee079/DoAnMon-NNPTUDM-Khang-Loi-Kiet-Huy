// product.service.js
const Product = require('../models/product.model');
const Category = require('../models/category.model'); // Đảm bảo đã import model Category
const cloudinary = require('../config/cloudinary'); // Đảm bảo cấu hình Cloudinary

class ProductService {
    static createProduct = async (data) => {
        const product = new Product(data);
        await product.save();

        // Thêm sản phẩm vào danh sách sản phẩm của Category nếu cần
        await Category.findByIdAndUpdate(data.category, { $push: { products: product._id } });

        return product;
    }

    static getAllProducts = async () => {
        return await Product.find().populate('category', 'name');
    }

    static getProductBySlug = async (slug) => {
        return await Product.findOne({ slug }).populate('category', 'name');
    }

    static updateProduct = async (slug, data) => {
        const product = await Product.findOneAndUpdate({ slug }, data, { new: true }).populate('category', 'name');
        return product;
    }

    static deleteProduct = async (slug) => {
        try {
            const product = await Product.findOneAndDelete({ slug });
    
            // Cập nhật danh sách sản phẩm trong Category nếu cần
            if (product) {
                await Category.findByIdAndUpdate(product.category, { $pull: { products: product._id } });
            }
    
            return product;
        } catch (error) {
            throw new Error('Error deleting product: ' + error.message);
        }
    }

    static searchProducts = async (name) => {
        try {
            const products = await Product.find({
                $text: { $search: name }
            }, {
                score: { $meta: "textScore" }
            }).sort({
                score: { $meta: "textScore" }
            }).populate('category', 'name');
            return products;
        } catch (error) {
            throw new Error('Error searching products: ' + error.message);
        }
    }

    static updateProductStatus = async (id, status) => {
        const product = await Product.findByIdAndUpdate(id, { status }, { new: true }).populate('category', 'name');
        return product;
    }

    static updateProductImage = async (id, imagePath) => {
        const uploadResult = await cloudinary.uploader.upload(imagePath);
        const product = await Product.findByIdAndUpdate(id, { $set: { image: uploadResult.url } }, { new: true });
        return product;
    }

    static addProductImages = async (id, files) => {
        const uploadPromises = files.map(file => cloudinary.uploader.upload(file.path));
        const results = await Promise.all(uploadPromises);
        const urls = results.map(result => result.url);

        const product = await Product.findByIdAndUpdate(id, { $push: { images: { $each: urls } } }, { new: true });
        return product;
    }

    static removeProductImages = async (id, imagesToRemove) => {
        // Ví dụ này giả định imagesToRemove là một mảng URL của ảnh cần xóa
        const product = await Product.findByIdAndUpdate(id, { $pull: { images: { $in: imagesToRemove } } }, { new: true });
        return product;
    }

    static getProductsByCategory = async (categoryId) => {
        return await Product.find({ category: categoryId }).populate('category', 'name');
    }
}

module.exports = ProductService;
