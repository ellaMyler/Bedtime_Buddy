import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'bedtime_page.dart';
import 'log_sleep_page.dart';
import 'main.dart';
import 'stats_page.dart';
import 'settings_page.dart';
import 'videos_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    BedtimePage(),
    LogSleepPage(),
    VideosPage(),
    SleepStatsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bedtime Buddy',
          style: TextStyle(fontWeight: FontWeight.w300, fontFamily: 'plastun'),
        ),
        centerTitle: false,
        backgroundColor:
        ThemeProvider.optionsOf<MyThemeOptions>(context).backgroundColor,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
        ThemeProvider.optionsOf<MyThemeOptions>(context).backgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Bedtime',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bedtime),
            label: 'Log Sleep',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Sleep Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple[400],
        unselectedItemColor: Theme.of(context).textTheme.caption!.color,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}