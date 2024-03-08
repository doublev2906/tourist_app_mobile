import 'package:get/instance_manager.dart';
import 'package:tourist_app_mobille/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
