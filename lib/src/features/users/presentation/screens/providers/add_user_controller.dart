import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PermissionType {
  view,
  create,
  update,
  delete,
}

enum UserRole {
  administrator,
  manager,
  cashier,
  custom,
}

class PermissionState {
  final String module;
  final bool view;
  final bool create;
  final bool update;
  final bool delete;

  const PermissionState({
    required this.module,
    this.view = false,
    this.create = false,
    this.update = false,
    this.delete = false,
  });

  PermissionState copyWith({
    bool? view,
    bool? create,
    bool? update,
    bool? delete,
  }) {
    return PermissionState(
      module: module,
      view: view ?? this.view,
      create: create ?? this.create,
      update: update ?? this.update,
      delete: delete ?? this.delete,
    );
  }

  bool get hasAnyPermission {
    return view || create || update || delete;
  }

  bool get hasAllPermissions {
    return view && create && update && delete;
  }
}

class AddUserState {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  final UserRole role;
  final bool isActive;

  final List<PermissionState> permissions;

  final bool isSaving;

  const AddUserState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.role = UserRole.cashier,
    this.isActive = true,
    this.permissions = const [],
    this.isSaving = false,
  });

  AddUserState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    UserRole? role,
    bool? isActive,
    List<PermissionState>? permissions,
    bool? isSaving,
  }) {
    return AddUserState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      permissions: permissions ?? this.permissions,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class AddUserController extends Notifier<AddUserState> {
  @override
  AddUserState build() {
    return AddUserState(
      permissions: [
        const PermissionState(
          module: 'Inventory',
        ),
        const PermissionState(
          module: 'Customers',
        ),
        const PermissionState(
          module: 'Sales',
        ),
        const PermissionState(
          module: 'Employee Management',
        ),
        const PermissionState(
          module: 'Reports',
        ),
        const PermissionState(
          module: 'Settings',
        ),
      ],
    );
  }

  void setFullName(String value) {
    state = state.copyWith(fullName: value);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  void setRole(UserRole role) {
    state = state.copyWith(role: role);

    switch (role) {
      case UserRole.administrator:
        enableAdministrator();
        break;

      case UserRole.manager:
        enableManager();
        break;

      case UserRole.cashier:
        enableCashier();
        break;

      case UserRole.custom:
        clearPermissions();
        break;
    }
  }

  void setActive(bool value) {
    state = state.copyWith(isActive: value);
  }

  void togglePermission({
    required String module,
    required PermissionType type,
    required bool value,
  }) {
    final updatedPermissions = state.permissions.map((permission) {
      if (permission.module != module) {
        return permission;
      }

      switch (type) {
        case PermissionType.view:
          return permission.copyWith(view: value);

        case PermissionType.create:
          return permission.copyWith(create: value);

        case PermissionType.update:
          return permission.copyWith(update: value);

        case PermissionType.delete:
          return permission.copyWith(delete: value);
      }
    }).toList();

    state = state.copyWith(
      permissions: updatedPermissions,
      role: UserRole.custom,
    );
  }

  void enableAdministrator() {
    state = state.copyWith(
      permissions: state.permissions
          .map(
            (permission) => permission.copyWith(
          view: true,
          create: true,
          update: true,
          delete: true,
        ),
      )
          .toList(),
    );
  }

  void enableManager() {
    state = state.copyWith(
      permissions: state.permissions.map((permission) {
        if (permission.module == 'Settings') {
          return permission.copyWith(
            view: true,
            create: false,
            update: true,
            delete: false,
          );
        }

        return permission.copyWith(
          view: true,
          create: true,
          update: true,
          delete: true,
        );
      }).toList(),
    );
  }

  void enableCashier() {
    state = state.copyWith(
      permissions: state.permissions.map((permission) {
        switch (permission.module) {
          case 'Inventory':
            return permission.copyWith(
              view: true,
            );

          case 'Customers':
            return permission.copyWith(
              view: true,
              create: true,
            );

          case 'Sales':
            return permission.copyWith(
              view: true,
              create: true,
            );

          default:
            return permission.copyWith(
              view: false,
              create: false,
              update: false,
              delete: false,
            );
        }
      }).toList(),
    );
  }

  void clearPermissions() {
    state = state.copyWith(
      permissions: state.permissions
          .map(
            (permission) => permission.copyWith(
          view: false,
          create: false,
          update: false,
          delete: false,
        ),
      )
          .toList(),
    );
  }

  bool validate() {
    if (state.fullName.trim().isEmpty) {
      return false;
    }

    if (state.email.trim().isEmpty) {
      return false;
    }

    if (state.password.isEmpty) {
      return false;
    }

    if (state.password != state.confirmPassword) {
      return false;
    }

    return true;
  }

  Future<bool> saveUser() async {
    if (!validate()) {
      return false;
    }

    state = state.copyWith(isSaving: true);

    // TODO:
    // Call your repository/use case here.
    await Future.delayed(
      const Duration(seconds: 1),
    );

    state = state.copyWith(isSaving: false);

    return true;
  }
}

final addUserControllerProvider =
NotifierProvider<AddUserController, AddUserState>(
  AddUserController.new,
);