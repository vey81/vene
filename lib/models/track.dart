import 'dart:convert';

class GpsPoint {
  final double latitude;
  final double longitude;

  GpsPoint(this.latitude, this.longitude);

  Map<String, dynamic> toJson() => {
        'lat': latitude,
        'lng': longitude,
      };

  factory GpsPoint.fromJson(Map<String, dynamic> json) {
    return GpsPoint(
      json['lat'],
      json['lng'],
    );
  }
}

class Track {
  final String id;
  final String name;
  final DateTime date;
  final double distanceKm;
  final Duration duration;
  final List<GpsPoint> gpsPoints;

  final Map<String, Map<String, double>>? markers;

  Track({
    required this.id,
    required this.name,
    required this.date,
    required this.distanceKm,
    required this.duration,
    required this.gpsPoints,
    this.markers,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date.toIso8601String(),
        'distance_km': distanceKm,
        'duration_seconds': duration.inSeconds,
        'gps_points': gpsPoints.map((p) => p.toJson()).toList(),
        'markers': markers,
      };

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      distanceKm: (json['distance_km'] as num).toDouble(),
      duration: Duration(seconds: json['duration_seconds']),
      gpsPoints: (json['gps_points'] as List)
          .map((p) => GpsPoint.fromJson(p))
          .toList(),
      markers: (json['markers'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          Map<String, double>.from(value),
        ),
      ),
    );
  }
}
