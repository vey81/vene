import 'package:flutter/material.dart';

class OBDDashboardWidget extends StatelessWidget {
  const OBDDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        // Tilt
        Positioned(
          left: 170,
          top: 40,
          child: Text(
            'Tilt',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // Speed
        Positioned(
          left: 340,
          top: 40,
          child: Text(
            'Speed',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // RPM Zahlen
        Positioned(
          left: 510,
          top: 40,
          child: Text(
            'RPM Zahlen',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // Gear
        Positioned(
          left: 40,
          top: 40,
          child: Text(
            'Gear',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // MAP
        Positioned(
          right: 20,
          top: 30,
          child: Text(
            'MAP',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // RPM Animation
        Positioned(
          left: 250,
          top: 100,
          child: Text(
            'RPM Animation',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // Sektor 1
        Positioned(
          left: 100,
          top: 200,
          child: Text(
            'Sektor 1',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // Sektor 2
        Positioned(
          left: 320,
          top: 200,
          child: Text(
            'Sektor 2',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // Sektor 3
        Positioned(
          left: 550,
          top: 200,
          child: Text(
            'Sektor 3',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // Oil
        Positioned(
          left: 120,
          bottom: 150,
          child: Text(
            'Oil',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // Moto Temp
        Positioned(
          left: 220,
          bottom: 150,
          child: Text(
            'Moto Temp',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // Volt
        Positioned(
          left: 320,
          bottom: 150,
          child: Text(
            'Volt',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // Gesamt Zeit
        Positioned(
          left: 500,
          bottom: 150,
          child: Text(
            'Gesamt Zeit',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
