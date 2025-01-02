// lib/models/time_entry.dart
import 'package:hive/hive.dart';

part 'time_entry.g.dart';

@HiveType(typeId: 0)
class TimeEntry extends HiveObject {
  @HiveField(0)
  String type; // 'exercise' or 'leisure'

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  DateTime endTime;

  @HiveField(3)
  int durationInMinutes;

  TimeEntry({
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.durationInMinutes,
  });
}
