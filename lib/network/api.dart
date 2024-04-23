import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tourist_app_mobille/network/pretty_dio_logger.dart';
import 'package:tourist_app_mobille/network/request_headers.dart';
import 'package:tourist_app_mobille/storage/storage.dart';

const String headerUrl = 'https://192.168.22.100:4001';
// const String headerUrl = 'https://192.168.1.66:4001';

class Api {
  static Dio? _instance;
  static const int _maxLineWidth = 90;

  static final BaseOptions baseOptions = BaseOptions(
      baseUrl: '$headerUrl/api',
      connectTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 60000));

  static final _prettyDioLogger = PrettyDioLogger(
      requestHeader: false,
      requestBody: false,
      responseBody: false,
      responseHeader: false,
      error: false,
      compact: false,
      maxWidth: _maxLineWidth);

  static Dio get dio {
    final userDataString = appStorage.getUser();
    final Map<String, dynamic> userData =
        userDataString.isNotEmpty ? jsonDecode(userDataString) : {};
    if (userData.isNotEmpty) {
      baseOptions.headers
          .addAll({'authorization': '${userData['access_token']}'});
    }

    if (_instance == null) {
      _instance = Dio(baseOptions);
      _instance!.interceptors.add(RequestHeaderInterceptor());
      _instance!.interceptors.add(_prettyDioLogger);

      return _instance!;
    } else {
      _instance!.interceptors.clear();
      _instance!.interceptors.add(RequestHeaderInterceptor());
      _instance!.interceptors.add(_prettyDioLogger);

      return _instance!;
    }
  }
}
