import 'package:app_mobile_shopping/apps/helper/format_vnd.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../manage/controllers/order_controller.dart';
import '../../models/order.admin.model.dart';
import 'orderAdminDetailPage/order_admin_detail_page.dart';

class OrderAdminPage extends StatelessWidget {
  OrderAdminPage({super.key});

  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
      ),
      body: Obx(() {
        if (orderController.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        } else if (orderController.ordersAdmin.isEmpty) {
          return const Center(child: Text('Không có đơn hàng nào.'));
        }

        return ListView.separated(
          itemCount: orderController.ordersAdmin.length,
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.grey),
          itemBuilder: (context, index) {
            final OrderAdmin order = orderController.ordersAdmin[index];
            return ListTile(
              onTap: () => Get.to(() => DetailAdminOrderPage(order: order)),
              title: Text('Đơn hàng: ${order.codeOrder}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tổng giá: ${currencyFormat.format(order.totalPrice)}'),
                  Text('Trạng thái: ${order.status}',
                      style: const TextStyle(color: Colors.blueAccent)),
                  Text(
                      'Ngày đặt: ${order.datetime.toLocal().toString().split(' ')[0]}'),
                ],
              ),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: order.status,
                  items: <String>['pending', 'completed', 'cancelled']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.deepPurple)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    orderController.updateOrderStatus(order.id, newValue!);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
