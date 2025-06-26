import 'package:flutter/material.dart';

class DebugOverlayWidget extends StatelessWidget {
  const DebugOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Beispiel-Daten – später mit echten Werten aus SensorProvider/GhostProvider ersetzen
    const debugData = {
      'Speed': '92.5 km/h',
      'Lean': '31.4°',
      'GPS': '48.76 / 9.14',
      'Ghost': 'ON',
    };

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: debugData.entries.map((entry) {
          return Text(
            '${entry.key}: ${entry.value}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'Courier',
            ),
          );
        }).toList(),
      ),
    );
  }
}
