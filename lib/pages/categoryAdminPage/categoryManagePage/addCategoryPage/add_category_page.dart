import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../manage/controllers/category_controller.dart';

class AddCategoryPage extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();

  AddCategoryPage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Danh Mục Mới'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên Danh Mục',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập tên danh mục',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô Tả',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập mô tả cho danh mục',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _descriptionController.text.isNotEmpty) {
                    final Map<String, dynamic> cateData = {
                      'name': _nameController.text,
                      'desc': _descriptionController.text,
                    };
                    categoryController.addCategory(cateData);
                  } else {
                    Get.snackbar(
                      'Thông báo',
                      'Tên và mô tả danh mục không được để trống!',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text('Thêm Danh Mục'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
