import 'dart:async';
import 'dart:math';
import 'package:location/location.dart';
import 'package:vene/models/track.dart';
import 'package:vene/services/track_data_service.dart'; // ✅ Wichtig

class TrackRecorder {
  final Location _location = Location();
  bool _recording = false;
  List<GpsPoint> _points = [];
  DateTime? _startTime;

  StreamSubscription<LocationData>? _subscription;

  Future<void> startRecording(
    String trackName, {
    Map<String, Map<String, double>>? markers,
  }) async {
    _points = [];
    _startTime = DateTime.now();
    _recording = true;

    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _subscription = _location.onLocationChanged.listen((locationData) {
      if (!_recording ||
          locationData.latitude == null ||
          locationData.longitude == null) return;

      _points.add(GpsPoint(locationData.latitude!, locationData.longitude!));
    });
  }

  Stream<LocationData> get onLocationStream => _location.onLocationChanged;

  Future<Track?> stopRecording(
    String trackName, {
    Map<String, Map<String, double>>? markers,
  }) async {
    _recording = false;
    await _subscription?.cancel();

    final endTime = DateTime.now();
    if (_startTime == null || _points.length < 2) return null;

    final duration = endTime.difference(_startTime!);
    final distanceKm = _calculateDistance();

    final track = Track(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: trackName,
      date: _startTime!,
      distanceKm: distanceKm,
      duration: duration,
      gpsPoints: _points,
      markers: markers,
    );

    // ✅ SPEICHERN
    await TrackDataService.saveTrack(track);

    return track;
  }

  double _calculateDistance() {
    double distance = 0.0;
    for (int i = 0; i < _points.length - 1; i++) {
      distance += _haversineDistance(
        _points[i].latitude,
        _points[i].longitude,
        _points[i + 1].latitude,
        _points[i + 1].longitude,
      );
    }
    return distance;
  }

  double _haversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * pi / 180;
}
