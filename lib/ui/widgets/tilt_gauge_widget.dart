import 'package:flutter/material.dart';
import 'dart:math';

class TiltGaugeWidget extends StatelessWidget {
  final double angle;

  const TiltGaugeWidget({super.key, required this.angle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 60),
      painter: _TiltGaugePainter(-angle), // ← Invertiere das Vorzeichen hier!
    );
  }
}

class _TiltGaugePainter extends CustomPainter {
  final double angle;
  static const double maxAngle = 65.0;

  _TiltGaugePainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final basePaint = Paint()
      ..color = Colors.grey.shade900
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00FFFF), Color(0xFF00BFFF)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    // Hintergrund-Bogen (volle 180° unten)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      basePaint,
    );

    final clamped = angle.clamp(-maxAngle, maxAngle);
    final sweepAngle = (clamped.abs() / maxAngle) * (pi / 2);
    final startAngle = -pi / 2; // Start bei 12 Uhr

    if (clamped < 0) {
      // Links → 12 Uhr → 9 Uhr
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        -sweepAngle,
        false,
        activePaint,
      );
    } else if (clamped > 0) {
      // Rechts → 12 Uhr → 3 Uhr
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        activePaint,
      );
    }

    // Textanzeige zentriert
    final textPainter = TextPainter(
      text: TextSpan(
        text: "${clamped.toStringAsFixed(0)}°",
        style: const TextStyle(
          color: Color(0xFF00FFFF),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - 50),
    );
  }

  @override
  bool shouldRepaint(covariant _TiltGaugePainter oldDelegate) =>
      oldDelegate.angle != angle;
}
