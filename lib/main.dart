import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vene/providers/sensor_provider.dart';
import 'router.dart'; // <-- Import vom final Router

void main() {
  runApp(const VeneApp());
}

class VeneApp extends StatelessWidget {
  const VeneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SensorProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Vene',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Roboto',
        ),
        routerConfig: appRouter, // <-- Hier ist es wichtig!
      ),
    );
  }
}
