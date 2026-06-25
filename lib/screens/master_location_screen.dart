import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import '../blocs/master_location_cubit.dart';
import '../blocs/auth_cubit.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';
import 'map_picker_screen.dart';

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
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            top: 32,
            left: 32,
            right: 32,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Location',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nameController,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Location Name',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (tempLocation != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Coordinates Set',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 18),
                        onPressed: () =>
                            setModalState(() => tempLocation = null),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  children: [
                    _SmallActionBtn(
                      label: 'Curent',
                      icon: Icons.gps_fixed,
                      isLoading: isGettingLocation,
                      onTap: () async {
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
                              address: '',
                            );
                            isGettingLocation = false;
                          });
                        } catch (e) {
                          setModalState(() => isGettingLocation = false);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    _SmallActionBtn(
                      label: 'Map',
                      icon: Icons.map_outlined,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapPickerScreen(),
                          ),
                        );
                        if (result != null) {
                          setModalState(() {
                            tempLocation = LocationModel(
                              id: const Uuid().v4(),
                              name: '',
                              latitude: result.latitude,
                              longitude: result.longitude,
                              address: '',
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed:
                      (tempLocation == null || nameController.text.isEmpty)
                      ? null
                      : () {
                          context.read<MasterLocationCubit>().addLocation(
                            LocationModel(
                              id: tempLocation!.id,
                              name: nameController.text,
                              latitude: tempLocation!.latitude,
                              longitude: tempLocation!.longitude,
                              address: '',
                            ),
                          );
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'SAVE LOCATION',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  onPressed: () => _showAddLocationDialog(context),
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
              final loc = state.locations[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.03)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Colors.white38,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${loc.latitude.toStringAsFixed(3)}, ${loc.longitude.toStringAsFixed(3)}',
                            style: const TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (context.read<AuthCubit>().state.role == UserRole.admin)
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              surfaceTintColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              title: const Text(
                                'Delete Location?',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'Are you sure you want to remove this location?',
                                style: TextStyle(color: Colors.white60),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'CANCEL',
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<MasterLocationCubit>()
                                        .deleteLocation(loc.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'DELETE',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
            },
          );
        },
      ),
    );
  }
}

class _SmallActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _SmallActionBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(icon, size: 18, color: Colors.white54),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
