import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../manage/controllers/register_controller.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/text_form_custom.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
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
                    "Đăng Ký",
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
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Theme.of(context).canvasColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: SingleChildScrollView(
                      child: Form(
                        key: controller.keyRegisterForm,
                        child: Column(
                          children: [
                            TextFormCustom(
                              controller: controller.usernameController,
                              hintText: 'Tên Đăng Nhập',
                              errorCheck: 'username',
                            ),
                            const SizedBox(height: 20),
                            TextFormCustom(
                              controller: controller.emailController,
                              hintText: 'Email',
                              iconPrefix: Icons.email,
                              errorCheck: 'email',
                            ),
                            const SizedBox(height: 20),
                            TextFormCustom(
                              controller: controller.passwordController,
                              hintText: 'Mật Khẩu',
                              iconPrefix: Icons.lock,
                              isPassword: true,
                              errorCheck: 'password',
                            ),
                            const SizedBox(height: 20),
                            TextFormCustom(
                              controller: controller.addressController,
                              hintText: 'Địa Chỉ',
                              iconPrefix: Icons.home,
                              errorCheck: 'address',
                            ),
                            const SizedBox(height: 20),
                            TextFormCustom(
                              controller: controller.fullnameController,
                              hintText: 'Tên Đầy Đủ',
                              iconPrefix: Icons.person,
                              errorCheck: 'fullname',
                            ),
                            const SizedBox(height: 25),
                            Obx(
                              () => ButtonCustom(
                                onloading: controller.loading.value,
                                onTap: controller.register,
                                backgroundColor: Colors.blue.shade400,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white),
                                textButton: 'ĐĂNG KÝ',
                              ),
                            ),
                            const SizedBox(height: 20),
                            ButtonCustom(
                              onTap: controller.transToLoginPage,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.white),
                              backgroundColor: Colors.blue.shade400,
                              textButton: 'Quay lại đăng nhập',
                            ),
                          ],
                        ),
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
