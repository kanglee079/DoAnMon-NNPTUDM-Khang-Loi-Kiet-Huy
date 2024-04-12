import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../manage/controllers/product_controller.dart';
import '../../detailPage/detail_page.dart';

class ProductsPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ProductsPage(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND', decimalDigits: 0);

    Future.microtask(() => productController.getProductsByCategory(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Obx(
        () {
          if (productController.isLoading.value) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Container(width: 100, height: 100, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 20, color: Colors.white),
                            const SizedBox(height: 5),
                            Container(height: 15, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (productController.productListByCategory.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào'));
          } else {
            return ListView.builder(
              itemCount: productController.productListByCategory.length,
              itemBuilder: (context, index) {
                final product = productController.productListByCategory[index];
                return InkWell(
                  onTap: () {
                    Get.to(() => ProductDetailPage(product: product));
                  },
                  child: Container(
                    color: Colors.grey[200],
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: product.image ?? '',
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.description,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                currencyFormat.format(product.price),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.add_shopping_cart,
                          color: Colors.pink.shade400,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
