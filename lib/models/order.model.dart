class OrderItem {
  final String? productId;
  final int quantity;
  final double? price;

  OrderItem({
    this.productId,
    required this.quantity,
    this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    String? productId;
    if (json['product'] != null) {
      productId = json['product']['_id'];
    }
    double? price;
    if (json['price'] != null) {
      price = (json['price'] as num).toDouble();
    }
    return OrderItem(
      productId: productId,
      quantity: json['quantity'],
      price: price,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'quantity': quantity,
    };
    if (productId != null) {
      data['product'] = productId;
    }
    if (price != null) {
      data['price'] = price;
    }
    return data;
  }
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;
  final String status;
  final String methodPayment;
  final String addressShipping;
  final String phoneShipping;
  final DateTime datetime;
  final String codeOrder;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.methodPayment,
    required this.addressShipping,
    required this.phoneShipping,
    required this.datetime,
    required this.codeOrder,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['_id'],
        userId: json['user'],
        items: List<OrderItem>.from(
            json['items'].map((item) => OrderItem.fromJson(item))),
        totalPrice: json['total_price'].toDouble(),
        status: json['status'],
        methodPayment: json['method_payment'],
        addressShipping: json['address_shipping'],
        phoneShipping: json['phone_shipping'],
        datetime: DateTime.parse(json['datetime']),
        codeOrder: json['code_order'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'total_price': totalPrice,
        'status': status,
        'method_payment': methodPayment,
        'address_shipping': addressShipping,
        'phone_shipping': phoneShipping,
        'datetime': datetime.toIso8601String(),
        'code_order': codeOrder,
      };
}
