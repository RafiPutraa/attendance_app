import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/attendance_cubit.dart';
import '../../../location/data/models/location_model.dart';

class PunchButton extends StatelessWidget {
  final LocationModel? selectedLocation;
  final VoidCallback onPunch;

  const PunchButton({
    super.key,
    required this.selectedLocation,
    required this.onPunch,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        final isLoading = state is AttendanceLoading;
        return GestureDetector(
          onTap: (selectedLocation == null || isLoading) ? null : onPunch,
          child: AnimatedContainer(
            duration: 300.ms,
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: selectedLocation == null
                  ? colorScheme.surface
                  : colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedLocation == null
                    ? Colors.white10
                    : colorScheme.primary.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: selectedLocation == null
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
                    color: selectedLocation == null
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
                      color: selectedLocation == null
                          ? Colors.white10
                          : colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ).animate(target: selectedLocation != null ? 1 : 0).scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1, 1),
            );
      },
    );
  }
}
