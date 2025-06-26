import 'package:flutter/material.dart';

class SwipeSheetWidget extends StatelessWidget {
  final void Function()? onGhostSave;
  final void Function()? onGhostPlayback;
  final void Function()? onGhostStop;
  final void Function(String)? onGhostSelected;
  final List<Widget>? customButtons;

  const SwipeSheetWidget({
    Key? key,
    this.onGhostSave,
    this.onGhostPlayback,
    this.onGhostStop,
    this.onGhostSelected,
    this.customButtons,
  }) : super(key: key);

  Widget _buildActionButton(
      String label, VoidCallback? onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 0.45,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D2B2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView(
          controller: controller,
          children: [
            const Center(
              child: Icon(Icons.keyboard_arrow_up,
                  color: Colors.white70, size: 32),
            ),
            const SizedBox(height: 16),
            _buildActionButton("Ghost speichern", onGhostSave, Colors.teal),
            const SizedBox(height: 12),
            _buildActionButton(
                "Ghost wiedergeben", onGhostPlayback, Colors.purple),
            const SizedBox(height: 12),
            _buildActionButton("Ghost stoppen", onGhostStop, Colors.orange),
            const SizedBox(height: 12),
            ...(customButtons ?? []),
          ],
        ),
      ),
    );
  }
}
