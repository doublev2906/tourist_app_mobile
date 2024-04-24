import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart' as dio;
import 'package:tourist_app_mobille/network/api.dart';

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

Future<Map<String, dynamic>?> handleUploadDocument(
    String localPath, String? filename) async {
  const String url =
      'https://pancake.vn/api/v1/pages/114764021700779/contents?access_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI4OTBlZGE5YS05ZTdiLTRiNDgtYjQwOC1mZjUwMTBiNmIzNDgiLCJsb2dpbl9zZXNzaW9uIjpudWxsLCJpYXQiOjE3MTIyMDI0ODksImZiX25hbWUiOiJWYW4gVnUiLCJmYl9pZCI6IjEyMjA5MzE1MzgxMDEyMDc1NCIsImV4cCI6NDUzNDcwNTc1NDc4MzQsImNicyI6dHJ1ZX0.nxLSuKeW6WBBZGDJ6zIanCZd9LcwxIrLOfVRrbbomdM';
  try {
    MediaType? mediaType;
    final String? mimeType = lookupMimeType(localPath);
    if (mimeType != null) {
      final List<String> dataMimeType = mimeType.split('/');
      if (dataMimeType.length == 2) {
        mediaType = MediaType(dataMimeType[0], dataMimeType[1]);
      }
    }
    final Map<String, dynamic> data = {
      'file': await dio.MultipartFile.fromFile(localPath,
          filename: filename, contentType: mediaType),
    };
    final formData = dio.FormData.fromMap(data);
    final res = await Api.dio.post(url, data: formData);
    if (res.data['success']) {
      res.data.remove('success');
      return res.data;
    }
  } catch (_) {}
  return null;
}

void closeProgress() {
  if (Get.context?.mounted == true && Get.isDialogOpen == true) {
    Get.close(1);
  }
}

/// View loading toàn màn
void showProgress() {
  if (Get.context?.mounted == true && Get.isDialogOpen == false) {
    Get.dialog(
        barrierDismissible: false,
        barrierColor: const Color(
            0x00FFFFFF), // Màu nền dialog mặc định là màu đen mờ, được đổi thành màu trong suốt ở đây (các thuộc tính đã thêm trong 1.20)
        Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              height: 88.0,
              width: 120.0,
              decoration: const ShapeDecoration(
                color: Color(0xFF3A3A3A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Theme(
                    data: ThemeData(
                      cupertinoOverrideTheme: const CupertinoThemeData(
                        brightness: Brightness
                            .dark, // Nếu theme hiện tại là dark mode, màu của loading sẽ được đặt thành màu trắng
                      ),
                    ),
                    child: const CupertinoActivityIndicator(radius: 14.0),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Loading',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
        transitionCurve: Curves.ease);
  }
}
