import 'package:flutter/material.dart';

class AnimatedGhostMarker extends StatefulWidget {
  const AnimatedGhostMarker({Key? key}) : super(key: key);

  @override
  State<AnimatedGhostMarker> createState() => _AnimatedGhostMarkerState();
}

class _AnimatedGhostMarkerState extends State<AnimatedGhostMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _radiusAnimation = Tween<double>(begin: 10, end: 18).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _radiusAnimation,
      builder: (context, child) {
        return Container(
          width: _radiusAnimation.value,
          height: _radiusAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 4,
              ),
            ],
          ),
        );
      },
    );
  }
}
