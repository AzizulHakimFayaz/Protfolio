import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class AnimatedBlobProfile extends StatefulWidget {
  final String imagePath;
  final double size;

  const AnimatedBlobProfile({
    super.key,
    required this.imagePath,
    this.size = 350,
  });

  @override
  State<AnimatedBlobProfile> createState() => _AnimatedBlobProfileState();
}

class _AnimatedBlobProfileState extends State<AnimatedBlobProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 0. Background Sci-Fi Shapes (Rotating)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundShapesPainter(
                  progress: _controller.value,
                  color: AppColors.accentTeal,
                ),
                size: Size(widget.size * 1.4, widget.size * 1.4),
              );
            },
          ),

          // 1. The Morphing Blob & Particles
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: BlobPainter(
                  progress: _controller.value,
                  color1: AppColors.accentTeal,
                  color2: Colors.cyanAccent,
                ),
                size: Size(widget.size, widget.size),
              );
            },
          ),

          // 2. The Profile Image (Circular)
          Container(
            width: widget.size * 0.75,
            height: widget.size * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentTeal.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(widget.imagePath, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundShapesPainter extends CustomPainter {
  final double progress;
  final Color color;

  BackgroundShapesPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 1. Rotating Dash Circle
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * math.pi * 0.2); // Slow rotation
    _drawDashedCircle(canvas, maxRadius * 0.85, paint);
    canvas.restore();

    // 2. Counter-Rotating Hexagon
    final hexPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-progress * 2 * math.pi * 0.15); // Reverse slow rotation
    _drawPolygon(canvas, 6, maxRadius * 0.95, hexPaint);
    canvas.restore();

    // 3. Floating Orbit Particles (Outer Layer)
    final particlePaint = Paint()..color = color.withOpacity(0.4);
    for (int i = 0; i < 4; i++) {
      double angle = (progress * 2 * math.pi) + (i * math.pi / 2);
      // Add some sine wave oscillation to the radius for depth
      double r = maxRadius * (0.6 + 0.1 * math.sin(angle * 2));

      double x = center.dx + r * math.cos(angle);
      double y = center.dy + r * math.sin(angle);

      canvas.drawCircle(Offset(x, y), 3, particlePaint);
    }
  }

  void _drawDashedCircle(Canvas canvas, double radius, Paint paint) {
    const int dashCount = 24;
    const double angleStep = 2 * math.pi / dashCount;
    for (int i = 0; i < dashCount; i += 2) {
      // Skip every other for effect
      double start = i * angleStep;
      double end = start + angleStep * 0.6;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        start,
        end - start,
        false,
        paint,
      );
    }
  }

  void _drawPolygon(Canvas canvas, int sides, double radius, Paint paint) {
    final path = Path();
    final angleStep = 2 * math.pi / sides;
    for (int i = 0; i < sides; i++) {
      double angle = i * angleStep;
      double x = radius * math.cos(angle);
      double y = radius * math.sin(angle);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BackgroundShapesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class BlobPainter extends CustomPainter {
  final double progress;
  final Color color1;
  final Color color2;

  BlobPainter({
    required this.progress,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.9; // Leave some room for waves

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color1.withOpacity(0.0), color1.withOpacity(0.6), color2],
        stops: const [0.7, 0.9, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3; // Glowy thick border

    final glowPaint = Paint()
      ..color = color2.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Draw Morphing Blob
    final path = Path();
    const double points = 100;

    // We create a closed loop
    for (int i = 0; i <= points; i++) {
      final double angle = (i / points) * 2 * math.pi;

      // Blob Math: R = r + sin(a * k + t) * distortion
      // We sum multiple sines for organic complexity
      final double distortion =
          math.sin(angle * 3 + progress * 2 * math.pi) * 10 +
          math.cos(angle * 5 - progress * 4 * math.pi) * 8;

      final double r = radius + distortion;

      final double x = center.dx + r * math.cos(angle);
      final double y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Paint Glow
    canvas.drawPath(path, glowPaint);
    // Paint Main Border
    canvas.drawPath(path, paint);

    // Draw Particles
    _drawParticles(canvas, center, radius, progress);
  }

  void _drawParticles(
    Canvas canvas,
    Offset center,
    double radius,
    double progress,
  ) {
    // Deterministic random particles based on loop
    // We want particles moving outward.
    final particlePaint = Paint()..color = color2.withOpacity(0.5);

    for (int i = 0; i < 12; i++) {
      // Offset starting angle so they are spread out
      final double startAngle = (i / 12) * 2 * math.pi;

      // Make them move outward with time
      // Global time for this particle:
      final double t = (progress * 2 + i * 0.1) % 1.0;

      final double currentDist = radius + (t * 60); // Move 60px outward
      final double opacity = 1.0 - t; // Fade out as they move

      particlePaint.color = color2.withOpacity(opacity * 0.6);

      // Add some swirl
      final double currentAngle = startAngle + (t * 0.5);

      final double px = center.dx + currentDist * math.cos(currentAngle);
      final double py = center.dy + currentDist * math.sin(currentAngle);

      canvas.drawCircle(Offset(px, py), 2, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant BlobPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class SurfaceLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  SurfaceLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Description: "Thin, translucent curved lines with a soft aqua-to-teal gradient...
    // flow gracefully... curves vary slightly... particles softly glow"

    // 1. Definition of the gradient
    final Shader lineShader = LinearGradient(
      colors: [
        Colors.transparent,
        Colors.cyanAccent.withOpacity(0.5),
        AppColors.accentTeal.withOpacity(0.6),
        Colors.transparent,
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()
      ..shader = lineShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final particlePaint = Paint()..style = PaintingStyle.fill;

    // We will draw 3 varying curves to create depth
    final double midHeight = size.height / 2;
    final double width = size.width;

    // Global animation shift
    final double globalShift = progress * 2 * math.pi;

    for (int i = 0; i < 3; i++) {
      // Vary parameters for each line
      // Line 0: Base
      // Line 1: Slightly offset
      // Line 2: Slower, wider amplitude

      final double phaseOffset = i * (math.pi / 6);
      final double amplitudeMult = 1.0 + (i * 0.5);
      final double freqMult = 0.6 + (i * 0.05); // Lower frequency (was 0.8)

      final Path path = Path();
      path.moveTo(0, midHeight + (i * 25)); // Wider vertical spread (was 10)

      // Draw the wave
      for (double x = 0; x <= width; x += 5) {
        final double nk = x / width;

        // Envelope
        final double envelope = math.sin(nk * math.pi);

        // Complex wave function
        final double wave = math.sin(
          (nk * 2.0 * math.pi * freqMult) - globalShift + phaseOffset,
        );

        // Second harmonic
        final double wave2 =
            math.cos((nk * 3 * math.pi) + (globalShift * 0.5)) * 0.3;

        final double y =
            midHeight +
            (i * 25) + // Add offset to Y as well to keep them parallel-ish
            (wave + wave2) * 30 * amplitudeMult * envelope;

        path.lineTo(x, y);

        // --- Particles ---
        // Occasionally draw a particle along the curve
        if (x % 15 == 0) {
          double randomVal = math.sin(x * 0.2 + globalShift * 2 + i);
          // Only draw when near peak of random
          if (randomVal > 0.90) {
            double pSize = 1.5 + (randomVal - 0.90) * 8; // size 1.5 to ~2.5

            // Soft glow color
            particlePaint.color = Colors.cyanAccent.withOpacity(0.5 * envelope);
            particlePaint.maskFilter = const MaskFilter.blur(
              BlurStyle.normal,
              2,
            );

            canvas.drawCircle(Offset(x, y), pSize, particlePaint);

            // Core
            particlePaint.maskFilter = null;
            particlePaint.color = Colors.white.withOpacity(0.7 * envelope);
            canvas.drawCircle(Offset(x, y), pSize * 0.5, particlePaint);
          }
        }
      }

      // canvas.drawPath(path, paint); // Line removed as requested
    }
  }

  @override
  bool shouldRepaint(covariant SurfaceLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
