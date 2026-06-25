import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../location/data/models/location_model.dart';
import '../../../location/presentation/cubit/location_cubit.dart';

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
                'Work Location',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
              value: selectedLocation,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }
}
