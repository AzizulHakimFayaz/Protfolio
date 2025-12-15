import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:protfolio_website/Widgets/section_title.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

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

              _SkillCategory(
                title: "Languages",
                skills: const [
                  {"name": "Dart", "icon": Icons.code},
                  {"name": "Python", "icon": Icons.terminal},
                  {"name": "C & C++", "icon": Icons.memory},
                ],
                delay: 0,
              ),
              const SizedBox(height: 50),

              _SkillCategory(
                title: "Frameworks & Technologies",
                skills: const [
                  {"name": "Flutter", "icon": Icons.phone_android},
                  {"name": "Django", "icon": Icons.web},
                  {"name": "Firebase", "icon": Icons.cloud},
                ],
                delay: 200,
              ),
              const SizedBox(height: 50),

              _SkillCategory(
                title: "Tools & Platforms",
                skills: const [
                  {"name": "Git & GitHub", "icon": Icons.hub},
                  {"name": "REST API", "icon": Icons.api},
                ],
                delay: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillCategory extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> skills;
  final int delay;

  const _SkillCategory({
    required this.title,
    required this.skills,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
                letterSpacing: 1.2,
              ),
            )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: delay),
            )
            .slideY(begin: 0.2, end: 0, duration: 600.ms),
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: skills
              .map((s) => _ModernSkillCard(name: s["name"], icon: s["icon"]))
              .toList(),
        ),
      ],
    );
  }
}

class _ModernSkillCard extends StatefulWidget {
  final String name;
  final IconData icon;

  const _ModernSkillCard({required this.name, required this.icon});

  @override
  State<_ModernSkillCard> createState() => _ModernSkillCardState();
}

class _ModernSkillCardState extends State<_ModernSkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 150,
            height: 140,
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -8.0 : 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered ? AppColors.accentTeal : Colors.grey.shade200,
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? AppColors.accentTeal.withOpacity(0.15)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: _isHovered ? 20 : 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? AppColors.accentTeal.withOpacity(0.1)
                        : Colors.grey.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    size: 36,
                    color: _isHovered
                        ? AppColors.accentTeal
                        : AppColors.navyLight,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _isHovered
                        ? AppColors.accentTeal
                        : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(
          duration: 400.ms,
          curve: Curves.easeOutBack,
          begin: const Offset(0.8, 0.8),
        );
  }
}
