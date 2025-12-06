import 'package:flutter/material.dart';

class ModernProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<IconData> technologies;
  final String imagePath;
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
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() {
            _isHovered = false;
            _mousePos = Offset.zero;
          }),
          onHover: (event) {
            setState(() {
              _mousePos = event.localPosition;
            });
          },
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 200),
            tween: Tween<double>(begin: 0, end: _isHovered ? 1 : 0),
            builder: (context, hoverValue, child) {
              // Calculate tilt
              double tiltX = 0;
              double tiltY = 0;

              if (_isHovered) {
                // Use constraints to estimate size (safe during build)
                // If constraints are infinite, default to a reasonable size or 0
                final width = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : 300.0;
                final height = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : 200.0;
                final center = Offset(width / 2, height / 2);
                final relativePos = _mousePos - center;

                // Max tilt angle in radians (e.g., 0.1 rad ~= 5.7 degrees)
                const maxTilt = 0.05;
                tiltY = (relativePos.dx / (width / 2)) * -maxTilt;
                tiltX = (relativePos.dy / (height / 2)) * maxTilt;
              }

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateX(tiltX)
                  ..rotateY(tiltY)
                  ..scale(1.0 + (0.05 * hoverValue)), // Scale up slightly
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(
                          alpha: 0.05 + (0.05 * hoverValue),
                        ),
                        Colors.white.withValues(
                          alpha: 0.01 + (0.02 * hoverValue),
                        ),
                      ],
                    ),
                    border: Border.all(
                      color: widget.accentColor.withValues(
                        alpha: 0.1 + (0.3 * hoverValue),
                      ),
                      width: 1 + (1 * hoverValue),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withValues(
                          alpha: 0.1 * hoverValue,
                        ),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Side: Visual/Icon Area
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.accentColor.withValues(
                                  alpha: 0.1,
                                ),
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
                                    color: widget.accentColor.withValues(
                                      alpha: 0.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: widget.accentColor.withValues(
                                          alpha: 0.4 + (0.2 * hoverValue),
                                        ),
                                        blurRadius: 30 + (20 * hoverValue),
                                        spreadRadius: 5 + (2 * hoverValue),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    widget.technologies.isNotEmpty
                                        ? widget.technologies.first
                                        : Icons.code,
                                    size: 40 + (5 * hoverValue),
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
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      ...widget.technologies.map(
                                        (icon) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 15,
                                          ),
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
                                            color: widget.accentColor
                                                .withValues(alpha: 0.5),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color: widget.accentColor.withValues(
                                            alpha: 0.1 * hoverValue,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "View Project",
                                              style: TextStyle(
                                                color: widget.accentColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                            if (_isHovered) ...[
                                              const SizedBox(width: 5),
                                              Icon(
                                                Icons.arrow_forward,
                                                size: 14,
                                                color: widget.accentColor,
                                              ),
                                            ],
                                          ],
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
            },
          ),
        );
      },
    );
  }
}
