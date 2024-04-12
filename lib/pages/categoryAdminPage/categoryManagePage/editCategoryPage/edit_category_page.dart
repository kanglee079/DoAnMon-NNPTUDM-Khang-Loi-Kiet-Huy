import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../manage/controllers/category_controller.dart';
import '../../../../models/category.model.dart';

class EditCategoryPage extends StatelessWidget {
  final Category category;
  final CategoryController categoryController = Get.find<CategoryController>();

  EditCategoryPage({super.key, required this.category});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Khởi tạo giá trị cho các trường dữ liệu
    _nameController.text = category.name;
    _descriptionController.text = category.desc ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh Sửa Danh Mục: ${category.name}'),
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
                  hintText: 'Nhập tên danh mục mới',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô Tả',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập mô tả mới cho danh mục',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _descriptionController.text.isNotEmpty) {
                    // Gọi phương thức cập nhật danh mục
                    categoryController.updateCategory(category.id, {
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                    });
                  } else {
                    Get.snackbar(
                      'Thông báo',
                      'Tên và mô tả danh mục không được để trống!',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text('Cập Nhật Danh Mục'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
