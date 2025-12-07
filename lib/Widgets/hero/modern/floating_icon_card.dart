import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:protfolio_website/constants/app_colors.dart';

class FloatingIconCard extends StatefulWidget {
  final IconData icon;
  final double size;
  final Duration animationDuration;
  final double floatAmplitude;
  final Offset initialOffset;
  final double mouseX;
  final double mouseY;
  final double parallaxFactor;

  const FloatingIconCard({
    super.key,
    required this.icon,
    this.size = 50.0,
    required this.animationDuration,
    required this.floatAmplitude,
    required this.initialOffset,
    required this.mouseX,
    required this.mouseY,
    required this.parallaxFactor,
  });

  @override
  State<FloatingIconCard> createState() => _FloatingIconCardState();
}

class _FloatingIconCardState extends State<FloatingIconCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double _randomOffset = math.Random().nextDouble() * 2 * math.pi;

  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation =
        Tween<double>(
          begin: -widget.floatAmplitude,
          end: widget.floatAmplitude,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
        );

    // Start with random offset to desynchronize animations
    Future.delayed(
      Duration(
        milliseconds:
            (widget.animationDuration.inMilliseconds *
                    (_randomOffset / (2 * math.pi)))
                .toInt(),
      ),
      () {
        if (mounted) {
          _controller.repeat(reverse: true);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Parallax Shift
    final double parallaxX = widget.mouseX * widget.parallaxFactor;
    final double parallaxY = widget.mouseY * widget.parallaxFactor;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            widget.initialOffset.dx + parallaxX,
            widget.initialOffset.dy + _animation.value + parallaxY,
          ),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: AnimatedScale(
              scale: _isHovering ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  // Glass effect using Opacity + Gradient (No expensive Blur)
                  color: AppColors.navyLight.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovering
                        ? AppColors.accentTeal.withOpacity(0.6)
                        : AppColors.accentTeal.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovering
                          ? AppColors.accentTeal.withOpacity(0.3)
                          : Colors.black12,
                      blurRadius: _isHovering ? 15 : 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovering ? AppColors.accentTeal : Colors.white70,
                  size: widget.size * 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
