import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourist_app_mobille/network/api.dart';

class DestinationDetailController extends GetxController {
  final destination = Get.arguments ?? {};
  final ScrollController scrollController = ScrollController();
  final isExpand = Rx(true);
  final isTabPinned = Rx(true);
  final currentTabIndex = Rx<int>(0);
  final loadingData = RxBool(true);
  final destinationData = Rx<Map<String, dynamic>>({});

  final reviewSelectTab = Rx<String>("review");
  final nearByType = Rx<String>("nearbyHotel");

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      // isTabPinned(
      //     scrollController.hasClients && scrollController.offset >= 200);
      isExpand(scrollController.hasClients &&
          scrollController.offset <= (kToolbarHeight));
    });
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    loadDestinationData();
  }

  void loadDestinationData() {
    loadingData(true);
    final url = "$headerUrl/destination/detail/${destination['id']}";
    Api.dio.get(url).then((res) {
      loadingData(false);
      if (res.data["success"]) {
        destinationData(res.data["data"]);
      }
    });
  }
}
