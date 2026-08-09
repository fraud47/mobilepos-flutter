import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/databases/database_provider.dart';
import '../../data/data_sources/impl/units_of_measure_local_datasource_impl.dart';
import '../../data/data_sources/impl/units_of_measure_remote_datasource_impl.dart';
import '../../data/data_sources/local/units_of_measure_local_datasource.dart';
import '../../data/data_sources/remote/units_of_measure_remote_datasource.dart';
import '../../data/data_sources/repositories/units_of_measure_repository_impl.dart';
import '../../domain/entities/unit_of_measure.dart';
import '../../domain/repositories/unit_of_measure_repository.dart';


final unitsOfMeasureRemoteDataSourceProvider =
Provider<UnitsOfMeasureRemoteDataSource>((ref) {
  return UnitsOfMeasureRemoteDataSourceImpl.instance;
});


final unitsOfMeasureLocalDataSourceProvider =
Provider<UnitsOfMeasureLocalDataSource>((ref) {

  final database =
  ref.watch(appDatabaseProvider);

  return UnitsOfMeasureLocalDataSourceImpl(
    database: database,
  );
});


final unitsOfMeasureRepositoryProvider =
Provider<UnitsOfMeasureRepository>((ref) {

  final remoteDataSource =
  ref.watch(
    unitsOfMeasureRemoteDataSourceProvider,
  );

  final localDataSource =
  ref.watch(
    unitsOfMeasureLocalDataSourceProvider,
  );

  return UnitsOfMeasureRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});


final unitsOfMeasureProvider =
FutureProvider<List<UnitOfMeasure>>((ref) async {

  final repository =
  ref.watch(
    unitsOfMeasureRepositoryProvider,
  );

  return await repository.getUnitsOfMeasure(
    includeInactive: false,
  );
});