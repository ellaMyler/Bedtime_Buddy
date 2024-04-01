import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_controller.dart';
import 'notification_maker.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           const ElevatedButton(
              onPressed:NotificationService.showTestNotification,
              child:  Text('Send Test Notification'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to App Settings for permission adjustment
                AppSettings.openAppSettings();
              },
              child: const Text('Open App Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
