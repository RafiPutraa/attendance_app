import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/location_model.dart';
import '../../../login/presentation/cubit/auth_cubit.dart';
import '../cubit/location_cubit.dart';
import 'delete_location_dialog.dart';

class LocationListItem extends StatelessWidget {
  final LocationModel location;
  final int index;

  const LocationListItem({
    super.key,
    required this.location,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAdmin = context.read<AuthCubit>().state.role == UserRole.admin;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
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
                  location.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  location.address,
                  style: const TextStyle(color: Colors.white24, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                color: Colors.redAccent,
                size: 20,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DeleteLocationDialog(
                    onDelete: () => context
                        .read<LocationCubit>()
                        .deleteLocation(location.id),
                  ),
                );
              },
            ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
  }
}
