class CreateBranchDto {
  final String name;
  final String? code;
  final String? address;

  CreateBranchDto({
    required this.name,
    this.code,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (code != null && code!.isNotEmpty) 'code': code,
      if (address != null && address!.isNotEmpty) 'address': address,
    };
  }
}
