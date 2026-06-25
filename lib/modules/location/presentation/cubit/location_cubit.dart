import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/location_model.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  static const String boxName = 'locations_box';

  LocationCubit() : super(LocationState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      final box = await Hive.openBox<LocationModel>(boxName);
      emit(state.copyWith(locations: box.values.toList(), isLoading: false));
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
