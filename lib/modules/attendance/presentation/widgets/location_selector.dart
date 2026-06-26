import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../location/data/models/location_model.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import 'location_picker_bottom_sheet.dart';

class LocationSelector extends StatelessWidget {
  final LocationModel? selectedLocation;
  final ValueChanged<LocationModel?> onChanged;

  const LocationSelector({
    super.key,
    required this.selectedLocation,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => LocationPickerBottomSheet(
                initialLocation: selectedLocation,
                onLocationSelected: onChanged,
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedLocation?.name ?? 'Select Work Location',
                    style: TextStyle(
                      color: selectedLocation == null
                          ? Colors.white.withOpacity(0.4)
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: selectedLocation == null
                          ? FontWeight.w500
                          : FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withOpacity(0.25),
                  size: 22,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
