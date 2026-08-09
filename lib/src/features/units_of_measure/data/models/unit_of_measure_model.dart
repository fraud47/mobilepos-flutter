import '../../domain/entities/unit_of_measure.dart';

class UnitOfMeasureModel extends UnitOfMeasure {
  const UnitOfMeasureModel({
    required super.id,
    required super.tenantId,
    required super.name,
    required super.abbreviation,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UnitOfMeasureModel.fromJson(Map<String, dynamic> json) {
    return UnitOfMeasureModel(
      id: json['id'] as int,
      tenantId: json['tenantId'] as int,
      name: json['name'] as String,
      abbreviation: json['abbreviation'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}