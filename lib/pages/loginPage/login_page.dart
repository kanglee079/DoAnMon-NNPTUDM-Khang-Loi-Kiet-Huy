import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../manage/controllers/login_controller.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/form_login_widget.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.pink.shade200, Colors.blueGrey.shade200],
            ),
          ),
          child: Column(
            children: [
              const Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Bakery Store",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Theme.of(context).canvasColor,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.black87),
                          ),
                          const SizedBox(height: 20),
                          FormLoginWidget(
                            keyLoginForm: controller.keyLoginForm,
                            emailController: controller.usernameController,
                            passwordController: controller.passwordController,
                          ),
                          // const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("Quên mật khẩu?"),
                            ),
                          ),
                          Obx(
                            () => ButtonCustom(
                              onloading: controller.loading.value,
                              onTap: controller.login,
                              backgroundColor: Colors.blue.shade400,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.white),
                              textButton: 'ĐĂNG NHẬP',
                            ),
                          ),
                          const SizedBox(height: 20),
                          ButtonCustom(
                            onTap: controller.transToRegisterPage,
                            textStyle: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.white),
                            backgroundColor: Colors.blue.shade400,
                            textButton: 'Đăng kí ngay',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
