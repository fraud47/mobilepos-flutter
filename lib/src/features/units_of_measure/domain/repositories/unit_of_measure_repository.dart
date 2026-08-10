import '../entities/unit_of_measure.dart';

abstract class UnitsOfMeasureRepository {

  Future<List<UnitOfMeasure>> getUnitsOfMeasure({
    bool includeInactive,
  });

  Future<List<UnitOfMeasure>> getLocalUnitsOfMeasure();
  Future<UnitOfMeasure> createUnitOfMeasure({
    required String name,
    required String abbreviation,
  });

  Future<UnitOfMeasure> updateUnitOfMeasure({
    required int id,
    required String name,
    required String abbreviation,
  });

  Future<void> deleteUnitOfMeasure(int id);
}