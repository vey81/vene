import 'package:flutter/material.dart';

class SensorBar extends StatelessWidget {
  final String title;
  final double value; // Wert von 0.0 bis 1.0
  final double barWidth; // Breite des Balkens

  const SensorBar({
    super.key,
    required this.title,
    required this.value,
    this.barWidth = 20, // Standardbreite, falls nichts angegeben
  });

  @override
  Widget build(BuildContext context) {
    const double height = 100;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          width: barWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30, width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                blurRadius: 2,
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: height * value.clamp(0.0, 1.0),
              width: barWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF39FF14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF39FF14).withOpacity(0.9),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
