import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_mobile_shopping/manage/controllers/order_controller.dart';
import 'package:app_mobile_shopping/pages/CategoriesPage/categories_page.dart';
import 'package:app_mobile_shopping/pages/OrderPage/order_page.dart';
import 'package:app_mobile_shopping/pages/ProfilePage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'homePage/home_page.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    return Scaffold(
      body: IndexedStack(
        index: _bottomNavIndex,
        children: const <Widget>[
          HomePage(),
          CategoriesPage(),
          OrderPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.pink.shade300,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        icons: const [
          Icons.home,
          Icons.category,
          Icons.shopping_cart,
          Icons.person,
        ],
        activeColor: Colors.blue.shade400,
        inactiveColor: Colors.white,
        iconSize: 30,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
