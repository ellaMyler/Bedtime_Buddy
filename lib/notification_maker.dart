import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_controller.dart';
import 'bedtime_page.dart';

class NotificationService {
  static Future<void> initNotifications() async {
    /*
    await AwesomeNotifications().initialize(
      null, // This null is for the notification icon
      [
        NotificationChannel(
          channelGroupKey: "basic_channel_group",
          channelKey: 'local_channel',
          channelName: "Basic Notification",
          channelDescription: "Test notifications channel",
        )
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupKey: "basic_channel_group", channelGroupName: "Basic Group")
      ],
    );

     */

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
    // Ensure that initNotifications() has been called before creating notifications
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch % 10000,
        channelKey: 'local_channel',
        title: "Test Notification",
        body: "This notification works!",
      ),
    );
  }

  static Future<void> sendBedtimeNotification(DateTime bedtimeDateTime) async {
   // String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    //String utcTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
   // print("Scheduling bedtime notification for: $bedtimeDateTime");
    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar(
        day: bedtimeDateTime!.day,
        month: bedtimeDateTime!.month,
        year: bedtimeDateTime!.year,
        hour: bedtimeDateTime!.hour,
        minute: bedtimeDateTime!.minute,
      ),
      content: NotificationContent(
       // id: DateTime.now().millisecondsSinceEpoch.remainder(100000), // Ensures a unique ID for the notification
        id: DateTime.now().millisecondsSinceEpoch % 10000,
        channelKey: 'local_channel',
        title: 'Time for Bed!',
        body: "It is time for you to go to bed",
      ),
    );
  }
}
