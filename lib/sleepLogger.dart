import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MonthSelectionPage(),
    );
  }
}

class MonthSelectionPage extends StatelessWidget {
  const MonthSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Month'),
      ),
      body: GridView.builder(
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DaySelectionPage(month: index + 1),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  _getMonthName(index + 1),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
      ),
    );
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

class DaySelectionPage extends StatelessWidget {
  final int month;

  const DaySelectionPage({Key? key, required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getMonthName(month)),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: _getDaysInMonth(month),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepLoggingPage(
                          month: month,
                          day: index + 1,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Center(
                      child: Text('${index + 1}'),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
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

  int _getDaysInMonth(int monthNumber) {
    switch (monthNumber) {
      case 1: // January
      case 3: // March
      case 5: // May
      case 7: // July
      case 8: // August
      case 10: // October
      case 12: // December
        return 31;
      case 4: // April
      case 6: // June
      case 9: // September
      case 11: // November
        return 30;
      case 2: // February
      // For simplicity, considering it as non-leap year
        return 28;
      default:
        return 0;
    }
  }
}

class SleepLoggingPage extends StatefulWidget {
  final int month;
  final int day;

  const SleepLoggingPage({Key? key, required this.month, required this.day}) : super(key: key);

  @override
  _SleepLoggingPageState createState() => _SleepLoggingPageState();
}

class _SleepLoggingPageState extends State<SleepLoggingPage> {
  int _hoursSlept = 0;
  int _minutesSlept = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Sleep - ${_getMonthName(widget.month)} ${widget.day}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
          ],
        ),
      ),
    );
  }

  void _logSleep() {
    String sleepDuration = '$_hoursSlept hours and $_minutesSlept minutes';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sleep Logged'),
          content: Text('On ${_getMonthName(widget.month)} ${widget.day} you slept $sleepDuration.'),
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