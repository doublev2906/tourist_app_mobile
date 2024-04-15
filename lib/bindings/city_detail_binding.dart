import 'package:get/instance_manager.dart';
import 'package:tourist_app_mobille/controllers/city_detail_controller.dart';

class CityDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CityDetailController());
  }
}
