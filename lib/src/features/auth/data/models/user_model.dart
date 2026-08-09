import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.tenantId,
    required super.accountId,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      tenantId: json['tenantId'] as int,
      accountId: json['accountId'] as int,
    );
  }
}