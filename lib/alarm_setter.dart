 import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
AlarmSettings? currentAlarmSettings;
 class AlarmRepository {
   static final Map<int, AlarmSettings> _alarms = {};

   static void saveAlarm(AlarmSettings settings) {
     _alarms[settings.id] = settings;
   }

   static AlarmSettings? getAlarm(int id) {
     return _alarms[id];
   }

   static void removeAlarm(int id) {
     _alarms.remove(id);
   }
 }

 class AlarmSetter {

   static Future<void> setWakeupAlarm(DateTime? wakeupTimeDay, TimeOfDay? wakeupTime) async {
     final DateTime alarmTime = DateTime(
       wakeupTimeDay!.year,
       wakeupTimeDay!.month,
       wakeupTimeDay!.day,
       wakeupTime!.hour,
       wakeupTime!.minute,
     );

     final AlarmSettings alarmSettings = AlarmSettings(
       id: DateTime.now().millisecondsSinceEpoch % 10000,
       dateTime: alarmTime,
       loopAudio: true,
       vibrate: true,
       volume: 0.5,
       assetAudioPath: 'assets/marimba.mp3',
       notificationTitle: 'Wake Up!',
       notificationBody: 'Time to start your day!',
     );

     await Alarm.set(alarmSettings: alarmSettings);
     // Update the current alarm settings globally
     currentAlarmSettings = alarmSettings;

     // Awesome Notification Parallel Setup
     AwesomeNotifications().createNotification(
       content: NotificationContent(
         id: alarmSettings.id,  // Use the same ID for easy tracking
         channelKey: 'wakeup_alarm_channel',
         title: 'Wake Up!',
         body: 'Time to start your day!',
         notificationLayout: NotificationLayout.Default,
       ),
       schedule: NotificationCalendar.fromDate(date: alarmTime),
     );
   }
 }

 Future<AlarmSettings?> fetchAlarmSettings(int id) async {
   return AlarmRepository.getAlarm(id);  // Simply retrieve from the repository
 }

