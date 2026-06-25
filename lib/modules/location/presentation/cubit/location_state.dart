part of 'location_cubit.dart';

class LocationState {
  final List<LocationModel> locations;
  final bool isLoading;
  final String? error;

  LocationState({
    this.locations = const [],
    this.isLoading = false,
    this.error,
  });

  LocationState copyWith({
    List<LocationModel>? locations,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      locations: locations ?? this.locations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
