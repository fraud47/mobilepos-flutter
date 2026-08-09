import '../../models/unit_of_measure_model.dart';

abstract class UnitsOfMeasureLocalDataSource {
  Future<List<UnitOfMeasureModel>> getUnitsOfMeasure();

  Future<void> saveUnitsOfMeasure(
      List<UnitOfMeasureModel> units,
      );

  Future<void> clearUnitsOfMeasure();
}