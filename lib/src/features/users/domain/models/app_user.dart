class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString() ?? '';
    final lastName = json['lastName']?.toString() ?? '';
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

    return AppUser(
      id: json['id']?.toString() ?? '',
      name: fullName.isEmpty ? (json['name']?.toString() ?? 'Unknown') : fullName,
      email: json['email']?.toString() ?? '',
      role: json['jobTitle']?.toString() ?? json['role']?.toString() ?? 'Staff',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}