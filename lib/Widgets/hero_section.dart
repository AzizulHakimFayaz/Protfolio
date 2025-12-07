import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/hero/modern/modern_hero_section.dart';

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
    // Replaced the old Stack implementation with the new ModernHeroSection
    // which handles its own background, particles, and floating elements.
    return ModernHeroSection(onViewWork: onViewWork, onContact: onContact);
  }
}
