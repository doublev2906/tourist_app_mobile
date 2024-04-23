import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tourist_app_mobille/network/api.dart';
import 'package:tourist_app_mobille/util/action.dart';
import 'package:tourist_app_mobille/util/geo_apify.dart';

class TripDetailController extends GetxController {
  final loading = RxBool(true);
  final listDestination = RxList<Map<String, dynamic>>([]);
  final tripData = RxMap<String, dynamic>({});
  final tripId = Get.arguments;
  final indexDaySelect = RxInt(0);

  @override
  void onReady() {
    super.onReady();
    loadListDestination();
  }

  List<String>? getListDay() {
    final startAt = tripData["start_at"];
    final endAt = tripData["end_at"];
    if (startAt == null || endAt == null) return null;
    final startDate = DateTime.parse(startAt);
    final endDate = DateTime.parse(endAt);
    final listDay = <String>[];
    final currentDay = setDateTimeToZero(DateTime.now());
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      listDay.add(formatDateText(currentDay,
          startDate.add(Duration(days: i)).difference(currentDay).inDays));
    }
    return listDay;
  }

  String formatDateTextRange(DateTime startDate, DateTime endDate) {
    final isSameMoth = startDate.month == endDate.month;
    final isSameDate = startDate.day == endDate.day;
    if (isSameDate && isSameMoth) {
      return DateFormat("d MMM", "vi").format(startDate);
    }
    if (isSameMoth) {
      return "${DateFormat("d").format(startDate)} - ${DateFormat("d MMM", "vi").format(endDate)}";
    }
    return "${DateFormat("d MMM", "vi").format(startDate)} - ${DateFormat("d MMM", "vi").format(endDate)}";
  }

  String formatDateText(DateTime date, int difference) {
    if (difference == 0) {
      return "Hôm nay";
    }
    if (difference == 1) {
      return "Ngày mai";
    }
    return DateFormat("EEE, d/M", "vi")
        .format(date.add(Duration(days: difference)));
  }

  String getImageOfListDestination() {
    final list = listDestination
        .map((e) => {
              "lat": e["coordinates"]["latitude"],
              "long": e["coordinates"]["longitude"]
            })
        .toList();
    return GeoApify().genStaticMapImage(list);
  }

  void loadListDestination({bool isLoading = true}) {
    final url = "$headerUrl/trips/$tripId/";
    Api.dio.get(url).then((response) {
      loading(false);
      tripData(response.data["trip"]);
      listDestination((response.data["list_destinations"] ?? [])
          .cast<Map<String, dynamic>>());
    }).catchError((error) {
      loading(false);
    });
  }

  Future<bool> addDestinationToTrip(String destinationId) async {
    final url = "$headerUrl/trips/$tripId/update/";
    final currentListDestination = [
      ...((tripData["list_destinations"] ?? []) as List)
    ];
    final change = {
      "list_destinations": {...currentListDestination, destinationId}.toList()
    };
    final response =
        await Api.dio.post(url, data: {"change": change}).then((response) {
      return response.data["success"];
    }).catchError((error) {
      return false;
    });
    return response;
  }

  void deleteDestinationFromTrip(String destinationId) {
    final url = "$headerUrl/trips/$tripId/update/";
    final currentListDestination = [
      ...((tripData["list_destinations"] ?? []) as List)
    ];
    final destinationsPlan =
        jsonDecode(jsonEncode(tripData["destinations_plan"] ?? {}));
    destinationsPlan.forEach((key, value) {
      final list = value as List;
      if (list.contains(destinationId)) {
        list.remove(destinationId);
      }
    });

    currentListDestination.remove(destinationId);
    final change = {
      "list_destinations": currentListDestination,
      "destinations_plan": destinationsPlan
    };
    Api.dio.post(url,
        data: {"change": change}).then((value) => loadListDestination());
  }

  void addDateToTrip(String? startDate, String? endDate) {
    final url = "$headerUrl/trips/$tripId/update/";
    final change = {"start_at": startDate, "end_at": endDate};
    Api.dio.post(url,
        data: {"change": change}).then((value) => loadListDestination());
  }

  Future addDestinationsToDay(
      int day, List<String> destinationsSelected) async {
    final url = "$headerUrl/trips/$tripId/update/";
    final destinationsPlan =
        jsonDecode(jsonEncode(tripData["destinations_plan"] ?? {}));
    destinationsPlan[day.toString()] = destinationsSelected;
    final change = {"destinations_plan": destinationsPlan};
    return Api.dio.post(url,
        data: {"change": change}).then((value) => loadListDestination());
  }
}
