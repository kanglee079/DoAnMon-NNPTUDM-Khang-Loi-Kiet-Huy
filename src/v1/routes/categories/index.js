const express = require('express');
const router = express.Router();
const CategoryController = require('../../controller/category.controller');
const asyncHandle = require('../../utils/asyncHandle');
const {checkAuthentication, checkIsAdmin} = require('../../middlewares/index');
const { uploadDiskStorage } = require('../../helper/multer');

// Route để tạo danh mục mới, yêu cầu quyền admin
router.post('/', checkAuthentication, checkIsAdmin, asyncHandle(CategoryController.createCategory));

// Route để lấy tất cả danh mục
router.get('/', asyncHandle(CategoryController.getAllCategory));

// Route để lấy một danh mục cụ thể qua slug
router.get('/:slug', asyncHandle(CategoryController.getCategoryBySlug));

// Route để cập nhật danh mục, yêu cầu quyền admin
router.put('/:slug', checkAuthentication, checkIsAdmin, asyncHandle(CategoryController.updateCategory));

// Route để xóa danh mục, yêu cầu quyền admin
router.delete('/:slug', checkAuthentication, checkIsAdmin, asyncHandle(CategoryController.deleteCategory));

// Route để lấy tất cả sản phẩm của một danh mục
router.get('/:categoryId/products', asyncHandle(CategoryController.getProductsByCategory));

// Route để cập nhật ảnh của danh mục, yêu cầu quyền admin
router.patch('/:categoryId/image', checkAuthentication, checkIsAdmin, uploadDiskStorage.single('image'), asyncHandle(CategoryController.updateCategoryImage));
module.exports = router;
