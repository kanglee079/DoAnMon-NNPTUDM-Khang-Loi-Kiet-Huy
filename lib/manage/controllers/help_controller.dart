import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../apps/const/token_storage.dart';
import '../../apps/route/route_name.dart';

class HelpController extends GetxController {
  Future<void> logout() async {
    final result = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Đăng Xuất'),
            content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Đăng Xuất'),
              ),
            ],
          ),
        ) ??
        false;

    if (result) {
      await TokenStorage.clearAll();
      Get.offAllNamed(RouterName.login);
    }
  }
}
