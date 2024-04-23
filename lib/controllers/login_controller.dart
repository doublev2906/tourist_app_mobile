import 'dart:convert';

import 'package:get/get.dart';
import 'package:tourist_app_mobille/network/api.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';
import 'package:tourist_app_mobille/services/app_service.dart';
import 'package:tourist_app_mobille/storage/storage.dart';
import 'package:tourist_app_mobille/util/action.dart';

class LoginController extends GetxController {
  final email = Rx<String>("");
  final password = Rx<String>("");

  final loading = RxBool(false);
  final AppService appService = Get.find();

  void login() {
    if (email.value.isEmpty) {
      return showNotificationError("Email không được để trống");
    }
    if (password.value.isEmpty) {
      return showNotificationError("Mật khẩu không được để trống");
    }
    loading(true);
    const url = "$headerUrl/user/login";
    final data = {"email": email.value, "password": password.value};
    Api.dio.post(url, data: data).then((response) {
      loading(false);
      if (response.data["success"] == true) {
        appStorage.putData(userKey, jsonEncode(response.data["user_data"]));
        appService
            .currentUser((response.data["user_data"] as Map<String, dynamic>));
        Get.back();
        showNotificationSuccess("Đăng nhập thành công");
      } else {
        showNotificationError("Đăng nhập thất bại");
      }
    }).catchError((error) {
      loading(false);
      showNotificationError("Đăng nhập thất bại");
    });
  }
}
