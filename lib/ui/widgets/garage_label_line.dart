import 'package:flutter/material.dart';

class GarageLabelLine extends StatelessWidget {
  final Offset startOffset;
  final Offset endOffset;
  final String title;
  final String value;
  final Color color;

  const GarageLabelLine({
    super.key,
    required this.startOffset,
    required this.endOffset,
    required this.title,
    required this.value,
    this.color = Colors.cyanAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: startOffset.dx,
          top: startOffset.dy,
          child: CustomPaint(
            size: Size(
                endOffset.dx - startOffset.dx, endOffset.dy - startOffset.dy),
            painter: _LinePainter(
                startOffset: Offset(0, 0),
                endOffset: endOffset - startOffset,
                color: color),
          ),
        ),
        Positioned(
          left: endOffset.dx,
          top: endOffset.dy - 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
              Text(value,
                  style: TextStyle(
                    color: color.withOpacity(0.9),
                    fontSize: 13,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  final Offset startOffset;
  final Offset endOffset;
  final Color color;

  _LinePainter({
    required this.startOffset,
    required this.endOffset,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(startOffset, endOffset, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
