import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import '../cubit/master_location_cubit.dart';
import '../../data/models/location_model.dart';
import '../../../../services/location_service.dart';
import '../screen/map_picker_screen.dart';
import 'small_action_btn.dart';

class AddLocationBottomSheet extends StatefulWidget {
  const AddLocationBottomSheet({super.key});

  @override
  State<AddLocationBottomSheet> createState() => _AddLocationBottomSheetState();
}

class _AddLocationBottomSheetState extends State<AddLocationBottomSheet> {
  final _nameController = TextEditingController();
  LocationModel? _tempLocation;
  bool _isGettingCurrent = false;
  bool _isGettingMap = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            controller: _nameController,
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
            onChanged: (val) => setState(() {}),
          ),
          const SizedBox(height: 24),
          if (_tempLocation != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                    onPressed: () => setState(() => _tempLocation = null),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                SmallActionBtn(
                  label: 'Current',
                  icon: Icons.gps_fixed,
                  isLoading: _isGettingCurrent,
                  onTap: () async {
                    setState(() => _isGettingCurrent = true);
                    try {
                      final pos = await LocationService().getCurrentLocation();
                      setState(() {
                        _tempLocation = LocationModel(
                          id: const Uuid().v4(),
                          name: _nameController.text,
                          latitude: pos.latitude,
                          longitude: pos.longitude,
                          address: '',
                        );
                        _isGettingCurrent = false;
                      });
                    } catch (e) {
                      setState(() => _isGettingCurrent = false);
                    }
                  },
                ),
                const SizedBox(width: 12),
                SmallActionBtn(
                  label: 'Map',
                  icon: Icons.map_outlined,
                  isLoading: _isGettingMap,
                  onTap: () async {
                    setState(() => _isGettingMap = true);
                    try {
                      final pos = await LocationService().getCurrentLocation();
                      setState(() => _isGettingMap = false);
                      
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPickerScreen(
                            initialCenter: LatLng(pos.latitude, pos.longitude),
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _tempLocation = LocationModel(
                            id: const Uuid().v4(),
                            name: _nameController.text,
                            latitude: result.latitude,
                            longitude: result.longitude,
                            address: '',
                          );
                        });
                      }
                    } catch (e) {
                      setState(() => _isGettingMap = false);
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
              onPressed: (_tempLocation == null || _nameController.text.isEmpty)
                  ? null
                  : () {
                      context.read<MasterLocationCubit>().addLocation(
                            LocationModel(
                              id: _tempLocation!.id,
                              name: _nameController.text,
                              latitude: _tempLocation!.latitude,
                              longitude: _tempLocation!.longitude,
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
    );
  }
}
