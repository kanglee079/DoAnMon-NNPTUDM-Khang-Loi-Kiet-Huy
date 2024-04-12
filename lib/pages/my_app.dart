import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apps/const/token_storage.dart';
import '../apps/route/route_custom.dart';
import '../apps/route/route_name.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        TokenStorage.hasToken(),
        TokenStorage.getUserRole(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final hasToken = snapshot.data?[0] ?? false;
          final userRole = snapshot.data?[1] as String?;
          print(userRole);

          if (!hasToken) {
            return GetMaterialApp(
                initialRoute: RouterName.login,
                getPages: RouterCustom.getPage,
                debugShowCheckedModeBanner: false);
          }

          final initialRoute =
              userRole == "admin" ? RouterName.navAdmin : RouterName.nav;

          return GetMaterialApp(
            initialRoute: initialRoute,
            getPages: RouterCustom.getPage,
            debugShowCheckedModeBanner: false,
          );
        } else {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
