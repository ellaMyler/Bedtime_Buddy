import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

final databaseReference = FirebaseDatabase.instance.ref();

<<<<<<< Updated upstream
void sendBedtime(String type, String dayOfWeek, String timeOfDay) async {
  databaseReference.push().set({'Type':type, 'Day of Week':dayOfWeek, 'Time of Day':timeOfDay});
=======








void sendMessage (String message) async {
  databaseReference.push().set({'Logged Sleep':message});
>>>>>>> Stashed changes
}
