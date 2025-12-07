import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomSplitScreenParticles extends StatefulWidget {
  final double splitPosition;
  final double splitAngle;
  final Color leftBackgroundColor;
  final Color rightBackgroundColor;
  final Color leftParticleColor;
  final Color rightParticleColor;
  final int particleCount;
  final double speedMultiplier;
  final double connectionDistance;
  final Offset? mousePosition;

  const CustomSplitScreenParticles({
    super.key,
    this.splitPosition = 0.5,
    this.splitAngle = -0.1,
    this.leftBackgroundColor = Colors.transparent,
    this.rightBackgroundColor = Colors.transparent,
    required this.leftParticleColor,
    required this.rightParticleColor,
    this.particleCount = 80,
    this.speedMultiplier = 0.008,
    this.connectionDistance = 80.0,
    this.mousePosition,
  });

  @override
  State<CustomSplitScreenParticles> createState() =>
      _CustomSplitScreenParticlesState();
}

class _CustomSplitScreenParticlesState extends State<CustomSplitScreenParticles>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initParticles();
    _ticker = createTicker(_tick)..start();
  }

  void _initParticles() {
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          vx: (_random.nextDouble() - 0.5) * 2,
          vy: (_random.nextDouble() - 0.5) * 2,
          size: _random.nextDouble() * 2 + 1,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant CustomSplitScreenParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.particleCount != oldWidget.particleCount) {
      _initParticles();
    }
  }

  void _tick(Duration elapsed) {
    setState(() {
      for (var particle in _particles) {
        // Update position based on speedMultiplier
        particle.x += particle.vx * widget.speedMultiplier;
        particle.y += particle.vy * widget.speedMultiplier;

        // Bounce off edges
        if (particle.x < 0 || particle.x > 1) {
          particle.vx = -particle.vx;
          particle.x = particle.x.clamp(0.0, 1.0);
        }
        if (particle.y < 0 || particle.y > 1) {
          particle.vy = -particle.vy;
          particle.y = particle.y.clamp(0.0, 1.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(
        particles: _particles,
        splitPosition: widget.splitPosition,
        splitAngle: widget.splitAngle,
        leftBgColor: widget.leftBackgroundColor,
        rightBgColor: widget.rightBackgroundColor,
        leftParticleColor: widget.leftParticleColor,
        rightParticleColor: widget.rightParticleColor,
        connectionDistance: widget.connectionDistance,
        mousePosition: widget.mousePosition,
      ),
      size: Size.infinite,
    );
  }
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double splitPosition;
  final double splitAngle;
  final Color leftBgColor;
  final Color rightBgColor;
  final Color leftParticleColor;
  final Color rightParticleColor;
  final double connectionDistance;
  final Offset? mousePosition;

  _ParticlePainter({
    required this.particles,
    required this.splitPosition,
    required this.splitAngle,
    required this.leftBgColor,
    required this.rightBgColor,
    required this.leftParticleColor,
    required this.rightParticleColor,
    required this.connectionDistance,
    this.mousePosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Backgrounds
    final paint = Paint()..style = PaintingStyle.fill;

    // Right Background (Base)
    paint.color = rightBgColor;
    canvas.drawRect(Offset.zero & size, paint);

    // Left Background (Rotated Rect)
    paint.color = leftBgColor;
    canvas.save();
    final splitPoint = Offset(splitPosition * size.width, size.height / 2);
    canvas.translate(splitPoint.dx, splitPoint.dy);
    canvas.rotate(splitAngle);
    final diag = math.sqrt(size.width * size.width + size.height * size.height);
    canvas.drawRect(Rect.fromLTWH(-diag, -diag, diag, diag * 2), paint);
    canvas.restore();

    // 2. Draw Particles and Lines
    final particlePaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()..strokeWidth = 1.0;

    // Pre-calculate screen positions
    final screenPositions = particles
        .map((p) => Offset(p.x * size.width, p.y * size.height))
        .toList();

    for (int i = 0; i < particles.length; i++) {
      final pos = screenPositions[i];
      final particle = particles[i];
      final isLeft = _isLeft(pos, size);
      final color = isLeft ? leftParticleColor : rightParticleColor;

      // Check distance to mouse
      double mouseDist = double.infinity;
      if (mousePosition != null) {
        mouseDist = (pos - mousePosition!).distance;
      }

      // Draw Particle
      particlePaint.color = color;
      // Increase size if close to mouse
      double drawSize = particle.size;
      if (mouseDist < connectionDistance * 1.5) {
        drawSize *= 1.5;
        particlePaint.color = color.withOpacity(1.0); // Brighter
      }
      canvas.drawCircle(pos, drawSize, particlePaint);

      // Draw Connections to other particles
      for (int j = i + 1; j < particles.length; j++) {
        final otherPos = screenPositions[j];
        final dist = (pos - otherPos).distance;

        if (dist < connectionDistance) {
          final opacity = (1 - dist / connectionDistance).clamp(0.0, 1.0);
          linePaint.color = color.withOpacity(0.5 * opacity);
          canvas.drawLine(pos, otherPos, linePaint);
        }
      }

      // Draw Connection to Mouse
      if (mouseDist < connectionDistance * 2.0) {
        final opacity = (1 - mouseDist / (connectionDistance * 2.0)).clamp(
          0.0,
          1.0,
        );
        linePaint.color = color.withOpacity(0.8 * opacity);
        canvas.drawLine(pos, mousePosition!, linePaint);
      }
    }
  }

  bool _isLeft(Offset position, Size size) {
    final splitPoint = Offset(splitPosition * size.width, size.height / 2);
    final relativePos = position - splitPoint;
    final cosA = math.cos(-splitAngle);
    final sinA = math.sin(-splitAngle);
    final rotatedX = relativePos.dx * cosA - relativePos.dy * sinA;
    return rotatedX < 0;
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
