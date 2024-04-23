import 'package:get/instance_manager.dart';
import 'package:tourist_app_mobille/controllers/map_view_controller.dart';

class MapViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapViewController());
  }
}
