import 'package:get/instance_manager.dart';
import 'package:tourist_app_mobille/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
