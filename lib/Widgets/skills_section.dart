import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/section_title.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  final List<Map<String, dynamic>> _skills = const [
    {"name": "Flutter", "icon": Icons.phone_android},
    {"name": "Dart", "icon": Icons.code},
    {"name": "Python", "icon": Icons.terminal},
    {"name": "Django", "icon": Icons.web},
    {"name": "Firebase", "icon": Icons.cloud},
    {"name": "REST API", "icon": Icons.api},
    {"name": "C & C++", "icon": Icons.memory},
    {"name": "Git & GitHub", "icon": Icons.hub},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const SectionTitle(title: "Technical Skills"),
              const SizedBox(height: 60),
              Wrap(
                spacing: 30,
                runSpacing: 30,
                alignment: WrapAlignment.center,
                children: _skills
                    .map(
                      (skill) =>
                          _SkillCard(name: skill["name"], icon: skill["icon"]),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final String name;
  final IconData icon;

  const _SkillCard({required this.name, required this.icon});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        height: 160,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -10.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.accentTeal.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: _isHovered ? AppColors.accentTeal : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 48,
              color: _isHovered ? AppColors.accentTeal : AppColors.navyLight,
            ),
            const SizedBox(height: 20),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isHovered ? AppColors.accentTeal : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
