import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../manage/controllers/user_controller.dart';

class UserManagePage extends StatelessWidget {
  UserManagePage({super.key});

  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Người Dùng'),
      ),
      body: Obx(() {
        if (userController.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userController.userList.isEmpty) {
          return const Center(child: Text('Không có người dùng nào.'));
        }

        return ListView.builder(
          itemCount: userController.userList.length,
          itemBuilder: (context, index) {
            final user = userController.userList[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.avatar != null
                      ? NetworkImage(user.avatar!)
                      : const NetworkImage(
                          'https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg',
                        ),
                ),
                title: Text(user.username),
                subtitle: Text('Email: ${user.email}'),
                trailing: Switch(
                  value: user.status == 'active',
                  onChanged: (isActive) async {
                    await userController.changeUserStatus(
                        user.id, isActive ? 'active' : 'inactive');
                    user.status = isActive ? 'active' : 'inactive';
                    userController.userList[index] = user;
                    userController.fetchAllUsers();
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
