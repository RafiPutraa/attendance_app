import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/location_cubit.dart';
import '../../../login/presentation/cubit/auth_cubit.dart';
import '../widgets/add_location_bottom_sheet.dart';
import '../widgets/location_list_item.dart';
import '../widgets/location_search_bar.dart';
import '../widgets/no_locations_placeholder.dart';

class WorkLocationScreen extends StatelessWidget {
  const WorkLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Work Locations',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.role == UserRole.admin) {
                return IconButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const AddLocationBottomSheet(),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 28),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final locations = state.filteredLocations;

          return Column(
            children: [
              const LocationSearchBar(),
              Expanded(
                child: locations.isEmpty
                    ? NoLocationsPlaceholder(
                        isSearching: state.searchQuery.isNotEmpty,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 0,
                        ),
                        itemCount: locations.length,
                        itemBuilder: (context, index) {
                          return LocationListItem(
                            location: locations[index],
                            index: index,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
