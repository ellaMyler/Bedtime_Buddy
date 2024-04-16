import 'package:flutter/material.dart';
import 'bedtime_page.dart';
import 'log_sleep_page.dart';
import 'stats_page.dart';
import 'settings_page.dart';
import 'videos_page.dart';

//Contains the UI settings for the app.
//Changes to the UI are done here


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    //Separated Classes located in their respective files
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

  //Widget responsible for button UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bedtime Buddy'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,

        onTap: _onItemTapped,
      ),
    );
  }
}