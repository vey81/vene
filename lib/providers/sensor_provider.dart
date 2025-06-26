import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vene/models/tire_data.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SensorProvider with ChangeNotifier {
  int _kilometers = 0;
  double _gasValue = 0.0;
  double _brakeValue = 0.0;
  double _speed = 0.0;
  double _tiltAngle = 0.0;
  double _tiltOffset = 0.0;
  Duration _tripTime = Duration.zero;
  DateTime? _tripStartTime;
  bool _isGarageWarningActive = false;

  final List<double> _tiltHistory = [];
  final List<double> _gasHistory = [];
  final List<double> _brakeHistory = [];

  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Set<Polyline> _trackPolylines = {};

  // 🆕 GPS-Trip-Tracking
  Position? _lastGpsPosition;
  double _tripDistance = 0.0;

  // Getter
  int get kilometers => _kilometers;
  double get gasValue => _gasValue;
  double get brakeValue => _brakeValue;
  double get speed => _speed;
  double get tiltAngle => _tiltAngle;
  bool get isGarageWarningActive => _isGarageWarningActive;

  List<double> get tiltHistory => List.unmodifiable(_tiltHistory);
  List<double> get gasHistory => List.unmodifiable(_gasHistory);
  List<double> get brakeHistory => List.unmodifiable(_brakeHistory);

  LatLng? get currentPosition => _currentPosition;
  Set<Polyline> get trackPolylines => _trackPolylines;

  String get tripTimeFormatted {
    final minutes =
        _tripTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _tripTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  String get tripDistanceFormatted => "${_tripDistance.toStringAsFixed(2)} km";

  SensorProvider() {
    _initializeTiltListener();
    _loadGarageWarnings();
    startGpsTracking();
  }

  void _initializeTiltListener() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      double angle = event.x * 90 / 9.81;
      double adjusted = (angle - _tiltOffset).clamp(-65.0, 65.0);
      _tiltAngle = adjusted;
      collectLiveData();
      notifyListeners();
    });
  }

  void resetTiltCenter() {
    _tiltOffset = _tiltAngle + _tiltOffset;
  }

  void updateKilometers(int km) {
    _kilometers = km;
    _loadGarageWarnings();
    notifyListeners();
  }

  void addKilometers(double deltaKm) {
    _kilometers += deltaKm.round();
    _loadGarageWarnings();
    notifyListeners();
  }

  void updateGas(double value) {
    _gasValue = value.clamp(0.0, 1.0);
    collectLiveData();
    notifyListeners();
  }

  void updateBrake(double value) {
    _brakeValue = value.clamp(0.0, 1.0);
    collectLiveData();
    notifyListeners();
  }

  void updateSpeed(double value) {
    _speed = value;
    notifyListeners();
  }

  void startTrip() {
    _tripStartTime = DateTime.now();
    _tripDistance = 0.0;
    _lastGpsPosition = null;
  }

  void updateTripTime() {
    if (_tripStartTime != null) {
      _tripTime = DateTime.now().difference(_tripStartTime!);
      notifyListeners();
    }
  }

  void resetKilometers() {
    _kilometers = 0;
    _tripStartTime = DateTime.now();
    _tripTime = Duration.zero;
    _tripDistance = 0.0;
    _lastGpsPosition = null;
    _loadGarageWarnings();
    notifyListeners();
  }

  void collectLiveData() {
    _tiltHistory.add(_tiltAngle);
    _gasHistory.add(_gasValue);
    _brakeHistory.add(_brakeValue);

    if (_tiltHistory.length > 30) _tiltHistory.removeAt(0);
    if (_gasHistory.length > 30) _gasHistory.removeAt(0);
    if (_brakeHistory.length > 30) _brakeHistory.removeAt(0);
  }

  void setMapController(GoogleMapController? controller) {
    _mapController = controller;
  }

  void updatePosition(LatLng position) {
    _currentPosition = position;
    _addPolylinePoint(position);

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 16),
        ),
      );
    }

    notifyListeners();
  }

  void _addPolylinePoint(LatLng point) {
    final id = const PolylineId("track");
    final List<LatLng> updatedPoints = _trackPolylines
        .firstWhere((p) => p.polylineId == id,
            orElse: () => const Polyline(polylineId: PolylineId("track")))
        .points
        .toList()
      ..add(point);

    _trackPolylines = {
      Polyline(
        polylineId: id,
        color: Colors.cyanAccent,
        width: 3,
        points: updatedPoints,
      )
    };
  }

  void reverseTrack() {
    final id = const PolylineId("track");
    final List<LatLng> currentPoints = _trackPolylines
        .firstWhere((p) => p.polylineId == id,
            orElse: () => const Polyline(polylineId: PolylineId("track")))
        .points
        .toList()
        .reversed
        .toList();

    _trackPolylines = {
      Polyline(
        polylineId: id,
        color: Colors.cyanAccent,
        width: 3,
        points: currentPoints,
      )
    };
    notifyListeners();
  }

  void startGpsTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      final latLng = LatLng(position.latitude, position.longitude);
      updatePosition(latLng);
      _updateGpsTripDistance(position);
    });
  }

  void _updateGpsTripDistance(Position newPos) {
    if (_lastGpsPosition != null) {
      final distance = _calculateDistance(
        _lastGpsPosition!.latitude,
        _lastGpsPosition!.longitude,
        newPos.latitude,
        newPos.longitude,
      );
      if (distance > 0.1) {
        _tripDistance += distance;
        notifyListeners();
      }
    }
    _lastGpsPosition = newPos;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // in km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  Future<void> _loadGarageWarnings() async {
    final prefs = await SharedPreferences.getInstance();
    final double totalKm = _kilometers.toDouble();

    final int oilInterval = prefs.getInt('oel_intervall') ?? 1000;
    final double lastFuelKm = prefs.getDouble('lastFuelKm') ?? 0.0;
    final bool oilWarning = (totalKm - lastFuelKm) > oilInterval;

    final double tankSize = prefs.getDouble('tankSize') ?? 0.0;
    final double lastFuelAmount = prefs.getDouble('lastFuelAmount') ?? 0.0;
    final bool isTankFull = prefs.getBool('isTankFull') ?? false;

    double tankPercent = 100;
    if (!isTankFull && tankSize > 0 && lastFuelAmount > 0) {
      final double usedKm = totalKm - lastFuelKm;
      final double estRange = lastFuelAmount * (tankSize / lastFuelAmount);
      final double remainingKm = estRange - usedKm;
      tankPercent = (remainingKm / estRange * 100).clamp(0, 100);
    }
    final bool tankWarning = tankPercent < 15;

    final String? tuevString = prefs.getString('tuev');
    bool tuevWarning = false;
    if (tuevString != null) {
      try {
        final DateTime tuevDate = DateFormat('yyyy-MM-dd').parse(tuevString);
        final daysLeft = tuevDate.difference(DateTime.now()).inDays;
        tuevWarning = daysLeft < 30;
      } catch (_) {}
    }

    final double rearProfile = prefs.getDouble('rearProfileMm') ?? 0.0;
    final double frontProfile = prefs.getDouble('frontProfileMm') ?? 0.0;
    final String rearModel = prefs.getString('rearModel') ?? '';
    final String frontModel = prefs.getString('frontModel') ?? '';

    bool rearWarn = false;
    bool frontWarn = false;

    final rearTire = allTires.firstWhere(
      (t) => t.model == rearModel,
      orElse: () => TireData(
          brand: '', model: '', type: '', newTreadMm: 5.0, mileageKm: 6000),
    );

    final frontTire = allTires.firstWhere(
      (t) => t.model == frontModel,
      orElse: () => TireData(
          brand: '', model: '', type: '', newTreadMm: 5.0, mileageKm: 6000),
    );

    double rearRestKm =
        (rearProfile / rearTire.newTreadMm) * rearTire.mileageKm;
    double frontRestKm =
        (frontProfile / frontTire.newTreadMm) * frontTire.mileageKm;

    rearWarn = rearProfile < 1.6 || rearRestKm < 500;
    frontWarn = frontProfile < 1.6 || frontRestKm < 500;

    _isGarageWarningActive =
        oilWarning || tankWarning || tuevWarning || rearWarn || frontWarn;
    notifyListeners();
  }
}
