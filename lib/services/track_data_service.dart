import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:vene/services/track_recorder.dart';

class TrackDataService {
  static Future<String> _getTrackDirectoryPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/track_files';
    final trackDir = Directory(path);

    if (!await trackDir.exists()) {
      await trackDir.create(recursive: true);
    }

    return path;
  }

  static Future<void> saveTrack(Track track) async {
    final path = await _getTrackDirectoryPath();
    final file = File('$path/${track.id}.json');
    final jsonString = jsonEncode(track.toJson());
    await file.writeAsString(jsonString);
  }

  static Future<List<Track>> loadAllTracks() async {
    final path = await _getTrackDirectoryPath();
    final trackDir = Directory(path);

    if (!await trackDir.exists()) return [];

    final files = trackDir
        .listSync()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => File(f.path));

    final List<Track> tracks = [];

    for (final file in files) {
      try {
        final jsonStr = await file.readAsString();
        final map = jsonDecode(jsonStr);
        tracks.add(_trackFromJson(map));
      } catch (e) {
        // ignorieren beschädigter Dateien
      }
    }

    return tracks;
  }

  static Track _trackFromJson(Map<String, dynamic> map) {
    return Track(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      distanceKm: (map['distance_km'] as num).toDouble(),
      duration: Duration(seconds: map['duration_seconds']),
      gpsPoints: (map['gps_points'] as List<dynamic>)
          .map((p) => GpsPoint(p['lat'], p['lng']))
          .toList(),
    );
  }

  static Future<void> deleteTrack(String id) async {
    final path = await _getTrackDirectoryPath();
    final file = File('$path/$id.json');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
