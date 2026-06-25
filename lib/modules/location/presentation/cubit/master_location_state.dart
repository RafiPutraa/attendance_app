part of 'master_location_cubit.dart';

class MasterLocationState {
  final List<LocationModel> locations;
  final bool isLoading;
  final String? error;

  MasterLocationState({
    this.locations = const [],
    this.isLoading = false,
    this.error,
  });

  MasterLocationState copyWith({
    List<LocationModel>? locations,
    bool? isLoading,
    String? error,
  }) {
    return MasterLocationState(
      locations: locations ?? this.locations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
