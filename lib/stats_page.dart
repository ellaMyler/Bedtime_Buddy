// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/database.dart';

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
  List<String> dates = [
    "April 14, 2024", "April 15, 2024", "April 16, 2024",
    "April 17, 2024", "April 18, 2024", "April 19, 2024",
    "April 20, 2024",
  ];

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
                          FlSpot(1, 10.9), //Sunday (14)
                          FlSpot(2, 8.2), //Monday (15)
                          FlSpot(3, 12.3), //Tuesday (16)
                          FlSpot(4, 6.19), // Wednesday (17)
                          FlSpot(5, 7.2), //Thursday (18)
                          FlSpot(6, 6.1), //Friday (19)
                          FlSpot(7, 5.11), //Saturday (20)
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
                height: 125,
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.black),
                ),
                child: FutureBuilder <void> (
                  future: Future.wait([
                    calcWeeklyAveSleep(dates),
                    calcWeeklyAveStress(dates),
                    calcWeeklyAveQuality(dates),
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator()); // Or any loading indicator widget
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final List<int> averages = snapshot.data as List<int>;
                      final int sleepAveMinutes = averages[0];
                      final int stressAve = averages[1];
                      final int qualityAve = averages [2];
                      
                      int sleepAveHours = sleepAveMinutes ~/ 60;
                      int sleepAveMin = sleepAveMinutes % 60;
                    
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text ('On Average, you slept $sleepAveHours hours '
                              'and $sleepAveMin minutes this week', 
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                          Text('On Average, your stress level was $stressAve this week',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                          Text('On Average, your quality of sleep this week was $qualityAve',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
                        ],
                      );
                    }
                  },
                ),
              ),
            ]
          )
        )
    );
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
      case 12:
        text = '12';
        break;
      case 14:
        text = '14';
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