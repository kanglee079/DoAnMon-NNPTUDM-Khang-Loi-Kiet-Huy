import 'package:app_mobile_shopping/pages/categoryAdminPage/categoryManagePage/category_manage_page.dart';
import 'package:app_mobile_shopping/pages/categoryAdminPage/productManagePage/product_manage_page.dart';
import 'package:app_mobile_shopping/pages/categoryAdminPage/userMangePage/user_manage_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryAdminPage extends StatelessWidget {
  const CategoryAdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.category,
          color: Colors.white,
        ),
        title:
            const Text('Trang Quản Lí', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: const Text(
                  'Danh Sách Mục Quản Lí',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  onTap: () {
                    Get.to(() => CategoryManagePage());
                  },
                  title: const Text('Quản lí loại sản phẩm'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  onTap: () {
                    Get.to(() => const ProductManagePage());
                  },
                  title: const Text('Quản lí sản phẩm'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  onTap: () {
                    Get.to(() => UserManagePage());
                  },
                  title: const Text('Quản lí người dùng'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
