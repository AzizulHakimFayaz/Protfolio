import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/floating_card.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectedCardsSection extends StatelessWidget {
  const ConnectedCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Connecting Lines (Custom Painter)
          CustomPaint(
            size: const Size(double.infinity, 600),
            painter: ConnectionPainter(),
          ),

          // Central Hub
          const FloatingCard(
            duration: Duration(seconds: 4),
            distance: 10,
            child: CentralHubCard(),
          ),

          // ===== LEFT SIDE - TECH STACK =====

          // Flutter (Top Left)
          const Positioned(
            top: 50,
            left: 100,
            child: FloatingCard(
              duration: Duration(seconds: 5),
              delay: Duration(milliseconds: 500),
              child: FeatureIconCard(
                icon: Icons.flutter_dash,
                color: Color(0xFF02569B),
                label: "Flutter",
              ),
            ),
          ),

          // C++ (Middle Left Top)
          const Positioned(
            top: 180,
            left: 50,
            child: FloatingCard(
              duration: Duration(seconds: 6),
              delay: Duration(milliseconds: 800),
              child: FeatureIconCard(
                icon: Icons.code,
                color: Color(0xFF00599C),
                label: "C++",
              ),
            ),
          ),

          // Python (Middle Left)
          const Positioned(
            left: 40,
            child: FloatingCard(
              duration: Duration(seconds: 7),
              delay: Duration(milliseconds: 200),
              child: FeatureIconCard(
                icon: Icons.terminal,
                color: Color(0xFF3776AB),
                label: "Python",
              ),
            ),
          ),

          // Django (Bottom Left Top)
          const Positioned(
            bottom: 180,
            left: 70,
            child: FloatingCard(
              duration: Duration(seconds: 5),
              delay: Duration(milliseconds: 1000),
              child: FeatureIconCard(
                icon: Icons.web,
                color: Color(0xFF092E20),
                label: "Django",
              ),
            ),
          ),

          // AI (Bottom Left)
          const Positioned(
            bottom: 60,
            left: 120,
            child: FloatingCard(
              duration: Duration(seconds: 6),
              delay: Duration(milliseconds: 1500),
              child: FeatureIconCard(
                icon: Icons.psychology,
                color: Color(0xFFFF6F00),
                label: "AI",
              ),
            ),
          ),

          // ===== RIGHT SIDE - SOCIAL MEDIA =====

          // Facebook (Top Right)
          const Positioned(
            top: 80,
            right: 120,
            child: FloatingCard(
              duration: Duration(seconds: 6),
              delay: Duration(milliseconds: 600),
              child: FeatureIconCard(
                icon: Icons.facebook,
                color: Color(0xFF1877F2),
                label: "Facebook",
                url: "https://www.facebook.com/YOUR_FACEBOOK_USERNAME",
              ),
            ),
          ),

          // LinkedIn (Middle Right Top)
          const Positioned(
            top: 200,
            right: 60,
            child: FloatingCard(
              duration: Duration(seconds: 5),
              delay: Duration(milliseconds: 900),
              child: FeatureIconCard(
                icon: Icons.work,
                color: Color(0xFF0A66C2),
                label: "LinkedIn",
                url: "https://www.linkedin.com/in/YOUR_LINKEDIN_USERNAME",
              ),
            ),
          ),

          // Twitter (Middle Right)
          const Positioned(
            right: 50,
            child: FloatingCard(
              duration: Duration(seconds: 6),
              delay: Duration(milliseconds: 1200),
              child: FeatureIconCard(
                icon: Icons.flutter_dash, // Using as Twitter bird substitute
                color: Color(0xFF1DA1F2),
                label: "Twitter",
                url: "https://twitter.com/YOUR_TWITTER_USERNAME",
              ),
            ),
          ),

          // YouTube (Bottom Right Top)
          const Positioned(
            bottom: 200,
            right: 80,
            child: FloatingCard(
              duration: Duration(seconds: 7),
              delay: Duration(milliseconds: 400),
              child: FeatureIconCard(
                icon: Icons.play_circle_outline,
                color: Color(0xFFFF0000),
                label: "YouTube",
                url: "https://www.youtube.com/@YOUR_YOUTUBE_CHANNEL",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CentralHubCard extends StatelessWidget {
  const CentralHubCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
            blurRadius: 50,
            spreadRadius: 10,
          ),
        ],
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF00E5FF), width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile.jpg', // Update this path to your image
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image not found
                return Container(
                  color: const Color(0xFF2A2A2A),
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Color(0xFF00E5FF),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureIconCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String? url; // Optional URL for clickable cards

  const FeatureIconCard({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.url,
  });

  @override
  State<FeatureIconCard> createState() => _FeatureIconCardState();
}

class _FeatureIconCardState extends State<FeatureIconCard> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    if (widget.url != null) {
      final uri = Uri.parse(widget.url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.url != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GlassEffectContainer(
        width: 80,
        height: 80,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: widget.url != null ? _launchUrl : null,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: _isHovered && widget.url != null
                ? (Matrix4.identity()..scale(1.05))
                : Matrix4.identity(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: _isHovered && widget.url != null
                      ? widget.color.withValues(alpha: 1.0)
                      : widget.color,
                  size: _isHovered && widget.url != null ? 32 : 30,
                ),
                const SizedBox(height: 5),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: _isHovered && widget.url != null
                        ? Colors.white
                        : Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Left side tech stack connection points
    final leftPoints = [
      Offset(140, 90), // Flutter
      Offset(90, 220), // C++
      Offset(80, size.height / 2), // Python
      Offset(110, size.height - 220), // Django
      Offset(160, size.height - 100), // AI
    ];

    // Right side social media connection points
    final rightPoints = [
      Offset(size.width - 160, 120), // Facebook
      Offset(size.width - 100, 240), // LinkedIn
      Offset(size.width - 90, size.height / 2), // Twitter
      Offset(size.width - 120, size.height - 240), // YouTube
    ];

    // Draw connections from center to left points
    for (final point in leftPoints) {
      canvas.drawLine(center, point, paint);
      canvas.drawCircle(
        Offset.lerp(center, point, 0.5)!,
        2,
        Paint()..color = const Color(0xFF00E5FF).withValues(alpha: 0.3),
      );
    }

    // Draw connections from center to right points
    for (final point in rightPoints) {
      canvas.drawLine(center, point, paint);
      canvas.drawCircle(
        Offset.lerp(center, point, 0.5)!,
        2,
        Paint()..color = const Color(0xFF00E5FF).withValues(alpha: 0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
