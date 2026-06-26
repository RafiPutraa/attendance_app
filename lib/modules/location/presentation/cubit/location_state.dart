part of 'location_cubit.dart';

class LocationState {
  final List<LocationModel> locations;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  LocationState({
    this.locations = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  List<LocationModel> get filteredLocations {
    if (searchQuery.isEmpty) return locations;
    return locations.where((location) {
      final nameMatch = location.name.toLowerCase().contains(searchQuery.toLowerCase());
      final addressMatch = location.address.toLowerCase().contains(searchQuery.toLowerCase());
      return nameMatch || addressMatch;
    }).toList();
  }

  LocationState copyWith({
    List<LocationModel>? locations,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return LocationState(
      locations: locations ?? this.locations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
