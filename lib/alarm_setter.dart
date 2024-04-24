import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
AlarmSettings? currentAlarmSettings;
class AlarmAccess {
  AlarmSettings? getAlarmSettings(currentAlarmSettings) {
    return currentAlarmSettings;
  }

}


class AlarmSetter {

  static Future<void> setWakeupAlarm(DateTime? wakeupTimeDay, TimeOfDay? wakeupTime) async {
    final int notificationId = DateTime.now().millisecondsSinceEpoch % 10000 + 5000;
    final DateTime alarmTime = DateTime(
      wakeupTimeDay!.year,
      wakeupTimeDay!.month,
      wakeupTimeDay!.day,
      wakeupTime!.hour,
      wakeupTime!.minute,
    );

    final AlarmSettings alarmSettings = AlarmSettings(
      id:notificationId,
      dateTime: alarmTime,
      loopAudio: true,
      vibrate: true,
      volume: 0.5,
      assetAudioPath: 'assets/marimba.mp3',
      notificationTitle: 'Alarm Ringing',
      notificationBody: 'Alarm is Ringing',
    );

    await Alarm.set(alarmSettings: alarmSettings);


    //currentAlarmSettings = alarmSettings;



  }

  static Future<void> sendBedtimeNotification(DateTime wakeupDateTime) async {
    int notificationId = (DateTime.now().millisecondsSinceEpoch % 10000);  // Wakeup Alarm ID
    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar(
        day: wakeupDateTime!.day,
        month: wakeupDateTime!.month,
        year: wakeupDateTime!.year,
        hour:wakeupDateTime!.hour,
        minute: wakeupDateTime!.minute,
      ),
      content: NotificationContent(
        id: notificationId,
        channelKey: 'wakeup_alarm_channel',
        title: 'Wake Up!',
        body: "Click Here to Stop",
        payload: {'type': 'wakeup'},  // Custom payload to identify bedtime notification
      ),
    );
  }

  static Future<AlarmSettings?> fetchAlarmSettings(CurrentAlarmSettings) async {
    return CurrentAlarmSettings;  // Use the shared instance to retrieve alarms
  }

}
