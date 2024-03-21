import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

final databaseReference = FirebaseDatabase.instance.ref();

void sendMessage (String message) async {
  String name = "Enter title here";
  databaseReference.push().set({'Sender':name, 'message':message});
}
