import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../apps/const/token_storage.dart';
import '../../models/user.model.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var isLoadingImage = false.obs;
  var userList = <User>[].obs;
  var userInfo = User(
          id: '',
          username: '',
          email: '',
          phone: '',
          status: '',
          ordering: 0,
          role: '')
      .obs;
  final apiUrl = "http://localhost:3000/auths";

  @override
  void onInit() {
    super.onInit();
    checkUserRoleAndFetchUsers();
  }

  void checkUserRoleAndFetchUsers() async {
    String? role = await TokenStorage.getUserRole();
    if (role == 'admin') {
      fetchAllUsers();
      fetchUserInfo();
    } else {
      fetchUserInfo();
    }
  }

  Future<void> fetchUserInfo() async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();
      final response = await http.get(
        Uri.parse('$apiUrl/info'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userId ?? '',
        },
      );

      if (response.statusCode == 200) {
        userInfo.value =
            User.fromJson(json.decode(response.body)['message']['metadata']);
      } else {
        Get.snackbar('Error', 'Failed to fetch user info');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUserInfo(Map<String, dynamic> updatedData) async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();
      final response = await http.put(
        Uri.parse('$apiUrl/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userId ?? '',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        fetchUserInfo();
        Get.snackbar('Success', 'User info updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update user info');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> changeUserPassword(
      String currentPassword, String newPassword) async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();

      if (userId == null) {
        throw Exception('User ID is null');
      }

      final response = await http.put(
        Uri.parse('$apiUrl/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userId,
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password changed successfully');
      } else {
        Get.snackbar('Error', 'Failed to change password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> uploadAvatar(File imageFile) async {
    isLoadingImage(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();

      if (userId == null || token == null) {
        throw Exception('Token or User ID is null');
      }

      var uri = Uri.parse('$apiUrl/upload-avatar/$userId');
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
          'x-user-id': userId,
        })
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path,
            contentType: MediaType('image', 'png')));

      // print(request.headers);

      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var response = await http.Response.fromStream(streamedResponse);
        print(response.body);
        Get.snackbar('Thành Công', 'Cập nhât ảnh đại diện thành công');
        fetchUserInfo();
      } else {
        Get.snackbar('Error',
            'Failed to upload avatar. Status code: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception occurred: $e');
    } finally {
      isLoadingImage(false);
    }
  }

  Future<void> fetchAllUsers() async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userId = await TokenStorage.getUserId();

      if (userId == null || token == null) {
        throw Exception('Token or User ID is null');
      }

      final response = await http.get(
        Uri.parse('$apiUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userId,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> usersJson =
            json.decode(response.body)['message']['metadata'];
        userList.value = List<User>.from(
            usersJson.map((userJson) => User.fromJson(userJson)));
      } else {
        Get.snackbar('Error', 'Failed to fetch users');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> changeUserStatus(String userId, String newStatus) async {
    isLoading(true);
    try {
      String? token = await TokenStorage.getToken();
      String? userIdAdmin = await TokenStorage.getUserId();
      // print(userId);

      if (userIdAdmin == null || token == null) {
        throw Exception('Token or User ID is null');
      }
      final response = await http.post(
        Uri.parse('$apiUrl/status/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-user-id': userIdAdmin,
        },
        body: jsonEncode({'status': newStatus}),
      );
      // print(response.body);
      // print(response.statusCode);
      // print(response.request!.headers);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Cập nhật trạng thái thành công');
      } else {
        Get.snackbar('Error', 'Failed to change user status');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
