const CategoryService = require('../services/category.service');
const { CREATED, OK } = require('../core/success.response');

class CategoryController {
    static createCategory = async (req, res, next) => {
        new CREATED({
            message: "Create category success!",
            metadata: await CategoryService.createCategory(req.body),
        }).sendData(res);
    }

    static getAllCategory = async (req, res, next) => {
        new OK({
            message: "Get all category success!",
            metadata: await CategoryService.getAllCategory(),
        }).sendData(res);
    }

    static getCategoryBySlug = async (req, res, next) => {
        new OK({
            message: "Get category by slug success!",
            metadata: await CategoryService.getCategoryBySlug(req.params.slug),
        }).sendData(res);
    }

    static updateCategory = async (req, res, next) => {
        new OK({
            message: "Update category success!",
            metadata: await CategoryService.updateCategory(req.params.slug, req.body),
        }).sendData(res);
    }

    static deleteCategory = async (req, res, next) => {
        new OK({
            message: "Delete category success!",
            metadata: await CategoryService.deleteCategory(req.params.slug),
        }).sendData(res);
    }

    static getProductsByCategory = async (req, res, next) => {
        try {
            const products = await CategoryService.getProductsByCategory(req.params.categoryId);
            new OK({
                message: "Products retrieved successfully",
                metadata: products,
            }).sendData(res);
        } catch (error) {
            next(error);
        }
    }

    static updateCategoryImage = async (req, res, next) => {
        new OK({
            message: "Update category image success!",
            metadata: await CategoryService.updateCategoryImage(req.params.categoryId, req.file.path),
        }).sendData(res);
    }

}

module.exports = CategoryController;