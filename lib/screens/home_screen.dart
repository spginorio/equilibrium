import 'dart:async';
import 'package:get/get.dart';
import 'package:time_it/services/sign_google_apple.dart';
import 'package:time_it/services/signup_service.dart';
import 'package:vibration/vibration.dart';
import 'package:time_it/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../hive/hive_service.dart';
import '../models/time_entry.dart';
import '../screens/widgets/time_entry_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  DateTime? _startTime;
  int _totalEarnedSeconds = 0;
  Timer? _timer;
  Duration _currentDuration = Duration.zero;
  bool _isTracking = false;
  String _currentTrackingType = '';
  List<TimeEntry> _exerciseEntries = [];
  List<TimeEntry> _leisureEntries = [];
  bool _mounted = true;

  //! retreive the signup controller
  final controller = Get.find<SignUpController>();
  final googleAppleController = Get.find<SignGoogleAppleController>();

  @override
  void initState() {
    super.initState();
    _loadTotalMinutes();
    _loadRecentEntries();
  }

  @override
  @override
  void dispose() {
    _mounted = false; // Set mounted flag to false
    _timer?.cancel(); // Cancel timer
    super.dispose();
  }

  Future<void> _loadTotalMinutes() async {
    final savedTotalSeconds = await HiveService.loadTotalSeconds();
    // final earnedSeconds = await HiveService.getTotalEarnedSeconds();
    // final spentSeconds = await HiveService.getTotalSpentSeconds();
    if (!mounted) return;
    setState(() {
      _totalEarnedSeconds = savedTotalSeconds; // Use the saved total seconds
    });
  }

  Future<void> _loadRecentEntries() async {
    final exerciseEntries =
        await HiveService.getRecentEntriesByType('exercise');
    final leisureEntries = await HiveService.getRecentEntriesByType('leisure');
    if (!mounted) return;

    setState(() {
      _exerciseEntries = exerciseEntries;
      _leisureEntries = leisureEntries;
    });
  }

  String _formatTotalTime(int totalSeconds) {
    final isNegative = totalSeconds < 0;
    final absSeconds = totalSeconds.abs();
    final hours = absSeconds ~/ 3600;
    final minutes = (absSeconds % 3600) ~/ 60;
    final seconds = absSeconds % 60;
    return '${isNegative ? '-' : ''}${hours.toString().padLeft(2, '0')}.${minutes.toString().padLeft(2, '0')}.${seconds.toString().padLeft(2, '0')}';
  }

  String _formatTimeEntry(TimeEntry entry) {
    final duration = entry.endTime.difference(entry.startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    final startFormat = DateFormat('(MMM dd) \nHH:mm');
    final endFormat = DateFormat('HH:mm');

    return '${hours}h:${minutes}m  ${startFormat.format(entry.startTime)} - ${endFormat.format(entry.endTime)}h';
  }

// START TIMER FUNCTION
  void _startTimer(String type) {
    _timer?.cancel();
    if (!_mounted) return; // Check mounted state before setState

    setState(() {
      _startTime = DateTime.now();
      _isTracking = true;
      _currentTrackingType = type;
      _currentDuration = Duration.zero;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_mounted) {
        // Check mounted state in timer callback
        timer.cancel();
        return;
      }
      setState(() {
        _currentDuration = DateTime.now().difference(_startTime!);

        // Real-time updates to total time
        if (_currentTrackingType == 'exercise') {
          _totalEarnedSeconds++;
        } else if (_currentTrackingType == 'leisure') {
          _totalEarnedSeconds--;
        }

        // Save the total seconds whenever it changes
        HiveService.saveTotalSeconds(_totalEarnedSeconds);
      });
    });

    if (!_mounted) return; // Check mounted state before showing SnackBar

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: type == 'exercise'
            ? const Color.fromARGB(255, 66, 165, 83)
            : type == 'leisure'
                ? const Color.fromARGB(255, 89, 122, 195)
                : Colors.transparent,
        duration: const Duration(seconds: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(8),
        content: Center(
          child: Text(
            '${type[0].toUpperCase()}${type.substring(1)} Tracking started',
            style: textStyleInterFont,
          ),
        ),
      ),
    );
  }

