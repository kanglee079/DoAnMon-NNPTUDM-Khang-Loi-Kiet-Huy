import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../apps/helper/format_vnd.dart';
import '../../../../manage/controllers/order_controller.dart';
import '../detailOrderPage/detail_order_page.dart';

class ListOrderPage extends StatelessWidget {
  const ListOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đơn hàng'),
      ),
      body: Obx(() {
        if (orderController.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderController.orders.isEmpty) {
          return const Center(
            child: Text("Lịch sử đơn hàng trống"),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
            final order = orderController.orders[index];
            return ListTile(
              title: Text('Đơn hàng #${order.codeOrder}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tổng giá: ${currencyFormat.format(order.totalPrice)}'),
                  Text('Trạng thái: ${order.status.capitalizeFirst}'),
                  Text(
                      'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(order.datetime)}'),
                ],
              ),
              onTap: () {
                Get.to(() => DetailOrderPage(order: order));
              },
            );
          },
        );
      }),
    );
  }
}
