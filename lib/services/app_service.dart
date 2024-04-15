import 'dart:convert';

import 'package:get/get.dart';
import 'package:tourist_app_mobille/storage/storage.dart';

class AppService extends GetxService {
  final longitude = Rx<double?>(null);
  final latitude = Rx<double?>(null);

  final currentCity = Rx<String>("");
  final currentUser = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    final user = appStorage.getData(userKey);
    if (user.isNotEmpty) {
      currentUser(jsonDecode(user));
    }
  }

  void setPosition(double lat, double long) {
    latitude(lat);
    longitude(long);
  }
}
