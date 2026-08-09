class CompanyEntity {
  final int tenantId;
  final String name;
  final String slug;
  final bool isDefault;
  final String role;
  final int branchCount;
  final String subscriptionStatus;
  final String subscriptionPlan;

  const CompanyEntity({
    required this.tenantId,
    required this.name,
    required this.slug,
    required this.isDefault,
    required this.role,
    required this.branchCount,
    required this.subscriptionStatus,
    required this.subscriptionPlan,
  });
}