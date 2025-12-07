import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/github/styles/github_theme.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class ContributionSquare extends StatefulWidget {
  final int contributionCount;
  final String date;
  final String colorCode; // From API, but we might override with our theme

  const ContributionSquare({
    super.key,
    required this.contributionCount,
    required this.date,
    required this.colorCode,
  });

  @override
  State<ContributionSquare> createState() => _ContributionSquareState();
}

class _ContributionSquareState extends State<ContributionSquare> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Determine color based on count (overriding API color for consistency)
    final Color baseColor = GitHubTheme.getContributionColor(
      widget.contributionCount,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Tooltip(
        message: '${widget.date}\n${widget.contributionCount} contributions',
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.navyDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.accentTeal.withOpacity(0.3)),
          boxShadow: [GitHubTheme.softShadow],
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        waitDuration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: 12,
          height: 12, // Fixed size
          transform: _isHovering
              ? (Matrix4.identity()..scale(1.3))
              : Matrix4.identity(),
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(3),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: GitHubTheme.getGlowColor(widget.contributionCount),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }
}
