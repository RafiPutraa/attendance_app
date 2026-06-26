import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/map_picker_header.dart';
import '../widgets/map_picker_controls.dart';
import '../widgets/confirm_location_button.dart';
import '../widgets/custom_map_marker.dart';
import '../widgets/map_theme_toggle.dart';
import '../widgets/map_hint_overlay.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng initialCenter;

  const MapPickerScreen({super.key, required this.initialCenter});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _selectedPoint;
  final MapController _mapController = MapController();
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: 15.0,
              onTap: (_, point) => setState(() => _selectedPoint = point),
            ),
            children: [
              TileLayer(
                urlTemplate: _isDarkMode
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.attendance_app',
              ),
              if (_selectedPoint != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPoint!,
                      width: 80,
                      height: 80,
                      child: CustomMapMarker(color: colorScheme.primary),
                    ),
                  ],
                ),
            ],
          ),
          MapPickerHeader(
            isDarkMode: _isDarkMode,
            onBack: () => Navigator.pop(context),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 20,
            child: MapThemeToggle(
              isDarkMode: _isDarkMode,
              onToggle: () => setState(() => _isDarkMode = !_isDarkMode),
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2),
          MapPickerControls(
            isDarkMode: _isDarkMode,
            hasSelection: _selectedPoint != null,
            onResetRotation: () => _mapController.rotate(0),
            onFindMe: () async {
              final lastPos = await Geolocator.getLastKnownPosition();
              if (lastPos != null) {
                _mapController.move(
                  LatLng(lastPos.latitude, lastPos.longitude),
                  15.0,
                );
              }
              try {
                final position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high,
                );
                _mapController.move(
                  LatLng(position.latitude, position.longitude),
                  15.0,
                );
              } catch (e) {
                debugPrint('Error getting location: $e');
              }
            },
          ),
          if (_selectedPoint != null)
            ConfirmLocationButton(
              onTap: () => Navigator.pop(context, _selectedPoint),
            ),
          if (_selectedPoint == null) const MapHintOverlay(),
        ],
      ),
    );
  }
}
