// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AuthUsersTable extends AuthUsers
    with TableInfo<$AuthUsersTable, AuthUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, email, tenantId, accountId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_users';
  @override
  VerificationContext validateIntegrity(Insertable<AuthUser> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthUser(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
    );
  }

  @override
  $AuthUsersTable createAlias(String alias) {
    return $AuthUsersTable(attachedDatabase, alias);
  }
}

class AuthUser extends DataClass implements Insertable<AuthUser> {
  final int id;
  final String email;
  final int tenantId;
  final int accountId;
  const AuthUser(
      {required this.id,
      required this.email,
      required this.tenantId,
      required this.accountId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['tenant_id'] = Variable<int>(tenantId);
    map['account_id'] = Variable<int>(accountId);
    return map;
  }

  AuthUsersCompanion toCompanion(bool nullToAbsent) {
    return AuthUsersCompanion(
      id: Value(id),
      email: Value(email),
      tenantId: Value(tenantId),
      accountId: Value(accountId),
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthUser(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      accountId: serializer.fromJson<int>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'tenantId': serializer.toJson<int>(tenantId),
      'accountId': serializer.toJson<int>(accountId),
    };
  }

  AuthUser copyWith({int? id, String? email, int? tenantId, int? accountId}) =>
      AuthUser(
        id: id ?? this.id,
        email: email ?? this.email,
        tenantId: tenantId ?? this.tenantId,
        accountId: accountId ?? this.accountId,
      );
  AuthUser copyWithCompanion(AuthUsersCompanion data) {
    return AuthUser(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthUser(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('tenantId: $tenantId, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, tenantId, accountId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthUser &&
          other.id == this.id &&
          other.email == this.email &&
          other.tenantId == this.tenantId &&
          other.accountId == this.accountId);
}

class AuthUsersCompanion extends UpdateCompanion<AuthUser> {
  final Value<int> id;
  final Value<String> email;
  final Value<int> tenantId;
  final Value<int> accountId;
  const AuthUsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.accountId = const Value.absent(),
  });
  AuthUsersCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required int tenantId,
    required int accountId,
  })  : email = Value(email),
        tenantId = Value(tenantId),
        accountId = Value(accountId);
  static Insertable<AuthUser> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<int>? tenantId,
    Expression<int>? accountId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (tenantId != null) 'tenant_id': tenantId,
      if (accountId != null) 'account_id': accountId,
    });
  }

  AuthUsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? email,
      Value<int>? tenantId,
      Value<int>? accountId}) {
    return AuthUsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      tenantId: tenantId ?? this.tenantId,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthUsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('tenantId: $tenantId, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }
}

class $AuthTenantsTable extends AuthTenants
    with TableInfo<$AuthTenantsTable, AuthTenant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthTenantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subscriptionStatusMeta =
      const VerificationMeta('subscriptionStatus');
  @override
  late final GeneratedColumn<String> subscriptionStatus =
      GeneratedColumn<String>('subscription_status', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subscriptionPlanMeta =
      const VerificationMeta('subscriptionPlan');
  @override
  late final GeneratedColumn<String> subscriptionPlan = GeneratedColumn<String>(
      'subscription_plan', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, slug, subscriptionStatus, subscriptionPlan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_tenants';
  @override
  VerificationContext validateIntegrity(Insertable<AuthTenant> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('subscription_status')) {
      context.handle(
          _subscriptionStatusMeta,
          subscriptionStatus.isAcceptableOrUnknown(
              data['subscription_status']!, _subscriptionStatusMeta));
    } else if (isInserting) {
      context.missing(_subscriptionStatusMeta);
    }
    if (data.containsKey('subscription_plan')) {
      context.handle(
          _subscriptionPlanMeta,
          subscriptionPlan.isAcceptableOrUnknown(
              data['subscription_plan']!, _subscriptionPlanMeta));
    } else if (isInserting) {
      context.missing(_subscriptionPlanMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthTenant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthTenant(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      subscriptionStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}subscription_status'])!,
      subscriptionPlan: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}subscription_plan'])!,
    );
  }

  @override
  $AuthTenantsTable createAlias(String alias) {
    return $AuthTenantsTable(attachedDatabase, alias);
  }
}

class AuthTenant extends DataClass implements Insertable<AuthTenant> {
  final int id;
  final String name;
  final String slug;
  final String subscriptionStatus;
  final String subscriptionPlan;
  const AuthTenant(
      {required this.id,
      required this.name,
      required this.slug,
      required this.subscriptionStatus,
      required this.subscriptionPlan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['subscription_status'] = Variable<String>(subscriptionStatus);
    map['subscription_plan'] = Variable<String>(subscriptionPlan);
    return map;
  }

  AuthTenantsCompanion toCompanion(bool nullToAbsent) {
    return AuthTenantsCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      subscriptionStatus: Value(subscriptionStatus),
      subscriptionPlan: Value(subscriptionPlan),
    );
  }

  factory AuthTenant.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthTenant(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      subscriptionStatus:
          serializer.fromJson<String>(json['subscriptionStatus']),
      subscriptionPlan: serializer.fromJson<String>(json['subscriptionPlan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'subscriptionStatus': serializer.toJson<String>(subscriptionStatus),
      'subscriptionPlan': serializer.toJson<String>(subscriptionPlan),
    };
  }

  AuthTenant copyWith(
          {int? id,
          String? name,
          String? slug,
          String? subscriptionStatus,
          String? subscriptionPlan}) =>
      AuthTenant(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
        subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      );
  AuthTenant copyWithCompanion(AuthTenantsCompanion data) {
    return AuthTenant(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      subscriptionStatus: data.subscriptionStatus.present
          ? data.subscriptionStatus.value
          : this.subscriptionStatus,
      subscriptionPlan: data.subscriptionPlan.present
          ? data.subscriptionPlan.value
          : this.subscriptionPlan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthTenant(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('subscriptionStatus: $subscriptionStatus, ')
          ..write('subscriptionPlan: $subscriptionPlan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, slug, subscriptionStatus, subscriptionPlan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthTenant &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.subscriptionStatus == this.subscriptionStatus &&
          other.subscriptionPlan == this.subscriptionPlan);
}

class AuthTenantsCompanion extends UpdateCompanion<AuthTenant> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> subscriptionStatus;
  final Value<String> subscriptionPlan;
  const AuthTenantsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.subscriptionStatus = const Value.absent(),
    this.subscriptionPlan = const Value.absent(),
  });
  AuthTenantsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String slug,
    required String subscriptionStatus,
    required String subscriptionPlan,
  })  : name = Value(name),
        slug = Value(slug),
        subscriptionStatus = Value(subscriptionStatus),
        subscriptionPlan = Value(subscriptionPlan);
  static Insertable<AuthTenant> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? subscriptionStatus,
    Expression<String>? subscriptionPlan,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (subscriptionStatus != null) 'subscription_status': subscriptionStatus,
      if (subscriptionPlan != null) 'subscription_plan': subscriptionPlan,
    });
  }

  AuthTenantsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? slug,
      Value<String>? subscriptionStatus,
      Value<String>? subscriptionPlan}) {
    return AuthTenantsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (subscriptionStatus.present) {
      map['subscription_status'] = Variable<String>(subscriptionStatus.value);
    }
    if (subscriptionPlan.present) {
      map['subscription_plan'] = Variable<String>(subscriptionPlan.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthTenantsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('subscriptionStatus: $subscriptionStatus, ')
          ..write('subscriptionPlan: $subscriptionPlan')
          ..write(')'))
        .toString();
  }
}

