import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GhostMarkerWidget extends StatelessWidget {
  final LatLng position;
  final double mapHeight;

  const GhostMarkerWidget({
    Key? key,
    required this.position,
    required this.mapHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Rechnet die Markerposition (vereinfacht, da MapController nicht exakt abgefragt wird)
    final width = MediaQuery.of(context).size.width;

    return Positioned(
      top: mapHeight / 2 - 12,
      left: width / 2 - 12,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.6),
              blurRadius: 18,
              spreadRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}
