import 'package:flutter/material.dart';

class RpmBar extends StatelessWidget {
  final double rpmPercent; // 0.0 bis 1.0
  final int rpmValue;

  const RpmBar({
    Key? key,
    required this.rpmPercent,
    required this.rpmValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (rpmPercent < 0.5) return Colors.cyanAccent;
      if (rpmPercent < 0.8) return Colors.purpleAccent;
      return Colors.redAccent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[900],
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: rpmPercent.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: getColor(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$rpmValue RPM",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
