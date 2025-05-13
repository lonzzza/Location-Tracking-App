import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'models/daily_summary.dart';
import 'providers/tracking_state_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DailySummaryAdapter());
  await Hive.openBox<DailySummary>('summaries');
  runApp(const LocationTrackingApp());
}

class LocationTrackingApp extends StatelessWidget {
  const LocationTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrackingStateProvider(),
      child: MaterialApp(
        title: 'Location Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}