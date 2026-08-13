import 'package:drift/drift.dart';

class LocalProducts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  RealColumn get costPrice => real().nullable()();
  TextColumn get image => text().nullable()();
  TextColumn get sku => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get category => text().nullable()();
  IntColumn get categoryId => integer().nullable()();
  IntColumn get branchId => integer().nullable()();
  BoolColumn get enableWholesale => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
