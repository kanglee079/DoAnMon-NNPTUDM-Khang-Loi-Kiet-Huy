import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../manage/controllers/category_controller.dart';
import '../../../../manage/controllers/product_controller.dart';
import '../../../../models/category.model.dart';

class AddProductPage extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  AddProductPage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Sản Phẩm Mới'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildTextField(_nameController, 'Tên Sản Phẩm'),
              buildTextField(_descController, 'Mô Tả', maxLines: 3),
              buildTextField(_priceController, 'Giá',
                  keyboardType: TextInputType.number),
              buildTextField(_stockController, 'Số Lượng Trong Kho',
                  keyboardType: TextInputType.number),
              buildTextField(_ratingController, 'Đánh Giá',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              Obx(() {
                if (categoryController.isLoading.isTrue) {
                  return const CircularProgressIndicator();
                }
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Danh Mục',
                    border: OutlineInputBorder(),
                  ),
                  value: productController.selectedCategoryId,
                  onChanged: (newValue) {
                    productController.selectedCategoryId = newValue;
                    productController.selectedCategory.value =
                        categoryController.categoryList.firstWhere(
                      (category) => category.id == newValue,
                      orElse: () =>
                          Category(id: '', name: 'Chọn Danh Mục', slug: ''),
                    );
                  },
                  items: categoryController.categoryList
                      .map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final Map<String, dynamic> productData = {
                    'name': _nameController.text,
                    'description': _descController.text,
                    'price': double.tryParse(_priceController.text) ?? 0,
                    'category': productController.selectedCategoryId,
                    'stock': int.tryParse(_stockController.text) ?? 0,
                    'rating': double.tryParse(_ratingController.text) ?? 0,
                  };
                  productController.addProduct(productData);
                },
                child: const Text('Thêm Sản Phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }
}
