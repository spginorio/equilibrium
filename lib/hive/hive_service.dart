import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/time_entry.dart';

class HiveService {
  static const String _timeEntriesBox = 'timeEntries';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    // Register adapters
    Hive.registerAdapter(TimeEntryAdapter());
  }

  static Future<Box<TimeEntry>> getTimeEntriesBox() async {
    return await Hive.openBox<TimeEntry>(_timeEntriesBox);
  }

  static Future<void> addTimeEntry(TimeEntry entry) async {
    final box = await getTimeEntriesBox();
    await box.add(entry);
  }

  static Future<int> getTotalEarnedSeconds() async {
    final box = await getTimeEntriesBox();
    return box.values
        .where((entry) => entry.type == 'exercise')
        .map((entry) => entry.durationInMinutes * 60)
        .fold<int>(0, (prev, curr) => prev + curr);
  }

  static Future<int> getTotalSpentSeconds() async {
    final box = await getTimeEntriesBox();
    return box.values
        .where((entry) => entry.type == 'leisure')
        .map((entry) => entry.durationInMinutes * 60)
        .fold<int>(0, (prev, curr) => prev + curr);
  }

  static Future<List<TimeEntry>> getRecentEntriesByType(String type) async {
    final box = await getTimeEntriesBox();
    // Get entries of the specified type
    final entries = box.values.where((entry) => entry.type == type).toList();
    // Sort by most recent
    entries.sort((a, b) => b.endTime.compareTo(a.endTime));
    // Return top 30 entries
    return entries.take(30).toList();
  }

  static Future<void> clearAllEntries() async {
    var box = await Hive.openBox<TimeEntry>(_timeEntriesBox);
    await box.clear(); // Clear all entries from the Hive box
  }

  static Future<void> saveTotalSeconds(int totalSeconds) async {
    final box = await Hive.openBox<int>('totalTimeBox');
    await box.put('totalSeconds', totalSeconds);
  }

  static Future<int> loadTotalSeconds() async {
    final box = await Hive.openBox<int>('totalTimeBox');
    return box.get('totalSeconds', defaultValue: 0) ?? 0;
  }
}
