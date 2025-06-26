import 'package:flutter/material.dart';
import 'obd_dashboard.dart'; // Import deines Zeiger/Painter-Widgets

class OBDDashboardWidget extends StatelessWidget {
  const OBDDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Hier kannst du ALLES für dein Dashboard platzieren:
    // z.B. Zeiger, Labels, Zahlen.
    return const Center(
      child: OBDDashboard(progress: 0.5), // Beispiel: 50% Drehzahl
    );
  }
}
