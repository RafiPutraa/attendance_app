import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import '../blocs/master_location_cubit.dart';
import '../blocs/auth_cubit.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';

class MasterLocationScreen extends StatelessWidget {
  const MasterLocationScreen({super.key});

  void _showAddLocationDialog(BuildContext context) async {
    final nameController = TextEditingController();
    LocationModel? tempLocation;
    bool isGettingLocation = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Master Location',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Location Name',
                  prefixIcon: const Icon(Icons.business_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (tempLocation != null)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.gps_fixed, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Geotagged: ${tempLocation!.latitude.toStringAsFixed(5)}, ${tempLocation!.longitude.toStringAsFixed(5)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: isGettingLocation
                      ? null
                      : () async {
                          setModalState(() => isGettingLocation = true);
                          try {
                            final pos = await LocationService()
                                .getCurrentLocation();
                            setModalState(() {
                              tempLocation = LocationModel(
                                id: const Uuid().v4(),
                                name: '',
                                latitude: pos.latitude,
                                longitude: pos.longitude,
                                address: 'Custom Location',
                              );
                              isGettingLocation = false;
                            });
                          } catch (e) {
                            setModalState(() => isGettingLocation = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                  icon: isGettingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(
                    isGettingLocation
                        ? 'Fetching GPS...'
                        : 'Geotag Current Location',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (tempLocation == null || nameController.text.isEmpty)
                    ? null
                    : () {
                        final finalLocation = LocationModel(
                          id: tempLocation!.id,
                          name: nameController.text,
                          latitude: tempLocation!.latitude,
                          longitude: tempLocation!.longitude,
                          address: tempLocation!.address,
                        );
                        context.read<MasterLocationCubit>().addLocation(
                          finalLocation,
                        );
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Save Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Location Master', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.role == UserRole.admin) {
                return IconButton(
                  onPressed: () => _showAddLocationDialog(context),
                  icon: const Icon(Icons.add_circle, size: 30),
                  color: Theme.of(context).colorScheme.primary,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<MasterLocationCubit, MasterLocationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.locations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: 80,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No locations yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _showAddLocationDialog(context),
                    child: const Text('Add your first location'),
                  ),
                ],
              ).animate().fade().scale(),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: state.locations.length,
            itemBuilder: (context, index) {
              final loc = state.locations[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: const Icon(Icons.location_on, color: Colors.indigo),
                  ),
                  title: Text(
                    loc.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  trailing: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      if (authState.role == UserRole.admin) {
                        return IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => context.read<MasterLocationCubit>().deleteLocation(loc.id),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideX();
            },
          );
        },
      ),
    );
  }
}
