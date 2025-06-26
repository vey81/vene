import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Benutzerprofil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF39FF14),
              ),
            ),
            const SizedBox(height: 20),
            _profileRow('Name', 'Max Rider'),
            const SizedBox(height: 10),
            _profileRow('E-Mail', 'max@vene.app'),
            const SizedBox(height: 10),
            _profileRow('Level', 'Pro Racer'),
            const SizedBox(height: 30),
            const Divider(color: Colors.white24),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Später: Logout oder Settings öffnen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F51FF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              child: const Text('Einstellungen'),
            )
          ],
        ),
      ),
    );
  }

  Widget _profileRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
