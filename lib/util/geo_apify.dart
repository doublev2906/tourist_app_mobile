import 'package:tourist_app_mobille/network/api.dart';

class GeoApify {
  static const _apiKey = "b8568cb9afc64fad861a69edbddb2658";

  static final GeoApify _instance = GeoApify._internal();

  factory GeoApify() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  GeoApify._internal() {
    // initialization logic
  }

  Future<Map<String, dynamic>> getCurrentPosition(
      {required double lat, required double long}) async {
    final url =
        'https://api.geoapify.com/v1/geocode/reverse?lang=vi&lat=$lat&lon=$long&format=json&apiKey=${_apiKey}';
    final data = await Api.dio.get(url);
    return data.data;
  }
}
