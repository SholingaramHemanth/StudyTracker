import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

class AppColors {
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF8B5CF6);
  static const accent = Color(0xFFD946EF);
  static const emerald = Color(0xFF10B981);
  static const amber = Color(0xFFF59E0B);
  
  static const neonCyan = Color(0xFF06FBFF);
  static const neonFuchsia = Color(0xFFFF00FF);
  static const deepIndigo = Color(0xFF0F172A);
  
  static const darkBg = Color(0xFF020617);
  static const darkSurface = Color(0xFF0F172A);
  
  static const lightBg = Color(0xFFF8FAFC);
  static const lightSurface = Colors.white;

  static LinearGradient premiumGradient = const LinearGradient(
    colors: [primary, secondary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient futuristicGradient = const LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static List<BoxShadow> glassShadow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.2),
      blurRadius: 25,
      offset: const Offset(0, 10),
    )
  ];

  static List<BoxShadow> glowShadow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.4),
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: color.withOpacity(0.1),
      blurRadius: 40,
      spreadRadius: 10,
    )
  ];
}
