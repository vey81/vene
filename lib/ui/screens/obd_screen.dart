import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/obd_dashboard_widget.dart';

class OBDScreen extends StatelessWidget {
  const OBDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        // SafeArea schützt zuverlässig vor Notch + Home Indicator
        child: Stack(
          children: [
            // 🔵 Hintergrund-SVG bleibt immer fullscreen
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/dashboard.svg',
                fit: BoxFit.contain,
              ),
            ),

            // 🟢 Dein Dashboard Widget drüber
            const OBDDashboardWidget(),
          ],
        ),
      ),
    );
  }
}