class $AuthCompaniesTable extends AuthCompanies
    with TableInfo<$AuthCompaniesTable, AuthCompany> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthCompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _branchCountMeta =
      const VerificationMeta('branchCount');
  @override
  late final GeneratedColumn<int> branchCount = GeneratedColumn<int>(
      'branch_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _subscriptionStatusMeta =
      const VerificationMeta('subscriptionStatus');
  @override
  late final GeneratedColumn<String> subscriptionStatus =
      GeneratedColumn<String>('subscription_status', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subscriptionPlanMeta =
      const VerificationMeta('subscriptionPlan');
  @override
  late final GeneratedColumn<String> subscriptionPlan = GeneratedColumn<String>(
      'subscription_plan', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        tenantId,
        name,
        slug,
        isDefault,
        role,
        branchCount,
        subscriptionStatus,
        subscriptionPlan
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_companies';
  @override
  VerificationContext validateIntegrity(Insertable<AuthCompany> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('branch_count')) {
      context.handle(
          _branchCountMeta,
          branchCount.isAcceptableOrUnknown(
              data['branch_count']!, _branchCountMeta));
    }
    if (data.containsKey('subscription_status')) {
      context.handle(
          _subscriptionStatusMeta,
          subscriptionStatus.isAcceptableOrUnknown(
              data['subscription_status']!, _subscriptionStatusMeta));
    } else if (isInserting) {
      context.missing(_subscriptionStatusMeta);
    }
    if (data.containsKey('subscription_plan')) {
      context.handle(
          _subscriptionPlanMeta,
          subscriptionPlan.isAcceptableOrUnknown(
              data['subscription_plan']!, _subscriptionPlanMeta));
    } else if (isInserting) {
      context.missing(_subscriptionPlanMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tenantId, slug};
  @override
  AuthCompany map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthCompany(
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      branchCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}branch_count'])!,
      subscriptionStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}subscription_status'])!,
      subscriptionPlan: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}subscription_plan'])!,
    );
  }

  @override
  $AuthCompaniesTable createAlias(String alias) {
    return $AuthCompaniesTable(attachedDatabase, alias);
  }
}

