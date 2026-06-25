import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/location_model.dart';

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

class MasterLocationCubit extends Cubit<MasterLocationState> {
  static const String boxName = 'locations_box';

  MasterLocationCubit() : super(MasterLocationState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      final box = await Hive.openBox<LocationModel>(boxName);
      emit(state.copyWith(
        locations: box.values.toList(),
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addLocation(LocationModel location) async {
    try {
      final box = Hive.box<LocationModel>(boxName);
      await box.put(location.id, location);
      emit(state.copyWith(locations: box.values.toList()));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteLocation(String id) async {
    try {
      final box = Hive.box<LocationModel>(boxName);
      await box.delete(id);
      emit(state.copyWith(locations: box.values.toList()));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
