import 'package:attendance_app/modules/report/presentation/widgets/log_detail_bottom_sheet.dart';
import 'package:attendance_app/modules/report/presentation/widgets/log_date_header.dart';
import 'package:attendance_app/modules/report/presentation/widgets/log_item_card.dart';
import 'package:attendance_app/modules/report/presentation/widgets/empty_logs_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/log_cubit.dart';

class AdminReportScreen extends StatelessWidget {
  const AdminReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            return const EmptyLogsPlaceholder();
          }

          final items = state.flattenedItems;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              if (item is DateTime) {
                return LogDateHeader(date: item)
                    .animate()
                    .fadeIn(delay: (index * 50).ms)
                    .slideX(begin: 0.05);
              }

              final log = item;

              return LogItemCard(
                log: log,
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
