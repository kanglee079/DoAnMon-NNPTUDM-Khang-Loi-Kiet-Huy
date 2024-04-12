class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final int stock;
  final String status;
  final String? image; // Cho phép null nếu server có thể không trả về
  final bool featured;
  final double rating;
  final String slug;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.stock,
    required this.status,
    this.image,
    required this.featured,
    required this.rating,
    required this.slug,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as double? ?? 0.0),
      categoryId: json['category']?['_id'] ?? '',
      stock: json['stock'] ?? 0,
      status: json['status'] ?? '',
      image: json['image'],
      featured: json['featured'] ?? false,
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] as double? ?? 0.0),
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id, // Nếu bạn cần gửi lại dữ liệu này tới server
        'name': name,
        'description': description,
        'price': price,
        'categoryId': categoryId, // Gửi lại dưới dạng ID của danh mục
        'stock': stock,
        'status': status,
        'image': image,
        'featured': featured,
        'rating': rating,
        'slug': slug,
      };
}
