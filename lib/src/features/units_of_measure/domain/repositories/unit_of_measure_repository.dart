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
}