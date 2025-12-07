import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';
import 'package:protfolio_website/Widgets/floating_card.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectedCardsSection extends StatefulWidget {
  const ConnectedCardsSection({super.key});

  @override
  State<ConnectedCardsSection> createState() => _ConnectedCardsSectionState();
}

class _ConnectedCardsSectionState extends State<ConnectedCardsSection> {
  int? _hoveredIndex;

  void _onHover(int index, bool isHovered) {
    setState(() {
      if (isHovered) {
        _hoveredIndex = index;
      } else if (_hoveredIndex == index) {
        _hoveredIndex = null;
      }
    });
  }

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
            painter: ConnectionPainter(hoveredIndex: _hoveredIndex),
          ),

          // Central Hub
          const FloatingCard(
            duration: Duration(seconds: 4),
            distance: 10,
            child: CentralHubCard(),
          ),

          // ===== LEFT SIDE - TECH STACK =====

          // Flutter (Top Left) - Index 0
          Positioned(
            top: 60,
            left: 120,
            child: FloatingCard(
              duration: const Duration(seconds: 5),
              delay: const Duration(milliseconds: 500),
              child: FeatureIconCard(
                icon: Icons.flutter_dash,
                color: const Color(0xFF02569B),
                label: "Flutter",
                onHover: (isHovered) => _onHover(0, isHovered),
              ),
            ),
          ),

          // C++ (Middle Left Top) - Index 1
          Positioned(
            top: 170,
            left: 60,
            child: FloatingCard(
              duration: const Duration(seconds: 6),
              delay: const Duration(milliseconds: 800),
              child: FeatureIconCard(
                icon: Icons.code,
                color: const Color(0xFF00599C),
                label: "C++",
                onHover: (isHovered) => _onHover(1, isHovered),
              ),
            ),
          ),

          // Python (Middle Left) - Index 2
          Positioned(
            left: 40,
            child: FloatingCard(
              duration: const Duration(seconds: 7),
              delay: const Duration(milliseconds: 200),
              child: FeatureIconCard(
                icon: Icons.terminal,
                color: const Color(0xFF3776AB),
                label: "Python",
                onHover: (isHovered) => _onHover(2, isHovered),
              ),
            ),
          ),

          // Django (Bottom Left Top) - Index 3
          Positioned(
            bottom: 170,
            left: 80,
            child: FloatingCard(
              duration: const Duration(seconds: 5),
              delay: const Duration(milliseconds: 1000),
              child: FeatureIconCard(
                icon: Icons.web,
                color: const Color(0xFF092E20),
                label: "Django",
                onHover: (isHovered) => _onHover(3, isHovered),
              ),
            ),
          ),

          // AI (Bottom Left) - Index 4
          Positioned(
            bottom: 60,
            left: 130,
            child: FloatingCard(
              duration: const Duration(seconds: 6),
              delay: const Duration(milliseconds: 1500),
              child: FeatureIconCard(
                icon: Icons.psychology,
                color: const Color(0xFFFF6F00),
                label: "AI",
                onHover: (isHovered) => _onHover(4, isHovered),
              ),
            ),
          ),

          // ===== RIGHT SIDE - SOCIAL MEDIA =====

          // Facebook (Top Right) - Index 5
          Positioned(
            top: 60,
            right: 130,
            child: FloatingCard(
              duration: const Duration(seconds: 6),
              delay: const Duration(milliseconds: 600),
              child: FeatureIconCard(
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                label: "Facebook",
                url: "https://www.facebook.com/YOUR_FACEBOOK_USERNAME",
                onHover: (isHovered) => _onHover(5, isHovered),
              ),
            ),
          ),

          // LinkedIn (Middle Right Top) - Index 6
          Positioned(
            top: 170,
            right: 70,
            child: FloatingCard(
              duration: const Duration(seconds: 5),
              delay: const Duration(milliseconds: 900),
              child: FeatureIconCard(
                icon: Icons.work,
                color: const Color(0xFF0A66C2),
                label: "LinkedIn",
                url: "https://www.linkedin.com/in/YOUR_LINKEDIN_USERNAME",
                onHover: (isHovered) => _onHover(6, isHovered),
              ),
            ),
          ),

          // Twitter (Middle Right) - Index 7
          Positioned(
            right: 50,
            child: FloatingCard(
              duration: const Duration(seconds: 6),
              delay: const Duration(milliseconds: 1200),
              child: FeatureIconCard(
                icon: Icons.flutter_dash, // Using as Twitter bird substitute
                color: const Color(0xFF1DA1F2),
                label: "Twitter",
                url: "https://twitter.com/YOUR_TWITTER_USERNAME",
                onHover: (isHovered) => _onHover(7, isHovered),
              ),
            ),
          ),

          // YouTube (Bottom Right Top) - Index 8
          Positioned(
            bottom: 170,
            right: 90,
            child: FloatingCard(
              duration: const Duration(seconds: 7),
              delay: const Duration(milliseconds: 400),
              child: FeatureIconCard(
                icon: Icons.play_circle_outline,
                color: const Color(0xFFFF0000),
                label: "YouTube",
                url: "https://www.youtube.com/@YOUR_YOUTUBE_CHANNEL",
                onHover: (isHovered) => _onHover(8, isHovered),
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
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withOpacity(0.3),
            blurRadius: 50,
            spreadRadius: 10,
          ),
        ],
        border: Border.all(
          color: AppColors.neonCyan.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.neonCyan, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonCyan.withOpacity(0.5),
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
                  color: AppColors.cardDark,
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: AppColors.neonCyan,
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
  final Function(bool)? onHover;

  const FeatureIconCard({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.url,
    this.onHover,
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
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onHover?.call(true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.onHover?.call(false);
      },
      cursor: widget.url != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GlassEffectContainer(
        width: 100,
        height: 100,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: widget.url != null ? _launchUrl : null,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: _isHovered
                ? (Matrix4.identity()..scale(1.15)) // Increased scale on hover
                : Matrix4.identity(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: _isHovered
                      ? widget.color.withOpacity(1.0)
                      : widget.color,
                  size: _isHovered ? 36 : 30,
                ),
                const SizedBox(height: 5),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: _isHovered
                        ? AppColors.textPrimaryDark
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
  final int? hoveredIndex;

  ConnectionPainter({this.hoveredIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.neonCyan.withOpacity(0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..color = AppColors.neonCyan.withOpacity(0.8)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);

    // Left side tech stack connection points
    final leftPoints = [
      Offset(160, 100), // Flutter (Index 0)
      Offset(100, 210), // C++ (Index 1)
      Offset(80, size.height / 2), // Python (Index 2)
      Offset(120, size.height - 210), // Django (Index 3)
      Offset(170, size.height - 100), // AI (Index 4)
    ];

    // Right side social media connection points
    final rightPoints = [
      Offset(size.width - 170, 100), // Facebook (Index 5)
      Offset(size.width - 110, 210), // LinkedIn (Index 6)
      Offset(size.width - 90, size.height / 2), // Twitter (Index 7)
      Offset(size.width - 130, size.height - 210), // YouTube (Index 8)
    ];

    final allPoints = [...leftPoints, ...rightPoints];

    for (int i = 0; i < allPoints.length; i++) {
      final point = allPoints[i];
      final isHovered = hoveredIndex == i;

      canvas.drawLine(center, point, isHovered ? activePaint : paint);

      canvas.drawCircle(
        Offset.lerp(center, point, 0.5)!,
        isHovered ? 4 : 2,
        Paint()
          ..color = isHovered
              ? AppColors.neonCyan
              : AppColors.neonCyan.withOpacity(0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) {
    return oldDelegate.hoveredIndex != hoveredIndex;
  }
}
