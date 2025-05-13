import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'summary_screen.dart';
import '../util/location_service.dart';
import '../providers/tracking_state_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LocationService.checkLocationPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      LocationService.saveSummary();
    }
  }

  Future<void> toggleTracking(BuildContext context) async {
    if(LocationService.isLocationPermissionGranted) {
      final trackingState = Provider.of<TrackingStateProvider>(context, listen: false);
      if (trackingState.isTracking) {
        await LocationService.stopTracking();
      } else {
        await LocationService.startTracking();
      }
      trackingState.toggle();
    }else{
      _showLocationDeniedDialog();
    }

  }

  ///Show the popup dialog
  void _showLocationDeniedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Location Required'),
        content: const Text('This app needs location access to function properly. Please enable it in your device settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () => LocationService.openAppSettings(),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<TrackingStateProvider>().isTracking;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SummaryScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => toggleTracking(context),
          child: Text(tracking ? 'Clock Out' : 'Clock In'),
        ),
      ),
    );
  }
}