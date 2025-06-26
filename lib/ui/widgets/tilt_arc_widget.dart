import 'package:flutter/material.dart';
import 'dart:math';

class TiltArcWidget extends StatelessWidget {
  final double tiltAngle; // z. B. -45 bis +45 (0 = gerade)

  const TiltArcWidget({super.key, required this.tiltAngle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 60), // Breite und Höhe des Halbkreises
      painter: _TiltArcPainter(tiltAngle),
    );
  }
}

class _TiltArcPainter extends CustomPainter {
  final double angle;

  _TiltArcPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final arcPaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;

    // Zeichne Halbkreis von 180° bis 360° (links nach rechts)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start bei 180°
      pi, // 180° Bogen
      false,
      arcPaint,
    );

    // Roter Punkt: Position auf dem Bogen
    final clampedAngle = angle.clamp(-65.0, 65.0);
    final radians = (clampedAngle + 180) * pi / 180;

    final pointX = center.dx + radius * cos(radians);
    final pointY = center.dy + radius * sin(radians);

    canvas.drawCircle(Offset(pointX, pointY), 5, pointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
