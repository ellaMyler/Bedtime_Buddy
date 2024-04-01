import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_controller.dart';

class NotificationService {
  static Future<void> initNotifications() async {
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
      channelGroups: [
        NotificationChannelGroup(channelGroupKey: "basic_channel_group", channelGroupName: "Basic Group")
      ],
    );

    // Check if notifications are allowed, if not, request permission
    bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowedToSendNotification) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
  }

  //Test notification to make sure the implementation works properly
  static void showTestNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "local_channel",
        title: "Test Notification",
        body: "This notification works!",
      ),
    );
  }
}
