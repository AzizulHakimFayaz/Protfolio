import 'dart:math';
import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class HeroParticles extends StatefulWidget {
  const HeroParticles({super.key});

  @override
  State<HeroParticles> createState() => _HeroParticlesState();
}

class _HeroParticlesState extends State<HeroParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_particles.isEmpty) {
      final size = MediaQuery.of(context).size;
      _initParticles(size);
    }
  }

  void _initParticles(Size size) {
    // Medium-light density: roughly 1 particle per 2500 sq pixels
    final particleCount = (size.width * size.height / 2500).toInt().clamp(
      20,
      100,
    );
    _particles.clear();
    for (int i = 0; i < particleCount; i++) {
      _particles.add(_createParticle(size));
    }
  }

  _Particle _createParticle(Size size) {
    return _Particle(
      position: Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      ),
      velocity: Offset(
        (_random.nextDouble() - 0.5) * 0.3, // Slow movement X
        (_random.nextDouble() - 0.5) * 0.3, // Slow movement Y
      ),
      radius: _random.nextDouble() * 3 + 1, // Size 1-4px
      color: _random.nextBool()
          ? AppColors.particleTeal.withValues(
              alpha: 0.4 + _random.nextDouble() * 0.4,
            )
          : AppColors.particleWhite.withValues(
              alpha: 0.3 + _random.nextDouble() * 0.3,
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            animation: _controller,
          ),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
      },
    );
  }
}

class _Particle {
  Offset position;
  final Offset velocity;
  final double radius;
  final Color color;

  _Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
  });

  void update(Size size) {
    position += velocity;

    // Wrap around screen
    if (position.dx < -radius)
      position = Offset(size.width + radius, position.dy);
    if (position.dx > size.width + radius)
      position = Offset(-radius, position.dy);
    if (position.dy < -radius)
      position = Offset(position.dx, size.height + radius);
    if (position.dy > size.height + radius)
      position = Offset(position.dx, -radius);
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Animation<double> animation;

  _ParticlePainter({required this.particles, required this.animation})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update(size);
      final paint = Paint()..color = particle.color;
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
