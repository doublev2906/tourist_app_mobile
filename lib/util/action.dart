import 'package:geolocator/geolocator.dart';

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
