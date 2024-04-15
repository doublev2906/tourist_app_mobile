import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tourist_app_mobille/network/api.dart';

class ListDestinationController extends GetxController {
  final listDestination = RxList<Map<String, dynamic>>([]);
  final loadingDestination = RxBool(false);
  final refreshController = RefreshController(initialRefresh: false);
  final isLoadMore = RxBool(false);
  final canLoadMore = RxBool(true);
  final searchController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    getDestination(isFirstLoading: true);
    searchController.addListener(() {
      getDestination(isSearch: true);
    });
  }

  void getDestination({isFirstLoading = false, bool isSearch = false}) {
    int offset = listDestination.length;
    String search = searchController.text;
    final url =
        "$headerUrl/destination/get_list_destination?offset=$offset${isSearch && searchController.text.isNotEmpty ? "&search=$search" : ""}";
    if (!canLoadMore.value) return;
    if (isFirstLoading) {
      loadingDestination(true);
    }
    Api.dio.get(url).then((res) {
      if (isFirstLoading) {
        loadingDestination(false);
      } else {
        refreshController.loadComplete();
      }
      if (res.data["data"] != null) {
        final data = (res.data["data"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        if (data.length < 10) {
          canLoadMore(false);
        }
        if (isSearch) {
          listDestination([...data]);
        } else {
          listDestination([...listDestination, ...data]);
        }
      }
    });
  }

  void loadMore() {
    isLoadMore(true);
    getDestination();
  }
}
