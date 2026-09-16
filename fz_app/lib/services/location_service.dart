import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

import 'user_service.dart';

class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  Future<Position?> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<Position?> publishCurrentLocation() async {
    final position = await getCurrentPosition();

    if (position == null) {
      return null;
    }

    await UserService.instance.updateLocation(
      position.latitude,
      position.longitude,
    );

    return position;
  }

  static double distanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;

    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat1)) *
            math.cos(_rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final safeA = a.clamp(0.0, 1.0);

    return earthRadiusKm *
        2 *
        math.atan2(
          math.sqrt(safeA),
          math.sqrt(1 - safeA),
        );
  }

  static double _rad(double degrees) {
    return degrees * math.pi / 180;
  }
}
