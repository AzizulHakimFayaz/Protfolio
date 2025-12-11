import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

/// Draws curved, glowing network lines around the hero card
class CurvedConnectionLines extends StatefulWidget {
  final Size screenSize;
  final bool isMobile;

  const CurvedConnectionLines({
    super.key,
    required this.screenSize,
    required this.isMobile,
  });

  @override
  State<CurvedConnectionLines> createState() => _CurvedConnectionLinesState();
}

class _CurvedConnectionLinesState extends State<CurvedConnectionLines>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Loop the animation for continuous traffic flow
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
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
        return CustomPaint(
          size: widget.screenSize,
          painter: _ConnectionLinesPainter(
            screenSize: widget.screenSize,
            isMobile: widget.isMobile,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class _ConnectionLinesPainter extends CustomPainter {
  final Size screenSize;
  final bool isMobile;
  final double animationValue;

  _ConnectionLinesPainter({
    required this.screenSize,
    required this.isMobile,
    required this.animationValue,
  });

  // Palette for lines
  static const _palette = <Color>[
    Color(0xFF18E0B4), // teal
    Color(0xFF33F6D0), // aqua
    Color(0xFF2A6CFF), // blue
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Exact hero card rect matching GlassHeroCard logic
    final double cardWidth = size.width > 900
        ? 800.0
        : size.width > 600
        ? size.width * 0.85
        : size.width * 0.92;

    // Approximate height based on GlassHeroCard content
    final double cardHeight = isMobile ? size.height * 0.6 : 480.0;

    final Rect cardRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: cardWidth,
      height: cardHeight,
    );

    // Icon positions relative to center
    final List<_IconPosition> iconPositions = isMobile
        ? [
            _IconPosition(-0.35, -0.30), // 0
            _IconPosition(0.35, -0.35), // 1
            _IconPosition(-0.30, 0.35), // 2
            _IconPosition(0.30, 0.30), // 3
          ]
        : [
            // Positions matching ModernHeroSection EXACTLY
            _IconPosition(-0.33, -0.25), // 0: GitHub
            _IconPosition(-0.43, 0.05), // 1: LinkedIn
            _IconPosition(-0.23, 0.36), // 2: Instagram
            _IconPosition(-0.18, -0.39), // 3: Terminal
            _IconPosition(-0.05, -0.42), // 4: Database
            _IconPosition(0.20, -0.41), // 5: Cloud
            _IconPosition(0.42, -0.15), // 6: Python
            _IconPosition(0.45, 0.07), // 7: Bot/Smart Toy
            _IconPosition(0.40, 0.24), // 8: Gear
            _IconPosition(0.05, 0.42), // 9: Laptop
            _IconPosition(0.35, 0.38), // 10: Code
          ];

    // Convert to absolute positions
    final List<Offset> nodeCenters = iconPositions
        .map(
          (pos) => Offset(
            centerX + (pos.relX * size.width),
            centerY + (pos.relY * size.height),
          ),
        )
        .toList();

    // Background web (very faint)
    _drawAmbientLines(canvas, size, centerX, centerY, cardRect);

    // === Fans that make lines come out from the card edge ===
    if (!isMobile) {
      // LEFT edge fan: to GitHub, LinkedIn, Instagram
      _drawEdgeFan(
        canvas: canvas,
        card: cardRect,
        side: _Side.left,
        portT: 0.34,
        fanSpreadDeg: 16,
        portKick: 36,
        bulge: 0.22,
        cx: centerX,
        cy: centerY,
        targets: [nodeCenters[0], nodeCenters[1], nodeCenters[2]],
        colorOffset: 0,
      );

      // RIGHT edge fan: to Bot, Python, Code
      _drawEdgeFan(
        canvas: canvas,
        card: cardRect,
        side: _Side.right,
        portT: 0.38,
        fanSpreadDeg: 14,
        portKick: 32,
        bulge: 0.22,
        cx: centerX,
        cy: centerY,
        targets: [nodeCenters[7], nodeCenters[6], nodeCenters[10]],
        colorOffset: 1,
      );

      // BOTTOM fan: to Laptop
      _drawEdgeFan(
        canvas: canvas,
        card: cardRect,
        side: _Side.bottom,
        portT: 0.50,
        fanSpreadDeg: 0,
        portKick: 26,
        bulge: 0.18,
        cx: centerX,
        cy: centerY,
        targets: [nodeCenters[9]],
        colorOffset: 2,
      );
    }

    // Main connections (glowing, multi-colour)
    final List<_Connection> connections = isMobile
        ? [
            _Connection(0, 1, 0.30),
            _Connection(1, 3, 0.30),
            _Connection(2, 3, 0.30),
            _Connection(0, 2, 0.35),
          ]
        : [
            // Long outer ring around the card
            _Connection(0, 1, 0.34),
            _Connection(1, 2, 0.34),
            _Connection(2, 9, 0.32),
            _Connection(9, 10, 0.32),
            _Connection(10, 8, 0.32),
            _Connection(8, 7, 0.34),
            _Connection(7, 6, 0.34),
            _Connection(6, 5, 0.32),
            _Connection(5, 4, 0.30),
            _Connection(4, 3, 0.30),
            _Connection(3, 0, 0.32),

            // Cross links going "through" / behind the card
            _Connection(1, 4, 0.22),
            _Connection(1, 9, 0.30),
            _Connection(2, 10, 0.36),
            _Connection(6, 10, 0.28),
            _Connection(6, 9, 0.30),
            _Connection(3, 7, 0.24),
            _Connection(4, 9, 0.20),
          ];

    for (var i = 0; i < connections.length; i++) {
      final c = connections[i];
      _drawConnection(
        canvas,
        nodeCenters[c.startIndex],
        nodeCenters[c.endIndex],
        c.curvature,
        centerX,
        centerY,
        i,
      );
    }
  }

  /// Faint ambient lines starting at edges, passing behind the card
  void _drawAmbientLines(
    Canvas canvas,
    Size size,
    double centerX,
    double centerY,
    Rect cardRect,
  ) {
    if (isMobile) return;

    final ambientPaint = Paint()
      ..color = const Color(0xFF2AC7D1).withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;

    final List<List<Offset>> invisiblePaths = [
      [
        Offset(0, size.height * 0.25),
        Offset(cardRect.left - 80, cardRect.top - 40),
      ],
      [
        Offset(size.width, size.height * 0.30),
        Offset(cardRect.right + 120, cardRect.top - 60),
      ],
      [
        Offset(0, size.height * 0.80),
        Offset(cardRect.left - 60, cardRect.bottom + 40),
      ],
      [
        Offset(size.width, size.height * 0.75),
        Offset(cardRect.right + 80, cardRect.bottom + 20),
      ],
      [Offset(size.width * 0.25, 0), Offset(centerX, cardRect.top - 120)],
      [
        Offset(size.width * 0.80, size.height),
        Offset(centerX + 60, cardRect.bottom + 120),
      ],
    ];

    for (final pair in invisiblePaths) {
      final path = _createCurvedPath(pair[0], pair[1], 0.22, centerX, centerY);
      canvas.drawPath(path, ambientPaint);
    }
  }

  /// Draw one glowing curved connection with animated packet
  void _drawConnection(
    Canvas canvas,
    Offset start,
    Offset end,
    double curvature,
    double centerX,
    double centerY,
    int colorSlot,
  ) {
    final baseColor = _palette[colorSlot % _palette.length];
    final path = _createCurvedPath(start, end, curvature, centerX, centerY);

    final glowPaint = Paint()
      ..color = baseColor.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(start, end, [
        baseColor.withOpacity(0.25),
        baseColor.withOpacity(0.55),
      ]);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);

    // Draw Packet
    _drawPacket(canvas, path, baseColor, colorSlot);
  }

  /// Bezier curve that bulges away from the center (around the card)
  Path _createCurvedPath(
    Offset start,
    Offset end,
    double curvature,
    double centerX,
    double centerY,
  ) {
    final path = Path()..moveTo(start.dx, start.dy);

    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = math.sqrt(dx * dx + dy * dy).clamp(1.0, double.infinity);

    // Perpendicular direction
    final perpX = -dy / length;
    final perpY = dx / length;

    // Vector from center to midpoint
    final toCenterX = midX - centerX;
    final toCenterY = midY - centerY;

    // Decide which way to bulge so it wraps around the card
    final dot = perpX * toCenterX + perpY * toCenterY;
    final direction = dot > 0 ? 1.0 : -1.0;

    final controlX = midX + perpX * length * curvature * direction;
    final controlY = midY + perpY * length * curvature * direction;

    path.quadraticBezierTo(controlX, controlY, end.dx, end.dy);
    return path;
  }

  // ────────────────────────────────
  // FANNED LINES FROM CARD EDGE
  // ────────────────────────────────

  ({Offset port, Offset normal}) _edgePort(
    Rect card,
    _Side side, {
    double t = 0.5,
  }) {
    switch (side) {
      case _Side.left:
        return (
          port: Offset(card.left, ui.lerpDouble(card.top, card.bottom, t)!),
          normal: const Offset(-1, 0),
        );
      case _Side.right:
        return (
          port: Offset(card.right, ui.lerpDouble(card.top, card.bottom, t)!),
          normal: const Offset(1, 0),
        );
      case _Side.top:
        return (
          port: Offset(ui.lerpDouble(card.left, card.right, t)!, card.top),
          normal: const Offset(0, -1),
        );
      case _Side.bottom:
        return (
          port: Offset(ui.lerpDouble(card.left, card.right, t)!, card.bottom),
          normal: const Offset(0, 1),
        );
    }
  }

  Offset _rot(Offset v, double radians) {
    final c = math.cos(radians), s = math.sin(radians);
    return Offset(v.dx * c - v.dy * s, v.dx * s + v.dy * c);
  }

  /// Draw a fan of N cubic curves that are tangent to the card edge.
  void _drawEdgeFan({
    required Canvas canvas,
    required Rect card,
    required _Side side,
    required List<Offset> targets,
    required double cx,
    required double cy,
    double portT = 0.5,
    double fanSpreadDeg = 12,
    double portKick = 30,
    double bulge = 0.22,
    int colorOffset = 0,
  }) {
    final info = _edgePort(card, side, t: portT);
    final port = info.port;
    final baseNormal = info.normal;

    // scale with viewport so it looks good on any size
    final scale = math.min(card.width, card.height);
    final kick = portKick.clamp(12, 999) * (scale / 700).clamp(0.7, 1.2);

    for (int i = 0; i < targets.length; i++) {
      // Slightly rotate the normal for each strand to create the fan
      final angle =
          ((i - (targets.length - 1) / 2) * (fanSpreadDeg * math.pi / 180.0));
      final n = _rot(baseNormal, angle);

      final start = port;
      final c1 = start + n * kick; // tangent at the edge

      // Build bulging direction away from the center
      final end = targets[i];
      final mx = (c1.dx + end.dx) / 2;
      final my = (c1.dy + end.dy) / 2;
      final dx = end.dx - c1.dx, dy = end.dy - c1.dy;
      final len = math.max(1.0, math.sqrt(dx * dx + dy * dy));
      final px = -dy / len, py = dx / len;
      final toCenX = mx - cx, toCenY = my - cy;
      final dir = (px * toCenX + py * toCenY) > 0 ? 1.0 : -1.0;

      final c2 = Offset(
        mx + px * len * bulge * dir,
        my + py * len * bulge * dir,
      );

      _strokeFanCurve(canvas, start, c1, c2, end, i + colorOffset);
    }

    // tiny glow at the “port” so it feels like it emits from the card
    final glow = Paint()
      ..color = const Color(0xFF33F6D0).withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(port, 2.2, glow);
  }

  void _strokeFanCurve(
    Canvas canvas,
    Offset s,
    Offset c1,
    Offset c2,
    Offset e,
    int slot,
  ) {
    final color = _palette[slot % _palette.length];

    final path = Path()
      ..moveTo(s.dx, s.dy)
      ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, e.dx, e.dy);

    final glow = Paint()
      ..color = color.withOpacity(0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(s, e, [
        color.withOpacity(0.28),
        color.withOpacity(0.55),
      ]);

    canvas.drawPath(path, glow);
    canvas.drawPath(path, line);

    // Draw animated packet
    _drawPacket(canvas, path, color, slot);
  }

  /// Draws a moving 'light packet' along the path
  void _drawPacket(Canvas canvas, Path path, Color color, int index) {
    if (animationValue == 0) return;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      // Offset the animation so packets don't all move in perfect sync
      // 'index' is used to stagger them
      final shift = (index * 0.23);
      final t = (animationValue + shift) % 1.0;
      final distance = metric.length * t;

      final pos = metric.getTangentForOffset(distance)?.position;
      if (pos != null) {
        // Core dot
        final dotPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 2.0, dotPaint);

        // Glow halo
        final haloPaint = Paint()
          ..color = color.withOpacity(0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 6.0, haloPaint);

        // Impact Glow at the end (when t is near 1.0)
        if (t > 0.95) {
          final endPos = metric.getTangentForOffset(metric.length)?.position;
          if (endPos != null) {
            final double impact = (t - 0.95) / 0.05; // 0.0 to 1.0
            final impactPaint = Paint()
              ..color = color.withOpacity(0.5 * impact)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
              ..style = PaintingStyle.fill;
            canvas.drawCircle(endPos, 12.0 * impact, impactPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ConnectionLinesPainter oldDelegate) {
    return oldDelegate.screenSize != screenSize ||
        oldDelegate.isMobile != isMobile ||
        oldDelegate.animationValue != animationValue;
  }
}

enum _Side { left, right, top, bottom }

class _IconPosition {
  final double relX;
  final double relY;
  _IconPosition(this.relX, this.relY);
}

class _Connection {
  final int startIndex;
  final int endIndex;
  final double curvature;
  _Connection(this.startIndex, this.endIndex, this.curvature);
}
