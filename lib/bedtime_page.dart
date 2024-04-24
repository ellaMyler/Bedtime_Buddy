import 'package:flutter/material.dart';
import 'package:sleep_tracker/database.dart';
import 'package:theme_provider/theme_provider.dart';
import 'main.dart';
import 'notification_maker.dart';
import 'alarm_setter.dart';

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
    String currentTheme = ThemeProvider.themeOf(context).id;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bedtime/Wakeup',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ThemeProvider.optionsOf<MyThemeOptions>(context).backgroundColor,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/$currentTheme.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _selectTime(true),
                    icon: const Icon(Icons.bedtime),
                    label: const Text('Set Bedtime'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _selectTime(false),
                    icon: const Icon(Icons.wb_sunny),
                    label: const Text('Set Wakeup'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await setPrevious();
                      print(bedtime!);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Set Previous'),
                  ),
                  const SizedBox(height: 20),
                  if (bedtime != null && wakeupTime != null)
                    Column(
                      children: [
                        Text('Bedtime: ${_formatTime(bedtime!)} on ${_formatDate(bedtimeDay!)}'),
                        Text('Wakeup Time: ${_formatTime(wakeupTime!)} on ${_formatDate(wakeupTimeDay!)}'),
                        Text('You will sleep for ${_calculateSleepDuration(bedtime!, wakeupTime!, bedtimeDay!, wakeupTimeDay!)}'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _showConfirmationDialog();
                            storePrevious(bedtime!, bedtimeDay!, wakeupTime!, wakeupTimeDay!);
                            final bedtimeDateTime = DateTime(
                              bedtimeDay!.year,
                              bedtimeDay!.month,
                              bedtimeDay!.day,
                              bedtime!.hour,
                              bedtime!.minute,
                            );
                            NotificationService.sendBedtimeNotification(bedtimeDateTime);
                            final wakeupDateTime = DateTime(
                              wakeupTimeDay!.year,
                              wakeupTimeDay!.month,
                              wakeupTimeDay!.day,
                              wakeupTime!.hour,
                              wakeupTime!.minute,
                            );
                            AlarmSetter.setWakeupAlarm(wakeupTimeDay, wakeupTime);
                            AlarmSetter.sendBedtimeNotification(wakeupDateTime);
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(bool isBedtime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showDialog<TimeOfDay>(
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
              Text('Bedtime: ${bedtime != null && bedtimeDay != null ? "${_formatTime(bedtime!)} on ${_formatDate(bedtimeDay!)}" : "Not set"}'),
              Text('Wakeup Time: ${wakeupTime != null && wakeupTimeDay != null ? "${_formatTime(wakeupTime!)} on ${_formatDate(wakeupTimeDay!)}" : "Not set"}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

  Future<void> setPrevious() async {
    // Assume 'readPrevious' is a method that populates previous times from storage or similar
    await readPrevious();
    setState(() {
      bedtime = previousBedTime;
      bedtimeDay = previousBedtimeDay?.add(const Duration(days: 1));
      wakeupTime = previousWakeupTime;
      wakeupTimeDay = previousWakeupTimeDay?.add(const Duration(days: 1));
    });
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
    _selectedTime = widget.bedtime ?? TimeOfDay.now();
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
            subtitle: Text(_formatDate(widget.pickedDate)),
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
              child: Text(_selectedTime.format(context)),
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
