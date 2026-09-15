import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'user_service.dart';

class LocationService {
  LocationService._();
  static final instance = LocationService._();

  Future<Position?> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return null;
    return Geolocator.getCurrentPosition();
  }

  Future<Position?> publishCurrentLocation() async {
    final position = await getCurrentPosition();
    if (position == null) return null;
    await UserService.instance.updateLocation(position.latitude, position.longitude);
    return position;
  }

  static double distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) + math.cos(_rad(lat1)) * math.cos(_rad(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static double _rad(double d) => d * math.pi / 180;
}
