import 'dart:convert';

import 'package:get/get.dart';
import 'package:tourist_app_mobille/network/api.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';
import 'package:tourist_app_mobille/services/app_service.dart';
import 'package:tourist_app_mobille/storage/storage.dart';
import 'package:tourist_app_mobille/util/action.dart';

class SignUpController extends GetxController {
  final email = Rx<String>("");
  final username = Rx<String>("");
  final phoneNumber = Rx<String>("");
  final password = Rx<String>("");
  final confirmPassword = Rx<String>("");

  final loading = RxBool(false);
  final AppService appService = Get.find();

  void signUp() {
    if (email.value.isEmpty) {
      return showNotificationError("Email không được để trống");
    }
    if (username.value.isEmpty) {
      return showNotificationError("Tên người dùng không được để trống");
    }

    if (phoneNumber.value.isEmpty) {
      return showNotificationError("Số điện thoại không được để trống");
    }
    if (password.value.isEmpty) {
      return showNotificationError("Mật khẩu không được để trống");
    }
    if (confirmPassword.value.isEmpty) {
      return showNotificationError("Xác nhận mật khẩu không được để trống");
    }

    loading(true);
    const url = "$headerUrl/user/sign_up";
    final data = {
      "email": email.value,
      "name": username.value,
      "phone_number": phoneNumber.value,
      "password": password.value,
      "confirm_password": confirmPassword.value
    };
    Api.dio.post(url, data: data).then((response) {
      loading(false);
      if (response.data["success"] == true) {
        appStorage.putData(userKey, jsonEncode(response.data["user_data"]));
        appService
            .currentUser((response.data["user_data"] as Map<String, dynamic>));
        showNotificationSuccess("Đăng ký thành công");
        Get.offNamedUntil(AppRoutes.MAIN, (page) => false);
      } else {
        showNotificationError("Đăng ký thất bại");
      }
    }).catchError((error) {
      loading(false);
      showNotificationError("Đăng ký thất bại");
    });
  }
}
