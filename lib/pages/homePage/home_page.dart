import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../manage/controllers/product_controller.dart';
import '../../widgets/product_tile.dart';

class HomePage extends GetView<ProductController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.cake,
          color: Colors.white,
        ),
        title: const Text('Cửa hàng', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            final product = controller.productList[index];
            // Sử dụng custom widget ProductTile hoặc một widget tương tự để hiển thị thông tin sản phẩm
            return ProductTile(product: product);
          },
        );
      }),
    );
  }
}
