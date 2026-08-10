import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/features/units_of_measure/presentation/providers/unit_of_measure_provider.dart';

final createUnitProvider =
AsyncNotifierProvider<
    CreateUnitNotifier,
    void>(
  CreateUnitNotifier.new,
);

class CreateUnitNotifier
    extends AsyncNotifier<void> {

  @override
  Future<void> build() async {}

  Future<void> create({
    required String name,
    required String abbreviation,
  }) async {

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {

      final repository =
      ref.read(
        unitsOfMeasureRepositoryProvider,
      );

      await repository.createUnitOfMeasure(
        name: name,
        abbreviation: abbreviation,
      );

      ref.invalidate(
        unitsOfMeasureProvider,
      );
    });
  }

  Future<void> updateUnit({
    required int id,
    required String name,
    required String abbreviation,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(unitsOfMeasureRepositoryProvider);
      await repository.updateUnitOfMeasure(
        id: id,
        name: name,
        abbreviation: abbreviation,
      );
      ref.invalidate(unitsOfMeasureProvider);
    });
  }

  Future<void> deleteUnit(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(unitsOfMeasureRepositoryProvider);
      await repository.deleteUnitOfMeasure(id);
      ref.invalidate(unitsOfMeasureProvider);
    });
  }
}