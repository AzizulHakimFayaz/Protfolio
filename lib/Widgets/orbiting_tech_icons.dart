import 'dart:math';
import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class OrbitingTechIcons extends StatefulWidget {
  final List<IconData> technologies;
  final String centerText;
  final double radius;

  const OrbitingTechIcons({
    super.key,
    required this.technologies,
    required this.centerText,
    this.radius = 60.0,
  });

  @override
  State<OrbitingTechIcons> createState() => _OrbitingTechIconsState();
}

class _OrbitingTechIconsState extends State<OrbitingTechIcons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2 + 60, // Add padding for icons
      height: widget.radius * 2 + 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glowing Lines Painter
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.radius * 2, widget.radius * 2),
                painter: _OrbitLinesPainter(
                  itemCount: widget.technologies.length,
                  progress: _controller.value,
                  radius: widget.radius,
                ),
              );
            },
          ),

          // Center Text (Project Name)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.scaffoldBackground.withValues(alpha: 0.8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonCyan.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
              border: Border.all(
                color: AppColors.neonCyan.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.centerText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          // Orbiting Icons
          ...List.generate(widget.technologies.length, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double angle =
                    (2 * pi * index / widget.technologies.length) +
                    (2 * pi * _controller.value);
                final double x = cos(angle) * widget.radius;
                final double y = sin(angle) * widget.radius;

                return Transform.translate(
                  offset: Offset(x, y),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.neonPurple.withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonPurple.withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.technologies[index],
                      color: AppColors.textPrimaryDark,
                      size: 18,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _OrbitLinesPainter extends CustomPainter {
  final int itemCount;
  final double progress;
  final double radius;

  _OrbitLinesPainter({
    required this.itemCount,
    required this.progress,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < itemCount; i++) {
      final double angle = (2 * pi * i / itemCount) + (2 * pi * progress);
      final double x = center.dx + cos(angle) * radius;
      final double y = center.dy + sin(angle) * radius;

      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitLinesPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.itemCount != itemCount;
  }
}
