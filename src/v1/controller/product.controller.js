// product.controller.js
const ProductService = require('../services/product.service');
const { CREATED, OK } = require('../core/success.response');

class ProductController {
    static createProduct = async (req, res, next) => {
        try {
            const product = await ProductService.createProduct(req.body);
            new CREATED({
                message: "Product created successfully",
                metadata: product,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static getAllProducts = async (req, res, next) => {
        try {
            const products = await ProductService.getAllProducts();
            new OK({
                message: "Products retrieved successfully",
                metadata: products,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static getProductBySlug = async (req, res, next) => {
        try {
            const product = await ProductService.getProductBySlug(req.params.slug);
            if (!product) {
                return res.status(404).send({ message: "Product not found" });
            }
            new OK({
                message: "Product retrieved successfully",
                metadata: product,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static updateProduct = async (req, res, next) => {
        try {
            const updatedProduct = await ProductService.updateProduct(req.params.slug, req.body);
            new OK({
                message: "Product updated successfully",
                metadata: updatedProduct,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static deleteProduct = async (req, res, next) => {
        try {
            await ProductService.deleteProduct(req.params.slug);
            new OK({
                message: "Product deleted successfully",
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static searchProducts = async (req, res, next) => {
        try {
            const products = await ProductService.searchProducts(req.query.name);
            new OK({
                message: "Products found successfully",
                metadata: products,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static updateProductStatus = async (req, res, next) => {
        try {
            const product = await ProductService.updateProductStatus(req.params.id, req.body.status);
            new OK({
                message: "Product status updated successfully",
                metadata: product,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static updateProductImage = async (req, res, next) => {
        try {
            const product = await ProductService.updateProductImage(req.params.id, req.file.path);
            new OK({
                message: "Product image updated successfully",
                metadata: product,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static addProductImages = async (req, res, next) => {
        try {
            const images = await ProductService.addProductImages(req.params.id, req.files);
            new OK({
                message: "Product images added successfully",
                metadata: images,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static removeProductImages = async (req, res, next) => {
        try {
            await ProductService.removeProductImages(req.params.id, req.body.images);
            new OK({
                message: "Product images removed successfully",
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static getProductsByCategory = async (req, res, next) => {
        try {
            const products = await ProductService.getProductsByCategory(req.params.categoryId);
            new OK({
                message: "Products by category retrieved successfully",
                metadata: products,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = ProductController;
