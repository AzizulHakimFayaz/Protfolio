import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';

class TimelineExperience extends StatelessWidget {
  const TimelineExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimelineItem(
          year: "2023 - Present",
          title: "Mobile App Developer",
          company: "Tech Innovators Ltd.",
          description:
              "Developing high-performance Flutter applications, integrating AI features using TensorFlow Lite, and optimizing app performance for millions of users.",
          isFirst: true,
          isLast: false,
        ),
        _buildTimelineItem(
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

  Widget _buildTimelineItem({
    required String year,
    required String title,
    required String company,
    required String description,
    required bool isFirst,
    required bool isLast,
  }) {
    return IntrinsicHeight(
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
                      color: isFirst
                          ? Colors.transparent
                          : const Color(0xFF00E5FF).withValues(alpha: 0.6),
                      boxShadow: isFirst
                          ? []
                          : [
                              BoxShadow(
                                color: const Color(
                                  0xFF00E5FF,
                                ).withValues(alpha: 0.3),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                    ),
                  ),
                ),
                // Dot
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF050505),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.7),
                        blurRadius: 15,
                        spreadRadius: 3,
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
                      color: isLast
                          ? Colors.transparent
                          : const Color(0xFF00E5FF).withValues(alpha: 0.6),
                      boxShadow: isLast
                          ? []
                          : [
                              BoxShadow(
                                color: const Color(
                                  0xFF00E5FF,
                                ).withValues(alpha: 0.3),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
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
              child: GlassEffectContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00E5FF),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF00E5FF,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(
                                0xFF00E5FF,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            year,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      company,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
