import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../blocs/attendance_cubit.dart';
import '../blocs/master_location_cubit.dart';
import '../models/location_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  LocationModel? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BlocListener<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceSuccess) {
            _showResultDialog(
              context,
              success: true,
              message: 'Success',
              details: 'Attendance recorded successfully.',
            );
          } else if (state is AttendanceFailure) {
            _showResultDialog(
              context,
              success: false,
              message: 'Rejected',
              details: state.message,
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
              _buildLocationDropdown(colorScheme),
              const Spacer(),
              Center(child: _buildMainAction(colorScheme)),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDropdown(ColorScheme colorScheme) {
    return BlocBuilder<MasterLocationCubit, MasterLocationState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<LocationModel>(
              isExpanded: true,
              hint: const Text(
                'Target Location',
                style: TextStyle(color: Colors.white38),
              ),
              value: _selectedLocation,
              dropdownColor: colorScheme.surface,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white24,
              ),
              items: state.locations.map((loc) {
                return DropdownMenuItem(
                  value: loc,
                  child: Text(
                    loc.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedLocation = val),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainAction(ColorScheme colorScheme) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        final isLoading = state is AttendanceLoading;
        return GestureDetector(
              onTap: (_selectedLocation == null || isLoading)
                  ? null
                  : () => context.read<AttendanceCubit>().submitAttendance(
                      _selectedLocation!,
                    ),
              child: AnimatedContainer(
                duration: 300.ms,
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: _selectedLocation == null
                      ? colorScheme.surface
                      : colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedLocation == null
                        ? Colors.white10
                        : colorScheme.primary.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: _selectedLocation == null
                      ? []
                      : [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.2),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const CircularProgressIndicator(strokeWidth: 2)
                    else ...[
                      Icon(
                        Icons.fingerprint_rounded,
                        size: 80,
                        color: _selectedLocation == null
                            ? Colors.white10
                            : colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'PUNCH IN',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          fontSize: 12,
                          color: _selectedLocation == null
                              ? Colors.white10
                              : colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )
            .animate(target: _selectedLocation != null ? 1 : 0)
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
      },
    );
  }

  void _showResultDialog(
    BuildContext context, {
    required bool success,
    required String message,
    required String details,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (success ? Colors.green : Colors.redAccent).withOpacity(
                  0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                success ? Icons.check_rounded : Icons.close_rounded,
                color: success ? Colors.green : Colors.redAccent,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              details,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AttendanceCubit>().reset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.05),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'DISMISS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
