import 'dart:ui';
import 'package:flutter/material.dart';
import 'database.dart';
import 'package:firebase_core/firebase_core.dart';


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
        title: const Text(
          'Select a Date',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(9, 7, 61, 1),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/agile_moonlit_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _selectDate(context);
                },
                icon: Icon(Icons.calendar_today),
                label: Text(_selectedDate != null
                    ? 'Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Select Date'),
               style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromRGBO(51, 43, 138, 1)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                textStyle: MaterialStateProperty.all(
                TextStyle(fontWeight: FontWeight.bold),
               ),
               ),
              ),
            ),
          ),
        ],
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Color.fromRGBO(9, 7, 61, 1),
                child: Center(
                  child: Text(
                    'Log Sleep - ${_getFormattedDate(widget.selectedDate)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Color.fromRGBO(9, 7, 61, 1),
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/agile_moonlit_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Select your sleep quality',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  _buildSleepQualitySlider(),
                  SizedBox(height: 20),
                  Text(
                    'Select your stress level',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  _buildStressLevelSlider(),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      _sleepThoughts = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Your thoughts on how you slept',
                      prefixIcon: Icon(Icons.cloud, color: Colors.white),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      _dreamNight = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Your dreams and/or nightmares',
                      prefixIcon: Icon(Icons.nightlight_round, color: Colors.white),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _hoursSlept = int.tryParse(value) ?? 0;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Hours',
                            prefixIcon: Icon(Icons.access_time, color: Colors.white),
                            labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _minutesSlept = int.tryParse(value) ?? 0;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Minutes',
                            prefixIcon: Icon(Icons.access_time, color: Colors.white),
                            labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _logSleep();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bed, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Log Sleep'),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(51, 43, 138, 1)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  SizedBox(height: 20), // Add some space between buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _readSleepInfo();
                      },
                      icon: Icon(Icons.book),
                      label: Text('Read sleep logged for this date'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(51, 43, 138, 1),
                        foregroundColor: (Colors.white),
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepQualitySlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: _getSleepQualityScrollColor(_sleepQuality),
        inactiveTrackColor: Colors.grey,
        trackHeight: 4.0,
        thumbColor: Colors.blue,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayColor: Colors.red.withAlpha(32),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
      ),
      child: Slider(
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
    );
  }

  Widget _buildStressLevelSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: _getStressLevelScrollColor(_stressLevel),
        inactiveTrackColor: Colors.grey,
        trackHeight: 4.0,
        thumbColor: Colors.blue,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayColor: Colors.red.withAlpha(32),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
      ),
      child: Slider(
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
    );
  }

  Color _getSleepQualityScrollColor(double value) {
    if (value == 5) {
      return Colors.green;
    } else if (value >= 4) {
      return Colors.blue;
    } else if (value >= 3) {
      return Colors.yellow;
    } else if (value >= 2) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getStressLevelScrollColor(double value) {
    if (value == 5) {
      return Colors.red;
    } else if (value == 4) {
      return Colors.orange;
    } else if (value == 3) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
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
    }
  }

  void _logSleep() {
    String sleepDuration = '$_hoursSlept hours and $_minutesSlept minutes';
    String formattedDate = _getFormattedDate(widget.selectedDate);
    String sleepThoughts = _sleepThoughts;
    String dreamNight = _dreamNight;
    int sleepQuality = _sleepQuality.round();
    int stressLevel = _stressLevel.round();

    sendSleepLog(formattedDate, sleepThoughts, dreamNight, sleepQuality.toString(), stressLevel.toString(), _hoursSlept, _minutesSlept);

    String message = 'On $formattedDate you slept $sleepDuration';
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
