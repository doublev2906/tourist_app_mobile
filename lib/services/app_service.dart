import 'dart:convert';

import 'package:get/get.dart';
import 'package:tourist_app_mobille/network/api.dart';
import 'package:tourist_app_mobille/storage/storage.dart';

class AppService extends GetxService {
  final longitude = Rx<double?>(null);
  final latitude = Rx<double?>(null);

  final currentCity = Rx<String>("");
  final currentUser = Rx<Map<String, dynamic>>({});

  final listCity = RxList<Map<String, dynamic>>([]);

  @override
  void onInit() {
    super.onInit();
    loadListCity();
    final user = appStorage.getData(userKey);
    if (user.isNotEmpty) {
      currentUser(jsonDecode(user));
    }
  }

  void setPosition(double lat, double long) {
    latitude(lat);
    longitude(long);
  }

  void loadListCity() {
    const url = "$headerUrl/city/all_city";
    Api.dio.get(url).then((response) {
      final data = response.data;
      listCity((data["data"] as List).cast<Map<String, dynamic>>());
    });
  }

  bool isAuth() => currentUser.value.isNotEmpty;
}
