import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourist_app_mobille/network/api.dart';

class CityDetailController extends GetxController {
  final cityData = Get.arguments ?? {};

  final cityDetailData = Rx<Map<String, dynamic>>({});
  final loadingCityDetail = RxBool(false);

  final ScrollController scrollController = ScrollController();
  final isExpand = Rx(true);

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      isExpand(scrollController.hasClients &&
          scrollController.offset <= (248 - kToolbarHeight));
    });
  }

  @override
  void onReady() {
    super.onReady();
    getCityDetailData();
  }

  void getCityDetailData() {
    loadingCityDetail(true);
    final jump_url = cityData["extra_info"]["jump_url"];
    final url = "$headerUrl/city/${cityData['id']}?jump_url=$jump_url";
    Api.dio.get(url).then((res) {
      loadingCityDetail(false);
      if (res.data["success"]) {
        cityDetailData(res.data);
      }
    });
  }
}
