import 'package:flutter/material.dart';
import 'nav_icon.dart';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final bool isAdmin;
  final Function(int) onTap;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.isAdmin,
    required this.onTap,
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
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            NavIcon(
              icon: Icons.map_outlined,
              selectedIcon: Icons.map_rounded,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            if (isAdmin)
              NavIcon(
                icon: Icons.bar_chart_outlined,
                selectedIcon: Icons.bar_chart_rounded,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
          ],
        ),
      ),
    );
  }
}
