class CreateBranchDto {
  final String name;
  final String? code;

  CreateBranchDto({
    required this.name,
    this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (code != null && code!.isNotEmpty) 'code': code,
    };
  }
}
