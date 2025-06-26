import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vene/models/ghost_model.dart';
import 'package:vene/providers/sensor_provider.dart';
import 'package:vene/services/ghost_load_service.dart';
import 'package:vene/services/ghost_playback_service.dart';
import 'package:vene/services/ghost_save_service.dart';
import 'package:vene/ui/widgets/neon_map.dart';
import 'package:vene/ui/widgets/sensor_bar.dart';
import 'package:vene/ui/widgets/swipe_sheet_widget.dart';
import 'package:vene/ui/widgets/tilt_race_widget.dart';

class TrackModeTab extends StatefulWidget {
  const TrackModeTab({Key? key}) : super(key: key);

  @override
  State<TrackModeTab> createState() => _TrackModeTabState();
}

class _TrackModeTabState extends State<TrackModeTab>
    with SingleTickerProviderStateMixin {
  bool isRecording = false;
  bool reverseDirection = false; // <-- Start/Ziel-Richtungsumschalter
  Stopwatch stopwatch = Stopwatch();
  Duration lastLap = Duration.zero;
  late AnimationController _markerPulseController;

  GhostPlaybackService? _ghostPlaybackService;
  Set<Polyline> _ghostPolyline = {};
  LatLng? _ghostMarkerPosition;
  String? selectedGhostName;

  double ghostTimeDiff = 0.0;

  int _currentSektor = 0;
  List<Duration> sektorTimes = [Duration.zero, Duration.zero, Duration.zero];
  double _sektorDistance = 0.2;

  @override
  void initState() {
    super.initState();
    stopwatch.start();
    _markerPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _markerPulseController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      if (isRecording) {
        lastLap = stopwatch.elapsed;
        stopwatch.stop();
      } else {
        stopwatch.reset();
        stopwatch.start();
        sektorTimes = [Duration.zero, Duration.zero, Duration.zero];
        _currentSektor = 0;
      }
      isRecording = !isRecording;
    });
  }

  void _resetRecording() {
    setState(() {
      stopwatch.reset();
      lastLap = Duration.zero;
      isRecording = false;
      ghostTimeDiff = 0.0;
      sektorTimes = [Duration.zero, Duration.zero, Duration.zero];
      _currentSektor = 0;
    });
  }

  void _toggleDirection() {
    setState(() {
      reverseDirection = !reverseDirection;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reverseDirection
              ? "Fahrtrichtung: Rückwärts"
              : "Fahrtrichtung: Vorwärts"),
        ),
      );
    });
  }

  void _checkSektorUpdate(double distance) {
    if (_currentSektor >= sektorTimes.length) return;

    final currentDist = reverseDirection ? 1.0 - distance : distance;

    if (currentDist > (_currentSektor + 1) * _sektorDistance) {
      final dauer = stopwatch.elapsed;
      sektorTimes[_currentSektor] = dauer;
      _currentSektor++;
    }
  }

  Future<void> _loadGhostTrack(String ghostName) async {
    final loader = GhostLoadService();
    final ghost = await loader.loadGhost(ghostName);
    if (ghost != null) {
      setState(() {
        _ghostPolyline = {
          Polyline(
            polylineId: const PolylineId("ghost"),
            color: Colors.purpleAccent,
            width: 3,
            points: ghost.trackPoints,
          )
        };
        selectedGhostName = ghostName;
      });
    }
  }

  Future<void> _saveGhost() async {
    final sensor = Provider.of<SensorProvider>(context, listen: false);
    final allPoints =
        sensor.trackPolylines.expand((poly) => poly.points).toList();
    if (allPoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Keine Streckendaten verfügbar.")),
      );
      return;
    }

    final ghost = GhostModel(
      name: "Ghost_${DateTime.now().millisecondsSinceEpoch}",
      timestamp: DateTime.now(),
      trackPoints: allPoints,
      sektorTimes: sektorTimes,
    );
    final saveService = GhostSaveService();
    await saveService.saveGhost(ghost);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ghost gespeichert.")),
    );
  }

  void _startGhostPlayback() async {
    if (selectedGhostName == null) return;
    final loader = GhostLoadService();
    final ghost = await loader.loadGhost(selectedGhostName!);
    if (ghost == null) return;

    _ghostPlaybackService?.stop();
    _ghostPlaybackService = GhostPlaybackService(
      ghost: ghost,
      onUpdate: (LatLng pos) {
        setState(() {
          _ghostMarkerPosition = pos;
          final updated = Set<Polyline>.from(_ghostPolyline);
          final points = updated.first.points.toList()..add(pos);
          _ghostPolyline = {
            Polyline(
              polylineId: const PolylineId("ghost"),
              color: Colors.purpleAccent,
              width: 3,
              points: points,
            )
          };
          ghostTimeDiff = (stopwatch.elapsed.inMilliseconds -
                  ghost.sektorTimes.first.inMilliseconds) /
              1000.0;
        });
      },
      onFinish: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ghost Playback beendet.")),
        );
      },
    );
    _ghostPlaybackService?.start();
  }

  void _stopGhostPlayback() {
    _ghostPlaybackService?.stop();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final ms = (d.inMilliseconds.remainder(1000) ~/ 100);
    return "$minutes:$seconds.$ms";
  }

  String _formatGhostDiff(double value) {
    String prefix = value >= 0 ? "+" : "-";
    return "$prefix${value.abs().toStringAsFixed(2)} s";
  }

  Widget _buildButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildGlowSektorBar(String title, double value, Color glowColor) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              glowColor.withOpacity(0.4),
              glowColor,
              glowColor.withOpacity(0.4),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "$title: ${value.toStringAsFixed(1)}",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSektorBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2B2E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FFFF).withOpacity(0.25),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF00FFFF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSektorGlowBereich() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _buildGlowSektorBar("Sektor 1",
                sektorTimes[0].inMilliseconds / 1000, Colors.redAccent),
            const SizedBox(width: 8),
            _buildGlowSektorBar("Sektor 2",
                sektorTimes[1].inMilliseconds / 1000, Colors.greenAccent),
            const SizedBox(width: 8),
            _buildGlowSektorBar("Sektor 3",
                sektorTimes[2].inMilliseconds / 1000, Colors.purpleAccent),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSektorBox("Gesamtzeit", _formatDuration(stopwatch.elapsed)),
            _buildSektorBox("Letzte Zeit", _formatDuration(lastLap)),
            _buildSektorBox("Ghost Diff", _formatGhostDiff(ghostTimeDiff)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensor = Provider.of<SensorProvider>(context);
    final tilt = sensor.tiltAngle;
    final gas = sensor.gasValue;
    final brake = sensor.brakeValue;
    final style = sensor.brakeValue;
    final speed = sensor.speed;
    final distance = sensor.kilometers.toDouble();

    _checkSektorUpdate(distance);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: NeonMap(sensor: sensor, showPremium: !isRecording),
              ),
              const SizedBox(height: 4),
              const Text(
                "Track Mode",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF00FFFF),
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Color(0xFF00FFFF),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TiltRaceWidget(tilt: tilt),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Text(
                                  speed.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00FFFF),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: Color(0xFF00FFFF),
                                      )
                                    ],
                                  ),
                                ),
                                const Text(
                                  "km/h",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Distanz: ${distance.toStringAsFixed(1)} km",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white60,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SensorBar(title: 'Gas', value: gas, barWidth: 16),
                              const SizedBox(width: 8),
                              SensorBar(
                                  title: 'Bremse', value: brake, barWidth: 16),
                              const SizedBox(width: 8),
                              SensorBar(
                                  title: 'Style', value: style, barWidth: 16),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      _buildSektorGlowBereich(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton("Start/Stopp", _toggleRecording,
                              isRecording ? Colors.red : Colors.green),
                          _buildButton("Reset", _resetRecording, Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SwipeSheetWidget(
            onGhostSelected: _loadGhostTrack,
            onGhostSave: _saveGhost,
            onGhostPlayback: _startGhostPlayback,
            onGhostStop: _stopGhostPlayback,
            customButtons: [
              _buildButton(
                "Richtung tauschen",
                () {
                  final sensor =
                      Provider.of<SensorProvider>(context, listen: false);
                  sensor.reverseTrack();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Start- und Zielrichtung getauscht.")),
                  );
                },
                Colors.blueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
