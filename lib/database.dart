import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

final databaseReference = FirebaseDatabase.instance.ref();


void sendBedtime(String type, String dayOfWeek, String timeOfDay) async {
  databaseReference.push().set(
      {'Type': type, 'Day of Week': dayOfWeek, 'Time of Day': timeOfDay});
}

void sendMessage (String message) async {
  databaseReference.push().set({'Logged Sleep':message});

}

Future<int> getSleepTime(String date) async {
  int hours = await getSleepHours(date);
  int minutes = await getSleepMinutes(date);
  int intTime = sleepTimeInMinutes(hours, minutes);

  return intTime;
}

Future<int> getSleepHours(String date) async {
  final hours = FirebaseDatabase.instance.ref();
  int time = 0;
  try {
    DataSnapshot snapshot = await hours.child(date + "/Hours slept").get();
    if (snapshot.exists) {
      time = int.parse(snapshot.value.toString());
      return time;
    } else {
      print('No data available for hours slept on $date');
      return -1;
    }
  } catch (error) {
    print("Error: $error");
    return -1;
  }
}

Future<int> getSleepMinutes(String date) async {
  final minutes = FirebaseDatabase.instance.ref();
  int time = 0;
  try {
    DataSnapshot snapshot = await minutes.child(date + "/Minutes slept").get();
    if (snapshot.exists) {
      time = int.parse(snapshot.value.toString());
      return time;
    } else {
      print('No data available for minutes slept on $date');
      return -1;
    }
  } catch (error) {
    print("Error: $error");
    return -1;
  }
}

int sleepTimeInMinutes(int hours, int minutes) {
  return (hours * 60) + minutes;
}

Future<int> getStress(String date) async {
  final minutes = FirebaseDatabase.instance.ref();
  int time = 0;
  try {
    DataSnapshot snapshot = await minutes.child(date + "/Your level of stress that night was").get();
    if (snapshot.exists) {
      time = int.parse(snapshot.value.toString());
      return time;
    } else {
      print('No data available for minutes slept on $date');
      return -1;
    }
  } catch (error) {
    print("Error: $error");
    return -1;
  }
}

Future<int> getStressLevel(String date) async {
  int stress = await getStress(date);

  print("Stress Level: $stress");

  return stress;
}

Future<int> getQuality(String date) async {
  final minutes = FirebaseDatabase.instance.ref();
  int time = 0;
  try {
    DataSnapshot snapshot = await minutes.child(date + "/Your quality of sleep was").get();
    if (snapshot.exists) {
      time = int.parse(snapshot.value.toString());
      return time;
    } else {
      print('No data available for minutes slept on $date');
      return -1;
    }
  } catch (error) {
    print("Error: $error");
    return -1;
  }
}

Future<int> getQualityLevel(String date) async {
  int quality = await getQuality(date);

  print("Stress Level: $quality");

  return quality;
}

Future<int> calculateWeeklyAverage(List<String> dates) async {
  int totalSleepTime = 0;
  for (String date in dates) {
    totalSleepTime += await getSleepTime(date);
  }
  return totalSleepTime ~/ dates.length;
}

Future<int> getFormattedWeeklyAverage() async {
  List<String> dates = [
    "April 14, 2024",
    "April 15, 2024",
    "April 16, 2024",
    "April 17, 2024",
    "April 18, 2024",
    "April 19, 2024",
    "April 20, 2024",
  ];

  /*int totalSleepTime = await calculateWeeklyAverage(dates);
  int hours = totalSleepTime ~/ 60;
  int minutes = totalSleepTime % 60;

  String formattedDuration = "$hours hours";
  if (minutes > 0) {
    formattedDuration += "$minutes minutes";
  } */

  return calculateWeeklyAverage(dates);
}