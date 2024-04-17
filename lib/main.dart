import 'package:flutter/material.dart';
import 'package:sleep_tracker/database.dart';
import 'app_ui.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_maker.dart';
import 'package:alarm/alarm.dart';


// The main file accesses MainScreen class from app_ui.dart to generate the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initNotifications(); // Starts Notifications
  await Alarm.init(); // Starts Alarms

  //Notification Initialization Code
  AwesomeNotifications().initialize(
      null, //Icon; null defaults to app icon
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'local_channel',
            channelName: 'Basic Notification',
            channelDescription: 'Notification channel for basic notifications',
            importance: NotificationImportance.High,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white
        )
      ],
      debug: true
  );
  //End of Notification Initialization Code

  runApp(const SleepTrackerApp());
}

class SleepTrackerApp extends StatelessWidget{
  const SleepTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sleep Tracker',
      home: MainScreen(),
    );
  }
}





