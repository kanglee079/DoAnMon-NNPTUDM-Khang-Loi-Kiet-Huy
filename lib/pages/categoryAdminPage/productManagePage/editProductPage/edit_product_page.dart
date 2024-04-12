import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../manage/controllers/category_controller.dart';
import '../../../../manage/controllers/product_controller.dart';
import '../../../../models/category.model.dart';
import '../../../../models/product.model.dart';

class EditProductPage extends StatelessWidget {
  final Product product;

  EditProductPage({super.key, required this.product});

  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = product.name;
    _descController.text = product.description ?? "";
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _ratingController.text = product.rating.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh Sửa Sản Phẩm: ${product.name}'),
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
                  value: product.categoryId,
                  onChanged: (newValue) {
                    productController.selectedCategoryId = newValue!;
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
                  final Map<String, dynamic> updatedProductData = {
                    'name': _nameController.text,
                    'description': _descController.text,
                    'price': double.tryParse(_priceController.text) ?? 0,
                    'stock': int.tryParse(_stockController.text) ?? 0,
                    'rating': double.tryParse(_ratingController.text) ?? 0,
                    'category': productController.selectedCategoryId,
                  };
                  productController.updateProduct(
                    product.slug,
                    updatedProductData,
                  );
                },
                child: const Text('Cập Nhật Sản Phẩm'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    productController.uploadProductImage(
                      product.id,
                      File(pickedFile.path),
                    );
                  } else {
                    Get.snackbar("Lỗi", "Không có ảnh được chọn");
                  }
                },
                child: const Text('Tải Ảnh Lên'),
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
      child: TextFormField(
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
