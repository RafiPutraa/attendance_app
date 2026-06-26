import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MapHintOverlay extends StatelessWidget {
  const MapHintOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: const Text(
          'Tap on map to mark location',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .fadeIn(duration: 1.seconds)
          .then(delay: 2.seconds)
          .fadeOut(duration: 1.seconds),
    );
  }
}
