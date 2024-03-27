import 'package:flutter/material.dart';
import 'package:sleep_tracker/database.dart';

//Bed Time Page
class BedtimePage extends StatefulWidget {
  const BedtimePage({Key? key}) : super(key: key);

  @override
  State<BedtimePage> createState() => _BedtimePageState();
}

class _BedtimePageState extends State<BedtimePage> {
  TimeOfDay? bedtime;

  DateTime? bedtimeDay;

  TimeOfDay? wakeupTime;

  DateTime? wakeupTimeDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bedtime/Wakeup'),
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
                Text('Bedtime: ${_formatTime(bedtime!)} on ${_formatDate(bedtimeDay!)}'),
                Text('Wakeup Time: ${_formatTime(wakeupTime!)} on ${_formatDate(wakeupTimeDay!)}'),
                Text(
                    'You will sleep for ${_calculateSleepDuration(bedtime!, wakeupTime!,bedtimeDay!, wakeupTimeDay!)}'),
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog();
                    sendBedtime('Bedtime', bedtimeDay.toString(), bedtime.toString());
                    sendBedtime('WakeupTime', wakeupTimeDay.toString(), wakeupTime.toString());
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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return TimeOfDayDialog(
            isBedtime: isBedtime,
            pickedDate: pickedDate,
            bedtime: bedtime,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          if (isBedtime) {
            bedtime = pickedTime;
            bedtimeDay = pickedDate;
          } else {
            wakeupTime = pickedTime;
            wakeupTimeDay = pickedDate;
          }
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
              Text('Bedtime: ${_formatTime(bedtime!)} on ${_formatDate(bedtimeDay!)}'),
              Text('Wakeup Time: ${_formatTime(wakeupTime!)} on ${_formatDate(wakeupTimeDay!)}'),
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

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String _calculateSleepDuration(TimeOfDay bedtime, TimeOfDay wakeupTime, DateTime bedtimeDay, DateTime wakeupTimeDay) {
    final bedtimeDateTime = DateTime(bedtimeDay.year, bedtimeDay.month, bedtimeDay.day, bedtime.hour, bedtime.minute);
    final wakeupDateTime = DateTime(wakeupTimeDay.year, wakeupTimeDay.month, wakeupTimeDay.day, wakeupTime.hour, wakeupTime.minute);

    // Add 1 day to wakeup time if it's before bedtime
    if (wakeupDateTime.isBefore(bedtimeDateTime)) {
      wakeupDateTime.add(Duration(days: 1));
    }

    final duration = wakeupDateTime.difference(bedtimeDateTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

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
  final DateTime pickedDate;
  final TimeOfDay? bedtime;

  TimeOfDayDialog({
    required this.isBedtime,
    required this.pickedDate,
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
            title: Text('Select Date'),
            subtitle: Text('${_formatDate(widget.pickedDate)}'),
          ),
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
          onPressed: () {
            Navigator.of(context).pop(_selectedTime);
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}