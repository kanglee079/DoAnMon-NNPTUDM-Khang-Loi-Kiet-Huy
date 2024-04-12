import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../manage/controllers/help_controller.dart';
import '../../manage/controllers/user_controller.dart';
import 'changePasswordPage/change_password_page.dart';
import 'userEditPage/user_edit_page.dart';

class ProfilePage extends GetView<UserController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HelpController()); // Có thể cần chuyển vào một phần khởi tạo

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        title: const Text('Cá nhân', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.isLoadingImage.value
                        ? null
                        : NetworkImage(controller.userInfo.value.avatar ??
                            'https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg'),
                    backgroundColor: Colors.transparent,
                    child: controller.isLoadingImage.value
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery,
                              );

                              if (pickedFile != null) {
                                controller.uploadAvatar(File(pickedFile.path));
                              } else {
                                Get.snackbar("Error", "No image selected");
                              }
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tên khách hàng: ${controller.userInfo.value.fullname ?? 'Full Name'}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '@${controller.userInfo.value.username}',
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Địa chỉ: ${controller.userInfo.value.address ?? 'Address'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Số điện thoại: ${controller.userInfo.value.phone ?? 'not found'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  buildCustomButton(context, 'Chỉnh sửa thông tin', Icons.edit,
                      () {
                    Get.to(() => UserEditPage());
                  }),
                  buildCustomButton(context, 'Đổi mật khẩu', Icons.lock_outline,
                      () {
                    Get.to(() => ChangePasswordPage());
                  }),
                  buildCustomButton(context, 'Đăng xuất', Icons.exit_to_app,
                      () {
                    final controller = Get.find<HelpController>();
                    controller.logout();
                  }, isLogout: true),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget buildCustomButton(
      BuildContext context, String text, IconData icon, VoidCallback onPressed,
      {bool isLogout = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: isLogout ? Colors.red : Colors.blue),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
