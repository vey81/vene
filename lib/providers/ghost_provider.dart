import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GhostProvider with ChangeNotifier {
  final List<LatLng> _currentLap = [];
  final List<LatLng> _bestLap = [];
  bool _isRecording = false;

  bool get isRecording => _isRecording;
  List<LatLng> get currentLap => List.unmodifiable(_currentLap);
  List<LatLng> get bestLap => List.unmodifiable(_bestLap);

  void startRecording() {
    _currentLap.clear();
    _isRecording = true;
    notifyListeners();
  }

  void stopRecording() {
    _isRecording = false;
    if (_bestLap.isEmpty || _currentLap.length < _bestLap.length) {
      _bestLap
        ..clear()
        ..addAll(_currentLap);
    }
    notifyListeners();
  }

  void addPosition(LatLng pos) {
    if (_isRecording) {
      _currentLap.add(pos);
      notifyListeners();
    }
  }

  void reset() {
    _currentLap.clear();
    _bestLap.clear();
    _isRecording = false;
    notifyListeners();
  }
}
