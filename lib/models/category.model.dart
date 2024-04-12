import 'product.model.dart';

class Category {
  final String id;
  final String name;
  final String desc;
  final int ordering;
  final String status;
  // final List<Product> products;
  final String? imageUrl;
  final String slug;

  Category({
    required this.id,
    required this.name,
    this.desc = '',
    this.ordering = 0,
    this.status = 'active',
    // required this.products,
    this.imageUrl,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    // var productList = json['products'] as List? ?? [];
    // List<Product> productsList = productList.map((productMap) {
    //   return Product.fromJson(productMap as Map<String, dynamic>);
    // }).toList();

    return Category(
      id: json['_id'],
      name: json['name'],
      desc: json['desc'] ?? '',
      ordering: json['ordering']?.toInt() ?? 0,
      status: json['status'] ?? 'active',
      // products: productsList,
      imageUrl: json['image_url'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'desc': desc,
      'ordering': ordering,
      'status': status,
      // 'products': products.map((product) => product.toJson()).toList(),
      'image_url': imageUrl,
      'slug': slug,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? desc,
    int? ordering,
    String? status,
    List<Product>? products,
    String? imageUrl,
    String? slug,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      ordering: ordering ?? this.ordering,
      status: status ?? this.status,
      // products: products ?? this.products,
      imageUrl: imageUrl ?? this.imageUrl,
      slug: slug ?? this.slug,
    );
  }
}
