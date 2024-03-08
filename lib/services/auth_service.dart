import 'dart:convert';

import 'package:get/get.dart';
import 'package:tourist_app_mobille/models/user_model.dart';
import 'package:tourist_app_mobille/storage/storage.dart';

class AuthService extends GetxService {
  final name = Rx<String>('');

  final email = Rx<String>('');

  final phoneNumber = Rx<String>('');

  final userId = Rx<String>('');

  void setUserData() {
    final String userData = appStorage.getToken(userKey);
    if (userData == "") return;
    final UserModel user =
        UserModel.fromJson(jsonDecode(userData) as Map<String, dynamic>);
    name(user.name);
    email(user.email);
    phoneNumber(user.phoneNumber);
    userId(user.id);
  }
}
