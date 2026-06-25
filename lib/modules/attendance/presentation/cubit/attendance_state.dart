part of 'attendance_cubit.dart';

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
