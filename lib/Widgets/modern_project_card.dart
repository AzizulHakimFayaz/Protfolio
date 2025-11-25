import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';

class ModernProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<IconData> technologies;
  final String
  imagePath; // Placeholder for now, can be an asset or network image
  final Color accentColor;

  const ModernProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.technologies,
    this.imagePath = "",
    this.accentColor = const Color(0xFF00E5FF),
  });

  @override
  State<ModernProjectCard> createState() => _ModernProjectCardState();
}

class _ModernProjectCardState extends State<ModernProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _isHovered ? 1.02 : 1.0,
          _isHovered ? 1.02 : 1.0,
          1.0,
        ),
        child: GlassEffectContainer(
          width: double.infinity,
          padding: const EdgeInsets.all(0), // Padding handled internally
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Side: Visual/Icon Area
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.1),
                      border: Border(
                        right: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.accentColor.withValues(alpha: 0.2),
                          boxShadow: [
                            BoxShadow(
                              color: widget.accentColor.withValues(alpha: 0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.technologies.isNotEmpty
                              ? widget.technologies.first
                              : Icons.code,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Right Side: Content Area
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ...widget.technologies.map(
                              (icon) => Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Icon(
                                  icon,
                                  size: 20,
                                  color: widget.accentColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: widget.accentColor.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: _isHovered
                                    ? widget.accentColor.withValues(alpha: 0.1)
                                    : Colors.transparent,
                              ),
                              child: Text(
                                "View Project",
                                style: TextStyle(
                                  color: widget.accentColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
