import 'package:flutter/material.dart';

class HomeAdminPage extends StatelessWidget {
  const HomeAdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.home,
          color: Colors.white,
        ),
        title: const Text('Trang Chủ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
      ),
    );
  }
}
