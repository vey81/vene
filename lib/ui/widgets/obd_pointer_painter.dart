import 'package:flutter/material.dart';
import 'dart:math';

class OBDPointerPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0

  OBDPointerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    final Paint arcPaint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Beispiel: Halber Kreis als Skala
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(arcRect, pi, pi, false, arcPaint);

    // Zeiger berechnen
    final double angle = pi + pi * progress;
    final Offset pointerEnd = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );

    final Paint pointerPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, pointerEnd, pointerPaint);
  }

  @override
  bool shouldRepaint(covariant OBDPointerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
