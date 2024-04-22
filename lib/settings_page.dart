import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:theme_provider/theme_provider.dart';

import 'alarm_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  List<String> imagePaths = [
    'lib/assets/thumbnails/notifications.png',
    'lib/assets/thumbnails/off.png',
    'lib/assets/thumbnails/AlarmSettingsButtonDark.png',
  ];

  @override
  Widget build(BuildContext context) {
    double _crossAxisSpacing = 0, _mainAxisSpacing = 12, _aspectRatio = 2.5;
    int _crossAxisCount = 1;
    double screenWidth = MediaQuery.of(context).size.width;

    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var height = width / _aspectRatio;

    bool isFirstTime = true; // Track if it's the first time dark mode is set
    late bool darkMode;
    if (isFirstTime == true) {
      isFirstTime = false;
      String currentTheme = ThemeProvider.themeOf(context).id;
      if (currentTheme == 'light') { // Light theme is in use
        darkMode = false;
      } else if (currentTheme == 'dark') { // Dark theme is in use
        darkMode = true;
      } else { /* Handle other themes if needed */ }
    }
    imagePaths[0] = darkMode ? 'lib/assets/thumbnails/notificationsDark.png' : 'lib/assets/thumbnails/notifications.png';
    imagePaths[1] = darkMode ? 'lib/assets/thumbnails/on.png' : 'lib/assets/thumbnails/off.png';
    imagePaths[2] = darkMode ? 'lib/assets/thumbnails/AlarmSettingsButtonDark.png' : 'lib/assets/thumbnails/AlarmSettingsButton.png';

    return Scaffold(
      body: Container(
        child: GridView.builder(
          padding: EdgeInsets.fromLTRB(width / 4, height, width / 4, 0),
          itemCount: 3,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              // Toggle the image path for the tapped item
              switch (index) {
                case 0:
                  AppSettings.openAppSettings(); // open notifications settings
                  break;
                case 1:
                  setState(() {
                    darkMode = !darkMode; // Toggle dark mode
                    // Update notifications icon based on dark mode status
                    if (darkMode == true) {
                      ThemeProvider.controllerOf(context).setTheme('dark');
                    } else {
                      ThemeProvider.controllerOf(context).setTheme('light');
                    }
                  });
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExampleAlarmHomeScreen()),
                  );

                  break;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePaths[index]), // Use the image path based on the index
                  fit: BoxFit.cover,
                ),
              ),
              // You can customize the container further if needed
            ),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossAxisCount,
            crossAxisSpacing: _crossAxisSpacing,
            mainAxisSpacing: _mainAxisSpacing,
            childAspectRatio: _aspectRatio,
          ),
        ),
      ),
    );
  }
}
