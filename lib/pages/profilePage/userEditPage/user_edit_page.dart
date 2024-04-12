import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../manage/controllers/user_controller.dart';

class UserEditPage extends StatelessWidget {
  UserEditPage({super.key});

  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController fullnameController =
        TextEditingController(text: userController.userInfo.value.fullname);
    final TextEditingController addressController =
        TextEditingController(text: userController.userInfo.value.address);
    final TextEditingController phoneController =
        TextEditingController(text: userController.userInfo.value.phone);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin người dùng'),
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: fullnameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên đầy đủ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Cập nhật thông tin người dùng
                    Map<String, dynamic> updatedData = {
                      'fullname': fullnameController.text,
                      'address': addressController.text,
                      'phone': phoneController.text,
                    };
                    print(updatedData);
                    userController.updateUserInfo(updatedData);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pinkAccent, // Màu chữ
                    minimumSize: const Size(double.infinity, 50), // Kích thước
                  ),
                  child: const Text('Cập nhật'),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
