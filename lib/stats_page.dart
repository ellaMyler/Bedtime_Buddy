// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(child:
                Text('Stats', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 15),
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.black),
                ),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(enabled: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(1, 3),
                          FlSpot(3, 6),
                          FlSpot(4, 8),
                          FlSpot(5, 4),
                          FlSpot(6, 7),
                          FlSpot(7, 9),
                        ],
                        isCurved: true,
                        barWidth: 8,
                      ),
                    ],
                    minY: 0,
                    titlesData: FlTitlesData (
                      show: true,
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text('Day',
                          style: TextStyle(fontSize: 10, color: Colors.black),),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 18,
                          interval: 1,
                          getTitlesWidget: bottomTitleWidgets,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameSize: 20,
                        axisNameWidget: const Text(
                          'Hours', style: TextStyle(color: Colors.black),),
                        sideTitles: SideTitles (
                          showTitles: true, interval: 1, reservedSize: 40, getTitlesWidget: leftTitleWidgets,
                        ),
                      ),
                    ),
                    borderData: FlBorderData (
                      show: true, border: Border.all (color: Colors.black),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 1,
                        ),
                      ),
                    ),
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
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        confirmDelete(index);
                                      },
                                    ),
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
                    Text('On Average, you slept _____ hours this week',
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
                child: Text('Get Data'),
              ),
      ]
        )));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
   String text;
    switch (value.toInt()) {
      case 1:
        text = 'Sun';
        break;
      case 2:
        text = 'Mon';
        break;
      case 3:
        text = 'Tue';
        break;
      case 4:
        text = 'Wed';
        break;
      case 5:
        text = 'Thur';
        break;
      case 6:
        text = 'Fri';
        break;
      case 7:
        text = 'Sat';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      )
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 2:
        text = '2';
        break;
      case 4:
        text = '4';
        break;
      case 6:
        text = '6';
        break;
      case 8:
        text = '8';
        break;
      case 10:
        text = '10';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  void deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  void confirmDelete (int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        title: Text ('Delete Goal'),
        content: Text ('Are you sure you want to delete this goal?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text ('Cancel'),
          ),
          TextButton(
              onPressed: () {
                deleteGoal(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
          )
        ],
      );
    },
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