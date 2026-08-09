

import '../../../domain/entities/unit_of_measure.dart';
import '../../../domain/repositories/unit_of_measure_repository.dart';
import '../../models/create_unit_of_measure_request.dart';
import '../local/units_of_measure_local_datasource.dart';
import '../remote/units_of_measure_remote_datasource.dart';

class UnitsOfMeasureRepositoryImpl
    implements UnitsOfMeasureRepository {

  final UnitsOfMeasureRemoteDataSource remoteDataSource;

  final UnitsOfMeasureLocalDataSource localDataSource;

  UnitsOfMeasureRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<UnitOfMeasure>> getUnitsOfMeasure({
    bool includeInactive = false,
  }) async {
    try {
      final remoteUnits =
      await remoteDataSource.getUnitsOfMeasure(
        includeInactive: includeInactive,
      );

      await localDataSource.saveUnitsOfMeasure(
        remoteUnits,
      );

      return remoteUnits
          .map<UnitOfMeasure>(
            (unit) => unit,
      )
          .toList();
    } catch (e) {
      final localUnits =
      await localDataSource.getUnitsOfMeasure();

      if (localUnits.isNotEmpty) {
        return localUnits
            .map<UnitOfMeasure>(
              (unit) => unit,
        )
            .toList();
      }

      rethrow;
    }
  }


  @override
  Future<UnitOfMeasure> createUnitOfMeasure({
    required String name,
    required String abbreviation,
  }) async {

    final unit =
    await remoteDataSource.createUnitOfMeasure(
      request: CreateUnitOfMeasureRequest(
        name: name,
        abbreviation: abbreviation,
      ),
    );

    await localDataSource.saveUnitsOfMeasure([
      unit,
    ]);

    return unit;
  }

  @override
  Future<List<UnitOfMeasure>>
  getLocalUnitsOfMeasure() async {
    final localUnits =
    await localDataSource.getUnitsOfMeasure();

    return localUnits
        .map<UnitOfMeasure>(
          (unit) => unit,
    )
        .toList();
  }
}