import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogDateHeader extends StatelessWidget {
  final DateTime date;

  const LogDateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final isYesterday = DateUtils.isSameDay(
      date,
      DateTime.now().subtract(const Duration(days: 1)),
    );

    String dateText = DateFormat('EEEE, d MMMM yyyy').format(date);
    if (isToday) dateText = 'Today';
    if (isYesterday) dateText = 'Yesterday';

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16, left: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            dateText.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
