import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const CustomBottomNav({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      // Querformat: nur Striche, keine Icons/Labels
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            final isSelected = index == navigationShell.currentIndex;
            return GestureDetector(
              onTap: () => navigationShell.goBranch(index),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      );
    } else {
      // Hochformat: normale NavigationBar
      return NavigationBar(
        height: 60,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.directions_bike),
            label: 'Track',
          ),
          NavigationDestination(
            icon: Icon(Icons.speed),
            label: 'Kombi',
          ),
          NavigationDestination(
            icon: Icon(Icons.garage),
            label: 'Garage',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.gps_fixed),
            label: 'GPS Test',
          ),
          NavigationDestination(
            icon: Icon(Icons.car_repair),
            label: 'OBD',
          ),
        ],
      );
    }
  }
}
