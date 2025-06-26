import 'package:flutter/material.dart';

class TiltDisplayWidget extends StatelessWidget {
  final double angle;

  const TiltDisplayWidget({super.key, required this.angle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Schräglage",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
            ),
            Transform.rotate(
              angle: angle * 3.1415 / 180,
              child: Container(
                width: 4,
                height: 60,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "${angle.toStringAsFixed(1)}°",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
