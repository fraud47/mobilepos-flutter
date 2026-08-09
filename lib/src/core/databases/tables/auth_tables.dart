import 'package:drift/drift.dart';

class AuthUsers extends Table {
  IntColumn get id => integer()();

  TextColumn get email => text()();

  IntColumn get tenantId => integer()();

  IntColumn get accountId => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class AuthTenants extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  TextColumn get slug => text()();

  TextColumn get subscriptionStatus => text()();

  TextColumn get subscriptionPlan => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class AuthCompanies extends Table {
  IntColumn get tenantId => integer()();

  TextColumn get name => text()();

  TextColumn get slug => text()();

  BoolColumn get isDefault =>
      boolean().withDefault(
        const Constant(false),
      )();

  TextColumn get role => text()();

  IntColumn get branchCount =>
      integer().withDefault(
        const Constant(0),
      )();

  TextColumn get subscriptionStatus => text()();

  TextColumn get subscriptionPlan => text()();

  @override
  Set<Column> get primaryKey => {
    tenantId,
    slug,
  };
}

class AuthPermissions extends Table {
  IntColumn get userId => integer()();

  TextColumn get permission => text()();

  @override
  Set<Column> get primaryKey => {
    userId,
    permission,
  };
}