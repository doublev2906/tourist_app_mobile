import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tourist_app_mobille/models/category.dart';
import 'package:tourist_app_mobille/network/api.dart';
import 'package:tourist_app_mobille/services/app_service.dart';
import 'package:tourist_app_mobille/storage/storage.dart';
import 'package:tourist_app_mobille/util/action.dart';
import 'package:tourist_app_mobille/util/geo_apify.dart';

class HomeController extends GetxController {
  final appService = Get.find<AppService>();

  final currentPlace = Rx<String>("");
  final loadingCity = RxBool(false);
  final listCity = RxList<Map<String, dynamic>>([]);
  final listCityFull = RxList<Map<String, dynamic>>([]);
  final listCategory = RxList<Category>([]);
  final loadingActivities = RxBool(false);
  final activities = RxList<Map<String, dynamic>>([]);

  final destinations = RxList<Map<String, dynamic>>([]);
  final loadingDestination = RxBool(false);

  final refreshController = RefreshController(initialRefresh: false);
  final cityRefreshController = RefreshController(initialRefresh: false);
  final isLoadMore = RxBool(false);
  final canLoadMore = RxBool(true);
  final searchController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    getDestination();
    getListCity();

    searchController.addListener(() {
      getListCity(isLoadFull: true, isSearch: true);
    });
  }

  void getListCity({bool isLoadFull = false, isSearch = false}) {
    int offset = isLoadFull ? listCityFull.length : 0;
    String search = searchController.text;
    if (isLoadFull && isSearch) {
      offset = 0;
    }
    final url =
        "$headerUrl/city/get_list_city?offset=$offset${isSearch && searchController.text.isNotEmpty ? "&search=$search" : ""}";
    if (!isLoadFull) {
      loadingCity(true);
    }
    Api.dio.get(url).then((res) {
      if (!isLoadFull) {
        loadingCity(false);
      } else {
        cityRefreshController.loadComplete();
      }
      if (res.data["data"] != null) {
        final data = (res.data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        if (isLoadFull) {
          if (isLoadFull && isSearch) {
            listCityFull([...data]);
          } else {
            listCityFull([...listCityFull, ...data]);
          }
        } else {
          listCityFull(data);
          listCity(data);
        }
      }
    });
  }

  void getDestination() async {
    loadingDestination(true);
    final position = await getCurrentLocation();
    if (position != null) {
      appService.setPosition(position.latitude, position.longitude);
      loadDestination().then((value) {
        loadingDestination(false);
      });
      GeoApify()
          .getCurrentPosition(lat: position.latitude, long: position.longitude)
          .then(
        (res) {
          if (res["results"] != null && res["results"].length > 0) {
            currentPlace(res["results"][0]["formatted"]);
          }
        },
      );
    }
  }

  Future loadDestination() async {
    if (!canLoadMore.value) {
      return;
    }
    final offset = destinations.length;
    await Api.dio
        .get(
            "$headerUrl/home/destinations?latitude=${appService.latitude}&longitude=${appService.longitude}&offset=$offset")
        .then((res) {
      if (!loadingDestination.value) {
        refreshController.loadComplete();
      }
      if (res.data["success"]) {
        appService.currentCity(res.data["city_id"]);
        final data = res.data["destinations"];
        if (data != null && data.length > 0) {
          destinations.addAll(
              (data as List).map((e) => e as Map<String, dynamic>).toList());
        } else {
          canLoadMore(false);
        }
      }
    });
  }

  void getActivities() {
    Api.dio.get("$headerUrl/home/activities").then((res) {
      if (res.data["success"]) {
        final data = res.data["data"];
        final categories = data["categories"];
        if (appStorage.getData(categoryKey) == "") {
          appStorage.putData(categoryKey, jsonEncode(categories));
        }
        listCategory(categoryListFromMap((categories as List)
            .map((e) => e as Map<String, dynamic>)
            .toList()));
        activities((data["activities"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList());
      }
    });
  }
}
