class ModulePermission {
  final String module;

  bool view;
  bool create;
  bool update;
  bool delete;

  ModulePermission({
    required this.module,
    this.view = false,
    this.create = false,
    this.update = false,
    this.delete = false,
  });
}