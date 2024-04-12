const express = require('express');
const router = express.Router();
const ProductController = require('../../controller/product.controller');
const asyncHandle = require('../../utils/asyncHandle');
const {checkAuthentication, checkIsAdmin} = require('../../middlewares/index');
const { uploadDiskStorage } = require('../../helper/multer');


// Route để tạo sản phẩm mới, yêu cầu quyền admin
router.post('/', checkAuthentication, checkIsAdmin, asyncHandle(ProductController.createProduct));

// Route để lấy tất cả sản phẩm
router.get('/', asyncHandle(ProductController.getAllProducts));

// Route để lấy một sản phẩm cụ thể qua slug
router.get('/:slug', asyncHandle(ProductController.getProductBySlug));

// Route để cập nhật sản phẩm, yêu cầu quyền admin
router.put('/:slug', checkAuthentication, checkIsAdmin, asyncHandle(ProductController.updateProduct));

// Route để xóa sản phẩm, yêu cầu quyền admin
router.delete('/:slug', checkAuthentication, checkIsAdmin, asyncHandle(ProductController.deleteProduct));

// Route để tìm kiếm sản phẩm
router.get('/search', asyncHandle(ProductController.searchProducts));

// Route để cập nhật trạng thái sản phẩm, yêu cầu quyền admin
router.patch('/:id/status', checkAuthentication, checkIsAdmin, asyncHandle(ProductController.updateProductStatus));

// Route thay đổi ảnh đại diện của sản phẩm
router.patch('/image/:id', checkAuthentication, checkIsAdmin, uploadDiskStorage.single('file'), asyncHandle(ProductController.updateProductImage));

// // Route thêm danh sách ảnh cho sản phẩm
// router.post('/images/:id', checkAuthentication, checkIsAdmin, uploadDiskStorage.array('images', 10), asyncHandle(ProductController.addProductImages));

// // Route xóa danh sách ảnh của sản phẩm
// router.delete('/images/:id', checkAuthentication, checkIsAdmin, asyncHandle(ProductController.removeProductImages));

// Route để lấy sản phẩm theo danh mục
router.get('/category/:categoryId', asyncHandle(ProductController.getProductsByCategory));

module.exports = router;
