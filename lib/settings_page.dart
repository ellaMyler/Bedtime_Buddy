import 'package:flutter/material.dart';

//Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      // this is where everything on the page will go! Put the widgets and stuff here!
      child: Text('Settings', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }
}