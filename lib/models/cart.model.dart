class CartItem {
  final String productId;
  int quantity;
  double price;
  String name;
  String imageUrl;

  CartItem({
    required this.productId,
    this.quantity = 1,
    required this.price,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'product': productId,
        'quantity': quantity,
        'price': price,
        'name': name,
        'image_url': imageUrl,
      };
}
