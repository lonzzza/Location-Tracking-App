import 'package:hive/hive.dart';
part 'daily_summary.g.dart';

@HiveType(typeId: 0)
class DailySummary extends HiveObject {
  @HiveField(0)
  Map<String, int> zoneDurations = {};

  void addDuration(String zone, Duration duration) {
    zoneDurations[zone] = (zoneDurations[zone] ?? 0) + duration.inSeconds;
  }

  Map<String, Duration> get zones => zoneDurations.map((k, v) => MapEntry(k, Duration(seconds: v)));
}