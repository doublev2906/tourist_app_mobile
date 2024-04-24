import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourist_app_mobille/network/api.dart';
import 'package:tourist_app_mobille/services/app_service.dart';
import 'package:tourist_app_mobille/storage/storage.dart';
import 'package:tourist_app_mobille/util/action.dart';

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

  final appService = Get.find<AppService>();

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

  bool checkDestinationIsFavorite() {
    final user = appService.currentUser.value;
    if (user.isEmpty) {
      return false;
    }
    final favoriteList =
        ((user["favorite_destinations"] ?? []) as List).cast<String>();
    return favoriteList.contains(destination["id"]);
  }

  void toggleFavorite() {
    final user = {...appService.currentUser.value};
    if (user.isEmpty) {
      Get.snackbar(
          "Thông báo", "Vui lòng đăng nhập để thực hiện chức năng này");
      return;
    }
    final favoriteList =
        ((user["favorite_destinations"] ?? []) as List).cast<String>();
    if (favoriteList.contains(destination["id"])) {
      favoriteList.remove(destination["id"]);
    } else {
      favoriteList.add(destination["id"]);
    }
    user["favorite_destinations"] = favoriteList;

    Api.dio.post("$headerUrl/user/favorite_destination", data: {
      "list_destinations": favoriteList,
    }).then((res) {
      if (res.data["success"]) {
        appService.currentUser(user);
        final userData = appStorage.getUser();
        if (userData.isNotEmpty) {
          final user = jsonDecode(userData);
          user["favorite_destinations"] = favoriteList;
          appStorage.putData(userKey, jsonEncode(user));
        }
      }
    });
  }

  Future<List<String>> pickListImages() async {
    final ImagePicker picker = ImagePicker();
    final files = await picker.pickMultiImage(limit: 8);
    if (files.isEmpty) {
      return [];
    }
    showProgress();
    final documentData = await Future.wait(
        files.map((file) => handleUploadDocument(file.path, file.name)));
    closeProgress();
    return documentData
        .map((e) => e?["content_url"].toString())
        .toList()
        .cast<String>();
  }

  void sendReview(double rating, String content, List<String> images) {
    final user = appService.currentUser.value;
    if (user.isEmpty) {
      showNotificationError("Vui lòng đăng nhập để thực hiện chức năng này");
      return;
    }
    const url = "$headerUrl/destination/review";
    Api.dio.post(url, data: {
      "place_id": destination["destination_id"],
      "rating": rating,
      "content": content,
      "images": images,
    }).then((res) {
      if (res.data["success"]) {
        // loadDestinationData();
      }
    });
  }
}
