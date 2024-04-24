import 'package:alarm/model/alarm_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'ring_page.dart';
import 'alarm_setter.dart';
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
    // Retrieve notification ID and type from payload
    int alarmId = receivedAction.id ?? 0;
    String? type = receivedAction.payload?['type'];
    AlarmSettings? alarmSettings = await AlarmSetter.fetchAlarmSettings(AlarmSettings);
      if (type == 'wakeup') {
        if (alarmSettings != null) {
          // Navigate to the Ring Page
          navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => ExampleAlarmRingScreen(alarmSettings: alarmSettings),
          ));
        } else {
          print("Alarm settings not found for ID: $alarmId");
        }
      } else if (type == 'bedtime') {
        // Handle bedtime notifications differently if needed
        print("Bedtime notification clicked.");
      }
  }
}














