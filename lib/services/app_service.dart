import 'dart:convert';

import 'package:get/get.dart';

class AppService extends GetxService {
  final longitude = Rx<double?>(null);
  final latitude = Rx<double?>(null);

  void setPosition(double lat, double long) {
    latitude(lat);
    longitude(long);
  }
}
