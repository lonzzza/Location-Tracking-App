import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/daily_summary.dart';

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Summary')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<DailySummary>('summaries').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) return const Center(child: Text('No data available'));

          return ListView(
            children: box.keys.map((key) {
              final summary = box.get(key)!;
              return ListTile(
                title: Text('Date: $key'),
                subtitle: Text(
                  summary.zones.entries.map((e) => '${e.key}: ${_formatDuration(e.value)}').join('\n'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    return '${h}h ${m}m';
  }
}