import 'package:advanced_particle_effects/advanced_particle_effects.dart';
import 'package:flutter/material.dart';

class ColorInvertingParticles extends StatelessWidget {
  const ColorInvertingParticles({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplitScreenParticleSystem(
      splitPosition: 0.5,
      splitAngle: -0.1,
      // Unified dark background
      leftBackgroundColor: Colors.transparent,
      rightBackgroundColor: Colors.transparent,
      // Cyan and Purple particles
      leftParticleColor: Color(0xFF00E5FF),
      rightParticleColor: Color(0xFFE040FB),
      particleCount: 80,
      speedMultiplier: 0.008,
    );
  }
}
