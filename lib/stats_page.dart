import 'package:flutter/material.dart';

//Stats Page
class SleepStatsPage extends StatelessWidget {
  const SleepStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sleep Stats', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(child:
              Text('Goals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 15),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.black),
                ),
              ),
              SizedBox(height: 40),
              const Text('Weekly Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.black),
                ),
              ),
            ]
        )
    );
  }
}

//return const Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Text('Sleep Stats', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
//         Text('Goals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
//       ],