import 'package:attendance_app/modules/report/presentation/widgets/log_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../cubit/log_cubit.dart';

class AdminReportScreen extends StatelessWidget {
  const AdminReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Attendance Logs',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          BlocBuilder<LogCubit, LogState>(
            builder: (context, state) {
              if (state.logs.isEmpty) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextButton(
                  onPressed: () => _confirmClear(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.08),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: BlocBuilder<LogCubit, LogState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
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

          final Map<DateTime, List<dynamic>> groupedLogs = {};
          final sortedLogs = List.from(state.logs)
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

          for (var log in sortedLogs) {
            final date = DateTime(
              log.timestamp.year,
              log.timestamp.month,
              log.timestamp.day,
            );
            if (!groupedLogs.containsKey(date)) {
              groupedLogs[date] = [];
            }
            groupedLogs[date]!.add(log);
          }

          final sortedDates = groupedLogs.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          final List<dynamic> flattenedItems = [];
          for (var date in sortedDates) {
            flattenedItems.add(date);
            flattenedItems.addAll(groupedLogs[date]!);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            itemCount: flattenedItems.length,
            itemBuilder: (context, index) {
              final item = flattenedItems[index];

              if (item is DateTime) {
                final isToday = DateUtils.isSameDay(item, DateTime.now());
                final isYesterday = DateUtils.isSameDay(
                  item,
                  DateTime.now().subtract(const Duration(days: 1)),
                );

                String dateText = DateFormat('EEEE, d MMMM yyyy').format(item);
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
                ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.05);
              }

              final log = item;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (bottomSheetContext) => LogDetailBottomSheet(
                        log: log,
                        onDelete: () async {
                          final confirm = await _confirmDelete(
                            context,
                            log.username,
                          );

                          if (confirm == true && context.mounted) {
                            context.read<LogCubit>().deleteLog(log.id);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              log.username[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.username,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 13,
                                    color: Colors.white.withOpacity(0.15),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      log.locationName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.25),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Clock In:",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.25),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('HH:mm').format(log.timestamp),
                                    style: TextStyle(
                                      color: colorScheme.primary.withOpacity(0.8),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: (index * 40).ms).slideX(begin: 0.02);
            },
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All Logs?'),
        content: const Text(
          'This action cannot be undone. All attendance history will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white38),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<LogCubit>().clearLogs();
              Navigator.pop(context);
            },
            child: const Text(
              'CLEAR ALL',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String username) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Log?'),
        content: Text('Delete attendance history for $username?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white38),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
