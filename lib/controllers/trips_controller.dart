import 'package:get/get.dart';
import 'package:tourist_app_mobille/network/api.dart';
import 'package:tourist_app_mobille/services/app_service.dart';

class TripsController extends GetxController {
  final trips = RxList<Map<String, dynamic>>([]);
  final loadingTrips = RxBool(false);

  final appService = Get.find<AppService>();

  @override
  void onReady() {
    super.onReady();
    if (appService.isAuth()) {
      print(appService.currentUser.value["access_token"]);
      loadTrips();
    }
  }

  void loadTrips() {
    loadingTrips(true);
    const url = "$headerUrl/trips/";
    Api.dio.get(url).then((res) {
      loadingTrips(false);
      trips((res.data['data'] as List).cast<Map<String, dynamic>>().toList());
    });
  }

  void createTrip(String name) {
    const url = "$headerUrl/trips/create";
    Api.dio.post(url, data: {"name": name}).then((res) {
      if (res.data['success']) {
        loadTrips();
      }
    });
  }
}
