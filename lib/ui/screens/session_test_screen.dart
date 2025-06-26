import 'package:flutter/material.dart';
import 'package:vene/ui/screens/garage_screen.dart';

class SessionTestScreen extends StatefulWidget {
  const SessionTestScreen({super.key});

  @override
  State<SessionTestScreen> createState() => _SessionTestScreenState();
}

class _SessionTestScreenState extends State<SessionTestScreen> {
  int _tapCounter = 0;
  DateTime _lastTap = DateTime.now();

  void _handleTap() {
    final now = DateTime.now();
    if (now.difference(_lastTap).inSeconds > 2) {
      _tapCounter = 1;
    } else {
      _tapCounter++;
    }

    _lastTap = now;

    if (_tapCounter >= 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GarageScreen()),
      );
      _tapCounter = 0; // Reset nach Navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Tap 5x schnell für Hidden Feature',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
