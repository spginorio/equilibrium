import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/time_entry.dart';

class HiveService {
  static const String _timeEntriesBoxPrefix = 'timeentries_';
  static const String _totalTimeBoxPrefix = 'totaltime_';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(TimeEntryAdapter());
  }

  // Helper method to get current user ID
  static String? getCurrentUserId() {
    return Supabase.instance.client.auth.currentUser?.id;
  }

  // Get user-specific box name
  static String getUserBoxName(String prefix) {
    final userId = getCurrentUserId();
    if (userId == null) throw Exception('No user logged in');
    return '$prefix$userId';
  }

  // Helper method to safely open a box
  static Future<Box<T>> _openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  static Future<Box<TimeEntry>> getTimeEntriesBox() async {
    final boxName = getUserBoxName(_timeEntriesBoxPrefix);
    return await _openBox<TimeEntry>(boxName);
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
    final entries = box.values.where((entry) => entry.type == type).toList();
    entries.sort((a, b) => b.endTime.compareTo(a.endTime));
    return entries.take(30).toList();
  }

  static Future<void> clearAllEntries() async {
    final timeEntriesBox = await getTimeEntriesBox();
    await timeEntriesBox.clear();

    final totalTimeBoxName = getUserBoxName(_totalTimeBoxPrefix);
    final totalTimeBox = await _openBox<int>(totalTimeBoxName);
    await totalTimeBox.clear();
  }

  static Future<void> saveTotalSeconds(int totalSeconds) async {
    final boxName = getUserBoxName(_totalTimeBoxPrefix);
    final box = await _openBox<int>(boxName);
    await box.put('totalSeconds', totalSeconds);
  }

  static Future<int> loadTotalSeconds() async {
    final boxName = getUserBoxName(_totalTimeBoxPrefix);
    final box = await _openBox<int>(boxName);
    return box.get('totalSeconds', defaultValue: 0) ?? 0;
  }

  // Improved closeUserBoxes method
  static Future<void> closeUserBoxes() async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    final timeEntriesBoxName = getUserBoxName(_timeEntriesBoxPrefix);
    final totalTimeBoxName = getUserBoxName(_totalTimeBoxPrefix);

    // Safely close boxes if they're open
    if (Hive.isBoxOpen(timeEntriesBoxName)) {
      final box = Hive.box<TimeEntry>(timeEntriesBoxName);
      if (!box.isOpen) return;
      await box.compact(); // Optimize storage before closing
      await box.close();
    }

    if (Hive.isBoxOpen(totalTimeBoxName)) {
      final box = Hive.box<int>(totalTimeBoxName);
      if (!box.isOpen) return;
      await box.compact(); // Optimize storage before closing
      await box.close();
    }
  }
}
