import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PortfolioParticlePage(),
  ));
}

class PortfolioParticlePage extends StatelessWidget {
  const PortfolioParticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DiagonalSplitBackground(),
          const ColorInvertingParticles(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hi, I am",
                  style: TextStyle(fontSize: 26, color: Colors.black54),
                ),
                const Text(
                  "Azizul Hakim",
                  style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "Web Developer / Flutter Enthusiast",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------
// Background
// ---------------------------
class DiagonalSplitBackground extends StatelessWidget {
  const DiagonalSplitBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _DiagonalBackgroundPainter(),
    );
  }
}

class _DiagonalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint whitePaint = Paint()..color = const Color(0xFFF2F2F2);
    final Paint blackPaint = Paint()..color = Colors.black;

    final Path leftPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.55, 0)
      ..lineTo(size.width * 0.45, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Path rightPath = Path()
      ..moveTo(size.width * 0.55, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.45, size.height)
      ..close();

    canvas.drawPath(leftPath, whitePaint);
    canvas.drawPath(rightPath, blackPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ---------------------------
// Particle System
// ---------------------------
class ColorInvertingParticles extends StatefulWidget {
  const ColorInvertingParticles({super.key});

  @override
  State<ColorInvertingParticles> createState() =>
      _ColorInvertingParticlesState();
}

class _ColorInvertingParticlesState extends State<ColorInvertingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  // 🔧 Control particle count and speed here
  final int particleCount = 100; // increase for more
  final double speedMultiplier = 0.008; // Reduced from 0.002 for slower movement

  late List<Offset> _positions;
  late List<Offset> _velocities;

  @override
  void initState() {
    super.initState();
    _positions = List.generate(
      particleCount,
      (_) => Offset(_random.nextDouble(), _random.nextDouble()),
    );
    _velocities = List.generate(
      particleCount,
      (_) => Offset(
        (_random.nextDouble() - 0.5) * speedMultiplier,
        (_random.nextDouble() - 0.5) * speedMultiplier,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1000),
    )..addListener(_updateParticles)
      ..repeat();
  }

  void _updateParticles() {
    setState(() {
      for (int i = 0; i < particleCount; i++) {
        var pos = _positions[i] + _velocities[i];
        if (pos.dx < 0 || pos.dx > 1) {
          _velocities[i] = Offset(-_velocities[i].dx, _velocities[i].dy);
        }
        if (pos.dy < 0 || pos.dy > 1) {
          _velocities[i] = Offset(_velocities[i].dx, -_velocities[i].dy);
        }
        _positions[i] = Offset(
          pos.dx.clamp(0.0, 1.0),
          pos.dy.clamp(0.0, 1.0),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _ParticlePainter(_positions),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Offset> positions;

  _ParticlePainter(this.positions);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final Paint linePaint = Paint()
      ..strokeWidth = 1.2 // Increased from 0.5 for better visibility
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < positions.length; i++) {
      final Offset offset1 =
          Offset(positions[i].dx * size.width, positions[i].dy * size.height);

      // Determine particle color based on background
      double divisionLineY = size.height * (offset1.dx / size.width - 0.55) / 0.1;
      bool isOnLeft = offset1.dy > divisionLineY;
      paint.color = isOnLeft ? Colors.black : Colors.white;

      // Draw particle
      canvas.drawCircle(offset1, 2.0, paint);

      // Connect with nearby particles
      for (int j = i + 1; j < positions.length; j++) {
        final Offset offset2 =
            Offset(positions[j].dx * size.width, positions[j].dy * size.height);
        double distance = (offset1 - offset2).distance;

        if (distance < 80) {
          // line color fades with distance
          double opacity = (1 - (distance / 80)) * 0.5;
          linePaint.color =
              isOnLeft ? Colors.black.withOpacity(opacity) : Colors.white.withOpacity(opacity);
          canvas.drawLine(offset1, offset2, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}