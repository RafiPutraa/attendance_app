import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/location_service.dart';
import '../models/location_model.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final double distance;
  AttendanceSuccess(this.distance);
}

class AttendanceFailure extends AttendanceState {
  final String message;
  final double? distance;
  AttendanceFailure(this.message, {this.distance});
}

class AttendanceCubit extends Cubit<AttendanceState> {
  final LocationService _locationService;

  AttendanceCubit(this._locationService) : super(AttendanceInitial());

  Future<void> submitAttendance(LocationModel target) async {
    emit(AttendanceLoading());
    try {
      final userPosition = await _locationService.getCurrentLocation();
      final distance = _locationService.calculateDistance(
        userPosition.latitude,
        userPosition.longitude,
        target.latitude,
        target.longitude,
      );

      if (distance <= 50) {
        emit(AttendanceSuccess(distance));
      } else {
        emit(AttendanceFailure(
          'Distance too far: ${distance.toStringAsFixed(1)}m. Max radius is 50m.',
          distance: distance,
        ));
      }
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
    }
  }

  void reset() {
    emit(AttendanceInitial());
  }
}
