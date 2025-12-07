import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDarkMode;
  final Color? color;

  const SectionTitle({
    super.key,
    required this.title,
    this.isDarkMode = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color:
                color ??
                (isDarkMode ? AppColors.textWhite : AppColors.textDark),
            fontFamily: 'Roboto', // Or preferred font
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.accentTeal,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
