import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:theme_provider/theme_provider.dart';
import 'edit_alarm.dart';
import 'main.dart';
import 'ring_page.dart';
import 'shortcut_button.dart';
import 'tile.dart';
import 'package:flutter/material.dart';

class ExampleAlarmHomeScreen extends StatefulWidget {
  const ExampleAlarmHomeScreen({Key? key}) : super(key: key);

  @override
  State<ExampleAlarmHomeScreen> createState() => _ExampleAlarmHomeScreenState();
}

class _ExampleAlarmHomeScreenState extends State<ExampleAlarmHomeScreen> {
  late List<AlarmSettings> alarms;

  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
          (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExampleAlarmRingScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: ExampleAlarmEditScreen(alarmSettings: settings),
        );
      },
    );

    if (res != null && res) loadAlarms();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentTheme = ThemeProvider.themeOf(context).id;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sleep Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: ThemeProvider.optionsOf<MyThemeOptions>(context).backgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/$currentTheme.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: alarms.isNotEmpty
              ? ListView.separated(
            itemCount: alarms.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ExampleAlarmTile(
                key: Key(alarms[index].id.toString()),
                title: TimeOfDay(
                  hour: alarms[index].dateTime.hour,
                  minute: alarms[index].dateTime.minute,
                ).format(context),
                onPressed: () => navigateToAlarmScreen(alarms[index]),
                onDismissed: () {
                  Alarm.stop(alarms[index].id).then((_) => loadAlarms());
                },
              );
            },
          )
              : const Center(
            child: Text(
              "No alarms set",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExampleAlarmHomeShortcutButton(refreshAlarms: loadAlarms),
            FloatingActionButton(
              onPressed: () => navigateToAlarmScreen(null),
              child: const Icon(Icons.alarm_add_rounded, size: 33),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}