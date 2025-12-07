import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class TimelineExperience extends StatelessWidget {
  const TimelineExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TimelineItem(
          year: "2023 - Present",
          title: "Mobile App Developer",
          company: "Tech Innovators Ltd.",
          description:
              "Developing high-performance Flutter applications, integrating AI features using TensorFlow Lite, and optimizing app performance for millions of users.",
          isFirst: true,
          isLast: false,
        ),
        TimelineItem(
          year: "2021 - 2023",
          title: "Junior Software Engineer",
          company: "SoftSys Solutions",
          description:
              "Worked on native Android development (Kotlin), implemented RESTful APIs, and collaborated with cross-functional teams to deliver scalable solutions.",
          isFirst: false,
          isLast: true,
        ),
      ],
    );
  }
}

class TimelineItem extends StatefulWidget {
  final String year;
  final String title;
  final String company;
  final String description;
  final bool isFirst;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.year,
    required this.title,
    required this.company,
    required this.description,
    required this.isFirst,
    required this.isLast,
  });

  @override
  State<TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<TimelineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Line & Dot
            SizedBox(
              width: 50,
              child: Column(
                children: [
                  // Top Line
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.isFirst
                                ? Colors.transparent
                                : AppColors.neonCyan.withValues(alpha: 0.2),
                            AppColors.neonCyan.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Dot
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isHovered ? 24 : 18,
                    height: _isHovered ? 24 : 18,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.neonCyan
                          : AppColors.neonCyan.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.scaffoldBackground,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonCyan.withValues(
                            alpha: _isHovered ? 0.8 : 0.4,
                          ),
                          blurRadius: _isHovered ? 20 : 10,
                          spreadRadius: _isHovered ? 5 : 2,
                        ),
                      ],
                    ),
                  ),
                  // Bottom Line
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.neonCyan.withValues(alpha: 0.6),
                            widget.isLast
                                ? Colors.transparent
                                : AppColors.neonCyan.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.translationValues(
                    _isHovered ? 10 : 0,
                    0,
                    0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: _isHovered ? 0.08 : 0.03,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.neonCyan.withValues(
                          alpha: _isHovered ? 0.3 : 0.1,
                        ),
                      ),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: AppColors.neonCyan.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 30,
                                spreadRadius: -5,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _isHovered
                                      ? AppColors.neonCyan
                                      : AppColors.textPrimaryDark,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.neonCyan.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.neonCyan.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                widget.year,
                                style: const TextStyle(
                                  color: AppColors.textPrimaryDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.company,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textPrimaryDark.withValues(
                              alpha: 0.7,
                            ),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
