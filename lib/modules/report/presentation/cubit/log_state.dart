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
