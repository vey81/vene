// lib/ui/widgets/obd_dashboard.dart

import 'package:flutter/material.dart';

class OBDDashboard extends StatelessWidget {
  final double progress;
  const OBDDashboard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    // Beispiel-Pointer oder Painter kommt hier rein
    return Container(
      width: 200,
      height: 200,
      color: Colors.transparent,
      child: Center(
        child: Text(
          'Drehzahl: ${(progress * 100).toInt()}%',
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
