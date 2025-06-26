import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final List<String> _routes = [
    '/track',
    '/kombi',
    '/garage',
    '/profile',
    '/obd',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: orientation == Orientation.portrait
          ? _buildNormalNavBar()
          : _buildMinimalNavBar(),
    );
  }

  BottomNavigationBar _buildNormalNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike), label: 'Track'),
        BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Kombi'),
        BottomNavigationBarItem(icon: Icon(Icons.garage), label: 'Garage'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.car_crash), label: 'OBD'),
      ],
    );
  }

  Widget _buildMinimalNavBar() {
    return Container(
      height: 20, // super schmal
      color: Colors.black.withOpacity(0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_routes.length, (index) {
          return Expanded(
            child: InkWell(
              onTap: () => _onTabTapped(index),
              child: Container(),
            ),
          );
        }),
      ),
    );
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      context.go(_routes[index]);
      setState(() => _currentIndex = index);
    }
  }
}
