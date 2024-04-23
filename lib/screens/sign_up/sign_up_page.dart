import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourist_app_mobille/controllers/sign_up_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/widgets/base_text_field.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  String validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Email không hợp lệ";
    }
    return "";
  }

  String validatePhoneNumber(String value) {
    if (!GetUtils.isPhoneNumber(value)) {
      return "Số điện thoại không hợp lệ";
    }
    return "";
  }

  String validatePassword(String value) {
    if (value.length < 6) {
      return "Mật khẩu phải có ít nhất 6 ký tự";
    }
    return "";
  }

  String validateConfirmPassword(String value) {
    if (value != controller.password.value) {
      return "Mật khẩu không khớp";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffff0f2f6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            title: const Text(
              'Đăng ký tài khoản',
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
        body: Obx(() {
          String emailError = "",
              phoneNumberError = "",
              passwordError = "",
              confirmPasswordError = "";
          if (controller.email.value.isNotEmpty) {
            emailError = validateEmail(controller.email.value);
          }
          if (controller.phoneNumber.value.isNotEmpty) {
            phoneNumberError =
                validatePhoneNumber(controller.phoneNumber.value);
          }
          if (controller.password.value.isNotEmpty) {
            passwordError = validatePassword(controller.password.value);
          }
          if (controller.confirmPassword.value.isNotEmpty) {
            confirmPasswordError =
                validateConfirmPassword(controller.confirmPassword.value);
          }

          final isError = emailError.isNotEmpty ||
              phoneNumberError.isNotEmpty ||
              passwordError.isNotEmpty ||
              confirmPasswordError.isNotEmpty;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              children: [
                BaseTextField(
                    hintText: "Nhập email",
                    labelText: "Email",
                    textError: emailError,
                    onChanged: controller.email.call),
                const SizedBox(height: 20),
                BaseTextField(
                    hintText: "Nhập tên người dùng",
                    labelText: "Tên người dùng",
                    onChanged: controller.username.call),
                const SizedBox(height: 20),
                BaseTextField(
                    hintText: "Nhập số điện thoại",
                    textError: phoneNumberError,
                    labelText: "Số điện thoại",
                    onChanged: controller.phoneNumber.call),
                const SizedBox(height: 20),
                BaseTextField(
                    hintText: "Nhập mật khẩu",
                    textError: passwordError,
                    labelText: "Mật khẩu",
                    isPassword: true,
                    onChanged: controller.password.call),
                const SizedBox(height: 20),
                BaseTextField(
                    hintText: "Nhập lại mật khẩu",
                    textError: confirmPasswordError,
                    labelText: "Xác nhận mật khẩu",
                    isPassword: true,
                    onChanged: controller.confirmPassword.call),
                const SizedBox(height: 40),
                SizedBox(
                  width: Get.width,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: isError ? null : controller.signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Đăng ký'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Bạn đã có tài khoản? "),
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => Get.back(),
                        child: const Text("Đăng nhập",
                            style: TextStyle(color: ColorPalette.primaryColor)))
                  ],
                )
              ],
            ),
          );
        }));
  }
}
