import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

final databaseReference = FirebaseDatabase.instance.ref();


void sendBedtime(String type, String dayOfWeek, String timeOfDay) async {
  databaseReference.push().set(
      {'Type': type, 'Day of Week': dayOfWeek, 'Time of Day': timeOfDay});
}

void sendMessage(String message) async {
  databaseReference.push().set({'Logged Sleep':message});

}

void readData() async { // Test function
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('April 3, 2024/Hours slept').get();
  if (snapshot.exists){
    print(snapshot.value);
  } else {
    print('No data available');
  }
}

Future<Object?> getSleepHours(String date) async{
  final ref = FirebaseDatabase.instance.ref();
  final hours = await ref.child(date + "/Hours slept").get();

  if(await hasDate(date)) {
    return hours.value;
  }

}

Future<int> getSleepMinutes(String date) async{
  final ref = FirebaseDatabase.instance.ref();
  final minutes = await ref.child(date + "/Minutes slept").get();

  return 0;
}

Future<bool> hasDate(String date) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child(date).get();

  if (snapshot.exists){
    return true;
  } else {
    return false;
  }
}
