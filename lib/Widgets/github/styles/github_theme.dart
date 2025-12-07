import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class GitHubTheme {
  // Container Gradient (Subtle Dark Gradient)
  static const LinearGradient containerGradient = LinearGradient(
    colors: [
      Color(0xFF0F172A), // Dark Navy
      Color(0xFF1E293B), // Slightly lighter Slate/Navy
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Borders
  static final Border border = Border.all(
    color: AppColors.accentTeal.withOpacity(0.1),
    width: 1.0,
  );

  static final BorderRadius borderRadius = BorderRadius.circular(16);

  // Shadows
  static const BoxShadow softShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  // Contribution Colors (0 to 4 levels)
  static Color getContributionColor(int level) {
    if (level <= 0) return const Color(0xFF1E293B).withOpacity(0.5); // Empty
    if (level <= 3) return AppColors.accentTeal.withOpacity(0.25);
    if (level <= 6) return AppColors.accentTeal.withOpacity(0.50);
    if (level <= 9) return AppColors.accentTeal.withOpacity(0.75);
    return AppColors.accentTeal; // Max
  }

  static Color getGlowColor(int level) {
    if (level <= 0) return Colors.transparent;
    return AppColors.accentTeal.withOpacity(0.4);
  }
}
