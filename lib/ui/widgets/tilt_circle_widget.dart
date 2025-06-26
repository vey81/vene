import 'package:flutter/material.dart';

class TiltCircleWidget extends StatelessWidget {
  final double tiltValue;

  const TiltCircleWidget({super.key, required this.tiltValue});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: _TiltPainter(tiltValue),
    );
  }
}

class _TiltPainter extends CustomPainter {
  final double tilt;

  _TiltPainter(this.tilt);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outerCircle = Paint()
      ..color = const Color(0xFF1F51FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    canvas.drawCircle(center, radius, outerCircle);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${tilt.toStringAsFixed(1)}°',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
