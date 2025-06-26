import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vene/providers/sensor_provider.dart';
import 'package:vene/ui/widgets/tilt_gauge_widget.dart';

class CombiScreen extends StatefulWidget {
  const CombiScreen({super.key});

  @override
  State<CombiScreen> createState() => _CombiScreenState();
}

class _CombiScreenState extends State<CombiScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensor = Provider.of<SensorProvider>(context);

    final Color neonCyan = const Color(0xFF00FFFF);
    final Color neonRed = const Color(0xFFFF1744);
    final Color neonGreen = const Color(0xFF00E676);
    final Color darkGray = const Color(0xFF1A1A1A);

    final bool warningActive = sensor.isGarageWarningActive;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Kartenbereich mit Google Map
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: neonCyan.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: neonCyan.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: sensor.currentPosition ??
                        const LatLng(48.137154, 11.576124),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  polylines: sensor.trackPolylines,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    sensor.setMapController(controller);
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Tilt + Tank & Warnsymbol + Balken
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text("Schräglage",
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      TiltGaugeWidget(angle: sensor.tiltAngle),
                      const SizedBox(height: 6),
                      TextButton.icon(
                        onPressed: () => sensor.resetTiltCenter(),
                        icon: const Icon(Icons.center_focus_strong,
                            color: Colors.white70, size: 18),
                        label: const Text("Zentrieren",
                            style: TextStyle(color: Colors.white70)),
                        style: TextButton.styleFrom(
                          foregroundColor: neonCyan,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      children: [
                        Icon(Icons.local_gas_station,
                            color: darkGray, size: 22),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            const Text("Distanz",
                                style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 6),
                            Text("${sensor.kilometers} km",
                                style: TextStyle(
                                    color: neonCyan,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(width: 12),
                        AnimatedBuilder(
                          animation: _blinkController,
                          builder: (context, child) {
                            final color = warningActive
                                ? neonRed.withOpacity(
                                    0.5 + 0.5 * _blinkController.value)
                                : darkGray;
                            return Column(
                              children: [
                                Icon(Icons.warning_amber_rounded,
                                    color: color, size: 22),
                                const SizedBox(height: 2),
                                Text("GARAGE",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: color,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    )),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildBar("Gas", sensor.gasValue, neonGreen),
                      const SizedBox(width: 10),
                      _buildBar("Bremse", sensor.brakeValue, neonRed),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text("${sensor.speed.toStringAsFixed(0)} km/h",
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: neonCyan,
                  shadows: [
                    Shadow(
                        color: neonCyan.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2)),
                  ],
                )),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer,
                              color: Colors.white70, size: 18),
                          const SizedBox(width: 6),
                          Text("Trip: ${sensor.tripTimeFormatted}",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 15)),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.wb_sunny_outlined,
                              color: Colors.amberAccent, size: 20),
                          SizedBox(width: 6),
                          Text("21°C – Klar",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => sensor.resetKilometers(),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Sensoren zurücksetzen"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: neonCyan,
                        elevation: 0,
                        side: BorderSide(color: neonCyan.withOpacity(0.8)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Container(
          height: 80,
          width: 16,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.7), width: 1.2),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80 * value.clamp(0.0, 1.0),
              width: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(6)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
