import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'notification_controller.dart';
import 'bedtime_page.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';

AlarmSettings? currentAlarmSettings;

class NotificationService {
  static Future<void> initNotifications() async {

    // Check if notifications are allowed, if not, request permission
    bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowedToSendNotification) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
  }

  //Test notification to make sure the implementation works properly
  static void showTestNotification() {
    // Ensure that initNotifications() has been called before creating notifications
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch % 10000,

        channelKey: 'local_channel',
        title: "Test Notification",
        body: "This notification works!",
      ),
    );
  }

  static Future<void> sendBedtimeNotification(DateTime bedtimeDateTime) async {
    int notificationId = (DateTime.now().millisecondsSinceEpoch % 10000) + 10000;  // +1000 for bedtime notifications
    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar(
        day: bedtimeDateTime!.day,
        month: bedtimeDateTime!.month,
        year: bedtimeDateTime!.year,
        hour: bedtimeDateTime!.hour,
        minute: bedtimeDateTime!.minute,
      ),
      content: NotificationContent(
        id: notificationId,
        channelKey: 'local_channel',
        title: 'Time for Bed!',
        body: "It is time for you to go to bed",
        payload: {'type': 'bedtime'},  // Custom payload to identify bedtime notification
      ),
    );
  }

}

