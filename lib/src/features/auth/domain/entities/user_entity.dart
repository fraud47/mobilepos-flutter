class UserEntity {
  final int id;
  final String email;
  final int tenantId;
  final int accountId;

  const UserEntity({
    required this.id,
    required this.email,
    required this.tenantId,
    required this.accountId,
  });
}