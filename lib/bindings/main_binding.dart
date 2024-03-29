import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tourist_app_mobille/services/app_service.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio(), fenix: true);
    Get.lazyPut(() => AppService(), fenix: true);
    // Get.lazyPut(() => PageService(), fenix: true);
  }
}
