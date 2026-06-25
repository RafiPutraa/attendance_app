import 'package:attendance_app/modules/report/data/models/log_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'log_state.dart';

class LogCubit extends Cubit<LogState> {
  static const String boxName = 'logs_box';

  LogCubit() : super(LogState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      final box = await Hive.openBox<LogModel>(boxName);
      emit(
        state.copyWith(
          logs: box.values.toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addLog(LogModel log) async {
    try {
      final box = Hive.box<LogModel>(boxName);
      await box.put(log.id, log);
      emit(
        state.copyWith(
          logs: box.values.toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteLog(String id) async {
    try {
      final box = Hive.box<LogModel>(boxName);
      await box.delete(id);
      emit(
        state.copyWith(
          logs: box.values.toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> clearLogs() async {
    try {
      final box = Hive.box<LogModel>(boxName);
      await box.clear();
      emit(state.copyWith(logs: []));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
