import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourist_app_mobille/controllers/login_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';
import 'package:tourist_app_mobille/widgets/base_text_field.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfffF0F2F6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            title: const Text(
              'Đăng nhập',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorPalette.primaryColor.withOpacity(0.2),
                      ColorPalette.primaryColor
                    ],
                  )),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            children: [
              BaseTextField(
                  hintText: "Nhập email",
                  labelText: "Email",
                  onChanged: controller.email.call),
              const SizedBox(height: 20),
              BaseTextField(
                  hintText: "Nhập mật khẩu",
                  labelText: "Mật khẩu",
                  isPassword: true,
                  onChanged: controller.password.call),
              const SizedBox(height: 40),
              SizedBox(
                width: Get.width,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Đăng nhập'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Bạn chưa có tài khoản? "),
                  TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => Get.toNamed(AppRoutes.SIGN_UP),
                      child: const Text("Đăng ký ngay",
                          style: TextStyle(color: ColorPalette.primaryColor)))
                ],
              )
            ],
          ),
        ));
  }
}
