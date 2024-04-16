import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';

AlarmSettings? currentAlarmSettings;

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
  }
}