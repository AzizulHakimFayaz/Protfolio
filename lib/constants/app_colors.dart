import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color navyDark = Color(0xFF0D1B2A); // Deep Navy
  static const Color navyLight = Color(0xFF1B263B); // Lighter Navy
  static const Color contentBackground = Color(0xFFF5F6F8); // Light Grey/White

  // Accents
  static const Color accentTeal = Color(0xFF2AC7D1); // Teal
  static const Color accentTealGlow = Color.fromRGBO(
    42,
    199,
    209,
    0.35,
  ); // Soft Teal Glow

  // Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF222222);
  static const Color textGrey = Color(0xFF666666);

  // Particles
  static const Color particleTeal = Color(0xFF2AC7D1);
  static const Color particleWhite = Color(0xFFF0FBFF);

  // Legacy mappings (to prevent immediate build errors before full refactor)
  static const Color scaffoldBackground = navyDark;
  static const Color surfaceDark = navyLight;
  static const Color surfaceLight = contentBackground;
  static const Color textPrimaryDark = textWhite;
  static const Color textPrimaryLight = textDark;
  static const Color textSecondaryDark = Colors.white70;
  static const Color cardDark = navyLight;
  static const Color neonCyan = accentTeal;
  static const Color neonPurple = accentTeal; // Temporary mapping
  static const Color accentBlue = accentTeal;
  static const Color accentGold = accentTeal;
  static const Color accentIndigo = accentTeal;
}
