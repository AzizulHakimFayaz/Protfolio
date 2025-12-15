import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:protfolio_website/Widgets/animated_blob_profile.dart';
import 'package:protfolio_website/Widgets/scroll_animated_item.dart';
import 'package:protfolio_website/Widgets/section_title.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      color: AppColors.contentBackground,
      // We remove inner padding from container to let waves touch edges if needed,
      // or we handle positioning in Stack. Let's keep padding for content but use Stack for background.
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Animation
          Positioned(
            top: 150, // Roughly aligns with where profile picture usually sits
            left: 0,
            right: 0,
            height: 400, // Enough height for the waves
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: SurfaceLinePainter(
                    progress: _controller.value,
                    color: AppColors.accentTeal,
                  ),
                  size: Size(size.width, 200),
                );
              },
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  children: [
                    ScrollAnimatedItem(
                      beginOffset: const Offset(0, -0.2), // Slide down slightly
                      child: const SectionTitle(title: "About Me"),
                    ),
                    const SizedBox(height: 60),

                    if (isMobile)
                      Column(
                        children: [
                          ScrollAnimatedItem(
                            beginOffset: const Offset(
                              0.2,
                              0,
                            ), // Slide in from Right
                            delay: const Duration(milliseconds: 200),
                            child: const _ProfileImage(),
                          ),
                          const SizedBox(height: 40),
                          const _AboutContent(),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 40),
                          ScrollAnimatedItem(
                            beginOffset: const Offset(
                              0.2,
                              0,
                            ), // Slide in from Right
                            delay: const Duration(milliseconds: 200),
                            child: const _ProfileImage(),
                          ),
                          const SizedBox(width: 60),
                          Expanded(child: const _AboutContent()),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage();

  @override
  Widget build(BuildContext context) {
    return const AnimatedBlobProfile(
      imagePath: "assets/images/profile.jpg",
      size: 350,
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollAnimatedItem(
          beginOffset: const Offset(-0.2, 0),
          delay: const Duration(milliseconds: 400),
          child: const Text(
            "I’m a passionate software engineer who builds real-world solutions using Flutter, Python, Django, Firebase, and modern UI design practices.",
            style: TextStyle(
              fontSize: 18,
              height: 1.8, // Increased line height
              color: AppColors.textDark,
              fontWeight: FontWeight.w400, // Lighter weight for elegance
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ScrollAnimatedItem(
          beginOffset: const Offset(-0.2, 0),
          delay: const Duration(milliseconds: 600),
          child: Text(
            "With a strong foundation in both mobile and backend development, I love turning complex problems into simple, beautiful, and scalable applications. My journey involves continuous learning and experimenting with new technologies to build better products.",
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
              color: AppColors.textGrey.withOpacity(0.9),
            ),
          ),
        ),
        const SizedBox(height: 36),

        // Quick Info Grid
        ScrollAnimatedItem(
          beginOffset: const Offset(0, 0.2),
          delay: const Duration(milliseconds: 800),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _TechChip(label: "Flutter & Dart"),
              _TechChip(label: "Python & Django"),
              _TechChip(label: "Firebase"),
              _TechChip(label: "REST API"),
              _TechChip(label: "C & C++"),
              _TechChip(label: "Git & GitHub"),
            ],
          ),
        ),

        const SizedBox(height: 48),
        ScrollAnimatedItem(
          delay: const Duration(milliseconds: 900),
          child: Divider(color: AppColors.textGrey.withOpacity(0.2)),
        ),
        const SizedBox(height: 30),

        // Stats Row
        ScrollAnimatedItem(
          beginOffset: const Offset(0, 0.2),
          delay: const Duration(milliseconds: 1000),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                targetValue: 10,
                label: "Projects Included",
                suffix: "+",
              ),
              _StatItem(targetValue: 8, label: "Technologies", suffix: "+"),
              _StatItem(targetValue: 2, label: "Years Exp.", suffix: ""),
            ],
          ),
        ),
      ],
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.accentTeal.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.accentTeal.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentTeal.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.accentTeal,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
          duration: 3.seconds,
          color: Colors.white.withOpacity(0.2),
        ) // Subtle shimmer
        .animate()
        .fadeIn(duration: 500.ms);
  }
}

class _StatItem extends StatelessWidget {
  final int targetValue;
  final String label;
  final String suffix;

  const _StatItem({
    required this.targetValue,
    required this.label,
    this.suffix = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated Counter
        Text("$targetValue$suffix") // Placeholder for size calculation
            .animate()
            .custom(
              duration: 2.seconds,
              curve: Curves.easeOutExpo,
              builder: (context, value, child) {
                final count = (value * targetValue).toInt();
                return Text(
                  "$count$suffix",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentTeal,
                    height: 1.0,
                  ),
                );
              },
            ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
