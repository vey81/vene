import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GPSTestScreen extends StatefulWidget {
  const GPSTestScreen({super.key});

  @override
  State<GPSTestScreen> createState() => _GPSTestScreenState();
}

class _GPSTestScreenState extends State<GPSTestScreen> {
  Position? _position;
  String _status = 'Warte auf GPS...';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _status = 'GPS ist deaktiviert';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _status = 'Keine Berechtigung';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _status = 'Berechtigung dauerhaft verweigert';
      });
      return;
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _position = position;
        _status = 'GPS aktiv';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Test')),
      body: Center(
        child: _position == null
            ? Text(_status)
            : Text(
                'LAT: ${_position!.latitude}\nLON: ${_position!.longitude}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
      ),
    );
  }
}
