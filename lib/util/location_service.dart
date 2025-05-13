import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import '../models/daily_summary.dart';
import 'geofence_manager.dart';

class LocationService {
  static Timer? _timer;
  static bool isLocationPermissionGranted = false;
  static DateTime? _lastUpdateTime;
  static final _geofenceManager = GeofenceManager();
  static final _box = Hive.box<DailySummary>('summaries');

  ///Ask the user for location permission
  static Future<void> checkLocationPermission() async {
    final LocationPermission permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.denied || permission != LocationPermission.deniedForever) {
      isLocationPermissionGranted = true;
    }
  }

  ///We use this method to start tracking if the user has granted the location
  static Future<void> startTracking() async {
    _lastUpdateTime = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) async {
      final pos = await Geolocator.getCurrentPosition();
      final now = DateTime.now();
      final delta = now.difference(_lastUpdateTime!);
      final zones = _geofenceManager.detectZones(pos);

      final todayKey = _formatDate(now);
      final summary = _box.get(todayKey) ?? DailySummary();

      if (zones.isEmpty) {
        summary.addDuration('Traveling', delta);
      } else {
        for (final zone in zones) {
          summary.addDuration(zone, delta);
        }
      }
      _box.put(todayKey, summary);
      _lastUpdateTime = now;
    });
  }

  ///This method stops the tracking
  static Future<void> stopTracking() async {
    _timer?.cancel();
    _timer = null;
    saveSummary();
  }

  ///Saves the summary information in a hive
  static void saveSummary() {
    if (_lastUpdateTime == null) return;
    final now = DateTime.now();
    final delta = now.difference(_lastUpdateTime!);
    final todayKey = _formatDate(now);
    final summary = _box.get(todayKey) ?? DailySummary();
    summary.addDuration('Traveling', delta);
    _box.put(todayKey, summary);
    _lastUpdateTime = now;
  }

  static void openAppSettings() {
    Geolocator.openAppSettings();
  }

  static String _formatDate(DateTime dt) => dt.toIso8601String().substring(0, 10);
}