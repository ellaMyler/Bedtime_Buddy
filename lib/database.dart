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

void readData() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('-NtXYmtubEemw7cEQFNI/message').get();
  if (snapshot.exists){
    print(snapshot.value);
  } else {
    print('No data available');
  }
}
