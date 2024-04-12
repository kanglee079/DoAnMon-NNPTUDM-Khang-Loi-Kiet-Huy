import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apps/route/route_name.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> keyRegisterForm = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  var loading = false.obs;

  // Thay đổi apiUrl theo địa chỉ IP và port của server NodeJS của bạn
  final String apiUrl = "http://localhost:3000/auths/register";

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    addressController.dispose();
    fullnameController.dispose();
    super.onClose();
  }

  Future<void> register() async {
    if (!keyRegisterForm.currentState!.validate()) {
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
          'email': emailController.text.trim(),
          'address': addressController.text.trim(),
          'fullname': fullnameController.text.trim(),
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Registration successful');

        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Registration Failed',
          responseData['message']?['message'] ?? 'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
        );
        print(responseData['message']?['message'] ??
            'An unexpected error occurred');
      }
    } catch (e) {
      // Xử lý lỗi không xác định
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e.toString());
    } finally {
      loading(false);
    }
  }

  void transToLoginPage() {
    Get.offAndToNamed(RouterName.login);
  }
}
