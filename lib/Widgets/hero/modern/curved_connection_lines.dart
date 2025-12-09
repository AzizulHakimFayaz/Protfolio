import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A custom painter that draws curved, glowing lines between icons
/// positioned around the hero card
class CurvedConnectionLines extends StatelessWidget {
  final Size screenSize;
  final bool isMobile;

  const CurvedConnectionLines({
    super.key,
    required this.screenSize,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: screenSize,
      painter: _ConnectionLinesPainter(
        screenSize: screenSize,
        isMobile: isMobile,
      ),
    );
  }
}

class _ConnectionLinesPainter extends CustomPainter {
  final Size screenSize;
  final bool isMobile;

  _ConnectionLinesPainter({required this.screenSize, required this.isMobile});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Define icon positions matching modern_hero_section.dart
    final List<_IconPosition> iconPositions = isMobile
        ? [
            _IconPosition(-0.35, -0.3), // 0
            _IconPosition(0.35, -0.35), // 1
            _IconPosition(-0.3, 0.35), // 2
            _IconPosition(0.3, 0.3), // 3
          ]
        : [
            // EXACT positions matching reference image (Compressed Y for fit)
            _IconPosition(-0.43, -0.10), // 0: GitHub
            _IconPosition(-0.38, 0.15), // 1: LinkedIn
            _IconPosition(-0.28, 0.36), // 2: Instagram
            _IconPosition(-0.18, -0.39), // 3: Terminal
            _IconPosition(-0.05, -0.42), // 4: Database
            _IconPosition(0.20, -0.41), // 5: Cloud
            _IconPosition(0.42, -0.15), // 6: Python
            _IconPosition(0.45, 0.07), // 7: Brain/Smart Toy
            _IconPosition(0.40, 0.24), // 8: Gear
            _IconPosition(0.05, 0.42), // 9: Laptop
            _IconPosition(0.35, 0.38), // 10: Code
          ];

    // Convert to absolute positions
    final List<Offset> iconCenters = iconPositions.map((pos) {
      return Offset(
        centerX + (pos.relX * size.width),
        centerY + (pos.relY * size.height),
      );
    }).toList();

    // Define connections exactly matching the reference image's web pattern
    final List<_Connection> connections = isMobile
        ? [
            _Connection(0, 1, 0.3),
            _Connection(1, 3, 0.3),
            _Connection(2, 3, 0.3),
            _Connection(0, 2, 0.35),
          ]
        : [
            // --- Outer Ring ---
            _Connection(0, 1, 0.30), // GitHub -> LinkedIn
            _Connection(1, 2, 0.30), // LinkedIn -> Instagram
            _Connection(2, 9, 0.25), // Instagram -> Laptop
            _Connection(9, 10, 0.25), // Laptop -> Code
            _Connection(10, 8, 0.25), // Code -> Gear
            _Connection(8, 7, 0.30), // Gear -> Brain
            _Connection(7, 6, 0.30), // Brain -> Python
            _Connection(6, 5, 0.25), // Python -> Cloud
            _Connection(5, 4, 0.25), // Cloud -> Database
            _Connection(4, 3, 0.25), // Database -> Terminal
            _Connection(3, 0, 0.30), // Terminal -> GitHub
            // --- Inner/Cross Connections (The "Web") ---
            _Connection(3, 7, 0.15), // Terminal <-> Robot
            _Connection(4, 9, 0.05), // Database <-> Laptop
            _Connection(0, 4, 0.20), // GitHub <-> Database
            _Connection(5, 8, 0.20), // Cloud <-> Gear
            _Connection(1, 9, 0.25), // LinkedIn <-> Laptop
            _Connection(6, 10, 0.30), // Python <-> Code
          ];

    // Draw Ambient "Infinity" Lines (Background Web)
    _drawAmbientLines(canvas, size, centerX, centerY);

    // Draw each connection (Main Graph)
    for (final connection in connections) {
      _drawConnection(
        canvas,
        iconCenters[connection.startIndex],
        iconCenters[connection.endIndex],
        connection.curvature,
        centerX,
        centerY,
      );
    }
  }

  /// Draws faint ambient lines from edges to suggest a larger network
  void _drawAmbientLines(
    Canvas canvas,
    Size size,
    double centerX,
    double centerY,
  ) {
    if (isMobile) return; // Keep mobile simple

    final ambientPaint = Paint()
      ..color = const Color(0xFF2AC7D1)
          .withOpacity(0.05) // Very faint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;

    // Define some "invisible node" paths
    // Edge points -> Near Center points
    final List<List<Offset>> invisiblePaths = [
      [
        Offset(0, size.height * 0.2),
        Offset(centerX - 200, centerY - 100),
      ], // Left-Top to Center-Left
      [
        Offset(size.width, size.height * 0.3),
        Offset(centerX + 250, centerY - 150),
      ], // Right-Top to Center-Right
      [
        Offset(0, size.height * 0.8),
        Offset(centerX - 150, centerY + 200),
      ], // Left-Bottom to Center-Low
      [
        Offset(size.width, size.height * 0.7),
        Offset(centerX + 200, centerY + 100),
      ], // Right-Bottom to Center
      [
        Offset(size.width * 0.2, 0),
        Offset(centerX - 100, centerY - 250),
      ], // Top-Left to High-Center
      [
        Offset(size.width * 0.8, size.height),
        Offset(centerX + 100, centerY + 250),
      ], // Bottom-Right to Low-Center
    ];

    for (final pair in invisiblePaths) {
      final path = _createCurvedPath(pair[0], pair[1], 0.2, centerX, centerY);
      canvas.drawPath(path, ambientPaint);
    }
  }

  /// Draws a curved connection between two points
  void _drawConnection(
    Canvas canvas,
    Offset start,
    Offset end,
    double curvature,
    double centerX,
    double centerY,
  ) {
    final paint = Paint()
      ..color = const Color(0xFF2AC7D1)
          .withOpacity(0.2) // More subtle Teal
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          1.0 // Thinner lines
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0xFF2AC7D1)
          .withOpacity(0.05) // Very subtle glow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4); // Tighter blur

    final path = _createCurvedPath(start, end, curvature, centerX, centerY);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  /// Creates curved path that bulges OUTWARD from center
  Path _createCurvedPath(
    Offset start,
    Offset end,
    double curvature,
    double centerX,
    double centerY,
  ) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    // Calculate direction AWAY from center
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = math.sqrt(dx * dx + dy * dy);

    // Perpendicular direction
    final perpX = -dy / length;
    final perpY = dx / length;

    // Determine if we should curve outward or inward
    // Vector from center to midpoint
    final toCenterX = midX - centerX;
    final toCenterY = midY - centerY;

    // Dot product to determine direction
    final dot = perpX * toCenterX + perpY * toCenterY;

    // Curve OUTWARD from center (away from center)
    final direction = dot > 0 ? 1.0 : -1.0;

    final controlX = midX + perpX * length * curvature * direction;
    final controlY = midY + perpY * length * curvature * direction;

    path.quadraticBezierTo(controlX, controlY, end.dx, end.dy);

    return path;
  }

  @override
  bool shouldRepaint(_ConnectionLinesPainter oldDelegate) {
    return oldDelegate.screenSize != screenSize ||
        oldDelegate.isMobile != isMobile;
  }
}

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
