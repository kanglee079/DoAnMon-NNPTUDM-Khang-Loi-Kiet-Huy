import 'package:app_mobile_shopping/manage/bindings/order_binding.dart';
import 'package:app_mobile_shopping/manage/bindings/product_binding.dart';
import 'package:app_mobile_shopping/manage/bindings/register_binding.dart';
import 'package:app_mobile_shopping/manage/bindings/user_binding.dart';
import 'package:app_mobile_shopping/pages/categoryAdminPage/category_admin_page.dart';
import 'package:app_mobile_shopping/pages/categoryAdminPage/productManagePage/product_manage_page.dart';
import 'package:app_mobile_shopping/pages/forgotPassPage/forgot_pass_page.dart';
import 'package:app_mobile_shopping/pages/homeAdminPage/home_admin_page.dart';
import 'package:app_mobile_shopping/pages/navigator_admin_page.dart';
import 'package:app_mobile_shopping/pages/orderAdminPage/order_admin_page.dart';
import 'package:get/get.dart';

import '../../manage/bindings/category_binding.dart';
import '../../manage/bindings/login_binding.dart';
import '../../pages/OrderPage/order_page.dart';
import '../../pages/ProfilePage/profile_page.dart';
import '../../pages/categoriesPage/categories_page.dart';
import '../../pages/homePage/home_page.dart';
import '../../pages/loginPage/login_page.dart';
import '../../pages/navigator_page.dart';
import '../../pages/registerPage/register_page.dart';
import 'route_name.dart';

class RouterCustom {
  static List<GetPage> getPage = [
    GetPage(
      name: RouterName.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouterName.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: RouterName.nav,
      page: () => const NavigatorPage(),
      bindings: [
        ProductBinding(),
        CategoryBinding(),
        UserBinding(),
        OrderBinding(),
        CategoryBinding(),
      ],
    ),
    GetPage(
      name: RouterName.home,
      page: () => const HomePage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: RouterName.categories,
      page: () => const CategoriesPage(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: RouterName.order,
      page: () => const OrderPage(),
      binding: OrderBinding(),
      // bindings: [
      //   OrderBinding(),
      //   CategoryBinding(),
      // ],
    ),
    GetPage(
      name: RouterName.profile,
      page: () => const ProfilePage(),
      binding: UserBinding(),
    ),
    GetPage(
      name: RouterName.forgotPass,
      page: () => const ForgotPassPage(),
    ),
    GetPage(
      name: RouterName.homeAdmin,
      page: () => const HomeAdminPage(),
    ),
    GetPage(
        name: RouterName.categoryAdmin,
        page: () => const CategoryAdminPage(),
        bindings: [
          ProductBinding(),
          CategoryBinding(),
          UserBinding(),
        ]),
    GetPage(
      name: RouterName.orderAdmin,
      page: () => OrderAdminPage(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: RouterName.navAdmin,
      page: () => const NavigatorAdminPage(),
      bindings: [
        ProductBinding(),
        CategoryBinding(),
        UserBinding(),
        OrderBinding(),
        CategoryBinding(),
      ],
    ),
    GetPage(
      name: RouterName.productManage,
      page: () => const ProductManagePage(),
      binding: ProductBinding(),
    ),
  ];
}
