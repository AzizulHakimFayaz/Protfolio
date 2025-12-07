import 'package:flutter/material.dart';
import 'package:protfolio_website/Particle_effect/hero_particles.dart';
import 'package:protfolio_website/Widgets/glass_hero_card.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const HeroSection({
    super.key,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure the hero section takes up the full screen height
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.navyDark, AppColors.navyLight],
              ),
            ),
          ),

          // 2. Particle Effect
          const Positioned.fill(child: HeroParticles()),

          // 3. Central Glass Card
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GlassHeroCard(
                  onViewWork: onViewWork,
                  onContact: onContact,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
