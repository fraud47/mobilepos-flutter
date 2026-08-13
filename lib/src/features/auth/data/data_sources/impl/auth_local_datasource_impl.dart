import 'package:drift/drift.dart';
import '../../../../../core/databases/app_database.dart';
import '../../../utils/auth_secure_storage.dart';
import '../../models/auth_session_model.dart';
import '../../models/company_model.dart';
import '../../models/tenant_model.dart';
import '../../models/user_model.dart';
import '../local/auth_local_datasource.dart';

class AuthLocalDataSourceImpl
    implements AuthLocalDataSource {
  final AppDatabase database;
  final AuthSecureStorage secureStorage;


  AuthLocalDataSourceImpl({
    required this.database,
    required this.secureStorage,
  });

  @override
  Future<void> saveLoginData(
      AuthSessionModel session,
      ) async {
    await database.transaction(() async {
      await database
          .into(database.authUsers)
          .insertOnConflictUpdate(
        AuthUsersCompanion.insert(
          id: Value(session.user.id),
          email: session.user.email,
          tenantId: session.user.tenantId,
          accountId:session.user.accountId,
        ),
      );

      await database
          .into(database.authTenants)
          .insertOnConflictUpdate(
        AuthTenantsCompanion.insert(
          id: Value(session.tenant.id),
          name: session.tenant.name,
          slug:session.tenant.slug,
          subscriptionStatus:session.tenant.subscriptionStatus,
          subscriptionPlan:session.tenant.subscriptionStatus,
        ),
      );

      await database
          .delete(database.authCompanies)
          .go();

      for (final company in session.companies) {
        await database
            .into(database.authCompanies)
            .insertOnConflictUpdate(
          AuthCompaniesCompanion.insert(
            tenantId: company.tenantId,
            name: company.name,
            slug: company.slug,
            isDefault:
            Value(company.isDefault),
            role: company.role,
            branchCount:
            Value(company.branchCount),
            subscriptionStatus:
            company.subscriptionStatus,
            subscriptionPlan:
            company.subscriptionPlan,
          ),
        );
      }

      await database
          .delete(database.authPermissions)
          .go();

      for (final permission
      in session.permissions) {
        await database
            .into(database.authPermissions)
            .insert(
          AuthPermissionsCompanion.insert(
            userId: session.user.id,
            permission: permission,
          ),
        );
      }
    });

    await secureStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }

  @override
  Future<AuthSessionModel?> getCurrentSession() async {
    final user =
    await (database.select(database.authUsers)
      ..limit(1))
        .getSingleOrNull();

    if (user == null) {
      return null;
    }

    final tenant =
    await (database.select(database.authTenants)
      ..where(
            (table) =>
            table.id.equals(user.tenantId),
      ))
        .getSingleOrNull();

    if (tenant == null) {
      return null;
    }

    final companies =
    await (database.select(database.authCompanies)
      ..where(
            (table) =>
            table.tenantId.equals(
              user.tenantId,
            ),
      ))
        .get();

    final permissions =
    await (database.select(database.authPermissions)
      ..where(
            (table) =>
            table.userId.equals(user.id),
      ))
        .get();

    final accessToken =
    await secureStorage.getAccessToken();

    final refreshToken =
    await secureStorage.getRefreshToken();

    if (accessToken == null ||
        refreshToken == null) {
      return null;
    }

    return AuthSessionModel(
      user: UserModel(
        id: user.id,
        email: user.email,
        tenantId: user.tenantId,
        accountId: user.accountId,
      ),
      tenant: TenantModel(
        id: tenant.id,
        name: tenant.name,
        slug: tenant.slug,
        subscriptionStatus:
        tenant.subscriptionStatus,
        subscriptionPlan:
        tenant.subscriptionPlan,
      ),
      companies: companies
          .map(
            (company) => CompanyModel(
          tenantId: company.tenantId,
          name: company.name,
          slug: company.slug,
          isDefault: company.isDefault,
          role: company.role,
          branchCount: company.branchCount,
          subscriptionStatus:
          company.subscriptionStatus,
          subscriptionPlan:
          company.subscriptionPlan,
        ),
      )
          .toList(),
      permissions: permissions
          .map((item) => item.permission)
          .toList(),
      tokenType: 'Bearer',
      jti: '',
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<String?> getAccessToken() {
    return secureStorage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() {
    return secureStorage.getRefreshToken();
  }

  @override
  Future<bool> hasPermission(
      String permission,
      ) async {
    final session =
    await getCurrentSession();

    if (session == null) {
      return false;
    }

    return session.hasPermission(permission);
  }


  @override
  Future<void> updateAccessToken(
      String accessToken,
      ) async {
    final refreshToken =
    await secureStorage.getRefreshToken();

    if (refreshToken == null ||
        refreshToken.isEmpty) {
      return;
    }

    await secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> clearSession() async {
    await database.transaction(() async {
      await database
          .delete(database.authUsers)
          .go();

      await database
          .delete(database.authTenants)
          .go();

      await database
          .delete(database.authCompanies)
          .go();

      await database
          .delete(database.authPermissions)
          .go();
    });

    await secureStorage.clearTokens();
  }
}

