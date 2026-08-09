import '../../domain/entities/tenant_entity.dart';

class TenantModel extends TenantEntity {
  const TenantModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.subscriptionStatus,
    required super.subscriptionPlan,
  });

  factory TenantModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TenantModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      subscriptionStatus:
      json['subscriptionStatus'] as String,
      subscriptionPlan:
      json['subscriptionPlan'] as String,
    );
  }
}