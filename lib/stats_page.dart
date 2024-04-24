// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import 'main.dart';

//Stats Page
class SleepStatsPage extends StatefulWidget {
  const SleepStatsPage({Key? key}) : super(key: key);

  @override
  _SleepStatsPageState createState() => _SleepStatsPageState();
}
class _SleepStatsPageState extends State<SleepStatsPage> {
  TextEditingController _controller = TextEditingController();
  final List<String> goals = [];
  List<bool> isChecked = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sleep Stats', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: ThemeProvider.optionsOf<MyThemeOptions>(context).backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(child:
                Text('(to be made in future sprint)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
              ),
              SizedBox(height: 15),
              Container(
                width: 350,
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
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: goals.length,
                          itemBuilder: (context, index) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(goals[index], style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Row(
                                    children: List.generate(7, (index) => Checkbox(
                                      value: isChecked[index],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked[index] = value ?? false;
                                        });
                                        },
                                    ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Sun'), Text('Mon'), Text('Tue'), Text('Wed'), Text('Thu'), Text('Fri'), Text('Sat'),
                                    ],
                                  )
                                ]
                            );
                          }
                          ),
                    ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: TextField(
                            controller: _controller, decoration: InputDecoration(hintText: 'Enter your goal'),
                            onSubmitted: (value) {
                              _controller.clear();
                              setState(() {
                                goals.add(value);
                                isChecked;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              const Text('Weekly Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.black),
                ),
                child: Column (
                  children:  [
                    Text('On Average, you slept ___ hours this week',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)
                    ),
                    Text('On Average, your stress level was __ this week',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)
                    ),
                    Text('On Average, your quality of sleep this week was ___ ',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)
                    ),
                  ]
                )
              ),
              ElevatedButton(
                onPressed: () {
                  readData();
                },
                child: Text('Test'),
              ),
            ]
          ),
        )
    );
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
}