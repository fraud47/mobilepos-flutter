import '../../models/create_unit_of_measure_request.dart';
import '../../models/unit_of_measure_model.dart';

abstract class UnitsOfMeasureRemoteDataSource {
  Future<List<UnitOfMeasureModel>> getUnitsOfMeasure({
    bool includeInactive,
  });
  Future<UnitOfMeasureModel> createUnitOfMeasure({
    required CreateUnitOfMeasureRequest request,
  });
  Future<UnitOfMeasureModel> updateUnitOfMeasure({
    required int id,
    required CreateUnitOfMeasureRequest request,
  });
  Future<void> deleteUnitOfMeasure({
    required int id,
  });
}