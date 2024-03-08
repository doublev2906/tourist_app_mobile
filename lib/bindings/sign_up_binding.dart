import 'package:get/instance_manager.dart';
import 'package:tourist_app_mobille/controllers/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
