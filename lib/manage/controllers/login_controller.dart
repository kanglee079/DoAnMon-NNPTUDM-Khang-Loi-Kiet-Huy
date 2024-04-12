import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apps/const/token_storage.dart';
import '../../apps/route/route_name.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> keyLoginForm = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var loading = false.obs;
  final String apiUrl = "http://localhost:3000/auths/login";

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> checkLoginStatus() async {
    String? token = await TokenStorage.getToken();
    if (token != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> login() async {
    if (!keyLoginForm.currentState!.validate()) {
      return;
    }

    loading(true);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final accessToken = responseData['message']['metadata']['accessToken'];
        final userJson = responseData['message']['metadata']['user'];
        // print(userJson);
        if (accessToken != null && userJson != null) {
          await TokenStorage.setToken(accessToken);
          await TokenStorage.setUserId(userJson['_id']);
          await TokenStorage.setUser(userJson);
          // Get.offAllNamed('/nav');
          if (userJson['status'] == 'inactive') {
            Get.snackbar('Lỗi', 'Tài khoản của bạn đã bị khóa');
            return;
          }
          Get.offAllNamed(
            userJson['role'] == 'admin' ? RouterName.navAdmin : RouterName.nav,
          );

          Get.snackbar('Thành công', 'Đăng nhập thành công');
        } else {
          Get.snackbar('Lỗi', 'Lỗi không xác định');
        }
      } else {
        Get.snackbar('Lỗi', 'Sai tên đăng nhập hoặc mật khẩu');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Something went wrong: $e');
    } finally {
      loading(false);
    }
  }

  void transToRegisterPage() {
    Get.offAndToNamed(RouterName.register);
  }

  void transToForgotPassPage() {
    Get.offAndToNamed(RouterName.forgotPass);
  }
}


// var token = await TokenStorage.getToken();
// var userId = await TokenStorage.getUserId(); // Lấy userId đã lưu

// var headers = {
//   'Content-Type': 'application/json',
//   'Authorization': 'Bearer $token',
//   'x-user-id': userId!, // Thêm userId vào header
// };

// final response = await http.get(
//   Uri.parse('http://192.168.50.138:3000/some-protected-route'),
//   headers: headers,
// );