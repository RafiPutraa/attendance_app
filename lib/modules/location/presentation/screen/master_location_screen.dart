import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/master_location_cubit.dart';
import '../../../login/presentation/cubit/auth_cubit.dart';

import '../widgets/add_location_bottom_sheet.dart';
import '../widgets/location_list_item.dart';

class MasterLocationScreen extends StatelessWidget {
  const MasterLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Locations',
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
      body: BlocBuilder<MasterLocationCubit, MasterLocationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.locations.isEmpty) {
            return const Center(
              child: Text(
                'No saved locations.',
                style: TextStyle(color: Colors.white24),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            itemCount: state.locations.length,
            itemBuilder: (context, index) {
              return LocationListItem(
                location: state.locations[index],
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}
