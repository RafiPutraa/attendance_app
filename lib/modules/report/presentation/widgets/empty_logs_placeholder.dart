import 'package:flutter/material.dart';

class EmptyLogsPlaceholder extends StatelessWidget {
  const EmptyLogsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.history_toggle_off_rounded,
            size: 64,
            color: Colors.white10,
          ),
          const SizedBox(height: 16),
          const Text(
            'No logs recorded yet.',
            style: TextStyle(color: Colors.white24),
          ),
        ],
      ),
    );
  }
}
