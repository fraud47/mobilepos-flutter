class TenantEntity {
  final int id;
  final String name;
  final String slug;
  final String subscriptionStatus;
  final String subscriptionPlan;

  const TenantEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.subscriptionStatus,
    required this.subscriptionPlan,
  });
}