import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';
import 'dart:ui';

class GlassHeroCard extends StatefulWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const GlassHeroCard({
    super.key,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  State<GlassHeroCard> createState() => _GlassHeroCardState();
}

class _GlassHeroCardState extends State<GlassHeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.02, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive card width
    final cardWidth = size.width > 900
        ? 800.0
        : size.width > 600
        ? size.width * 0.85
        : size.width * 0.92;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // The Glass Card
              Container(
                width: cardWidth,
                padding: const EdgeInsets.fromLTRB(40, 60, 40, 80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.0,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: -10,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tagline
                        Text(
                          "Clean Code • Scalable Systems • Beautiful UI/UX",
                          style: TextStyle(
                            fontFamily:
                                'Roboto', // Assuming default or Google Font
                            color: AppColors.accentTeal,
                            fontSize: 14,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Main Title
                        Text(
                          "Hi, I'm Azizul Hakim Fayaz",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: size.width < 600 ? 32 : 48,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Software & Flutter Developer",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textWhite.withOpacity(0.9),
                            fontSize: size.width < 600 ? 20 : 28,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Animated Subtitle
                        const _TypewriterSubtitle(),

                        const SizedBox(height: 50),

                        // Buttons
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _HeroButton(
                              text: "View My Work",
                              isPrimary: true,
                              onPressed: widget.onViewWork,
                            ),
                            _HeroButton(
                              text: "Contact Me",
                              isPrimary: false,
                              onPressed: widget.onContact,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Profile Image (Overlapping Bottom)
              Positioned(
                bottom: -60, // Overlap amount
                child: const _FloatingProfileImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypewriterSubtitle extends StatelessWidget {
  const _TypewriterSubtitle();

  @override
  Widget build(BuildContext context) {
    // Ideally use animated_text_kit, but building simple one for independence or standard text if package not preferred.
    // Given instructions, simple static or fade is safer without adding dep, but let's try a simple fade-in.
    return Text(
      "Building modern apps with Flutter, Python, and Django",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 16,
        height: 1.5,
      ),
    );
  }
}

class _FloatingProfileImage extends StatefulWidget {
  const _FloatingProfileImage();

  @override
  State<_FloatingProfileImage> createState() => _FloatingProfileImageState();
}

class _FloatingProfileImageState extends State<_FloatingProfileImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.05),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // Outer ring
          boxShadow: [
            BoxShadow(
              color: AppColors.accentTeal.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.navyLight,
          backgroundImage: AssetImage(
            "assets/images/profile.jpg",
          ), // Placeholder
        ),
      ),
    );
  }
}

class _HeroButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _HeroButton({
    super.key,
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<_HeroButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -3.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: widget.isPrimary
              ? const LinearGradient(
                  colors: [Color(0xFF2AC7D1), Color(0xFF26A69A)],
                )
              : null,
          color: widget.isPrimary ? null : Colors.transparent,
          border: widget.isPrimary
              ? null
              : Border.all(color: Colors.white, width: 1.5),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accentTeal.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.isPrimary
                  ? Colors.white
                  : (_isHovered ? AppColors.accentTeal : Colors.white),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
