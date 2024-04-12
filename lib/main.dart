import 'package:app_mobile_shopping/manage/controllers/category_controller.dart';
import 'package:app_mobile_shopping/pages/my_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'manage/controllers/product_controller.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ProductController());
  Get.put(CategoryController());
  runApp(const MyApp());
}
