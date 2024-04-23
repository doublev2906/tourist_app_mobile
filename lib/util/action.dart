import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

Future<LocationPermission> checkLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  return permission;
}

Future<Position?> getCurrentLocation() async {
  LocationPermission permission = await checkLocationPermission();
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }
  return null;
}

void showNotificationSuccess(String message, {int seconds = 3}) =>
    Get.snackbar('Success', 'message',
        titleText: const Text(
          "Thành công",
          style: TextStyle(
              fontSize: 18,
              height: 24 / 18,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        messageText: Text(message,
            style: const TextStyle(
                fontSize: 16, height: 20 / 16, color: Colors.white)),
        backgroundColor: const Color(0xff27AE60),
        duration: Duration(seconds: seconds),
        shouldIconPulse: false,
        borderRadius: 10,
        padding: const EdgeInsets.all(10),
        icon: const Icon(
          Icons.sunny,
          size: 30,
          color: Colors.white,
        ));

void showNotificationError(String message, {int seconds = 3}) =>
    Get.snackbar('Error', 'message',
        titleText: const Text(
          "Thất bại",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(message,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFFFF4759),
        duration: Duration(seconds: seconds),
        borderRadius: 10,
        shouldIconPulse: false,
        padding: const EdgeInsets.all(10),
        icon: const Icon(
          Icons.error_outline_outlined,
          size: 30,
          color: Colors.white,
        ));

DateTime setDateTimeToZero(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

DateTime getCurrentTime() {
  return setDateTimeToZero(DateTime.now());
}
