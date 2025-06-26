import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackPainter extends CustomPainter {
  final Set<Polyline> polylines;

  TrackPainter({required this.polylines});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (final polyline in polylines) {
      final path = Path();
      final points = polyline.points;

      if (points.isEmpty) continue;

      final scaleX = size.width / 400; // Dummy scale für Test
      final scaleY = size.height / 400;

      path.moveTo(
          points.first.latitude * scaleX, points.first.longitude * scaleY);

      for (final point in points.skip(1)) {
        path.lineTo(point.latitude * scaleX, point.longitude * scaleY);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
