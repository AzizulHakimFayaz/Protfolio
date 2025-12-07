import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/section_title.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  final List<Map<String, String>> _timeline = const [
    {
      "year": "2024 - Present",
      "title": "Expanding Horizon",
      "description":
          "Deep diving into Full-stack engineering with Django, Firebase, and Advanced Flutter architectures.",
    },
    {
      "year": "2024",
      "title": "Flutter Development",
      "description":
          "Entered the world of cross-platform mobile app development. Built multiple responsive applications.",
    },
    {
      "year": "2023",
      "title": "Python & Automation",
      "description":
          "Explored backend logic, scripting, and automation tools using Python.",
    },
    {
      "year": "2022",
      "title": "Programming Foundation",
      "description":
          "Started the journey with C & C++, mastering algorithms and memory management.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              const SectionTitle(title: "My Journey"),
              const SizedBox(height: 60),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _timeline.length,
                itemBuilder: (context, index) {
                  return _TimelineItem(
                    data: _timeline[index],
                    isLast: index == _timeline.length - 1,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Map<String, String> data;
  final bool isLast;

  const _TimelineItem({required this.data, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Marker Column
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.accentTeal,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height:
                    100, // Fixed height for consistency or use IntrinsicHeight on Row
                color: Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 30),

        // Content Column
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["year"]!,
                  style: const TextStyle(
                    color: AppColors.accentTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data["title"]!,
                  style: const TextStyle(
                    color: AppColors.navyDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data["description"]!,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
