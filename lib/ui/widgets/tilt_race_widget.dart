import 'package:flutter/material.dart';

class TiltRaceWidget extends StatelessWidget {
  final double tilt;
  const TiltRaceWidget({super.key, required this.tilt});

  @override
  Widget build(BuildContext context) {
    const double maxTilt = 65.0;
    final double clampedTilt = tilt.clamp(-maxTilt, maxTilt);
    final double normalized = clampedTilt / maxTilt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${clampedTilt.toStringAsFixed(1)}°",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 120,
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF00FFFF), // Cyan
                Color(0xFF00FFAA), // Türkis
                Color(0xFFFF0055), // Rot
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                alignment: Alignment(normalized, 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          "TILT",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
