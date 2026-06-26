import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/location_cubit.dart';
import '../../../login/presentation/cubit/auth_cubit.dart';
import '../widgets/add_location_bottom_sheet.dart';
import '../widgets/location_list_item.dart';

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
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: TextField(
                    onChanged: (value) =>
                        context.read<LocationCubit>().setSearchQuery(value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search office or address...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.white.withOpacity(0.35),
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
              Expanded(
                child: locations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off_outlined,
                              size: 48,
                              color: Colors.white.withOpacity(0.1),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.searchQuery.isEmpty
                                  ? 'No saved locations.'
                                  : 'No matches found.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.24),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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
