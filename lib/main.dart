import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sleep_tracker/app_ui.dart';
import 'package:theme_provider/theme_provider.dart';
import 'notification_maker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initNotifications();

  runApp(const SleepTrackerApp());
}

class SleepTrackerApp extends StatelessWidget {
  const SleepTrackerApp({Key? key}) : super(key: key);

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
      themes: <AppTheme>[
        AppTheme.light(id: 'light'),
        AppTheme.dark(id: 'dark'),
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

