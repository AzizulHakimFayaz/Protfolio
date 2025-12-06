import 'package:protfolio_website/Particle_effect/custom_split_screen_particles.dart';
import 'package:flutter/material.dart';

class ColorInvertingParticles extends StatefulWidget {
  final Offset? mousePosition;

  const ColorInvertingParticles({super.key, this.mousePosition});

  @override
  State<ColorInvertingParticles> createState() =>
      _ColorInvertingParticlesState();
}

class _ColorInvertingParticlesState extends State<ColorInvertingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _speedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Slow down over 4 seconds
    );

    _speedAnimation = Tween<double>(
      begin: 0.008,
      end: 0.001,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start slowing down after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _speedAnimation,
      builder: (context, child) {
        return CustomSplitScreenParticles(
          splitPosition: 0.5,
          splitAngle: -0.1,
          // Unified dark background
          leftBackgroundColor: Colors.transparent,
          rightBackgroundColor: Colors.transparent,
          // Cyan and Purple particles
          leftParticleColor: const Color(0xFF00E5FF),
          rightParticleColor: const Color(0xFFE040FB),
          particleCount: 80,
          speedMultiplier: _speedAnimation.value,
          mousePosition: widget.mousePosition,
        );
      },
    );
  }
}
