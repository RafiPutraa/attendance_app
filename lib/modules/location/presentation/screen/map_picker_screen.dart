import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';

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
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedPoint = point;
                });
              },
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
                      child: Column(
                        children: [
                          Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(
                                        0.4,
                                      ),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              )
                              .animate()
                              .scale(curve: Curves.elasticOut, duration: 500.ms)
                              .shake(hz: 2),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isDarkMode
                      ? Colors.black.withOpacity(0.4)
                      : Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                  size: 16,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 72,
            right: 72,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: _isDarkMode
                    ? Colors.black.withOpacity(0.4)
                    : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'PICK OFFICE LOCATION',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap precisely on map',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white30 : Colors.black38,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 20,
            child: InkWell(
              onTap: () => setState(() => _isDarkMode = !_isDarkMode),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _isDarkMode
                      ? Colors.black.withOpacity(0.4)
                      : Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                  ),
                ),
                child: Icon(
                  _isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2),
          Positioned(
            bottom: _selectedPoint != null
                ? MediaQuery.of(context).padding.bottom + 115
                : MediaQuery.of(context).padding.bottom + 32,
            right: 20,
            child: Column(
              children: [
                InkWell(
                  onTap: () => _mapController.rotate(0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? Colors.black.withOpacity(0.4)
                          : Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                      ),
                    ),
                    child: Icon(
                      Icons.explore_rounded,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms).scale(),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
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
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? Colors.black.withOpacity(0.4)
                          : Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                      ),
                    ),
                    child: Icon(
                      Icons.my_location_rounded,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).scale(),
              ],
            ),
          ),
          if (_selectedPoint != null)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 32,
              left: 40,
              right: 40,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _selectedPoint),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'CONFIRM LOCATION',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.3),
            ),
          if (_selectedPoint == null)
            Align(
              alignment: Alignment.center,
              child: IgnorePointer(
                child:
                    Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: const Text(
                            'Tap on map to mark location',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fadeIn(duration: 1.seconds)
                        .then(delay: 2.seconds)
                        .fadeOut(duration: 1.seconds),
              ),
            ),
        ],
      ),
    );
  }
}
