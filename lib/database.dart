import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

final databaseReference = FirebaseDatabase.instance.ref();


void sendBedtime(String type, String dayOfWeek, String timeOfDay) async {
  databaseReference.push().set(
      {'Type': type, 'Day of Week': dayOfWeek, 'Time of Day': timeOfDay});
}

void sendSleepLog (String dateLogged, String sleepThoughts, String dreamNight, String sleepQuality, String stressLevel, int hours, int minutes) async {
  String sanitizedKey = dateLogged.replaceAll(RegExp(r'[#$/\[\]]'), ''); // Replace invalid characters with an empty string

  // Store data as a map with ordered fields
  Map<String, dynamic> sleepLogData = {
    'Date Logged': dateLogged,
    'Thoughts on your sleep': sleepThoughts,
    'Your dreams were': dreamNight,
    'Your quality of sleep was': sleepQuality,
    'Your level of stress that night was': stressLevel,
    'Hours slept': hours,
    'Minutes slept': minutes,
  };

  // Set the data in Firestore
  await databaseReference.child(sanitizedKey).set(sleepLogData);
}

void readData() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('April 4, 2024/message').get();
  if (snapshot.exists){
    print(snapshot.value);
  } else {
    print('No data available');
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
Future<int> calcWeeklyAveSleep(List<String> dates) async {
  int totalSleepTime = 0;
  for (String date in dates) {
    totalSleepTime += await getSleepTime(date);
  }
  return totalSleepTime ~/ dates.length;
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
Future<int> calcWeeklyAveStress (List<String> dates) async {
  int totalStress = 0;
  for (String date in dates) {
    totalStress += await getStressLevel(date);
  }
  return totalStress ~/ dates.length;
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

  print("Quality of Sleep: $quality");

  return quality;
}
Future<int> calcWeeklyAveQuality (List<String> dates) async {
  int quality = 0;
  for (String date in dates) {
    quality += await getQualityLevel(date);
  }
  return quality ~/ dates.length;
}