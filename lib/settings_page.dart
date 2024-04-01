import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'notification_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  void initState() async {
    await AwesomeNotifications().initialize(
        null, // This null is for the notification icon
        [
          NotificationChannel(
            channelGroupKey: "basic_channel_group",
            channelKey: "local_channel",
            channelName: "Basic Notification",
            channelDescription: "Test notifications channel",
          )
        ],
        channelGroups:[
          NotificationChannelGroup(channelGroupKey: "basic_channel_group", channelGroupName: "Basic Group")
        ]
    );
    //Check if notifications are allowed, if not, request a permission
    bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
    if(!isAllowedToSendNotification){
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod);
  }

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
            ElevatedButton(
              onPressed:() { AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: 1,
                      channelKey: "local_channel",
                      title: "Test Notification",
                       body: "This notification works!"),

              );

              },
              child: const Text('Send Test Notification'),
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
