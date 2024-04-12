import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../manage/controllers/category_controller.dart';
import 'addCategoryPage/add_category_page.dart';
import 'editCategoryPage/edit_category_page.dart';

class CategoryManagePage extends StatelessWidget {
  CategoryManagePage({super.key});

  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Danh Mục'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => AddCategoryPage()),
          ),
        ],
      ),
      body: Obx(() {
        if (categoryController.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categoryController.categoryList.isEmpty) {
          return const Center(child: Text('Không có danh mục nào.'));
        }

        return ListView.builder(
          itemCount: categoryController.categoryList.length,
          itemBuilder: (context, index) {
            final category = categoryController.categoryList[index];
            return ListTile(
              title: Text(category.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        Get.to(() => EditCategoryPage(category: category)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        showDeleteConfirmation(context, category.slug),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void showDeleteConfirmation(BuildContext context, String slug) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn xóa danh mục này?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () {
                categoryController.deleteCategory(slug);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
