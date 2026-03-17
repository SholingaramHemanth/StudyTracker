import 'package:flutter/material.dart';
import 'app_shared.dart';
import 'study_tracker_premium_ui.dart';

void main() {
  runApp(const StudyTrackerApp());
}

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Smart Study Tracker',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: PremiumTheme.light,
          home: const PremiumSplashScreen(),
        );
      },
    );
  }
}
