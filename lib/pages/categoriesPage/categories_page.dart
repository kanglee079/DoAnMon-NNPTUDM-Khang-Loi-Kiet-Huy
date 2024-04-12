import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../manage/controllers/category_controller.dart';
import 'productByCategoryPage/product_by_categories_page.dart';

class CategoriesPage extends GetView<CategoryController> {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.category,
          color: Colors.white,
        ),
        title:
            const Text('Các loại bánh', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.categoryList.isEmpty) {
          return const Center(child: Text('No categories available'));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: controller.categoryList.length,
            itemBuilder: (context, index) {
              final category = controller.categoryList[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => ProductsPage(
                      categoryId: category.id, categoryName: category.name));
                },
                child: Card(
                  child: GridTile(
                    footer: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: category.imageUrl ??
                          'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
