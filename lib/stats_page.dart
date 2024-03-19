import 'package:flutter/material.dart';

//Stats Page
class SleepStatsPage extends StatelessWidget {
  const SleepStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      // this is where everything on the page will go! Put the widgets and stuff here!
      child: Text('Sleep Stats', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }
}