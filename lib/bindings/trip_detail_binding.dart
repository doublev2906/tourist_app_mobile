import 'package:get/instance_manager.dart';
import 'package:tourist_app_mobille/controllers/trip_detail_controller.dart';

class TripDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TripDetailController());
  }
}
