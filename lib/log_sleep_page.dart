import 'package:flutter/material.dart';
import 'database.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
=======
>>>>>>> troy_main

// Log Sleep Page
class LogSleepPage extends StatefulWidget {
  const LogSleepPage({Key? key}) : super(key: key);

  @override
  _LogSleepPageState createState() => _LogSleepPageState();
}

class _LogSleepPageState extends State<LogSleepPage> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Date'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Text(_selectedDate != null
              ? 'Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
              : 'Select Date'),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SleepLoggingPage(selectedDate: _selectedDate!),
        ),
      );
    }
  }
}

class SleepLoggingPage extends StatefulWidget {
  final DateTime selectedDate;

  const SleepLoggingPage({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  _SleepLoggingPageState createState() => _SleepLoggingPageState();
}

class _SleepLoggingPageState extends State<SleepLoggingPage> {
  int _hoursSlept = 0;
  int _minutesSlept = 0;
  String _sleepThoughts = '';
  String _dreamNight = '';
  double _sleepQuality = 1;
  double _stressLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Sleep - ${_getFormattedDate(widget.selectedDate)}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Select your sleep quality',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              Slider(
                value: _sleepQuality,
                min: 1,
                max: 5,
                divisions: 4,
                label: _sleepQuality.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _sleepQuality = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Select your stress level',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              Slider(
                value: _stressLevel,
                min: 1,
                max: 5,
                divisions: 4,
                label: _stressLevel.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _stressLevel = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  _sleepThoughts = value;
                },
                decoration: InputDecoration(
                  labelText: 'Your thoughts on how you slept',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  _dreamNight = value;
                },
                decoration: InputDecoration(
                  labelText: 'Your dreams and/or nightmares',
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Hours: '),
                  DropdownButton<int>(
                    value: _hoursSlept,
                    onChanged: (int? value) {
                      setState(() {
                        _hoursSlept = value!;
                      });
                    },
                    items: List.generate(25, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text('$index'),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Minutes: '),
                  DropdownButton<int>(
                    value: _minutesSlept,
                    onChanged: (int? value) {
                      setState(() {
                        _minutesSlept = value!;
                      });
                    },
                    items: List.generate(60, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text('$index'),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _logSleep();
                },
                child: Text('Log Sleep'),
              ),
              SizedBox(height: 20), // Add some space between buttons
              ElevatedButton(
                onPressed: () {
                  _readSleepInfo();
                },
                child: Text('Read Sleep Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _readSleepInfo() async {
    String formattedDate = _getFormattedDate(widget.selectedDate);
    final snapshot = await databaseReference.child(formattedDate).get();
    if (snapshot.exists) {

      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

      String sleepInfoMessage = '';
      sleepInfoMessage += 'Logged data for $formattedDate:\n\n';
      sleepInfoMessage += '• Thoughts on your sleep: ${data?['Thoughts on your sleep']}\n';
      sleepInfoMessage += '• Your dreams and/or nightmares: ${data?['Your dreams were']}\n';
      sleepInfoMessage += '• Your quality of sleep: ${data?['Your quality of sleep was']}\n';
      sleepInfoMessage += '• Your level of stress that night: ${data?['Your level of stress that night was']}\n';
      sleepInfoMessage += '• Hours slept: ${data?['Hours slept']}\n';
      sleepInfoMessage += '• Minutes slept: ${data?['Minutes slept']}\n';

      // Show message in dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sleep Data'),
            content: Text(sleepInfoMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      String message = 'No logged information for this date';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sleep Logged'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      //print('No logged information for $formattedDate');
    }
  }


  void _logSleep() {
    String sleepDuration = '$_hoursSlept hours and $_minutesSlept minutes';
    String formattedDate = _getFormattedDate(widget.selectedDate);
    String sleepThoughts = _sleepThoughts;
    String dreamNight = _dreamNight;
    int sleepQuality = _sleepQuality.round();
    int stressLevel = _stressLevel.round();

    String message = 'On $formattedDate you slept $sleepDuration';
    //send to firebase
    sendSleepLog(formattedDate, sleepThoughts, dreamNight, sleepQuality.toString(), stressLevel.toString(), _hoursSlept, _minutesSlept);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sleep Logged'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
