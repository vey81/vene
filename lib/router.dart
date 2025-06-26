import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/widgets/main_scaffold.dart';
import 'ui/screens/track_mode_tab.dart'; // ✅ korrekt!
import 'ui/screens/combi_screen.dart'; // ✅ korrekt!
import 'ui/screens/garage_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/screens/obd_screen.dart';
import 'ui/screens/gps_test_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/track',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/track',
          builder: (context, state) => const TrackModeTab(), // ✅ exakt
        ),
        GoRoute(
          path: '/kombi',
          builder: (context, state) => const CombiScreen(), // ✅ exakt
        ),
        GoRoute(
          path: '/garage',
          builder: (context, state) => const GarageScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/obd',
          builder: (context, state) => const OBDScreen(),
        ),
        GoRoute(
          path: '/gps',
          builder: (context, state) => const GPSTestScreen(),
        ),
      ],
    ),
  ],
);
