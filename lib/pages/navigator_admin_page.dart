import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_mobile_shopping/manage/controllers/order_controller.dart';
import 'package:app_mobile_shopping/pages/ProfilePage/profile_page.dart';
import 'package:app_mobile_shopping/pages/categoryAdminPage/category_admin_page.dart';
import 'package:app_mobile_shopping/pages/orderAdminPage/order_admin_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigatorAdminPage extends StatefulWidget {
  const NavigatorAdminPage({super.key});

  @override
  State<NavigatorAdminPage> createState() => _NavigatorAdminPageState();
}

class _NavigatorAdminPageState extends State<NavigatorAdminPage> {
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    return Scaffold(
      body: IndexedStack(
        index: _bottomNavIndex,
        children: <Widget>[
          // HomeAdminPage(),
          const CategoryAdminPage(),
          OrderAdminPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.pink.shade300,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        icons: const [
          // Icons.home,
          Icons.category,
          Icons.shopping_cart_checkout,
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
