class UnitOfMeasure {
  final int id;
  final int tenantId;
  final String name;
  final String abbreviation;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UnitOfMeasure({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.abbreviation,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}