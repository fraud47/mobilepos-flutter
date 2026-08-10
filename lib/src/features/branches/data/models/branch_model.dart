import '../../domain/entities/branch.dart';

class BranchModel extends Branch {
  const BranchModel({
    required super.id,
    required super.tenantId,
    required super.name,
    super.code,
    required super.isActive,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as int,
      tenantId: json['tenantId'] as int,
      name: json['name'] as String,
      code: json['code'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenantId': tenantId,
      'name': name,
      'code': code,
      'isActive': isActive,
    };
  }
}
