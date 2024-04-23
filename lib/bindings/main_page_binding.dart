import 'package:get/instance_manager.dart';
import 'package:tourist_app_mobille/controllers/account_controller.dart';
import 'package:tourist_app_mobille/controllers/home_controller.dart';
import 'package:tourist_app_mobille/controllers/trips_controller.dart';

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AccountController());
    Get.lazyPut(() => TripsController());
  }
}
