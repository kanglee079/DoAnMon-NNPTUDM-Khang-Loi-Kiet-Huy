import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../apps/const/token_storage.dart';
import '../../../apps/helper/format_vnd.dart';
import '../../../manage/controllers/order_controller.dart';
import 'listOrderPage/list_order_page.dart';

class OrderPage extends GetView<OrderController> {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final OrderController controller = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.shopping_bag,
          color: Colors.white,
        ),
        title: const Text('Giỏ hàng', style: TextStyle(color: Colors.white)),
        actions: [
          const Text(
            "Xem list đơn hàng",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              Get.to(() => const ListOrderPage());
            },
            child: const Icon(
              Icons.history,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 10)
        ],
        backgroundColor: Colors.pink.shade300,
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = controller.cartItems[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: cartItem.imageUrl ?? '',
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
                title: Text(
                  cartItem.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giá: ${currencyFormat.format(cartItem.price)}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      "Số lượng: ${cartItem.quantity} ",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (cartItem.quantity == 1) {
                          controller.removeFromCart(cartItem.productId);
                        } else {
                          controller.updateQuantity(
                              cartItem.productId, cartItem.quantity - 1);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        controller.updateQuantity(
                            cartItem.productId, cartItem.quantity + 1);
                      },
                    ),
                  ],
                ),
              );
            },
          )),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                    'Tổng tiền: ${currencyFormat.format(controller.totalPrice)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic>? user = await TokenStorage.getUser();
                  if (user != null) {
                    String address = user['address'] ?? 'Địa chỉ mặc định';
                    String phone = user['phone'] ?? 'Số điện thoại mặc định';
                    await controller.createOrder(
                      address,
                      phone,
                      "cash",
                    );
                  } else {
                    Get.snackbar('Error', 'Thông tin người dùng không có sẵn.');
                  }
                },
                child: const Text('Đặt hàng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
