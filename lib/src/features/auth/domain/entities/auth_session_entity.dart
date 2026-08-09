import 'company_entity.dart';
import 'tenant_entity.dart';
import 'user_entity.dart';


class AuthSessionEntity {
  final UserEntity user;
  final TenantEntity tenant;
  final List<CompanyEntity> companies;
  final List<String> permissions;
  final String tokenType;
  final String jti;

  const AuthSessionEntity({
    required this.user,
    required this.tenant,
    required this.companies,
    required this.permissions,
    required this.tokenType,
    required this.jti,
  });

  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }
}