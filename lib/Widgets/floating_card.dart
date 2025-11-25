import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingCard extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double distance;
  final Duration delay;

  const FloatingCard({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 6), // Base duration
    this.distance = 15.0,
    this.delay = Duration.zero,
  });

  @override
  State<FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<FloatingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Use a long duration to minimize repetition perception
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value * 2 * math.pi;

        // "Wind" Physics Simulation using Superposition of Sine Waves
        // This creates a non-linear, organic path that feels like floating in air

        // Vertical movement: Main float + subtle variation
        final y =
            math.sin(t) * widget.distance +
            math.sin(t * 2.3) * (widget.distance * 0.3);

        // Horizontal drift: Slower, independent sway
        final x = math.cos(t * 1.4) * (widget.distance * 0.5);

        // Rotation: Very subtle rocking based on horizontal movement
        final angle = math.sin(t * 0.8) * 0.03; // ~1.7 degrees max tilt

        return Transform(
          transform: Matrix4.identity()
            ..setTranslationRaw(x, y, 0)
            ..rotateZ(angle),
          alignment: Alignment.center,
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}