class AuthCompany extends DataClass implements Insertable<AuthCompany> {
  final int tenantId;
  final String name;
  final String slug;
  final bool isDefault;
  final String role;
  final int branchCount;
  final String subscriptionStatus;
  final String subscriptionPlan;
  const AuthCompany(
      {required this.tenantId,
      required this.name,
      required this.slug,
      required this.isDefault,
      required this.role,
      required this.branchCount,
      required this.subscriptionStatus,
      required this.subscriptionPlan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tenant_id'] = Variable<int>(tenantId);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['is_default'] = Variable<bool>(isDefault);
    map['role'] = Variable<String>(role);
    map['branch_count'] = Variable<int>(branchCount);
    map['subscription_status'] = Variable<String>(subscriptionStatus);
    map['subscription_plan'] = Variable<String>(subscriptionPlan);
    return map;
  }

  AuthCompaniesCompanion toCompanion(bool nullToAbsent) {
    return AuthCompaniesCompanion(
      tenantId: Value(tenantId),
      name: Value(name),
      slug: Value(slug),
      isDefault: Value(isDefault),
      role: Value(role),
      branchCount: Value(branchCount),
      subscriptionStatus: Value(subscriptionStatus),
      subscriptionPlan: Value(subscriptionPlan),
    );
  }

  factory AuthCompany.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthCompany(
      tenantId: serializer.fromJson<int>(json['tenantId']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      role: serializer.fromJson<String>(json['role']),
      branchCount: serializer.fromJson<int>(json['branchCount']),
      subscriptionStatus:
          serializer.fromJson<String>(json['subscriptionStatus']),
      subscriptionPlan: serializer.fromJson<String>(json['subscriptionPlan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tenantId': serializer.toJson<int>(tenantId),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'isDefault': serializer.toJson<bool>(isDefault),
      'role': serializer.toJson<String>(role),
      'branchCount': serializer.toJson<int>(branchCount),
      'subscriptionStatus': serializer.toJson<String>(subscriptionStatus),
      'subscriptionPlan': serializer.toJson<String>(subscriptionPlan),
    };
  }

  AuthCompany copyWith(
          {int? tenantId,
          String? name,
          String? slug,
          bool? isDefault,
          String? role,
          int? branchCount,
          String? subscriptionStatus,
          String? subscriptionPlan}) =>
      AuthCompany(
        tenantId: tenantId ?? this.tenantId,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        isDefault: isDefault ?? this.isDefault,
        role: role ?? this.role,
        branchCount: branchCount ?? this.branchCount,
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
        subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      );
  AuthCompany copyWithCompanion(AuthCompaniesCompanion data) {
    return AuthCompany(
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      role: data.role.present ? data.role.value : this.role,
      branchCount:
          data.branchCount.present ? data.branchCount.value : this.branchCount,
      subscriptionStatus: data.subscriptionStatus.present
          ? data.subscriptionStatus.value
          : this.subscriptionStatus,
      subscriptionPlan: data.subscriptionPlan.present
          ? data.subscriptionPlan.value
          : this.subscriptionPlan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthCompany(')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('isDefault: $isDefault, ')
          ..write('role: $role, ')
          ..write('branchCount: $branchCount, ')
          ..write('subscriptionStatus: $subscriptionStatus, ')
          ..write('subscriptionPlan: $subscriptionPlan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tenantId, name, slug, isDefault, role,
      branchCount, subscriptionStatus, subscriptionPlan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthCompany &&
          other.tenantId == this.tenantId &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.isDefault == this.isDefault &&
          other.role == this.role &&
          other.branchCount == this.branchCount &&
          other.subscriptionStatus == this.subscriptionStatus &&
          other.subscriptionPlan == this.subscriptionPlan);
}

class AuthCompaniesCompanion extends UpdateCompanion<AuthCompany> {
  final Value<int> tenantId;
  final Value<String> name;
  final Value<String> slug;
  final Value<bool> isDefault;
  final Value<String> role;
  final Value<int> branchCount;
  final Value<String> subscriptionStatus;
  final Value<String> subscriptionPlan;
  final Value<int> rowid;
  const AuthCompaniesCompanion({
    this.tenantId = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.role = const Value.absent(),
    this.branchCount = const Value.absent(),
    this.subscriptionStatus = const Value.absent(),
    this.subscriptionPlan = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthCompaniesCompanion.insert({
    required int tenantId,
    required String name,
    required String slug,
    this.isDefault = const Value.absent(),
    required String role,
    this.branchCount = const Value.absent(),
    required String subscriptionStatus,
    required String subscriptionPlan,
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        name = Value(name),
        slug = Value(slug),
        role = Value(role),
        subscriptionStatus = Value(subscriptionStatus),
        subscriptionPlan = Value(subscriptionPlan);
  static Insertable<AuthCompany> custom({
    Expression<int>? tenantId,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<bool>? isDefault,
    Expression<String>? role,
    Expression<int>? branchCount,
    Expression<String>? subscriptionStatus,
    Expression<String>? subscriptionPlan,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tenantId != null) 'tenant_id': tenantId,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (isDefault != null) 'is_default': isDefault,
      if (role != null) 'role': role,
      if (branchCount != null) 'branch_count': branchCount,
      if (subscriptionStatus != null) 'subscription_status': subscriptionStatus,
      if (subscriptionPlan != null) 'subscription_plan': subscriptionPlan,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthCompaniesCompanion copyWith(
      {Value<int>? tenantId,
      Value<String>? name,
      Value<String>? slug,
      Value<bool>? isDefault,
      Value<String>? role,
      Value<int>? branchCount,
      Value<String>? subscriptionStatus,
      Value<String>? subscriptionPlan,
      Value<int>? rowid}) {
    return AuthCompaniesCompanion(
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      isDefault: isDefault ?? this.isDefault,
      role: role ?? this.role,
      branchCount: branchCount ?? this.branchCount,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (branchCount.present) {
      map['branch_count'] = Variable<int>(branchCount.value);
    }
    if (subscriptionStatus.present) {
      map['subscription_status'] = Variable<String>(subscriptionStatus.value);
    }
    if (subscriptionPlan.present) {
      map['subscription_plan'] = Variable<String>(subscriptionPlan.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthCompaniesCompanion(')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('isDefault: $isDefault, ')
          ..write('role: $role, ')
          ..write('branchCount: $branchCount, ')
          ..write('subscriptionStatus: $subscriptionStatus, ')
          ..write('subscriptionPlan: $subscriptionPlan, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthPermissionsTable extends AuthPermissions
    with TableInfo<$AuthPermissionsTable, AuthPermission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthPermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _permissionMeta =
      const VerificationMeta('permission');
  @override
  late final GeneratedColumn<String> permission = GeneratedColumn<String>(
      'permission', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [userId, permission];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_permissions';
  @override
  VerificationContext validateIntegrity(Insertable<AuthPermission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('permission')) {
      context.handle(
          _permissionMeta,
          permission.isAcceptableOrUnknown(
              data['permission']!, _permissionMeta));
    } else if (isInserting) {
      context.missing(_permissionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, permission};
  @override
  AuthPermission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthPermission(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      permission: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permission'])!,
    );
  }

  @override
  $AuthPermissionsTable createAlias(String alias) {
    return $AuthPermissionsTable(attachedDatabase, alias);
  }
}

class AuthPermission extends DataClass implements Insertable<AuthPermission> {
  final int userId;
  final String permission;
  const AuthPermission({required this.userId, required this.permission});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['permission'] = Variable<String>(permission);
    return map;
  }

  AuthPermissionsCompanion toCompanion(bool nullToAbsent) {
    return AuthPermissionsCompanion(
      userId: Value(userId),
      permission: Value(permission),
    );
  }

  factory AuthPermission.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthPermission(
      userId: serializer.fromJson<int>(json['userId']),
      permission: serializer.fromJson<String>(json['permission']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'permission': serializer.toJson<String>(permission),
    };
  }

  AuthPermission copyWith({int? userId, String? permission}) => AuthPermission(
        userId: userId ?? this.userId,
        permission: permission ?? this.permission,
      );
  AuthPermission copyWithCompanion(AuthPermissionsCompanion data) {
    return AuthPermission(
      userId: data.userId.present ? data.userId.value : this.userId,
      permission:
          data.permission.present ? data.permission.value : this.permission,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthPermission(')
          ..write('userId: $userId, ')
          ..write('permission: $permission')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, permission);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthPermission &&
          other.userId == this.userId &&
          other.permission == this.permission);
}

class AuthPermissionsCompanion extends UpdateCompanion<AuthPermission> {
  final Value<int> userId;
  final Value<String> permission;
  final Value<int> rowid;
  const AuthPermissionsCompanion({
    this.userId = const Value.absent(),
    this.permission = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthPermissionsCompanion.insert({
    required int userId,
    required String permission,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        permission = Value(permission);
  static Insertable<AuthPermission> custom({
    Expression<int>? userId,
    Expression<String>? permission,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (permission != null) 'permission': permission,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthPermissionsCompanion copyWith(
      {Value<int>? userId, Value<String>? permission, Value<int>? rowid}) {
    return AuthPermissionsCompanion(
      userId: userId ?? this.userId,
      permission: permission ?? this.permission,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(permission.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthPermissionsCompanion(')
          ..write('userId: $userId, ')
          ..write('permission: $permission, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsOfMeasureTable extends UnitsOfMeasure
    with TableInfo<$UnitsOfMeasureTable, UnitsOfMeasureData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsOfMeasureTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _abbreviationMeta =
      const VerificationMeta('abbreviation');
  @override
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
      'abbreviation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tenantId, name, abbreviation, isActive, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units_of_measure';
  @override
  VerificationContext validateIntegrity(Insertable<UnitsOfMeasureData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
          _abbreviationMeta,
          abbreviation.isAcceptableOrUnknown(
              data['abbreviation']!, _abbreviationMeta));
    } else if (isInserting) {
      context.missing(_abbreviationMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitsOfMeasureData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitsOfMeasureData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      abbreviation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abbreviation'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UnitsOfMeasureTable createAlias(String alias) {
    return $UnitsOfMeasureTable(attachedDatabase, alias);
  }
}

class UnitsOfMeasureData extends DataClass
    implements Insertable<UnitsOfMeasureData> {
  final int id;
  final int tenantId;
  final String name;
  final String abbreviation;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UnitsOfMeasureData(
      {required this.id,
      required this.tenantId,
      required this.name,
      required this.abbreviation,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tenant_id'] = Variable<int>(tenantId);
    map['name'] = Variable<String>(name);
    map['abbreviation'] = Variable<String>(abbreviation);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UnitsOfMeasureCompanion toCompanion(bool nullToAbsent) {
    return UnitsOfMeasureCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      name: Value(name),
      abbreviation: Value(abbreviation),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UnitsOfMeasureData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitsOfMeasureData(
      id: serializer.fromJson<int>(json['id']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      name: serializer.fromJson<String>(json['name']),
      abbreviation: serializer.fromJson<String>(json['abbreviation']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tenantId': serializer.toJson<int>(tenantId),
      'name': serializer.toJson<String>(name),
      'abbreviation': serializer.toJson<String>(abbreviation),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UnitsOfMeasureData copyWith(
          {int? id,
          int? tenantId,
          String? name,
          String? abbreviation,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UnitsOfMeasureData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        name: name ?? this.name,
        abbreviation: abbreviation ?? this.abbreviation,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UnitsOfMeasureData copyWithCompanion(UnitsOfMeasureCompanion data) {
    return UnitsOfMeasureData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      name: data.name.present ? data.name.value : this.name,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitsOfMeasureData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, tenantId, name, abbreviation, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitsOfMeasureData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.name == this.name &&
          other.abbreviation == this.abbreviation &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UnitsOfMeasureCompanion extends UpdateCompanion<UnitsOfMeasureData> {
  final Value<int> id;
  final Value<int> tenantId;
  final Value<String> name;
  final Value<String> abbreviation;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UnitsOfMeasureCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.name = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UnitsOfMeasureCompanion.insert({
    this.id = const Value.absent(),
    required int tenantId,
    required String name,
    required String abbreviation,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : tenantId = Value(tenantId),
        name = Value(name),
        abbreviation = Value(abbreviation),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<UnitsOfMeasureData> custom({
    Expression<int>? id,
    Expression<int>? tenantId,
    Expression<String>? name,
    Expression<String>? abbreviation,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (name != null) 'name': name,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UnitsOfMeasureCompanion copyWith(
      {Value<int>? id,
      Value<int>? tenantId,
      Value<String>? name,
      Value<String>? abbreviation,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UnitsOfMeasureCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsOfMeasureCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalProductsTable extends LocalProducts
    with TableInfo<$LocalProductsTable, LocalProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
      'stock', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _costPriceMeta =
      const VerificationMeta('costPrice');
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
      'cost_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _branchIdMeta =
      const VerificationMeta('branchId');
  @override
  late final GeneratedColumn<int> branchId = GeneratedColumn<int>(
      'branch_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _enableWholesaleMeta =
      const VerificationMeta('enableWholesale');
  @override
  late final GeneratedColumn<bool> enableWholesale = GeneratedColumn<bool>(
      'enable_wholesale', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_wholesale" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        stock,
        price,
        costPrice,
        image,
        sku,
        barcode,
        category,
        categoryId,
        branchId,
        enableWholesale
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_products';
  @override
  VerificationContext validateIntegrity(Insertable<LocalProduct> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
          _stockMeta, stock.isAcceptableOrUnknown(data['stock']!, _stockMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('cost_price')) {
      context.handle(_costPriceMeta,
          costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta));
    }
    if (data.containsKey('enable_wholesale')) {
      context.handle(
          _enableWholesaleMeta,
          enableWholesale.isAcceptableOrUnknown(
              data['enable_wholesale']!, _enableWholesaleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProduct(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      stock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      costPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_price']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      branchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}branch_id']),
      enableWholesale: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enable_wholesale'])!,
    );
  }

  @override
  $LocalProductsTable createAlias(String alias) {
    return $LocalProductsTable(attachedDatabase, alias);
  }
}

class LocalProduct extends DataClass implements Insertable<LocalProduct> {
  final String id;
  final String name;
  final int stock;
  final double price;
  final double? costPrice;
  final String? image;
  final String? sku;
  final String? barcode;
  final String? category;
  final int? categoryId;
  final int? branchId;
  final bool enableWholesale;
  const LocalProduct(
      {required this.id,
      required this.name,
      required this.stock,
      required this.price,
      this.costPrice,
      this.image,
      this.sku,
      this.barcode,
      this.category,
      this.categoryId,
      this.branchId,
      required this.enableWholesale});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['stock'] = Variable<int>(stock);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || costPrice != null) {
      map['cost_price'] = Variable<double>(costPrice);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<int>(branchId);
    }
    map['enable_wholesale'] = Variable<bool>(enableWholesale);
    return map;
  }

  LocalProductsCompanion toCompanion(bool nullToAbsent) {
    return LocalProductsCompanion(
      id: Value(id),
      name: Value(name),
      stock: Value(stock),
      price: Value(price),
      costPrice: costPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(costPrice),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      enableWholesale: Value(enableWholesale),
    );
  }

  factory LocalProduct.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProduct(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      stock: serializer.fromJson<int>(json['stock']),
      price: serializer.fromJson<double>(json['price']),
      costPrice: serializer.fromJson<double?>(json['costPrice']),
      image: serializer.fromJson<String?>(json['image']),
      sku: serializer.fromJson<String?>(json['sku']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      category: serializer.fromJson<String?>(json['category']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      branchId: serializer.fromJson<int?>(json['branchId']),
      enableWholesale: serializer.fromJson<bool>(json['enableWholesale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'stock': serializer.toJson<int>(stock),
      'price': serializer.toJson<double>(price),
      'costPrice': serializer.toJson<double?>(costPrice),
      'image': serializer.toJson<String?>(image),
      'sku': serializer.toJson<String?>(sku),
      'barcode': serializer.toJson<String?>(barcode),
      'category': serializer.toJson<String?>(category),
      'categoryId': serializer.toJson<int?>(categoryId),
      'branchId': serializer.toJson<int?>(branchId),
      'enableWholesale': serializer.toJson<bool>(enableWholesale),
    };
  }

  LocalProduct copyWith(
          {String? id,
          String? name,
          int? stock,
          double? price,
          Value<double?> costPrice = const Value.absent(),
          Value<String?> image = const Value.absent(),
          Value<String?> sku = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          Value<String?> category = const Value.absent(),
          Value<int?> categoryId = const Value.absent(),
          Value<int?> branchId = const Value.absent(),
          bool? enableWholesale}) =>
      LocalProduct(
        id: id ?? this.id,
        name: name ?? this.name,
        stock: stock ?? this.stock,
        price: price ?? this.price,
        costPrice: costPrice.present ? costPrice.value : this.costPrice,
        image: image.present ? image.value : this.image,
        sku: sku.present ? sku.value : this.sku,
        barcode: barcode.present ? barcode.value : this.barcode,
        category: category.present ? category.value : this.category,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        branchId: branchId.present ? branchId.value : this.branchId,
        enableWholesale: enableWholesale ?? this.enableWholesale,
      );
  LocalProduct copyWithCompanion(LocalProductsCompanion data) {
    return LocalProduct(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      stock: data.stock.present ? data.stock.value : this.stock,
      price: data.price.present ? data.price.value : this.price,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      image: data.image.present ? data.image.value : this.image,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      category: data.category.present ? data.category.value : this.category,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      enableWholesale: data.enableWholesale.present
          ? data.enableWholesale.value
          : this.enableWholesale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProduct(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('stock: $stock, ')
          ..write('price: $price, ')
          ..write('costPrice: $costPrice, ')
          ..write('image: $image, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('categoryId: $categoryId, ')
          ..write('branchId: $branchId, ')
          ..write('enableWholesale: $enableWholesale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, stock, price, costPrice, image, sku,
      barcode, category, categoryId, branchId, enableWholesale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProduct &&
          other.id == this.id &&
          other.name == this.name &&
          other.stock == this.stock &&
          other.price == this.price &&
          other.costPrice == this.costPrice &&
          other.image == this.image &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.category == this.category &&
          other.categoryId == this.categoryId &&
          other.branchId == this.branchId &&
          other.enableWholesale == this.enableWholesale);
}

class LocalProductsCompanion extends UpdateCompanion<LocalProduct> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> stock;
  final Value<double> price;
  final Value<double?> costPrice;
  final Value<String?> image;
  final Value<String?> sku;
  final Value<String?> barcode;
  final Value<String?> category;
  final Value<int?> categoryId;
  final Value<int?> branchId;
  final Value<bool> enableWholesale;
  final Value<int> rowid;
  const LocalProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.stock = const Value.absent(),
    this.price = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.image = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.category = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.enableWholesale = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProductsCompanion.insert({
    required String id,
    required String name,
    this.stock = const Value.absent(),
    this.price = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.image = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.category = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.enableWholesale = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<LocalProduct> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? stock,
    Expression<double>? price,
    Expression<double>? costPrice,
    Expression<String>? image,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<String>? category,
    Expression<int>? categoryId,
    Expression<int>? branchId,
    Expression<bool>? enableWholesale,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (stock != null) 'stock': stock,
      if (price != null) 'price': price,
      if (costPrice != null) 'cost_price': costPrice,
      if (image != null) 'image': image,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (category != null) 'category': category,
      if (categoryId != null) 'category_id': categoryId,
      if (branchId != null) 'branch_id': branchId,
      if (enableWholesale != null) 'enable_wholesale': enableWholesale,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? stock,
      Value<double>? price,
      Value<double?>? costPrice,
      Value<String?>? image,
      Value<String?>? sku,
      Value<String?>? barcode,
      Value<String?>? category,
      Value<int?>? categoryId,
      Value<int?>? branchId,
      Value<bool>? enableWholesale,
      Value<int>? rowid}) {
    return LocalProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      image: image ?? this.image,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      branchId: branchId ?? this.branchId,
      enableWholesale: enableWholesale ?? this.enableWholesale,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<int>(branchId.value);
    }
    if (enableWholesale.present) {
      map['enable_wholesale'] = Variable<bool>(enableWholesale.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('stock: $stock, ')
          ..write('price: $price, ')
          ..write('costPrice: $costPrice, ')
          ..write('image: $image, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('categoryId: $categoryId, ')
          ..write('branchId: $branchId, ')
          ..write('enableWholesale: $enableWholesale, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineSalesTable extends OfflineSales
    with TableInfo<$OfflineSalesTable, OfflineSale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineSalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _branchIdMeta =
      const VerificationMeta('branchId');
  @override
  late final GeneratedColumn<int> branchId = GeneratedColumn<int>(
      'branch_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        branchId,
        totalAmount,
        discount,
        paymentMethod,
        itemsJson,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_sales';
  @override
  VerificationContext validateIntegrity(Insertable<OfflineSale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineSale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineSale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      branchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}branch_id']),
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OfflineSalesTable createAlias(String alias) {
    return $OfflineSalesTable(attachedDatabase, alias);
  }
}

class OfflineSale extends DataClass implements Insertable<OfflineSale> {
  final String id;
  final int? branchId;
  final double totalAmount;
  final double discount;
  final String paymentMethod;
  final String itemsJson;
  final String status;
  final DateTime createdAt;
  const OfflineSale(
      {required this.id,
      this.branchId,
      required this.totalAmount,
      required this.discount,
      required this.paymentMethod,
      required this.itemsJson,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<int>(branchId);
    }
    map['total_amount'] = Variable<double>(totalAmount);
    map['discount'] = Variable<double>(discount);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['items_json'] = Variable<String>(itemsJson);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OfflineSalesCompanion toCompanion(bool nullToAbsent) {
    return OfflineSalesCompanion(
      id: Value(id),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      totalAmount: Value(totalAmount),
      discount: Value(discount),
      paymentMethod: Value(paymentMethod),
      itemsJson: Value(itemsJson),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory OfflineSale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineSale(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<int?>(json['branchId']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      discount: serializer.fromJson<double>(json['discount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<int?>(branchId),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'discount': serializer.toJson<double>(discount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OfflineSale copyWith(
          {String? id,
          Value<int?> branchId = const Value.absent(),
          double? totalAmount,
          double? discount,
          String? paymentMethod,
          String? itemsJson,
          String? status,
          DateTime? createdAt}) =>
      OfflineSale(
        id: id ?? this.id,
        branchId: branchId.present ? branchId.value : this.branchId,
        totalAmount: totalAmount ?? this.totalAmount,
        discount: discount ?? this.discount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        itemsJson: itemsJson ?? this.itemsJson,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  OfflineSale copyWithCompanion(OfflineSalesCompanion data) {
    return OfflineSale(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      discount: data.discount.present ? data.discount.value : this.discount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineSale(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discount: $discount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, branchId, totalAmount, discount,
      paymentMethod, itemsJson, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineSale &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.totalAmount == this.totalAmount &&
          other.discount == this.discount &&
          other.paymentMethod == this.paymentMethod &&
          other.itemsJson == this.itemsJson &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class OfflineSalesCompanion extends UpdateCompanion<OfflineSale> {
  final Value<String> id;
  final Value<int?> branchId;
  final Value<double> totalAmount;
  final Value<double> discount;
  final Value<String> paymentMethod;
  final Value<String> itemsJson;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OfflineSalesCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.discount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineSalesCompanion.insert({
    required String id,
    this.branchId = const Value.absent(),
    required double totalAmount,
    this.discount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    required String itemsJson,
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        totalAmount = Value(totalAmount),
        itemsJson = Value(itemsJson),
        createdAt = Value(createdAt);
  static Insertable<OfflineSale> custom({
    Expression<String>? id,
    Expression<int>? branchId,
    Expression<double>? totalAmount,
    Expression<double>? discount,
    Expression<String>? paymentMethod,
    Expression<String>? itemsJson,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (discount != null) 'discount': discount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (itemsJson != null) 'items_json': itemsJson,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineSalesCompanion copyWith(
      {Value<String>? id,
      Value<int?>? branchId,
      Value<double>? totalAmount,
      Value<double>? discount,
      Value<String>? paymentMethod,
      Value<String>? itemsJson,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return OfflineSalesCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      totalAmount: totalAmount ?? this.totalAmount,
      discount: discount ?? this.discount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      itemsJson: itemsJson ?? this.itemsJson,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<int>(branchId.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineSalesCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discount: $discount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _actionTypeMeta =
      const VerificationMeta('actionType');
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
      'action_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, actionType, payloadJson, retryCount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action_type')) {
      context.handle(
          _actionTypeMeta,
          actionType.isAcceptableOrUnknown(
              data['action_type']!, _actionTypeMeta));
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      actionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_type'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String actionType;
  final String payloadJson;
  final int retryCount;
  final DateTime createdAt;
  const SyncQueueData(
      {required this.id,
      required this.actionType,
      required this.payloadJson,
      required this.retryCount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['action_type'] = Variable<String>(actionType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      actionType: Value(actionType),
      payloadJson: Value(payloadJson),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      actionType: serializer.fromJson<String>(json['actionType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actionType': serializer.toJson<String>(actionType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          String? actionType,
          String? payloadJson,
          int? retryCount,
          DateTime? createdAt}) =>
      SyncQueueData(
        id: id ?? this.id,
        actionType: actionType ?? this.actionType,
        payloadJson: payloadJson ?? this.payloadJson,
        retryCount: retryCount ?? this.retryCount,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      actionType:
          data.actionType.present ? data.actionType.value : this.actionType,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, actionType, payloadJson, retryCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.actionType == this.actionType &&
          other.payloadJson == this.payloadJson &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> actionType;
  final Value<String> payloadJson;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.actionType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String actionType,
    required String payloadJson,
    this.retryCount = const Value.absent(),
    required DateTime createdAt,
  })  : actionType = Value(actionType),
        payloadJson = Value(payloadJson),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? actionType,
    Expression<String>? payloadJson,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actionType != null) 'action_type': actionType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? actionType,
      Value<String>? payloadJson,
      Value<int>? retryCount,
      Value<DateTime>? createdAt}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      payloadJson: payloadJson ?? this.payloadJson,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AuthUsersTable authUsers = $AuthUsersTable(this);
  late final $AuthTenantsTable authTenants = $AuthTenantsTable(this);
  late final $AuthCompaniesTable authCompanies = $AuthCompaniesTable(this);
  late final $AuthPermissionsTable authPermissions =
      $AuthPermissionsTable(this);
  late final $UnitsOfMeasureTable unitsOfMeasure = $UnitsOfMeasureTable(this);
  late final $LocalProductsTable localProducts = $LocalProductsTable(this);
  late final $OfflineSalesTable offlineSales = $OfflineSalesTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        authUsers,
        authTenants,
        authCompanies,
        authPermissions,
        unitsOfMeasure,
        localProducts,
        offlineSales,
        syncQueue
      ];
}

typedef $$AuthUsersTableCreateCompanionBuilder = AuthUsersCompanion Function({
  Value<int> id,
  required String email,
  required int tenantId,
  required int accountId,
});
typedef $$AuthUsersTableUpdateCompanionBuilder = AuthUsersCompanion Function({
  Value<int> id,
  Value<String> email,
  Value<int> tenantId,
  Value<int> accountId,
});

class $$AuthUsersTableFilterComposer
    extends Composer<_$AppDatabase, $AuthUsersTable> {
  $$AuthUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));
}

class $$AuthUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthUsersTable> {
  $$AuthUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));
}

class $$AuthUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthUsersTable> {
  $$AuthUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);
}

class $$AuthUsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuthUsersTable,
    AuthUser,
    $$AuthUsersTableFilterComposer,
    $$AuthUsersTableOrderingComposer,
    $$AuthUsersTableAnnotationComposer,
    $$AuthUsersTableCreateCompanionBuilder,
    $$AuthUsersTableUpdateCompanionBuilder,
    (AuthUser, BaseReferences<_$AppDatabase, $AuthUsersTable, AuthUser>),
    AuthUser,
    PrefetchHooks Function()> {
  $$AuthUsersTableTableManager(_$AppDatabase db, $AuthUsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<int> accountId = const Value.absent(),
          }) =>
              AuthUsersCompanion(
            id: id,
            email: email,
            tenantId: tenantId,
            accountId: accountId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String email,
            required int tenantId,
            required int accountId,
          }) =>
              AuthUsersCompanion.insert(
            id: id,
            email: email,
            tenantId: tenantId,
            accountId: accountId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuthUsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuthUsersTable,
    AuthUser,
    $$AuthUsersTableFilterComposer,
    $$AuthUsersTableOrderingComposer,
    $$AuthUsersTableAnnotationComposer,
    $$AuthUsersTableCreateCompanionBuilder,
    $$AuthUsersTableUpdateCompanionBuilder,
    (AuthUser, BaseReferences<_$AppDatabase, $AuthUsersTable, AuthUser>),
    AuthUser,
    PrefetchHooks Function()>;
typedef $$AuthTenantsTableCreateCompanionBuilder = AuthTenantsCompanion
    Function({
  Value<int> id,
  required String name,
  required String slug,
  required String subscriptionStatus,
  required String subscriptionPlan,
});
typedef $$AuthTenantsTableUpdateCompanionBuilder = AuthTenantsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> slug,
  Value<String> subscriptionStatus,
  Value<String> subscriptionPlan,
});

class $$AuthTenantsTableFilterComposer
    extends Composer<_$AppDatabase, $AuthTenantsTable> {
  $$AuthTenantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subscriptionStatus => $composableBuilder(
      column: $table.subscriptionStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subscriptionPlan => $composableBuilder(
      column: $table.subscriptionPlan,
      builder: (column) => ColumnFilters(column));
}

class $$AuthTenantsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthTenantsTable> {
  $$AuthTenantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subscriptionStatus => $composableBuilder(
      column: $table.subscriptionStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subscriptionPlan => $composableBuilder(
      column: $table.subscriptionPlan,
      builder: (column) => ColumnOrderings(column));
}

class $$AuthTenantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthTenantsTable> {
  $$AuthTenantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get subscriptionStatus => $composableBuilder(
      column: $table.subscriptionStatus, builder: (column) => column);

  GeneratedColumn<String> get subscriptionPlan => $composableBuilder(
      column: $table.subscriptionPlan, builder: (column) => column);
}

class $$AuthTenantsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuthTenantsTable,
    AuthTenant,
    $$AuthTenantsTableFilterComposer,
    $$AuthTenantsTableOrderingComposer,
    $$AuthTenantsTableAnnotationComposer,
    $$AuthTenantsTableCreateCompanionBuilder,
    $$AuthTenantsTableUpdateCompanionBuilder,
    (AuthTenant, BaseReferences<_$AppDatabase, $AuthTenantsTable, AuthTenant>),
    AuthTenant,
    PrefetchHooks Function()> {
  $$AuthTenantsTableTableManager(_$AppDatabase db, $AuthTenantsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthTenantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthTenantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthTenantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String> subscriptionStatus = const Value.absent(),
            Value<String> subscriptionPlan = const Value.absent(),
          }) =>
              AuthTenantsCompanion(
            id: id,
            name: name,
            slug: slug,
            subscriptionStatus: subscriptionStatus,
            subscriptionPlan: subscriptionPlan,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String slug,
            required String subscriptionStatus,
            required String subscriptionPlan,
          }) =>
              AuthTenantsCompanion.insert(
            id: id,
            name: name,
            slug: slug,
            subscriptionStatus: subscriptionStatus,
            subscriptionPlan: subscriptionPlan,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuthTenantsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuthTenantsTable,
    AuthTenant,
    $$AuthTenantsTableFilterComposer,
    $$AuthTenantsTableOrderingComposer,
    $$AuthTenantsTableAnnotationComposer,
    $$AuthTenantsTableCreateCompanionBuilder,
    $$AuthTenantsTableUpdateCompanionBuilder,
    (AuthTenant, BaseReferences<_$AppDatabase, $AuthTenantsTable, AuthTenant>),
    AuthTenant,
    PrefetchHooks Function()>;
typedef $$AuthCompaniesTableCreateCompanionBuilder = AuthCompaniesCompanion
    Function({
  required int tenantId,
  required String name,
  required String slug,
  Value<bool> isDefault,
  required String role,
  Value<int> branchCount,
  required String subscriptionStatus,
  required String subscriptionPlan,
  Value<int> rowid,
});
typedef $$AuthCompaniesTableUpdateCompanionBuilder = AuthCompaniesCompanion
    Function({
  Value<int> tenantId,
  Value<String> name,
  Value<String> slug,
  Value<bool> isDefault,
  Value<String> role,
  Value<int> branchCount,
  Value<String> subscriptionStatus,
  Value<String> subscriptionPlan,
  Value<int> rowid,
});

class $$AuthCompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $AuthCompaniesTable> {
  $$AuthCompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get branchCount => $composableBuilder(
      column: $table.branchCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subscriptionStatus => $composableBuilder(
      column: $table.subscriptionStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subscriptionPlan => $composableBuilder(
      column: $table.subscriptionPlan,
      builder: (column) => ColumnFilters(column));
}

class $$AuthCompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthCompaniesTable> {
  $$AuthCompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get branchCount => $composableBuilder(
      column: $table.branchCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subscriptionStatus => $composableBuilder(
      column: $table.subscriptionStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subscriptionPlan => $composableBuilder(
      column: $table.subscriptionPlan,
      builder: (column) => ColumnOrderings(column));
}

class $$AuthCompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthCompaniesTable> {
  $$AuthCompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get branchCount => $composableBuilder(
      column: $table.branchCount, builder: (column) => column);

  GeneratedColumn<String> get subscriptionStatus => $composableBuilder(
      column: $table.subscriptionStatus, builder: (column) => column);

  GeneratedColumn<String> get subscriptionPlan => $composableBuilder(
      column: $table.subscriptionPlan, builder: (column) => column);
}

class $$AuthCompaniesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuthCompaniesTable,
    AuthCompany,
    $$AuthCompaniesTableFilterComposer,
    $$AuthCompaniesTableOrderingComposer,
    $$AuthCompaniesTableAnnotationComposer,
    $$AuthCompaniesTableCreateCompanionBuilder,
    $$AuthCompaniesTableUpdateCompanionBuilder,
    (
      AuthCompany,
      BaseReferences<_$AppDatabase, $AuthCompaniesTable, AuthCompany>
    ),
    AuthCompany,
    PrefetchHooks Function()> {
  $$AuthCompaniesTableTableManager(_$AppDatabase db, $AuthCompaniesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthCompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthCompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthCompaniesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> tenantId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<int> branchCount = const Value.absent(),
            Value<String> subscriptionStatus = const Value.absent(),
            Value<String> subscriptionPlan = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthCompaniesCompanion(
            tenantId: tenantId,
            name: name,
            slug: slug,
            isDefault: isDefault,
            role: role,
            branchCount: branchCount,
            subscriptionStatus: subscriptionStatus,
            subscriptionPlan: subscriptionPlan,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int tenantId,
            required String name,
            required String slug,
            Value<bool> isDefault = const Value.absent(),
            required String role,
            Value<int> branchCount = const Value.absent(),
            required String subscriptionStatus,
            required String subscriptionPlan,
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthCompaniesCompanion.insert(
            tenantId: tenantId,
            name: name,
            slug: slug,
            isDefault: isDefault,
            role: role,
            branchCount: branchCount,
            subscriptionStatus: subscriptionStatus,
            subscriptionPlan: subscriptionPlan,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuthCompaniesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuthCompaniesTable,
    AuthCompany,
    $$AuthCompaniesTableFilterComposer,
    $$AuthCompaniesTableOrderingComposer,
    $$AuthCompaniesTableAnnotationComposer,
    $$AuthCompaniesTableCreateCompanionBuilder,
    $$AuthCompaniesTableUpdateCompanionBuilder,
    (
      AuthCompany,
      BaseReferences<_$AppDatabase, $AuthCompaniesTable, AuthCompany>
    ),
    AuthCompany,
    PrefetchHooks Function()>;
typedef $$AuthPermissionsTableCreateCompanionBuilder = AuthPermissionsCompanion
    Function({
  required int userId,
  required String permission,
  Value<int> rowid,
});
typedef $$AuthPermissionsTableUpdateCompanionBuilder = AuthPermissionsCompanion
    Function({
  Value<int> userId,
  Value<String> permission,
  Value<int> rowid,
});

class $$AuthPermissionsTableFilterComposer
    extends Composer<_$AppDatabase, $AuthPermissionsTable> {
  $$AuthPermissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnFilters(column));
}

class $$AuthPermissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthPermissionsTable> {
  $$AuthPermissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnOrderings(column));
}

class $$AuthPermissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthPermissionsTable> {
  $$AuthPermissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => column);
}

class $$AuthPermissionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuthPermissionsTable,
    AuthPermission,
    $$AuthPermissionsTableFilterComposer,
    $$AuthPermissionsTableOrderingComposer,
    $$AuthPermissionsTableAnnotationComposer,
    $$AuthPermissionsTableCreateCompanionBuilder,
    $$AuthPermissionsTableUpdateCompanionBuilder,
    (
      AuthPermission,
      BaseReferences<_$AppDatabase, $AuthPermissionsTable, AuthPermission>
    ),
    AuthPermission,
    PrefetchHooks Function()> {
  $$AuthPermissionsTableTableManager(
      _$AppDatabase db, $AuthPermissionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthPermissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthPermissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthPermissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            Value<String> permission = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthPermissionsCompanion(
            userId: userId,
            permission: permission,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int userId,
            required String permission,
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthPermissionsCompanion.insert(
            userId: userId,
            permission: permission,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuthPermissionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuthPermissionsTable,
    AuthPermission,
    $$AuthPermissionsTableFilterComposer,
    $$AuthPermissionsTableOrderingComposer,
    $$AuthPermissionsTableAnnotationComposer,
    $$AuthPermissionsTableCreateCompanionBuilder,
    $$AuthPermissionsTableUpdateCompanionBuilder,
    (
      AuthPermission,
      BaseReferences<_$AppDatabase, $AuthPermissionsTable, AuthPermission>
    ),
    AuthPermission,
    PrefetchHooks Function()>;
typedef $$UnitsOfMeasureTableCreateCompanionBuilder = UnitsOfMeasureCompanion
    Function({
  Value<int> id,
  required int tenantId,
  required String name,
  required String abbreviation,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$UnitsOfMeasureTableUpdateCompanionBuilder = UnitsOfMeasureCompanion
    Function({
  Value<int> id,
  Value<int> tenantId,
  Value<String> name,
  Value<String> abbreviation,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$UnitsOfMeasureTableFilterComposer
    extends Composer<_$AppDatabase, $UnitsOfMeasureTable> {
  $$UnitsOfMeasureTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UnitsOfMeasureTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsOfMeasureTable> {
  $$UnitsOfMeasureTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UnitsOfMeasureTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsOfMeasureTable> {
  $$UnitsOfMeasureTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UnitsOfMeasureTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnitsOfMeasureTable,
    UnitsOfMeasureData,
    $$UnitsOfMeasureTableFilterComposer,
    $$UnitsOfMeasureTableOrderingComposer,
    $$UnitsOfMeasureTableAnnotationComposer,
    $$UnitsOfMeasureTableCreateCompanionBuilder,
    $$UnitsOfMeasureTableUpdateCompanionBuilder,
    (
      UnitsOfMeasureData,
      BaseReferences<_$AppDatabase, $UnitsOfMeasureTable, UnitsOfMeasureData>
    ),
    UnitsOfMeasureData,
    PrefetchHooks Function()> {
  $$UnitsOfMeasureTableTableManager(
      _$AppDatabase db, $UnitsOfMeasureTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsOfMeasureTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsOfMeasureTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsOfMeasureTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> abbreviation = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UnitsOfMeasureCompanion(
            id: id,
            tenantId: tenantId,
            name: name,
            abbreviation: abbreviation,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tenantId,
            required String name,
            required String abbreviation,
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              UnitsOfMeasureCompanion.insert(
            id: id,
            tenantId: tenantId,
            name: name,
            abbreviation: abbreviation,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnitsOfMeasureTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnitsOfMeasureTable,
    UnitsOfMeasureData,
    $$UnitsOfMeasureTableFilterComposer,
    $$UnitsOfMeasureTableOrderingComposer,
    $$UnitsOfMeasureTableAnnotationComposer,
    $$UnitsOfMeasureTableCreateCompanionBuilder,
    $$UnitsOfMeasureTableUpdateCompanionBuilder,
    (
      UnitsOfMeasureData,
      BaseReferences<_$AppDatabase, $UnitsOfMeasureTable, UnitsOfMeasureData>
    ),
    UnitsOfMeasureData,
    PrefetchHooks Function()>;
typedef $$LocalProductsTableCreateCompanionBuilder = LocalProductsCompanion
    Function({
  required String id,
  required String name,
  Value<int> stock,
  Value<double> price,
  Value<double?> costPrice,
  Value<String?> image,
  Value<String?> sku,
  Value<String?> barcode,
  Value<String?> category,
  Value<int?> categoryId,
  Value<int?> branchId,
  Value<bool> enableWholesale,
  Value<int> rowid,
});
typedef $$LocalProductsTableUpdateCompanionBuilder = LocalProductsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<int> stock,
  Value<double> price,
  Value<double?> costPrice,
  Value<String?> image,
  Value<String?> sku,
  Value<String?> barcode,
  Value<String?> category,
  Value<int?> categoryId,
  Value<int?> branchId,
  Value<bool> enableWholesale,
  Value<int> rowid,
});

class $$LocalProductsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProductsTable> {
  $$LocalProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get branchId => $composableBuilder(
      column: $table.branchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enableWholesale => $composableBuilder(
      column: $table.enableWholesale,
      builder: (column) => ColumnFilters(column));
}

class $$LocalProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProductsTable> {
  $$LocalProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get branchId => $composableBuilder(
      column: $table.branchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enableWholesale => $composableBuilder(
      column: $table.enableWholesale,
      builder: (column) => ColumnOrderings(column));
}

class $$LocalProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProductsTable> {
  $$LocalProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<int> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<bool> get enableWholesale => $composableBuilder(
      column: $table.enableWholesale, builder: (column) => column);
}

class $$LocalProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalProductsTable,
    LocalProduct,
    $$LocalProductsTableFilterComposer,
    $$LocalProductsTableOrderingComposer,
    $$LocalProductsTableAnnotationComposer,
    $$LocalProductsTableCreateCompanionBuilder,
    $$LocalProductsTableUpdateCompanionBuilder,
    (
      LocalProduct,
      BaseReferences<_$AppDatabase, $LocalProductsTable, LocalProduct>
    ),
    LocalProduct,
    PrefetchHooks Function()> {
  $$LocalProductsTableTableManager(_$AppDatabase db, $LocalProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> stock = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double?> costPrice = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int?> branchId = const Value.absent(),
            Value<bool> enableWholesale = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProductsCompanion(
            id: id,
            name: name,
            stock: stock,
            price: price,
            costPrice: costPrice,
            image: image,
            sku: sku,
            barcode: barcode,
            category: category,
            categoryId: categoryId,
            branchId: branchId,
            enableWholesale: enableWholesale,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> stock = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double?> costPrice = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int?> branchId = const Value.absent(),
            Value<bool> enableWholesale = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProductsCompanion.insert(
            id: id,
            name: name,
            stock: stock,
            price: price,
            costPrice: costPrice,
            image: image,
            sku: sku,
            barcode: barcode,
            category: category,
            categoryId: categoryId,
            branchId: branchId,
            enableWholesale: enableWholesale,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalProductsTable,
    LocalProduct,
    $$LocalProductsTableFilterComposer,
    $$LocalProductsTableOrderingComposer,
    $$LocalProductsTableAnnotationComposer,
    $$LocalProductsTableCreateCompanionBuilder,
    $$LocalProductsTableUpdateCompanionBuilder,
    (
      LocalProduct,
      BaseReferences<_$AppDatabase, $LocalProductsTable, LocalProduct>
    ),
    LocalProduct,
    PrefetchHooks Function()>;
typedef $$OfflineSalesTableCreateCompanionBuilder = OfflineSalesCompanion
    Function({
  required String id,
  Value<int?> branchId,
  required double totalAmount,
  Value<double> discount,
  Value<String> paymentMethod,
  required String itemsJson,
  Value<String> status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$OfflineSalesTableUpdateCompanionBuilder = OfflineSalesCompanion
    Function({
  Value<String> id,
  Value<int?> branchId,
  Value<double> totalAmount,
  Value<double> discount,
  Value<String> paymentMethod,
  Value<String> itemsJson,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$OfflineSalesTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineSalesTable> {
  $$OfflineSalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get branchId => $composableBuilder(
      column: $table.branchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$OfflineSalesTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineSalesTable> {
  $$OfflineSalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get branchId => $composableBuilder(
      column: $table.branchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$OfflineSalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineSalesTable> {
  $$OfflineSalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OfflineSalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OfflineSalesTable,
    OfflineSale,
    $$OfflineSalesTableFilterComposer,
    $$OfflineSalesTableOrderingComposer,
    $$OfflineSalesTableAnnotationComposer,
    $$OfflineSalesTableCreateCompanionBuilder,
    $$OfflineSalesTableUpdateCompanionBuilder,
    (
      OfflineSale,
      BaseReferences<_$AppDatabase, $OfflineSalesTable, OfflineSale>
    ),
    OfflineSale,
    PrefetchHooks Function()> {
  $$OfflineSalesTableTableManager(_$AppDatabase db, $OfflineSalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineSalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineSalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineSalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int?> branchId = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OfflineSalesCompanion(
            id: id,
            branchId: branchId,
            totalAmount: totalAmount,
            discount: discount,
            paymentMethod: paymentMethod,
            itemsJson: itemsJson,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int?> branchId = const Value.absent(),
            required double totalAmount,
            Value<double> discount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            required String itemsJson,
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              OfflineSalesCompanion.insert(
            id: id,
            branchId: branchId,
            totalAmount: totalAmount,
            discount: discount,
            paymentMethod: paymentMethod,
            itemsJson: itemsJson,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OfflineSalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OfflineSalesTable,
    OfflineSale,
    $$OfflineSalesTableFilterComposer,
    $$OfflineSalesTableOrderingComposer,
    $$OfflineSalesTableAnnotationComposer,
    $$OfflineSalesTableCreateCompanionBuilder,
    $$OfflineSalesTableUpdateCompanionBuilder,
    (
      OfflineSale,
      BaseReferences<_$AppDatabase, $OfflineSalesTable, OfflineSale>
    ),
    OfflineSale,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String actionType,
  required String payloadJson,
  Value<int> retryCount,
  required DateTime createdAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> actionType,
  Value<String> payloadJson,
  Value<int> retryCount,
  Value<DateTime> createdAt,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> actionType = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            actionType: actionType,
            payloadJson: payloadJson,
            retryCount: retryCount,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String actionType,
            required String payloadJson,
            Value<int> retryCount = const Value.absent(),
            required DateTime createdAt,
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            actionType: actionType,
            payloadJson: payloadJson,
            retryCount: retryCount,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AuthUsersTableTableManager get authUsers =>
      $$AuthUsersTableTableManager(_db, _db.authUsers);
  $$AuthTenantsTableTableManager get authTenants =>
      $$AuthTenantsTableTableManager(_db, _db.authTenants);
  $$AuthCompaniesTableTableManager get authCompanies =>
      $$AuthCompaniesTableTableManager(_db, _db.authCompanies);
  $$AuthPermissionsTableTableManager get authPermissions =>
      $$AuthPermissionsTableTableManager(_db, _db.authPermissions);
  $$UnitsOfMeasureTableTableManager get unitsOfMeasure =>
      $$UnitsOfMeasureTableTableManager(_db, _db.unitsOfMeasure);
  $$LocalProductsTableTableManager get localProducts =>
      $$LocalProductsTableTableManager(_db, _db.localProducts);
  $$OfflineSalesTableTableManager get offlineSales =>
      $$OfflineSalesTableTableManager(_db, _db.offlineSales);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
