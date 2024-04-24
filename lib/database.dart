import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bedtime_page.dart';

final databaseReference = FirebaseDatabase.instance.ref();

TimeOfDay? previousBedTime;
DateTime? previousBedtimeDay;
TimeOfDay? previousWakeupTime;
DateTime? previousWakeupTimeDay;


void sendBedtime(String type, String dayOfWeek, String timeOfDay) async {
  databaseReference.push().set(
      {'Type': type, 'Day of Week': dayOfWeek, 'Time of Day': timeOfDay});
}


void sendSleepLog (String dateLogged, String sleepThoughts, String dreamNight, String sleepQuality, String stressLevel, int hours, int minutes) async {
  String sanitizedKey = dateLogged.replaceAll(RegExp(r'[#$/\[\]]'),
      ''); // Replace invalid characters with an empty string

  void sendMessage(String message) async {
    databaseReference.push().set({'Logged Sleep': message});


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
}

void storePrevious(TimeOfDay? previousBT, DateTime? previousBD, TimeOfDay? previousWT, DateTime? previousWD){
  final previousReference = FirebaseDatabase.instance.ref("previous");

  previousReference.set({
    "Bedtime" : previousBT.toString(),
    "BedtimeDay" : previousBD.toString(),
    "Wakeup" : previousWT.toString(),
    "WakeupDay" : previousWD.toString(),
  });
}

Future<TimeOfDay> getPreviousTime(String type) async {
  final previous = FirebaseDatabase.instance.ref();
  String value = '';
  try {
    DataSnapshot snapshot = await previous.child("previous/" + type).get();
    if (snapshot.exists) {
      value = snapshot.value.toString();
      // Extract hour and minute from the string
      String timeString = value.replaceAll("TimeOfDay(", "").replaceAll(")", "");
      List<String> timeParts = timeString.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } else {
      print('No data available on $type');
      // Return a default time
      return TimeOfDay(hour: 0, minute: 0);
    }
  } catch (error) {
    print("Error: $error");
    // Return a default time
    return TimeOfDay(hour: 0, minute: 0);
  }
}

Future<DateTime> getPreviousDay(String type) async {
  final previous = FirebaseDatabase.instance.ref();
  String value = '';
  try {
    DataSnapshot snapshot = await previous.child("previous/" + type).get();
    if (snapshot.exists) {
      value = snapshot.value.toString();
      // Parse the datetime string into a DateTime object
      DateTime dateTime = DateTime.parse(value);
      return dateTime;
    } else {
      print('No data available on $type');
      // Return a default datetime
      return DateTime(-1);
    }
  } catch (error) {
    print("Error: $error");
    // Return a default datetime
    return DateTime(-1);
  }
}

  Future<void> readPrevious() async {
    try {
      final snapshot = await databaseReference.child('previous').get();
      if (snapshot.exists) {
        previousBedTime = await getPreviousTime("Bedtime");
        previousBedtimeDay = await getPreviousDay("BedtimeDay");
        previousWakeupTime = await getPreviousTime("Wakeup");
        previousWakeupTimeDay = await getPreviousDay("WakeupDay");
      } else {
        print("No previous");
      }
    } catch (e) {
      print("Error reading previous data: $e");
    }
  }

void readData() {
  final ref = FirebaseDatabase.instance.ref();

  // Get the snapshot asynchronously
  ref.child('April 4, 2024/Hours slept').get().then((snapshot) {
    // Check if data exists
    if (snapshot.exists) {
      // Data exists, print the value
      print(snapshot.value);
    } else {
      // Data doesn't exist
      print('No data available');
    }
  }).catchError((error) {
    // Handle any errors that occur during the database operation
    print("Error: $error");
  });
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

Future<int> getSleepTime(String date) async {
  int hours = await getSleepHours(date);
  int minutes = await getSleepMinutes(date);
  int intTime = sleepTimeInMinutes(hours, minutes);

  return intTime;
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

  //print("Stress Level: $stress");

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

  //print("Quality of Sleep: $quality");

  return quality;
}
Future<int> calcWeeklyAveQuality (List<String> dates) async {
  int quality = 0;
  for (String date in dates) {
    quality += await getQualityLevel(date);
  }
  return quality ~/ dates.length;
}





