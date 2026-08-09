class CreateUnitOfMeasureRequest {
  const CreateUnitOfMeasureRequest({
    required this.name,
    required this.abbreviation,
  });

  final String name;
  final String abbreviation;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'abbreviation': abbreviation,
    };
  }
}