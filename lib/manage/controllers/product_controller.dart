import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../apps/const/token_storage.dart';
import '../../models/category.model.dart';
import '../../models/product.model.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var isImageLoading = false.obs;
  var productList = <Product>[].obs;
  var productListByCategory = <Product>[].obs;
  String? selectedCategoryId;
  var selectedCategory = Category(id: '', name: 'Chọn Danh Mục', slug: '').obs;

  final apiUrl = "http://localhost:3000/products";

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Utility method to generate headers
  Future<Map<String, String>> _getHeaders() async {
    String? token = await TokenStorage.getToken();
    String? userId = await TokenStorage.getUserId();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-user-id': userId ?? '',
    };
  }

  // Fetch all products
  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      // print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final productsData = responseData['message']['metadata'] as List;
        productList.value = productsData
            .where((productJson) => productJson != null)
            .map((productJson) => Product.fromJson(productJson))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch products');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
      print(e);
    } finally {
      isLoading(false);
    }
  }

  // Add product (admin required)
  Future<void> addProduct(Map<String, dynamic> productData) async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(productData),
      );

      if (response.statusCode == 201) {
        Get.back();

        fetchProducts();
        Get.snackbar('Thành công', 'Sản phẩm đã được thêm vào thành công');
      } else {
        Get.snackbar('Error', 'Failed to add product');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  //update product (admin required)
  Future<void> updateProduct(
      String slug, Map<String, dynamic> productData) async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$apiUrl/$slug'),
        headers: headers,
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200) {
        final index = productList.indexWhere((product) => product.slug == slug);
        if (index != -1) {
          productList[index] = Product.fromJson(
              json.decode(response.body)['message']['metadata']);
          Get.snackbar('Thành công', 'Cập nhật sản phẩm thành công');
        }
      } else {
        Get.snackbar('Lỗi', 'Cập nhật sản phẩm thất bại');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  // Xoá product (admin required)
  Future<void> deleteProduct(String slug) async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$apiUrl/$slug'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        productList.removeWhere((product) => product.slug == slug);
        Get.snackbar('Success', 'Product deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete product');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  // Tìm kiếm sản phẩm
  Future<void> searchProducts(String query) async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$apiUrl/search?name=$query'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final productListJson = responseData['message']['metadata'] as List;
        productList.value = productListJson
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        Get.snackbar('Success', 'Search results retrieved successfully');
      } else {
        Get.snackbar('Error', 'Failed to search products');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  // Thêm nhiều hình ảnh cho sản phẩm (chỉ admin)
  Future<void> addProductImages(
      String productId, List<String> imagePaths) async {
    isLoading(true);
  }

  Future<void> uploadProductImage(String productId, File imageFile) async {
    isImageLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();

      if (userId == null || token == null) {
        throw Exception('Token or User ID is null');
      }

      var uri = Uri.parse('$apiUrl/image/$productId');
      var request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'x-user-id': userId,
        })
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('image', 'png'),
        ));

      print(request.headers);
      print(request.files);

      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var response = await http.Response.fromStream(streamedResponse);
        print(response.body);
        Get.snackbar('Success', 'Ảnh sản phẩm đã được tải lên thành công');
        fetchProducts();
      } else {
        Get.snackbar('Error',
            'Failed to upload product image. Status code: ${streamedResponse.statusCode}');
        print(streamedResponse.statusCode);
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception occurred: $e');
    } finally {
      isImageLoading(false);
    }
  }

  // Lấy sản phẩm theo danh mục
  Future<void> getProductsByCategory(String categoryId) async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$apiUrl/category/$categoryId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final productListJson = responseData['message']['metadata'] as List;
        productListByCategory.value = productListJson
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        // Get.snackbar('Success', 'Products by category retrieved successfully');
      } else {
        Get.snackbar('Error', 'Failed to fetch products for the category');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }
}
