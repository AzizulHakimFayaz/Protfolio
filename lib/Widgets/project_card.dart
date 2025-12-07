import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';
import 'package:protfolio_website/Widgets/orbiting_tech_icons.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<IconData> technologies;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.technologies,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GlassEffectContainer(
          width: 350,
          height: 400, // Increased height for the animation
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Orbiting Animation
              OrbitingTechIcons(
                technologies: widget.technologies,
                centerText: widget.title,
                radius: 70,
              ),

              const SizedBox(height: 30),

              // Description
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: AppColors.textPrimaryDark.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
