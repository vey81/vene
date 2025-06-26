import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Profil',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
