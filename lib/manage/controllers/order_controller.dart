import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apps/const/token_storage.dart';
import '../../models/cart.model.dart';
import '../../models/order.admin.model.dart';
import '../../models/order.model.dart';

class OrderController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var isLoading = false.obs;
  var orders = <Order>[].obs;
  var ordersAdmin = <OrderAdmin>[].obs;
  final apiUrl = "http://localhost:3000/orders";

  @override
  void onInit() {
    super.onInit();
    checkUserRoleAndFetchOrders();
  }

  void checkUserRoleAndFetchOrders() async {
    String? role = await TokenStorage.getUserRole();
    if (role == 'admin') {
      fetchAllOrders();
    } else {
      fetchUserOrders();
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  void addToCart(String productId, double price, String name, String imageUrl) {
    var existingItem =
        cartItems.firstWhereOrNull((item) => item.productId == productId);
    if (existingItem != null) {
      existingItem.quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          productId: productId,
          price: price,
          name: name,
          imageUrl: imageUrl,
        ),
      );
      cartItems.refresh();
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.productId == productId);
    cartItems.refresh();
  }

  // Cập nhật số lượng sản phẩm trong giỏ hàng
  void updateQuantity(String productId, int quantity) {
    var existingItem =
        cartItems.firstWhereOrNull((item) => item.productId == productId);
    if (existingItem != null) {
      if (quantity > 0) {
        existingItem.quantity = quantity;
      } else if (quantity <= 0) {
        removeFromCart(productId);
      }
      cartItems.refresh();
    }
  }

  // Tính tổng giá tiền trong giỏ hàng
  double get totalPrice => cartItems.fold(
        0,
        (previousValue, item) => previousValue + (item.price * item.quantity),
      );

  // Tạo đơn hàng
  Future<void> createOrder(
    String addressShipping,
    String phoneShipping,
    String methodPayment,
  ) async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userId ?? '',
        },
        body: jsonEncode({
          'items': cartItems.map((item) => item.toJson()).toList(),
          'address_shipping': addressShipping,
          'phone_shipping': phoneShipping,
          'method_payment': "cash",
          'status': 'pending',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Thành công', 'Đặt hàng thành công');
        cartItems.clear();
        fetchUserOrders();
      } else {
        Get.snackbar(
            'Lỗi', 'Đặt hàng thất bại. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi với: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchUserOrders() async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();
      final response = await http.get(
        Uri.parse('$apiUrl/user-orders/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userId ?? '',
        },
      );
      // print(response.body);
      // print(response.statusCode);

      isLoading(false);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> ordersJson = body['message']['metadata'];
        final List<Order> fetchedOrders =
            ordersJson.map<Order>((json) => Order.fromJson(json)).toList();
        orders.value = fetchedOrders;
      } else {
        Get.snackbar('Lỗi', 'Không thể lấy danh sách đơn hàng');
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Lỗi', 'Có lỗi xảy ra: $e');
      // print(e);
    }
  }

  Future<Order?> getOrderDetails(String orderId) async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();
      final response = await http.get(
        Uri.parse('$apiUrl/orders/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userId ?? '',
        },
      );
      print(response.body);
      print(response.statusCode);

      isLoading(false);
      if (response.statusCode == 200) {
        Map<String, dynamic> orderJson = json.decode(response.body);
        Order order = Order.fromJson(orderJson);
        return order;
      } else {
        Get.snackbar('Lỗi', 'Không thể lấy thông tin đơn hàng');
        return null;
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Lỗi', 'Có lỗi xảy ra: $e');
      return null;
    }
  }

  Future<void> fetchAllOrders() async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();

      final response = await http.get(
        Uri.parse('$apiUrl/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userId ?? '',
        },
      );
      // print(response.body);
      // print(response.statusCode);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> ordersJson = body['message']['metadata'];

        final List<OrderAdmin> fetchedOrders = ordersJson
            .map<OrderAdmin>((json) => OrderAdmin.fromJson(json))
            .toList();
        ordersAdmin.value = fetchedOrders;
        // Get.snackbar('Thành công', 'Lấy tất cả đơn hàng thành công');
      } else {
        // Get.snackbar('Lỗi', 'Không thể lấy danh sách đơn hàng');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra: $e');
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();

      final response = await http.put(
        Uri.parse('$apiUrl/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userId ?? '',
        },
        body: jsonEncode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Thành công', 'Cập nhật đơn hàng thành công');
        fetchAllOrders();
      } else {
        Get.snackbar('Lỗi', 'Không thể cập nhật đơn hàng');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra: $e');
    } finally {
      isLoading(false);
    }
  }
}
