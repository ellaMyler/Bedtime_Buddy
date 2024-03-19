import 'package:flutter/material.dart';

//Bed Time Page
class BedtimePage extends StatelessWidget {
  const BedtimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      // this is where everything on the page will go! Put the widgets and stuff here!
      child: Text('Bedtime', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }
}