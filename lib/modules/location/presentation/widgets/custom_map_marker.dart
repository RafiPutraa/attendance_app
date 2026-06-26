import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomMapMarker extends StatelessWidget {
  final Color color;

  const CustomMapMarker({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 28,
          ),
        )
            .animate()
            .scale(curve: Curves.elasticOut, duration: 500.ms)
            .shake(hz: 2),
      ],
    );
  }
}
