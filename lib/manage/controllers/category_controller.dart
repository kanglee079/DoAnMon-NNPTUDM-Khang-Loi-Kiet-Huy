import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apps/const/token_storage.dart';
import '../../models/category.model.dart';
import '../../models/product.model.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categoryList = <Category>[].obs;
  final String categoriesUrl = "http://localhost:3000/categories";

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<Map<String, String>> _getHeaders() async {
    String? token = await TokenStorage.getToken();
    String? userId = await TokenStorage.getUserId();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-user-id': userId ?? '',
    };
  }

  Future<void> fetchCategories() async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(categoriesUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        var categoryListJson = responseData['message']['metadata'] as List;
        // print(categoryListJson);
        categoryList.value = categoryListJson
            .map((categoryJson) =>
                Category.fromJson(categoryJson as Map<String, dynamic>))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch categories');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addCategory(Map<String, dynamic> categoryData) async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(categoriesUrl),
        headers: headers,
        body: jsonEncode(categoryData),
      );

      if (response.statusCode == 201) {
        Get.back();
        fetchCategories();
        Get.snackbar('Thành công', 'Thêm danh mục thành công');
      } else {
        Get.snackbar('Lỗi', 'Failed to add category');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateCategory(
      String categoryId, Map<String, dynamic> updatedData) async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$categoriesUrl/$categoryId'),
        headers: headers,
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        fetchCategories();
      } else {
        Get.snackbar('Error', 'Failed to update category');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCategory(String slug) async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$categoriesUrl/$slug'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        fetchCategories();
        Get.snackbar('Thành công', 'Xóa danh mục thành công');
      } else {
        Get.snackbar('Error', 'Failed to delete category');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchProductsByCategory(String categoryId) async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      final response = await http.get(
        Uri.parse('$categoriesUrl/$categoryId/products'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Assuming that the response structure is the same as fetching all categories
        var productListJson = responseData['message']['metadata'] as List;
        // Update the specific category with the fetched products
        int index =
            categoryList.indexWhere((category) => category.id == categoryId);
        if (index != -1) {
          var updatedCategory = categoryList[index].copyWith(
            products: productListJson
                .map((productJson) => Product.fromJson(productJson))
                .toList(),
          );
          categoryList[index] = updatedCategory;
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch products for the category');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  // Add other methods if needed...
}
