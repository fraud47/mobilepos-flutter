import '../../domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.tenantId,
    required super.name,
    required super.slug,
    required super.isDefault,
    required super.role,
    required super.branchCount,
    required super.subscriptionStatus,
    required super.subscriptionPlan,
  });

  factory CompanyModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CompanyModel(
      tenantId: json['tenantId'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      isDefault: json['isDefault'] as bool,
      role: json['role'] as String,
      branchCount: json['branchCount'] as int,
      subscriptionStatus:
      json['subscriptionStatus'] as String,
      subscriptionPlan:
      json['subscriptionPlan'] as String,
    );
  }
}