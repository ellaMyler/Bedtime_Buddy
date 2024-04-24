import 'package:alarm/model/alarm_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'alarm_setter.dart';
import 'edit_alarm.dart';
import 'ring_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationController {
  //Used to detect when a new notifications or schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {}

  //Used to detect every time a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {}

  //Used to track what happens when a notification gets dismissed
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {}

  //Used to detect when the users taps on the notification
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.payload != null && receivedAction.payload!.containsKey('alarmId')) {
      String? alarmIdStr = receivedAction.payload!['alarmId'];
      if (alarmIdStr != null) {
        int alarmId = int.parse(alarmIdStr);
        AlarmSettings? alarmSettings = await fetchAlarmSettings(alarmId);  // Fetch the settings
        if (alarmSettings != null) {
          SleepTrackerApp.navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => ExampleAlarmRingScreen(alarmSettings: alarmSettings),
          ));
        }
      }
    }
  }


}


