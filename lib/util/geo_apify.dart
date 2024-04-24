import 'package:tourist_app_mobille/network/api.dart';

class GeoApify {
  static const _apiKey = "b8568cb9afc64fad861a69edbddb2658";
  static const _weatherKey = "b23c74580b2086f23564be51d2d0de51";

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

  String genMarkerString(
      {required double lat,
      required double long,
      String type = "awesome",
      String color = "236155cc",
      String icon = "suitcase",
      String iconSize = "large"}) {
    return "lonlat:$long,$lat;type:$type;color:%$color;icon:$icon;iconsize:$iconSize;whitecircle:no";
  }

  String genStaticMapImage(List<Map<String, dynamic>> listCoordinates,
      {int width = 600, int height = 400}) {
    final markers = listCoordinates
        .map((e) => genMarkerString(lat: e["lat"], long: e["long"]))
        .join("|");
    return "https://maps.geoapify.com/v1/staticmap?style=osm-bright&width=$width&height=$height&marker=$markers&apiKey=$_apiKey";
  }

  String getTileLayerUrl() {
    // "'https://maps.geoapify.com/v1/tile/osm-carto/{z}/{x}/{y}.png?apiKey=YOUR_API_KEY'"
    return "https://maps.geoapify.com/v1/tile/osm-bright/{z}/{x}/{y}.png?apiKey=$_apiKey";
  }

  Future<Map<String, dynamic>> getCurrentPosition(
      {required double lat, required double long}) async {
    final url =
        'https://api.geoapify.com/v1/geocode/reverse?lang=vi&lat=$lat&lon=$long&format=json&apiKey=$_apiKey';
    final data = await Api.dio.get(url);
    return data.data;
  }

  Future<Map<String, dynamic>> getWeather({required lat, required long}) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${long}&appid=b23c74580b2086f23564be51d2d0de51&lang=vi&units=metric";
    return Api.dio
        .get(url)
        .then((response) => response.data as Map<String, dynamic>);
  }
}
