part of 'log_cubit.dart';

class LogState {
  final List<LogModel> logs;
  final bool isLoading;
  final String? error;

  LogState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
  });

  List<dynamic> get flattenedItems {
    if (logs.isEmpty) return [];

    final Map<DateTime, List<LogModel>> groupedLogs = {};
    for (var log in logs) {
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

    final List<dynamic> items = [];
    for (var date in sortedDates) {
      items.add(date);
      items.addAll(groupedLogs[date]!);
    }
    return items;
  }

  LogState copyWith({
    List<LogModel>? logs,
    bool? isLoading,
    String? error,
  }) {
    return LogState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
