import 'package:dio/dio.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio(), fenix: true);
    // Get.lazyPut(() => AuthService(), fenix: true);
    // Get.lazyPut(() => PageService(), fenix: true);
  }
}