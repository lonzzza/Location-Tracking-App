import 'package:geolocator/geolocator.dart';

class GeofenceManager {
  final Map<String, Position> _locations = {
    'Home': Position(latitude: 37.7749, longitude: -122.4194, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, headingAccuracy: 0, altitudeAccuracy: 0, isMocked: false),
    'Office': Position(latitude: 37.7858, longitude: -122.4364, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, headingAccuracy: 0, altitudeAccuracy: 0, isMocked: false),
  };

  List<String> detectZones(Position current) {
    final List<String> inZones = [];
    for (final entry in _locations.entries) {
      final distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        entry.value.latitude,
        entry.value.longitude,
      );
      if (distance <= 50) inZones.add(entry.key);
    }
    return inZones;
  }
}