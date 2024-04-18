import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/rendering.dart';
import 'notification_controller.dart';
import 'notification_maker.dart';
import 'dart:math' as math;


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> imagePaths = [
    'lib/assets/thumbnails/white.jpg', // Image path for switch0
    'lib/assets/thumbnails/notifications.png',  // Image path for switch1
    'lib/assets/thumbnails/white.jpg',
    'lib/assets/thumbnails/white.jpg',
    'lib/assets/thumbnails/off.png',
    'lib/assets/thumbnails/white.jpg',
    'lib/assets/thumbnails/white.jpg',
    'lib/assets/thumbnails/off.png',
    'lib/assets/thumbnails/white.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    double _crossAxisSpacing = 0, _mainAxisSpacing = 12, _aspectRatio = 2.5;
    int _crossAxisCount = 3;
    double screenWidth = MediaQuery.of(context).size.width;

    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var height = width / _aspectRatio;

    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.fromLTRB(0, height * 3, 0, 0),
        itemCount: 9,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
              // Toggle the image path for the tapped item
              switch (index) {
              case 1:
                setState(() {
                  imagePaths[index] = imagePaths[index] == 'lib/assets/thumbnails/notifications.png'
                      ? 'lib/assets/thumbnails/notifications.png'
                      : 'lib/assets/thumbnails/notifications.png';});
                AppSettings.openAppSettings();
                break;
              case 4:
                setState(() {
                  imagePaths[index] = imagePaths[index] == 'lib/assets/thumbnails/off.png'
                      ? 'lib/assets/thumbnails/on.png'
                      : 'lib/assets/thumbnails/off.png';});
                break;
              case 7:
                setState(() {
                  imagePaths[index] = imagePaths[index] == 'lib/assets/thumbnails/off.png'
                      ? 'lib/assets/thumbnails/on.png'
                      : 'lib/assets/thumbnails/off.png';});
                break;
          }},
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
    );
  }
}