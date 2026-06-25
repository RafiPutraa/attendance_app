import 'package:attendance_app/modules/login/presentation/cubit/auth_cubit.dart';
import 'package:attendance_app/modules/report/data/models/log_model.dart';
import 'package:attendance_app/modules/report/presentation/cubit/log_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/attendance_cubit.dart';
import '../../../location/data/models/location_model.dart';
import '../widgets/location_selector.dart';
import '../widgets/attendance_button.dart';
import '../widgets/attendance_result_dialog.dart';
import 'package:uuid/uuid.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  LocationModel? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceSuccess) {
            final authState = context.read<AuthCubit>().state;
            context.read<LogCubit>().addLog(
              LogModel(
                id: const Uuid().v4(),
                username: authState.username!,
                locationName: _selectedLocation?.name ?? 'Unknown',
                timestamp: DateTime.now(),
                status: 'Success',
              ),
            );

            showDialog(
              context: context,
              builder: (context) => const AttendanceResultDialog(
                success: true,
                message: 'Success',
                details: 'Attendance recorded successfully.',
              ),
            );
          } else if (state is AttendanceFailure) {
            showDialog(
              context: context,
              builder: (context) => AttendanceResultDialog(
                success: false,
                message: 'Rejected',
                details: state.message,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const Text(
                'Please select your current work location.',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
              const SizedBox(height: 48),
              LocationSelector(
                selectedLocation: _selectedLocation,
                onChanged: (val) => setState(() => _selectedLocation = val),
              ),
              const Spacer(),
              Center(
                child: AttendanceButton(
                  selectedLocation: _selectedLocation,
                  onTap: () => context.read<AttendanceCubit>().submitAttendance(
                    _selectedLocation!,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
