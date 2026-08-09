import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';

class InventoryMetric {
  const InventoryMetric({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
}

class BottomNavItem {
  const BottomNavItem(this.tab, this.label, this.icon);

  final HomeTab tab;
  final String label;
  final IconData icon;
}
