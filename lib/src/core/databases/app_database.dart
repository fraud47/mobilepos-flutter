import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/auth_tables.dart';
import 'tables/unit_of_measure.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    AuthUsers,
    AuthTenants,
    AuthCompanies,
    AuthPermissions,
    UnitsOfMeasure,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },

      onUpgrade: (
          Migrator m,
          int from,
          int to,
          ) async {
        // -----------------------------------------
        // VERSION 1 -> VERSION 2
        // -----------------------------------------
        if (from < 2) {
          await m.createTable(
            authUsers,
          );

          await m.createTable(
            authTenants,
          );

          await m.createTable(
            authCompanies,
          );

          await m.createTable(
            authPermissions,
          );
        }

        // -----------------------------------------
        // VERSION 2 -> VERSION 3
        // -----------------------------------------
        if (from < 3) {
          await m.createTable(
            unitsOfMeasure,
          );
        }

        // -----------------------------------------
        // VERSION 3 -> VERSION 4
        // Add primary key to UnitsOfMeasure
        // -----------------------------------------
        if (from < 4) {
          await _migrateUnitsOfMeasure(
            m,
          );
        }
      },
    );
  }

  Future<void> _migrateUnitsOfMeasure(
      Migrator m,
      ) async {
    // Rename old table
    await customStatement(
      'ALTER TABLE units_of_measure '
          'RENAME TO units_of_measure_old',
    );

    // Create new table with primary key
    await m.createTable(
      unitsOfMeasure,
    );

    // Copy existing data
    await customStatement(
      '''
      INSERT INTO units_of_measure (
        id,
        tenant_id,
        name,
        abbreviation,
        is_active,
        created_at,
        updated_at
      )
      SELECT
        id,
        tenant_id,
        name,
        abbreviation,
        is_active,
        created_at,
        updated_at
      FROM units_of_measure_old
      ''',
    );

    // Delete old table
    await customStatement(
      'DROP TABLE units_of_measure_old',
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder =
    await getApplicationDocumentsDirectory();

    final file = File(
      p.join(
        dbFolder.path,
        'mobile_pos.db',
      ),
    );

    return NativeDatabase(file);
  });
}