import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vene/models/track.dart'; // ✅ Korrekt eingebundene Track-Klasse

class TrackDetailScreen extends StatefulWidget {
  final File trackFile;

  const TrackDetailScreen({Key? key, required this.trackFile})
      : super(key: key);

  @override
  State<TrackDetailScreen> createState() => _TrackDetailScreenState();
}

class _TrackDetailScreenState extends State<TrackDetailScreen> {
  late Track track;
  late List<LatLng> polylinePoints;
  late LatLng startPoint;
  late LatLng endPoint;

  @override
  void initState() {
    super.initState();
    _loadTrackData();
  }

  void _loadTrackData() async {
    final content = await widget.trackFile.readAsString();
    final map = jsonDecode(content);
    track = Track.fromJson(map);

    polylinePoints =
        track.gpsPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();

    if (polylinePoints.isNotEmpty) {
      startPoint = polylinePoints.first;
      endPoint = polylinePoints.last;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!this.mounted || polylinePoints.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.cyan)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Streckendetails"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: startPoint,
                zoom: 15,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("track"),
                  color: Colors.cyan,
                  width: 5,
                  points: polylinePoints,
                )
              },
              markers: {
                Marker(
                  markerId: const MarkerId("start"),
                  position: startPoint,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ),
                Marker(
                  markerId: const MarkerId("end"),
                  position: endPoint,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDetailRow("Name", track.name),
                _buildDetailRow("Datum",
                    "${track.date.day}.${track.date.month}.${track.date.year}"),
                _buildDetailRow(
                    "Distanz", "${track.distanceKm.toStringAsFixed(2)} km"),
                _buildDetailRow("Dauer",
                    "${track.duration.inMinutes} Min ${track.duration.inSeconds % 60} Sek"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
