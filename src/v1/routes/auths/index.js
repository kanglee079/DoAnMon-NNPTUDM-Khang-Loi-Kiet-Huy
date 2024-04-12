const express = require('express');
const router = express.Router();
const AuthController = require('../../controller/auth.controller');
const asyncHandle = require('../../utils/asyncHandle');
const {checkAuthentication, checkIsAdmin} = require('../../middlewares/index');

const { uploadDiskStorage } = require('../../helper/multer');

// Route để đăng ký tài khoản
router.post('/register', asyncHandle(AuthController.registerUser));

// Route để đăng nhập
router.post('/login', asyncHandle(AuthController.loginUser));

// Route để request reset password
router.post('/request-reset-password', asyncHandle(AuthController.requestPasswordReset));

// Route để reset password
router.post('/reset-password/:token', asyncHandle(AuthController.resetPassword));

// Middleware để check authentication
router.use(asyncHandle(checkAuthentication));

// Route để upload avatar
router.post('/upload-avatar/:id', uploadDiskStorage.single('file'), asyncHandle(AuthController.uploadAvatar));

// Route để upload nhiều hình ảnh
router.post('/upload-images/:id', uploadDiskStorage.array('images', 10), AuthController.uploadMultipleImages);

router.use(asyncHandle(checkAuthentication));

// Route lấy thông tin tất cả user
router.get('/users', checkIsAdmin, asyncHandle(AuthController.getAllUsers));

// Route thay đổi status của user
router.post('/status/:id', checkIsAdmin, asyncHandle(AuthController.changeUserStatus));

// Route để thay đổi mật khẩu
router.put('/change-password', checkAuthentication, asyncHandle(AuthController.changePassword));

// Route để lấy thông tin user
router.get('/info', asyncHandle(AuthController.info));

// Route để cập nhật thông tin user
router.put('/update', asyncHandle(AuthController.updateUser));

// Route để xóa user
router.delete('/delete', checkIsAdmin, asyncHandle(AuthController.deleteUser));

module.exports = router;