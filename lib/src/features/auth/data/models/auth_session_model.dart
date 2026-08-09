import '../../domain/entities/auth_session_entity.dart';
import 'company_model.dart';
import 'tenant_model.dart';
import 'user_model.dart';

class AuthSessionModel extends AuthSessionEntity {
  final String accessToken;
  final String refreshToken;

  const AuthSessionModel({
    required super.user,
    required super.tenant,
    required super.companies,
    required super.permissions,
    required super.tokenType,
    required super.jti,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthSessionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final userJson =
    json['data']['user'] as Map<String, dynamic>;

    final tenantJson =
    json['data']['tenant'] as Map<String, dynamic>;

    final companiesJson =
        json['data']['companies'] as List<dynamic>? ?? [];

    return AuthSessionModel(
      user: UserModel.fromJson(userJson),
      tenant: TenantModel.fromJson(tenantJson),
      companies: companiesJson
          .map(
            (item) => CompanyModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
      permissions: const [],
      tokenType: json['data']['tokenType'] as String? ?? 'Bearer',
      jti: json['data']['jti'] as String? ?? '',
      accessToken:
      json['data']['accessToken'] as String,
      refreshToken:
      json['data']['refreshToken'] as String,
    );
  }

  AuthSessionEntity toEntity() {
    return AuthSessionEntity(
      user: user,
      tenant: tenant,
      companies: companies,
      permissions: permissions,
      tokenType: tokenType,
      jti: jti,
    );
  }
}

