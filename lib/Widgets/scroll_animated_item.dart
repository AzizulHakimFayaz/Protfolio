import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollAnimatedItem extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double visibilityThreshold;
  final Offset beginOffset; // Controls slide direction

  const ScrollAnimatedItem({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.visibilityThreshold = 0.1,
    this.beginOffset = const Offset(0, 0.2), // Default: Slide Up
  });

  @override
  State<ScrollAnimatedItem> createState() => _ScrollAnimatedItemState();
}

class _ScrollAnimatedItemState extends State<ScrollAnimatedItem>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  // Unique key for VisibilityDetector to avoid conflicts
  final Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (!_isVisible && info.visibleFraction > widget.visibilityThreshold) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible
          ? widget.child
                .animate()
                .fade(
                  duration: 600.ms,
                  curve: Curves.easeOutQuad,
                  delay: widget.delay,
                )
                .slide(
                  // Generalized slide for X and Y
                  begin: widget.beginOffset,
                  end: Offset.zero,
                  duration: 600.ms,
                  curve: Curves.easeOutQuad,
                  delay: widget.delay,
                )
                // Optional: slight blur for "materializing" effect
                .blur(
                  begin: const Offset(2, 2),
                  end: Offset.zero,
                  duration: 400.ms,
                )
          : Opacity(opacity: 0, child: widget.child), // Hide until visible
    );
  }
}
