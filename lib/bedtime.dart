import 'package:flutter/material.dart';

void main() {
  runApp(SleepApp());
}

class SleepApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SleepPage(),
    );
  }
}

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  TimeOfDay? bedtime;
  TimeOfDay? wakeupTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _selectTime(true);
              },
              child: Text('Set Bedtime'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectTime(false);
              },
              child: Text('Set Wakeup Time'),
            ),
            SizedBox(height: 20),
            bedtime != null && wakeupTime != null
                ? Column(
              children: [
                Text('Bedtime: ${_formatTime(bedtime!)}'),
                Text('Wakeup Time: ${_formatTime(wakeupTime!)}'),
                Text(
                    'You will sleep for ${_calculateSleepDuration(bedtime!, wakeupTime!)}'),
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog();
                  },
                  child: Text('Confirm'),
                ),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(bool isBedtime) async {
    final TimeOfDay? pickedTime = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimeOfDayDialog(
          isBedtime: isBedtime,
          bedtime: bedtime,
        );
      },
    );
    if (pickedTime != null) {
      if (isBedtime) {
        setState(() {
          bedtime = pickedTime;
        });
      } else {
        setState(() {
          wakeupTime = pickedTime;
        });
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bedtime: ${_formatTime(bedtime!)}'),
              Text('Wakeup Time: ${_formatTime(wakeupTime!)}'),
            ],
          ),
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
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
  String _calculateSleepDuration(TimeOfDay bedtime, TimeOfDay wakeupTime) {
    final bedTimeInMinutes = bedtime.hour * 60 + bedtime.minute;
    final wakeupTimeInMinutes = wakeupTime.hour * 60 + wakeupTime.minute;
    final durationInMinutes = wakeupTimeInMinutes - bedTimeInMinutes;

    final hours = durationInMinutes ~/ 60;
    final minutes = durationInMinutes % 60;

    String durationText = '$hours hour';
    if (hours != 1) {
      durationText += 's'; // Pluralize "hour" if needed
    }
    if (minutes > 0) {
      durationText += ' and $minutes minute';
      if (minutes != 1) {
        durationText += 's'; // Pluralize "minute" if needed
      }
    }
    return durationText;
  }
}

class TimeOfDayDialog extends StatefulWidget {
  final bool isBedtime;
  final TimeOfDay? bedtime;

  TimeOfDayDialog({
    required this.isBedtime,
    required this.bedtime,
  });

  @override
  _TimeOfDayDialogState createState() => _TimeOfDayDialogState();
}

class _TimeOfDayDialogState extends State<TimeOfDayDialog> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isBedtime ? 'Set Bedtime' : 'Set Wakeup Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Select Time'),
            trailing: TextButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
              child: Text('${_selectedTime.format(context)}'),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: widget.isBedtime
              ? (_selectedTime.hour > DateTime.now().hour ||
              (_selectedTime.hour == DateTime.now().hour && _selectedTime.minute > DateTime.now().minute)
              ? () => Navigator.of(context).pop(_selectedTime)
              : null)
              : (_selectedTime.hour > widget.bedtime!.hour ||
              (_selectedTime.hour == widget.bedtime!.hour && _selectedTime.minute > widget.bedtime!.minute)
              ? () => Navigator.of(context).pop(_selectedTime)
              : null),
          child: Text('OK'),
        ),
      ],
    );
  }
}





