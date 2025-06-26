import 'package:vene/services/track_recorder.dart';
import 'package:vene/services/track_session.dart';

class TrackManager {
  TrackSession? _currentSession;

  void startSession(Track track, void Function(Duration) onLapFinished) {
    _currentSession = TrackSession(track: track, onLapFinished: onLapFinished);
  }

  void stopSession() {
    _currentSession = null;
  }

  void handleGpsData(GpsPoint point) {
    _currentSession?.handleGps(point);
  }

  bool get isSessionRunning => _currentSession != null;
}
