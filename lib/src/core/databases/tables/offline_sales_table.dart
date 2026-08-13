import 'package:drift/drift.dart';

class OfflineSales extends Table {
  TextColumn get id => text()(); // UUID or local timestamp ID
  IntColumn get branchId => integer().nullable()();
  RealColumn get totalAmount => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  TextColumn get itemsJson => text()(); // JSON string array of cart items
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, synced, failed
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
