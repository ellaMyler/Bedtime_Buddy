import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_maker.dart';
import 'package:alarm/alarm.dart';
import 'package:sleep_tracker/app_ui.dart';
import 'package:theme_provider/theme_provider.dart';
import 'notification_maker.dart';
import 'ring_page.dart';
import 'notification_controller.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initNotifications(); // Starts Notifications
  await Alarm.init(); // Starts Alarms

  //Notification Initialization Code
  AwesomeNotifications().initialize(
      null, //Icon; null defaults to app icon
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'local_channel',
            channelName: 'Basic Notification',
            channelDescription: 'Notification channel for basic notifications',
            importance: NotificationImportance.High,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white
        )
      ],
      debug: true
  );
  //End of Notification Initialization Code

  // Initialize Awesome Notifications For Wakeup Alarms
  AwesomeNotifications().initialize(
      null, //Icon; null defaults to app icon
      [
        NotificationChannel(
          channelKey: 'wakeup_alarm_channel',
          channelName: 'Wakeup Alarms',
          channelDescription: 'Notification channel for wakeup alarms',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        // Include other channels as needed
      ],
      debug: true
  );

  runApp(const SleepTrackerApp());
}

class SleepTrackerApp extends StatelessWidget{
  const SleepTrackerApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        final view = WidgetsBinding.instance!.window.platformDispatcher;
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness = view.platformBrightness;
          if (platformBrightness == Brightness.dark) {
            controller.setTheme('dark');
          } else {
            controller.setTheme('light');
          }
        }
      },
      themes: [
        AppTheme(
          id: "light",
          description: "Light Theme",
          data: ThemeData.light(),
          options: MyThemeOptions(const Color.fromRGBO(179, 175, 255, 1.0)), // change the color here for light mode!
        ),
        AppTheme(
          id: "dark",
          description: "Dark Theme",
          data: ThemeData.dark(),
          options: MyThemeOptions(const Color.fromRGBO(9, 7, 61, 1)), // change the color here for dark mode!! 
        ),
      ],
      child: Builder(
        builder: (themeContext) => MaterialApp(
          theme: ThemeProvider.themeOf(themeContext).data,
          home: const MainScreen(),
        ),
      ),
    );
  }
}
// used in everything to set dark mode stuff
class MyThemeOptions implements AppThemeOptions{
  final Color backgroundColor;
  MyThemeOptions(this.backgroundColor);
}