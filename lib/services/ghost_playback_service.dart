import 'package:flutter/foundation.dart'; // ✅ FÜR VoidCallback
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vene/models/ghost_model.dart';
import 'dart:async';

class GhostPlaybackService {
  final GhostModel ghost;
  final Duration stepDuration;
  final void Function(LatLng position) onUpdate;
  final VoidCallback? onFinish;

  Timer? _timer;
  int _currentIndex = 0;
  bool _isPlaying = false;

  GhostPlaybackService({
    required this.ghost,
    required this.onUpdate,
    this.onFinish,
    this.stepDuration = const Duration(milliseconds: 300),
  });

  void start() {
    if (ghost.trackPoints.isEmpty) return;
    _isPlaying = true;
    _currentIndex = 0;
    _timer = Timer.periodic(stepDuration, (timer) {
      if (_currentIndex >= ghost.trackPoints.length) {
        stop();
        onFinish?.call();
        return;
      }
      onUpdate(ghost.trackPoints[_currentIndex]);
      _currentIndex++;
    });
  }

  void stop() {
    _timer?.cancel();
    _isPlaying = false;
  }

  void reset() {
    stop();
    _currentIndex = 0;
  }

  bool get isPlaying => _isPlaying;
}
