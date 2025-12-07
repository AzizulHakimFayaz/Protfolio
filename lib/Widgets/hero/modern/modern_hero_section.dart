import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protfolio_website/Particle_effect/hero_particles.dart';
import 'package:protfolio_website/Widgets/glass_hero_card.dart';
import 'package:protfolio_website/Widgets/hero/modern/floating_icon_card.dart';

class ModernHeroSection extends StatefulWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const ModernHeroSection({
    super.key,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  State<ModernHeroSection> createState() => _ModernHeroSectionState();
}

class _ModernHeroSectionState extends State<ModernHeroSection> {
  // Mouse position for parallax
  double _mouseX = 0.0;
  double _mouseY = 0.0;

  void _updateMousePosition(PointerEvent details, Size size) {
    setState(() {
      // Normalize from -1.0 to 1.0 (center is 0,0)
      _mouseX = (details.position.dx / size.width) * 2 - 1;
      _mouseY = (details.position.dy / size.height) * 2 - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    // Define icons layout (Relative positions from center)
    // We adjust spread based on screen size
    // INCREASED SPREAD to fit bigger icons
    // final double spreadX = isMobile ? size.width * 0.4 : size.width * 0.45;

    // Only show a few icons on mobile to prevent clutter
    final List<_FloatingIconConfig> icons = isMobile
        ? [
            _FloatingIconConfig(FontAwesomeIcons.github, -0.35, -0.3, 2.5),
            _FloatingIconConfig(FontAwesomeIcons.python, 0.35, -0.35, 3.0),
            _FloatingIconConfig(
              Icons.flutter_dash,
              -0.3,
              0.35,
              2.8,
            ), // Updated to Material
            _FloatingIconConfig(FontAwesomeIcons.react, 0.3, 0.3, 3.2),
          ]
        : [
            // Left Side - Using more standard icons where possible to avoid load issues
            _FloatingIconConfig(FontAwesomeIcons.github, -0.35, -0.25, 2.5),
            _FloatingIconConfig(FontAwesomeIcons.linkedin, -0.42, 0.1, 4.0),
            _FloatingIconConfig(FontAwesomeIcons.instagram, -0.25, 0.35, 3.0),
            _FloatingIconConfig(Icons.terminal, -0.15, -0.4, 5.0), // Material
            // Right Side
            _FloatingIconConfig(FontAwesomeIcons.python, 0.35, -0.3, 3.2),
            _FloatingIconConfig(
              Icons.flutter_dash,
              0.42,
              0.05,
              2.8,
            ), // Material
            _FloatingIconConfig(Icons.code, 0.28, 0.38, 3.5), // Material
            _FloatingIconConfig(Icons.cloud, 0.18, -0.38, 4.5), // Material
            // More scattered
            _FloatingIconConfig(
              Icons.laptop_chromebook, // Material
              0.05,
              0.45,
              6.0,
            ),
            _FloatingIconConfig(
              Icons.storage, // Material
              -0.05,
              -0.45,
              5.5,
            ),
          ];

    return MouseRegion(
      onHover: (details) => _updateMousePosition(details, size),
      child: SizedBox(
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
                  colors: [
                    Color(0xFF081521), // Deep Space Blue
                    Color(0xFF0C1C27), // Slightly lighter
                  ],
                ),
              ),
            ),

            // 2. Animated Particles (Reused)
            // Move slightly opposite to mouse for depth
            AnimatedBuilder(
              animation: AlwaysStoppedAnimation(0),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_mouseX * -10, _mouseY * -10),
                  child: const HeroParticles(),
                );
              },
            ),

            // 3. Floating Icons Layer (Parallax)
            // INCREASED SIZES: 40->60 (Mobile), 55->80 (Desktop)
            ...icons.map((config) {
              return Positioned(
                left:
                    size.width / 2 +
                    (config.relX * size.width) -
                    (isMobile ? 30 : 40), // Offset by half of new size
                top:
                    size.height / 2 +
                    (config.relY * size.height) -
                    (isMobile ? 30 : 40),
                child: FloatingIconCard(
                  icon: config.icon,
                  size: isMobile ? 60 : 80, // INCREASED SIZE
                  animationDuration: Duration(
                    seconds: config.speed.toInt() + 3,
                  ),
                  floatAmplitude: 20.0, // Increased float
                  initialOffset: Offset.zero,
                  mouseX: _mouseX,
                  mouseY: _mouseY,
                  parallaxFactor: 30.0 * (1 / config.speed),
                ),
              );
            }),

            // 4. Central Glass Card (Hero Content)
            // INCREASED SCALE slightly
            Center(
              child: Transform.translate(
                offset: Offset(_mouseX * -5, _mouseY * -5),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Transform.scale(
                      scale: isMobile ? 1.0 : 1.15, // Make it bigger on desktop
                      child: GlassHeroCard(
                        onViewWork: widget.onViewWork,
                        onContact: widget.onContact,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingIconConfig {
  final IconData icon;
  final double relX; // -0.5 to 0.5 (Relative to screen width)
  final double relY; // -0.5 to 0.5 (Relative to screen height)
  final double speed; // 1.0 = Fast, 5.0 = Slow

  _FloatingIconConfig(this.icon, this.relX, this.relY, this.speed);
}
