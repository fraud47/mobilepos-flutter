import 'module_permission.dart';

class UserPermissionModel {
  String fullName;
  String email;
  String phone;
  String role;

  List<ModulePermission> permissions;

  UserPermissionModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.permissions,
  });
}