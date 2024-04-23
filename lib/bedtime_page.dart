import 'package:flutter/material.dart';
import 'package:sleep_tracker/database.dart';

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
        title: const Text('Bedtime/Wakeup'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                  '!Recommended sleep time is 8 hours!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )
              ),

            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _selectTime(true);
                  },
                  icon: Icon(Icons.bedtime),
                  label: const Text('Set Bedtime'),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _selectTime(false);
                  },
                  icon: Icon(Icons.wb_sunny),
                  label: const Text('Set Wakeup'),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    //_setPrevious();
                  },
                  icon: Icon(Icons.refresh),
                  label: const Text('Set Previous'),
                ),
                const SizedBox(height: 20),
                bedtime != null && wakeupTime != null
                    ? Column(
                    children: [
                      Text(
                          'Bedtime: ${_formatTime(bedtime!)} on ${_formatDate(bedtimeDay!)}'),
                      Text(
                          'Wakeup Time: ${_formatTime(wakeupTime!)} on ${_formatDate(wakeupTimeDay!)}'),
                      Text(
                          'You will sleep for ${_calculateSleepDuration(bedtime!, wakeupTime!, bedtimeDay!, wakeupTimeDay!)}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog();
                      },
                      child: const Text('Confirm'),
                    ),
                    const SizedBox(height: 40),
                  ],
                )
                    : const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _setPrevious(DateTime? previousBTDay, TimeOfDay? previousBTTime, DateTime? previousWTDay, TimeOfDay? previousWTTime) {

  }

  DateTime? getDay(String type, String ) {

  }

  TimeOfDay? getTime() {

  }

  Future<void> _selectTime(bool isBedtime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
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
          title: const Text('Confirmation'),
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
              child: const Text('Close'),
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
      wakeupDateTime.add(const Duration(days: 1));
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
            title: const Text('Select Date'),
            subtitle: Text('${_formatDate(widget.pickedDate)}'),
          ),
          ListTile(
            title: const Text('Select Time'),
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
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedTime);
          },
          child: const Text('OK'),
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