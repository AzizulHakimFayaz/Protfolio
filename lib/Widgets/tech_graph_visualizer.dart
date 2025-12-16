import 'dart:math' as math;
import 'package:flutter/material.dart';

class TechGraphVisualizer extends StatefulWidget {
  final Color accentColor;
  final bool isActive;
  final List<IconData> techIcons;
  final List<String> techLabels;
  final IconData? centerIcon;

  const TechGraphVisualizer({
    super.key,
    required this.accentColor,
    required this.isActive,
    required this.techIcons,
    required this.techLabels,
    this.centerIcon,
  });

  @override
  State<TechGraphVisualizer> createState() => _TechGraphVisualizerState();
}

class _TechGraphVisualizerState extends State<TechGraphVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Node> _nodes = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _initializeNodes();
  }

  void _initializeNodes() {
    _nodes.clear();
    // Create random nodes
    for (int i = 0; i < 15; i++) {
      _nodes.add(
        Node(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          dx: (_random.nextDouble() - 0.5) * 0.002,
          dy: (_random.nextDouble() - 0.5) * 0.002,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            widget.accentColor.withOpacity(widget.isActive ? 0.15 : 0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Node Graph
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                _updateNodes();
                return CustomPaint(
                  painter: _NodeGraphPainter(
                    nodes: _nodes,
                    color: widget.accentColor,
                    opacity: widget.isActive ? 0.3 : 0.1,
                  ),
                );
              },
            ),
          ),

          // Central Connections (Lines to Orbiting Icons)
          if (widget.techIcons.isNotEmpty)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _CentralConnectionPainter(
                      itemCount: widget.techIcons.length,
                      animationValue: _controller.value,
                      color: widget.accentColor,
                      isActive: widget.isActive,
                    ),
                  );
                },
              ),
            ),

          // Orbiting Icons and Central Icon Layout
          if (widget.techIcons.isNotEmpty)
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double width = constraints.maxWidth;
                  final double height = constraints.maxHeight;
                  final double centerX = width / 2;
                  final double centerY = height / 2;

                  return Stack(
                    children: [
                      // Central Icon
                      if (widget.centerIcon != null)
                        Align(
                          alignment: Alignment.center,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: widget.isActive ? 1.0 : 0.0,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF1B263B), // Match bg
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.accentColor.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.centerIcon,
                                size: 40,
                                color: widget.accentColor,
                              ),
                            ),
                          ),
                        ),

                      // Orbiting Icons
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Stack(
                            children: List.generate(widget.techIcons.length, (
                              index,
                            ) {
                              // Angular spacing
                              final double step =
                                  (2 * math.pi) / widget.techIcons.length;
                              // Current angle + global rotation (clockwise)
                              final double angle =
                                  (index * step) +
                                  (_controller.value * 2 * math.pi);

                              // Radius (0.6 to 0.75 slightly oscillating for organic feel)
                              final double radius =
                                  0.7 + (math.sin(angle * 3) * 0.05);

                              // Calculate position relative to center
                              // Note: Paint uses size.width/2 * dx
                              final double dx =
                                  math.cos(angle) * radius * (width / 2);
                              final double dy =
                                  math.sin(angle) * radius * (height / 2);

                              return Positioned(
                                left: centerX + dx,
                                top: centerY + dy,
                                child: FractionalTranslation(
                                  translation: const Offset(-0.5, -0.5),
                                  child: _OrbitingItem(
                                    icon: widget.techIcons[index],
                                    color: widget.accentColor,
                                    isActive: widget.isActive,
                                    angle:
                                        angle, // Pass angle to counter-rotate if needed
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

          // Floating Labels (Keep them random or static for now to avoid clutter)
          // Removed strictly to focus on the request "icon will move clockwise" and clean up visual
        ],
      ),
    );
  }

  void _updateNodes() {
    for (var node in _nodes) {
      node.x += node.dx * (widget.isActive ? 2.0 : 0.5); // Faster when active
      node.y += node.dy * (widget.isActive ? 2.0 : 0.5);

      // Bounce off edges
      if (node.x < 0 || node.x > 1) node.dx *= -1;
      if (node.y < 0 || node.y > 1) node.dy *= -1;
    }
  }
}

class _OrbitingItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isActive;
  final double angle;

  const _OrbitingItem({
    required this.icon,
    required this.color,
    required this.isActive,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      // Counter-rotate the icon so it stays upright while orbiting
      angle: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isActive ? 1.0 : 0.0,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

class Node {
  double x, y;
  double dx, dy;

  Node({required this.x, required this.y, required this.dx, required this.dy});
}

class _NodeGraphPainter extends CustomPainter {
  final List<Node> nodes;
  final Color color;
  final double opacity;

  _NodeGraphPainter({
    required this.nodes,
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    // Draw Nodes
    for (var node in nodes) {
      final cx = node.x * size.width;
      final cy = node.y * size.height;
      canvas.drawCircle(Offset(cx, cy), 2, paint);

      // Draw Connections
      for (var other in nodes) {
        if (node == other) continue;
        final ox = other.x * size.width;
        final oy = other.y * size.height;

        final dist = math.sqrt(math.pow(cx - ox, 2) + math.pow(cy - oy, 2));
        if (dist < 100) {
          // Connect if close
          final lineOpacity = (1 - (dist / 100)) * opacity;
          canvas.drawLine(
            Offset(cx, cy),
            Offset(ox, oy),
            Paint()
              ..color = color.withOpacity(lineOpacity)
              ..strokeWidth = 0.5,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _FloatingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final int delay;
  final bool isActive;
  final Offset position; // Alignment (-1 to 1)

  const _FloatingIcon({
    required this.icon,
    required this.color,
    required this.delay,
    required this.isActive,
    required this.position,
  });

  @override
  State<_FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<_FloatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
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
        return Align(
          alignment: Alignment(
            widget.position.dx,
            widget.position.dy + (_controller.value * 0.1), // Float vertically
          ),
          child: Opacity(
            opacity: widget.isActive ? 0.6 : 0.0,
            child: Icon(
              widget.icon,
              color: widget.color.withOpacity(0.5),
              size: 24,
            ),
          ),
        );
      },
    );
  }
}

class _FloatingLabel extends StatefulWidget {
  final String label;
  final Color color;
  final int delay;
  final bool isActive;
  final Offset position;

  const _FloatingLabel({
    required this.label,
    required this.color,
    required this.delay,
    required this.isActive,
    required this.position,
  });

  @override
  State<_FloatingLabel> createState() => _FloatingLabelState();
}

class _FloatingLabelState extends State<_FloatingLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
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
        return Align(
          alignment: Alignment(
            widget.position.dx,
            widget.position.dy + (_controller.value * 0.05),
          ),
          child: Opacity(
            opacity: widget.isActive ? (0.4 + _controller.value * 0.3) : 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: widget.color.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CentralConnectionPainter extends CustomPainter {
  final int itemCount;
  final double animationValue;
  final Color color;
  final bool isActive;

  _CentralConnectionPainter({
    required this.itemCount,
    required this.animationValue,
    required this.color,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (itemCount == 0 || !isActive) return;

    final center = size.center(Offset.zero);
    final double shortSide = math.min(size.width, size.height);
    final double ringRadius = shortSide * 0.15; // 15% of shortest side

    final linePaint = Paint()
      ..color = color.withOpacity(isActive ? 0.2 : 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final ringPaint = Paint()
      ..color = color.withOpacity(isActive ? 0.6 : 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final glowPaint = Paint()
      ..color = color.withOpacity(isActive ? 0.2 : 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Draw Central Ring with Glow
    canvas.drawCircle(center, ringRadius, glowPaint);
    canvas.drawCircle(center, ringRadius, ringPaint);

    // Draw Inner Ring (Decor)
    canvas.drawCircle(
      center,
      ringRadius * 0.7,
      Paint()
        ..color = color.withOpacity(isActive ? 0.4 : 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    for (int i = 0; i < itemCount; i++) {
      // Logic must match _OrbitingItem positioning exactly
      final double step = (2 * math.pi) / itemCount;
      final double angle = (i * step) + (animationValue * 2 * math.pi);
      // Radius (0.6 to 0.75 relative to half-sizes)
      final double radiusFactor = 0.7 + (math.sin(angle * 3) * 0.05);

      // Icon Position (Center + Vector * factor * halfSize)
      // Note: _OrbitingItem used Align (1.0 = edge). Align coordinates relate to center.
      // dx = cos(angle) * max_width/2 * radiusFactor
      final double iconDx = math.cos(angle) * radiusFactor * (size.width / 2);
      final double iconDy = math.sin(angle) * radiusFactor * (size.height / 2);

      final iconPoint = Offset(center.dx + iconDx, center.dy + iconDy);

      // Start line at Ring Edge
      // Vector from center to icon
      final double vectorX = iconDx;
      final double vectorY = iconDy;
      final double distance = math.sqrt(vectorX * vectorX + vectorY * vectorY);

      if (distance > ringRadius) {
        // Normalize vector
        final double unitX = vectorX / distance;
        final double unitY = vectorY / distance;

        final startPoint = Offset(
          center.dx + (unitX * ringRadius),
          center.dy + (unitY * ringRadius),
        );

        canvas.drawLine(startPoint, iconPoint, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CentralConnectionPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isActive != isActive ||
        oldDelegate.color != color ||
        oldDelegate.itemCount != itemCount;
  }
}
