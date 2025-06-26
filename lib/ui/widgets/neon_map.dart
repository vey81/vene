import 'package:flutter/material.dart';
import 'package:vene/providers/sensor_provider.dart';
import 'package:vene/ui/widgets/track_painter.dart';

class NeonMap extends StatelessWidget {
  final SensorProvider sensor;
  final bool showPremium;

  const NeonMap({
    Key? key,
    required this.sensor,
    required this.showPremium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: showPremium
            ? DecorationImage(
                image: AssetImage('assets/images/your_static_track.jpg'),
                fit: BoxFit.cover,
              )
            : null,
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CustomPaint(
          painter: TrackPainter(polylines: sensor.trackPolylines),
          child: Container(),
        ),
      ),
    );
  }
}
