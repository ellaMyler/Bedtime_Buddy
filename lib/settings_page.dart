import 'package:flutter/material.dart';

//Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }
}