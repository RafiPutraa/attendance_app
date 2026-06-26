import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/location_service.dart';
import '../../../location/data/models/location_model.dart';

part 'attendance_state.dart';

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
        String displayDist = distance >= 1000
            ? '${(distance / 1000).toStringAsFixed(2)} km'
            : '${distance.toStringAsFixed(1)} meters';

        emit(
          AttendanceFailure(
            'You are outside the required radius. Current distance: $displayDist\n(Max allowance: 50 meters).',
            distance: distance,
          ),
        );
      }
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
    }
  }

  void reset() {
    emit(AttendanceInitial());
  }
}
