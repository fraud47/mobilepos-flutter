import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

import 'package:mobilepos/src/core/errors/exceptions.dart';
import '../../../../../core/databases/app_database.dart';
import '../../models/unit_of_measure_model.dart';
import '../local/units_of_measure_local_datasource.dart';

class UnitsOfMeasureLocalDataSourceImpl
    implements UnitsOfMeasureLocalDataSource {

  final AppDatabase database;

  UnitsOfMeasureLocalDataSourceImpl({
    required this.database,
  });

  @override
  Future<List<UnitOfMeasureModel>> getUnitsOfMeasure() async {
    try {
      final rows = await database.select(
        database.unitsOfMeasure,
      ).get();

      return rows.map((row) {
        return UnitOfMeasureModel(
          id: row.id,
          tenantId: row.tenantId,
          name: row.name,
          abbreviation: row.abbreviation,
          isActive: row.isActive,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        );
      }).toList();
    } catch (e) {
      throw CacheException(
         e.toString(),
      );
    }
  }

  @override
  Future<void> saveUnitsOfMeasure(
      List<UnitOfMeasureModel> units,
      ) async {

    try {
      await database.transaction(() async {
        for (final unit in units) {
          await database
              .into(database.unitsOfMeasure)
              .insertOnConflictUpdate(
            UnitsOfMeasureCompanion.insert(
              id: Value(unit.id),
              tenantId: unit.tenantId,
              name: unit.name,
              abbreviation:
              unit.abbreviation,
              isActive:
              Value(unit.isActive),
              createdAt:
              unit.createdAt,
              updatedAt:
              unit.updatedAt,
            ),
          );
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      throw CacheException(
         e.toString(),
      );
    }
  }

  @override
  Future<void> clearUnitsOfMeasure() async {
    try {
      await database.delete(
        database.unitsOfMeasure,
      ).go();
    } catch (e) {
      throw CacheException(e.toString(),
      );
    }
  }
}