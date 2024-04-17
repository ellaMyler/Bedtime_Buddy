import 'dart:io';
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

void readData() { // Follow this format for other functions
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

int getSleepTime(String date) {

  int hours = getSleepHours(date);
  int minutes = getSleepMinutes(date);

  int intTime = sleepTimeInMinutes(hours, minutes);

  print(hours);
  print(minutes);
  print(intTime);
  return(1);

}

int getSleepHours(String date) {
  final hours = FirebaseDatabase.instance.ref();
  // Get the snapshot asynchronously
  hours.child(date + "/Hours slept").get().then((snapshot) {
    // Check if data exists
    if (snapshot.exists) {
      // Data exists, print the value
      //print(snapshot.value);
      return(int.parse(snapshot.value.toString()));
    } else {
      // Data doesn't exist
      print('No data available');
      return(-1);
    }
  }).catchError((error) {
    // Handle any errors that occur during the database operation
    print("Error: $error");
  });

  return(-2);
}

int getSleepMinutes(String date) {
  final minutes = FirebaseDatabase.instance.ref();
  // Get the snapshot asynchronously
  minutes.child(date + "/Minutes slept").get().then((snapshot) {
    // Check if data exists
    if (snapshot.exists) {
      // Data exists, print the value
      //print(snapshot.value);
      return(int.parse(snapshot.value.toString()));
    } else {
      // Data doesn't exist
      print('No data available');
      return(-1);
    }
  }).catchError((error) {
    // Handle any errors that occur during the database operation
    print("Error: $error");
  });

  return(-2);
}

int sleepTimeInMinutes(int hours, int minutes){
  int total = (hours * 60) + minutes;
  return total;
}


