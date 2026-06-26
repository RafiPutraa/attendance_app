import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../location/data/models/location_model.dart';
import '../../../location/presentation/cubit/location_cubit.dart';

class LocationPickerBottomSheet extends StatefulWidget {
  final LocationModel? initialLocation;
  final ValueChanged<LocationModel> onLocationSelected;

  const LocationPickerBottomSheet({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerBottomSheet> createState() =>
      _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          Colors.black.withOpacity(0.2),
          colorScheme.surface,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Work Location',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select your current placement',
            style: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                cursorColor: colorScheme.primary,
                decoration: InputDecoration(
                  hintText: 'Search office or address...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.25),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white.withOpacity(0.25),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                final filteredLocations = state.locations.where((loc) {
                  final nameMatch = loc.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
                  final addressMatch = loc.address.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
                  return nameMatch || addressMatch;
                }).toList();

                if (filteredLocations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_off_rounded,
                            size: 32,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No saved locations.'
                              : 'No matches found',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: filteredLocations.length,
                  itemBuilder: (context, index) {
                    final loc = filteredLocations[index];
                    final isSelected = widget.initialLocation?.id == loc.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withOpacity(0.05)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          widget.onLocationSelected(loc);
                          Navigator.pop(context);
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color:
                                (isSelected
                                        ? colorScheme.primary
                                        : Colors.white)
                                    .withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            size: 22,
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.white38,
                          ),
                        ),
                        title: Text(
                          loc.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.white,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            loc.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                        trailing: isSelected
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.black,
                                ),
                              )
                            : Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white.withOpacity(0.1),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
