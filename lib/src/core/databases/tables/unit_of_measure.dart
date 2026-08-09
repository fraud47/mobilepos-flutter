import 'package:drift/drift.dart';

class UnitsOfMeasure extends Table {
  IntColumn get id => integer()();

  IntColumn get tenantId => integer()();

  TextColumn get name => text()();

  TextColumn get abbreviation => text()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime()();

  DateTimeColumn get updatedAt =>
      dateTime()();
  @override
  Set<Column> get primaryKey => {
    id,
  };
}