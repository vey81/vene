import 'package:google_maps_flutter/google_maps_flutter.dart';

class GhostModel {
  final String name;
  final DateTime timestamp;
  final List<LatLng> trackPoints;
  final List<Duration> sektorTimes;

  GhostModel({
    required this.name,
    required this.timestamp,
    required this.trackPoints,
    required this.sektorTimes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'timestamp': timestamp.toIso8601String(),
      'trackPoints': trackPoints
          .map((point) => {'lat': point.latitude, 'lng': point.longitude})
          .toList(),
      'sektorTimes': sektorTimes.map((d) => d.inMilliseconds).toList(),
    };
  }

  factory GhostModel.fromJson(Map<String, dynamic> json) {
    return GhostModel(
      name: json['name'],
      timestamp: DateTime.parse(json['timestamp']),
      trackPoints: (json['trackPoints'] as List)
          .map((point) => LatLng(point['lat'], point['lng']))
          .toList(),
      sektorTimes: (json['sektorTimes'] as List)
          .map((ms) => Duration(milliseconds: ms))
          .toList(),
    );
  }
}
