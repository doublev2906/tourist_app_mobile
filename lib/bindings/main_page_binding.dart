import 'package:get/instance_manager.dart';
import 'package:tourist_app_mobille/controllers/home_controller.dart';

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
