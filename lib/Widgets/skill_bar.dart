import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class SkillBar extends StatefulWidget {
  final String skillName;
  final double percentage;
  final Color color;

  const SkillBar({
    super.key,
    required this.skillName,
    required this.percentage,
    this.color = AppColors.neonCyan, // Cyan accent
  });

  @override
  State<SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<SkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.skillName.toUpperCase(),
                style: TextStyle(
                  color: widget.color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: widget.color.withValues(alpha: 0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              Text(
                "${(widget.percentage * 100).toInt()}%",
                style: TextStyle(
                  color: AppColors.textPrimaryDark.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontFamily: "monospace",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 12,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Background Track (Segmented)
                    Row(
                      children: List.generate(20, (index) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            color: AppColors.textPrimaryDark.withValues(
                              alpha: 0.05,
                            ),
                          ),
                        );
                      }),
                    ),

                    // Fill Animation
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: widget.percentage),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        final filledSegments = (value * 20).toInt();
                        return Row(
                          children: List.generate(20, (index) {
                            final isFilled = index < filledSegments;
                            return Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: isFilled
                                      ? widget.color.withValues(alpha: 0.8)
                                      : Colors.transparent,
                                  boxShadow: isFilled
                                      ? [
                                          BoxShadow(
                                            color: widget.color.withValues(
                                              alpha: 0.5,
                                            ),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : [],
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),

                    // Scanning Glint
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Positioned(
                          left:
                              constraints.maxWidth *
                                  widget.percentage *
                                  _controller.value -
                              20,
                          child: Container(
                            width: 40,
                            height: 12,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.textPrimaryDark.withValues(
                                    alpha: 0.8,
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
