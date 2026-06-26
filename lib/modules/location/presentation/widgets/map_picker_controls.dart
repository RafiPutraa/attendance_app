import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MapPickerControls extends StatelessWidget {
  final bool isDarkMode;
  final bool hasSelection;
  final VoidCallback onResetRotation;
  final VoidCallback onFindMe;

  const MapPickerControls({
    super.key,
    required this.isDarkMode,
    required this.hasSelection,
    required this.onResetRotation,
    required this.onFindMe,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      bottom: hasSelection
          ? MediaQuery.of(context).padding.bottom + 115
          : MediaQuery.of(context).padding.bottom + 32,
      right: 20,
      child: Column(
        children: [
          _buildToolButton(
            icon: Icons.explore_rounded,
            onTap: onResetRotation,
            colorScheme: colorScheme,
            delay: 100.ms,
          ),
          const SizedBox(height: 12),
          _buildToolButton(
            icon: Icons.my_location_rounded,
            onTap: onFindMe,
            colorScheme: colorScheme,
            delay: 200.ms,
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required Duration delay,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.black.withOpacity(0.4)
              : Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 22),
      ),
    ).animate().fadeIn(delay: delay).scale();
  }
}
