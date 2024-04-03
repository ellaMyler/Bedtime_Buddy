import 'package:flutter/material.dart';
import 'package:sleep_tracker/database.dart';

//Stats Page
class SleepStatsPage extends StatelessWidget {
  const SleepStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Stats', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text('(to be made in future sprint)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
            ),
            SizedBox(height: 15),
            Container(
              width: 250,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color:Colors.black),
              ),
              child: Text('(graph of weekly sleep stats, with amount of sleep shown)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal) ),
            ),
            SizedBox(height: 20),
            Text('Goals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Container(
              width: 250,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color:Colors.black),
              ),
            ),
            SizedBox(height: 20),
            const Text('Weekly Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Container(
              width: 250,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color:Colors.black),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                readData();
              },
              child: Text('Test'),
            ),
          ],
        ),
      ),
    );
  }
}

