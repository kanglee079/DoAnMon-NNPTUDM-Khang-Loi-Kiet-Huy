import 'package:app_mobile_shopping/models/order.admin.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../apps/helper/format_vnd.dart';
import '../../../manage/controllers/product_controller.dart';

class DetailAdminOrderPage extends StatelessWidget {
  final OrderAdmin order;
  final ProductController productController = Get.find<ProductController>();

  DetailAdminOrderPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng #${order.codeOrder}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin đơn hàng:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text('Code: ${order.codeOrder}'),
              Text('Tổng giá: ${currencyFormat.format(order.totalPrice)}'),
              Text('Trạng thái: ${order.status.capitalizeFirst}'),
              Text(
                  'Phương thức thanh toán: ${order.methodPayment.capitalizeFirst}'),
              Text('Địa chỉ giao hàng: ${order.addressShipping}'),
              Text('Số điện thoại: ${order.phoneShipping}'),
              Text(
                  'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(order.datetime)}'),
              const SizedBox(height: 20),
              const Text(
                'Sản phẩm trong đơn hàng:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  final product =
                      productController.productList.firstWhereOrNull(
                    (prod) => prod.id == item.productId,
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl:
                            product?.image ?? 'https://via.placeholder.com/150',
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                      title: Text(product?.name ?? "Sản phẩm không xác định"),
                      subtitle: Text(
                          'Số lượng: ${item.quantity}\nGiá: ${currencyFormat.format(product?.price ?? 0)}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