// STOP TIMER FUNCTION
  Future<void> _stopTimer() async {
    if (_startTime == null) {
      if (!_mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Center(child: Text('Please start tracking first')),
            duration: Duration(seconds: 1)),
      );
      return;
    }

    _timer?.cancel();

    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!);

    final durationInSeconds = duration.inSeconds > 0 ? duration.inSeconds : 1;

    final timeEntry = TimeEntry(
      type: _currentTrackingType,
      startTime: _startTime!,
      endTime: endTime,
      durationInMinutes: (durationInSeconds / 60).ceil(),
    );

    await HiveService.addTimeEntry(timeEntry);

    // Save the total seconds before resetting
    await HiveService.saveTotalSeconds(_totalEarnedSeconds);

    if (!_mounted) return; // Check mounted state before setState

    setState(() {
      _startTime = null;
      _isTracking = false;
      _currentDuration = Duration.zero;
      _currentTrackingType = '';
    });

    await _loadRecentEntries();

    if (!_mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 217, 87, 87),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(8),
        duration: const Duration(seconds: 1),
        content: Center(
          child: Text('$_currentTrackingType Tracking stopped'),
        ),
      ),
    );
  }

  // RESET DATA FUNCTION
  // Reset all logs and total time to zero
  Future<void> _resetData() async {
    final confirmed = await _showResetConfirmationDialog();
    if (confirmed) {
      // Reset local UI state
      setState(() {
        _totalEarnedSeconds = 0;
        _exerciseEntries.clear();
        _leisureEntries.clear();
      });

      // Clear the saved total seconds
      await HiveService.saveTotalSeconds(0);

      // Clear the data in Hive storage
      await HiveService.clearAllEntries();

      // Reload the entries from Hive (which should be empty after the reset)
      await _loadRecentEntries();
    }
  }

  Future<bool> _showResetConfirmationDialog() async {
    final result = await showDialog<Object?>(
      context: context,
      barrierDismissible: false, // User must choose an option
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Reset All Data',
            style: textStyleInterFont,
          ),
          content: Text(
              style: textStyleInterFont,
              'Are you sure you want to reset the total time and all logs? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when canceled
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when confirmed
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    return result == true; // Cast the result to a boolean value (true or false)
  }

  @override
  Widget build(BuildContext context) {
    // Determine if time is negative
    final isTimeNegative = _totalEarnedSeconds < 0;

    // phone vibrates when time is negative
    if (_totalEarnedSeconds < 0 &&
        _totalEarnedSeconds > -4 &&
        _currentTrackingType != 'exercise') {
      Vibration.vibrate(duration: 300);
    }

    // phone vibrates after 30 minutes exercising
    if (_currentDuration.inSeconds > 1800 &&
        _currentDuration.inSeconds < 1803 &&
        _currentTrackingType == 'exercise') {
      Vibration.vibrate(duration: 500);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: PopupMenuButton<String>(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    iconColor: const Color.fromARGB(255, 168, 166, 166),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    icon: const Icon(
                      Icons.menu_rounded,
                    ),
                    elevation: 5,
                    iconSize: 27,
                    onSelected: (value) async {
                      // Handle menu item selection
                      if (value == 'Reset') {
                        _resetData();
                      } else if (value == 'Option 2') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              title: Text(
                                'About this app: ',
                                style: TextStyle(
                                  fontFamily: interFont,
                                  color:
                                      const Color.fromARGB(255, 117, 116, 116),
                                ),
                              ),
                              content: GestureDetector(
                                onTap: () {
                                  // Dismiss the dialog when tapped anywhere inside it
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  '''Track your exercise time and turn it into earned leisure time. Discover a fun and rewarding way to balance fitness and leisure with our time-tracking app!\n \nEarn Time: Press the "Earn Time" button to track the time you spend exercising. Watch as your efforts accumulate into earned time.\n \nSpend Time: Use your earned time for leisure activities guilt-free. Whether it's gaming, streaming, or relaxing, you've earned it!\n \nStay Motivated: Keep track of your total earned and spent time to stay on top of your fitness and leisure goals.\n \n(The app will provide haptic feedback whenever you use up all your earned time and every 30 minutes you spend exercising.)
                                  ''',
                                  style: TextStyle(
                                      fontFamily: interFont,
                                      color: const Color.fromARGB(
                                          255, 117, 115, 115)),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (value == "logout") {
                        await controller.signOut();
                        await googleAppleController.googleSignOut();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem(
                          value: "logout",
                          child: Text("Logout",
                              style: TextStyle(
                                fontFamily: interFont,
                                color: const Color.fromARGB(255, 148, 148, 148),
                              ))),
                      PopupMenuItem<String>(
                        value: 'Option 2',
                        child: Text('About',
                            style: TextStyle(
                              fontFamily: interFont,
                              color: const Color.fromARGB(255, 148, 148, 148),
                            )),
                      ),
                      PopupMenuItem<String>(
                        value: 'Reset',
                        child: Text('Reset Data',
                            style: TextStyle(
                              fontFamily: interFont,
                              color: const Color.fromARGB(255, 210, 138, 133),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // TOTAL TIME DISPLAY BOX
            Padding(
              padding: const EdgeInsets.only(
                  top: 0, left: 16.0, right: 16.0, bottom: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isTimeNegative
                        ? Colors.red
                        : const Color.fromARGB(255, 1, 184, 47),
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: isTimeNegative
                      ? const EdgeInsets.all(30.0)
                      : const EdgeInsets.all(50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Time',
                        style: TextStyle(
                          fontFamily: interFont,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isTimeNegative
                              ? Colors.red
                              : const Color.fromARGB(255, 1, 184, 47),
                        ),
                      ),
                      Text(
                        _formatTotalTime(_totalEarnedSeconds),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isTimeNegative ? Colors.red : Colors.black,
                        ),
                      ),
                      if (isTimeNegative)
                        Text(
                          'You have used all \nthe earned time.',
                          style: TextStyle(
                            fontFamily: interFont,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // CURRENT TIME TRACKING DISPLAY
            if (_isTracking)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentTrackingType == 'exercise'
                          ? Colors.green
                          : Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current ${_currentTrackingType == 'exercise' ? 'Exercise' : 'Leisure'} Time',
                        style: TextStyle(
                          fontFamily: interFont,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        _formatTotalTime(_currentDuration.inSeconds),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _currentTrackingType == 'exercise'
                              ? Colors.green[700]
                              : Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),

            // TIME LOGS
            Expanded(
              child: Row(
                children: [
                  // EXERCISE LOGS
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Exercise Log',
                          style: timeLogStyle,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _exerciseEntries.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  _formatTimeEntry(_exerciseEntries[index]),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: interFont,
                                      color: const Color.fromARGB(
                                          255, 83, 168, 117)),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // LEISURE LOGS
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Leisure Log',
                          style: timeLogStyle,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _leisureEntries.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  _formatTimeEntry(_leisureEntries[index]),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: interFont,
                                    color: const Color.fromARGB(
                                        255, 104, 126, 196),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // BUTTONS
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TimeEntryButton(
                      label: 'Earn Time',
                      color: _isTracking && _currentTrackingType == 'exercise'
                          ? Colors.red
                          : Colors.green,
                      onPressed: () =>
                          _isTracking && _currentTrackingType == 'exercise'
                              ? _stopTimer()
                              : _startTimer('exercise'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TimeEntryButton(
                      label: 'Spend Time',
                      color: _isTracking && _currentTrackingType == 'leisure'
                          ? Colors.red
                          : Colors.blue,
                      onPressed: () =>
                          _isTracking && _currentTrackingType == 'leisure'
                              ? _stopTimer()
                              : _startTimer('leisure'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
