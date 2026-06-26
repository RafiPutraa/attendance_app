import 'package:flutter/material.dart';

class NoLocationsPlaceholder extends StatelessWidget {
  final bool isSearching;

  const NoLocationsPlaceholder({super.key, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 48,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'No matches found.' : 'No saved locations.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.24),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
