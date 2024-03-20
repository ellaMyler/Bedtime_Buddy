import 'package:flutter/material.dart';
import 'app_ui.dart';

// The main file accesses MainScreen class from app_ui.dart to generate the app.
void main() => runApp(const SleepTrackerApp());


class SleepTrackerApp extends StatelessWidget{
  const SleepTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sleep Tracker',
      home: MainScreen(),
    );
  }
}







