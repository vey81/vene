import 'dart:math';
import 'package:vene/models/track.dart';

class TrackSession {
  final Track track;
  final void Function(Duration lapTime) onLapFinished;

  bool _lapRunning = false;
  DateTime? _lapStart;

  late final GpsPoint startMarker;
  late final GpsPoint endMarker;

  TrackSession({
    required this.track,
    required this.onLapFinished,
  }) {
    final startLat = (track.markers?['start']?['lat']) ?? 0.0;
    final startLng = (track.markers?['start']?['lng']) ?? 0.0;
    final endLat = (track.markers?['end']?['lat']) ?? 0.0;
    final endLng = (track.markers?['end']?['lng']) ?? 0.0;

    startMarker = GpsPoint(startLat, startLng);
    endMarker = GpsPoint(endLat, endLng);
  }

  void handleGps(GpsPoint point) {
    const double thresholdMeters = 30;

    if (!_lapRunning &&
        _calculateDistance(point, startMarker) < thresholdMeters) {
      _lapStart = DateTime.now();
      _lapRunning = true;
    }

    if (_lapRunning && _calculateDistance(point, endMarker) < thresholdMeters) {
      if (_lapStart != null) {
        final lapTime = DateTime.now().difference(_lapStart!);
        onLapFinished(lapTime);
        _lapRunning = false;
      }
    }
  }

  double _calculateDistance(GpsPoint a, GpsPoint b) {
    const double R = 6371000;
    final dLat = _degToRad(b.latitude - a.latitude);
    final dLon = _degToRad(b.longitude - a.longitude);
    final lat1 = _degToRad(a.latitude);
    final lat2 = _degToRad(b.latitude);

    final aPart = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(aPart), sqrt(1 - aPart));
    return R * c;
  }

  double _degToRad(double deg) => deg * pi / 180;
}
