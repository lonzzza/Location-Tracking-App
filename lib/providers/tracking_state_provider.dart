import 'package:flutter/foundation.dart';

class TrackingStateProvider extends ChangeNotifier {
  bool isTracking = false;

  void toggle() {
    isTracking = !isTracking;
    notifyListeners();
  }
}