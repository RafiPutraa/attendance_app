import 'package:flutter/material.dart';
import 'nav_icon.dart';

class HomeBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavIcon(
              icon: Icons.grid_view_rounded,
              selectedIcon: Icons.grid_view_rounded,
              isSelected: selectedIndex == 0,
              onTap: () => onItemSelected(0),
            ),
            NavIcon(
              icon: Icons.map_outlined,
              selectedIcon: Icons.map_rounded,
              isSelected: selectedIndex == 1,
              onTap: () => onItemSelected(1),
            ),
          ],
        ),
      ),
    );
  }
}
