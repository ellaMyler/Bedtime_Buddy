import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

final databaseReference = FirebaseDatabase.instance.ref();


void sendBedtime(String type, String dayOfWeek, String timeOfDay) async {
  databaseReference.push().set(
      {'Type': type, 'Day of Week': dayOfWeek, 'Time of Day': timeOfDay});
}

void sendSleepLog (String dateLogged, String sleepThoughts, String dreamNight, String sleepQuality, String stressLevel, int hours, int minutes) async {
  String sanitizedKey = dateLogged.replaceAll(RegExp(r'[#$/\[\]]'), ''); //Removes any illegal characters
  //Makes it so data is saved in the same places
  Map<String, dynamic> sleepLogData = {
    'Date Logged': dateLogged,
    'Thoughts on your sleep': sleepThoughts,
    'Your dreams were': dreamNight,
    'Your quality of sleep was': sleepQuality,
    'Your level of stress that night was': stressLevel,
    'Hours slept': hours,
    'Minutes slept': minutes,
  };

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
}