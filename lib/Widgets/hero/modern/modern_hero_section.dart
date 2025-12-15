import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protfolio_website/Particle_effect/hero_particles.dart';
import 'package:protfolio_website/Widgets/glass_hero_card.dart';
import 'package:protfolio_website/Widgets/hero/modern/floating_icon_card.dart';
import 'package:protfolio_website/Widgets/hero/modern/curved_connection_lines.dart';
import 'package:url_launcher/url_launcher.dart';

class ModernHeroSection extends StatefulWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;
  final Function(String)? onIconTap;

  const ModernHeroSection({
    super.key,
    required this.onViewWork,
    required this.onContact,
    this.onIconTap,
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

    // EXACT icon positions matching reference image with Vertically Compressed Y coordinates
    // to prevent clipping at the screen edges.
    final List<_FloatingIconConfig> icons = isMobile
        ? [
            _FloatingIconConfig(
              FontAwesomeIcons.github,
              -0.35,
              -0.3,
              2.5,
              'Flutter', // On mobile, keep as project filter? Or link? Let's link.
              url: 'https://github.com/AzizulHakimFayaz',
            ),
            _FloatingIconConfig(
              FontAwesomeIcons.youtube,
              0.0, // Center top roughly
              -0.4,
              2.8,
              'YouTube',
              url: 'https://www.youtube.com/@AzizulHakim-0',
            ),
            _FloatingIconConfig(
              FontAwesomeIcons.python,
              0.35,
              -0.35,
              3.0,
              'Python',
            ),
            _FloatingIconConfig(Icons.cloud, -0.3, 0.35, 2.8, 'Automation'),
            _FloatingIconConfig(Icons.settings, 0.3, 0.3, 3.2, 'Interactive'),
          ]
        : [
            // Left side icons (Compressed Y)
            _FloatingIconConfig(
              FontAwesomeIcons.github,
              -0.33,
              -0.25,
              2.5,
              'Flutter',
              url: 'https://github.com/AzizulHakimFayaz',
            ), // GitHub -> Profile Link
            _FloatingIconConfig(
              FontAwesomeIcons.linkedin,
              -0.43,
              0.05,
              4.0,
              'UI',
              url: 'https://linkedin.com/in/azizulhakimfayaz',
            ), // LinkedIn -> Profile Link
            _FloatingIconConfig(
              FontAwesomeIcons.youtube,
              -0.38,
              0.25, // Placed between LinkedIn and bottom
              3.5,
              'YouTube',
              url: 'https://www.youtube.com/@AzizulHakim-0',
            ),
            _FloatingIconConfig(
              FontAwesomeIcons.instagram,
              -0.23,
              0.36,
              3.0,
              'Animation',
              // url: 'https://instagram.com/...', // Placeholder if needed, keeping as project filter for now unless user provides URL
            ), // Instagram -> Animation
            // Top arc icons (Lowered from edge)
            _FloatingIconConfig(
              Icons.terminal,
              -0.18,
              -0.39,
              5.0,
              'C',
            ), // Terminal -> C
            _FloatingIconConfig(
              Icons.storage,
              -0.05,
              -0.42,
              5.5,
              'File I/O',
            ), // Database -> Data
            _FloatingIconConfig(
              Icons.cloud,
              0.20,
              -0.41,
              4.5,
              'Automation',
            ), // Cloud -> Automation
            // Right side icons (Compressed Y)
            _FloatingIconConfig(
              FontAwesomeIcons.python,
              0.42,
              -0.15,
              7.2,
              'Python',
            ), // Python
            _FloatingIconConfig(
              Icons.smart_toy,
              0.45,
              0.07,
              3.8,
              'Particles',
            ), // Robot/AI -> Particles/AI
            _FloatingIconConfig(
              Icons.settings,
              0.40,
              0.24,
              3.5,
              'Custom UI',
            ), // Gear
            // Bottom icons (Raised from edge)
            _FloatingIconConfig(
              Icons.laptop_mac,
              0.05,
              0.42,
              6.0,
              'Flutter',
            ), // Laptop -> Flutter
            _FloatingIconConfig(
              Icons.code,
              0.35,
              0.38,
              5.5,
              'Dart',
            ), // Code brackets -> Dart
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
                    Color(0xFF02121C), // Deep Teal-Blue
                    Color(0xFF082838), // Slightly lighter Teal-Blue
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

            // 2.5. Curved Connection Lines (Between particles and icons)
            CurvedConnectionLines(screenSize: size, isMobile: isMobile),

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
                child: GestureDetector(
                  onTap: () async {
                    if (config.url != null) {
                      debugPrint('Launching URL: ${config.url}');
                      final uri = Uri.parse(config.url!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        // Fallback or debug
                        await launchUrl(uri);
                      }
                    } else {
                      debugPrint('Icon Tapped (Filter): ${config.tag}');
                      if (widget.onIconTap != null) {
                        widget.onIconTap!(config.tag);
                      }
                    }
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
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
                  ),
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
  final String tag;
  final String? url; // New: Optional URL for social links

  _FloatingIconConfig(
    this.icon,
    this.relX,
    this.relY,
    this.speed,
    this.tag, {
    this.url,
  });
}
