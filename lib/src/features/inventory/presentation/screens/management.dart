import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilepos/src/routing/app_routes.dart';
import 'package:mobilepos/src/features/inventory/presentation/screens/inventory_actions.dart';
import 'package:mobilepos/src/features/inventory/presentation/widgets/inventory_card.dart';
import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';
import '../providers/inventory_provider.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedCatId;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _accentFor(String name) {
    if (name.isEmpty) return const Color(0xFF6B7280);
    final palette = [
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF06B6D4),
      const Color(0xFFEC4899),
      const Color(0xFFF97316),
    ];
    return palette[name.length % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final inventoryAsync = ref.watch(inventoryListProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(FlutterRemix.arrow_left_line, color: Colors.black87, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Inventory Management',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Stats summary header
          inventoryAsync.maybeWhen(
            data: (products) => _buildStatsHeader(products, colors),
            orElse: () => const SizedBox.shrink(),
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 6.h),
            child: Container(
              height: 46.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 13.5.sp, color: const Color(0xFF111827)),
                decoration: InputDecoration(
                  hintText: 'Search product or SKU...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13.sp,
                  ),
                  prefixIcon: Icon(
                    FlutterRemix.search_2_line,
                    color: Colors.grey.shade400,
                    size: 18.sp,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _searchController.clear(),
                          child: Icon(FlutterRemix.close_circle_fill, size: 16.sp, color: Colors.grey.shade400),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),

          // Category filter pills
          categoriesAsync.maybeWhen(
            data: (cats) {
              if (cats.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 38.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  children: [
                    _buildCategoryFilterChip(
                      label: "All Items",
                      isSelected: _selectedCatId == null,
                      color: colors.primary,
                      onTap: () => setState(() => _selectedCatId = null),
                    ),
                    ...cats.map((cat) {
                      final catColor = _accentFor(cat.name);
                      return _buildCategoryFilterChip(
                        label: cat.name,
                        isSelected: _selectedCatId == cat.id,
                        color: catColor,
                        onTap: () {
                          setState(() {
                            _selectedCatId = _selectedCatId == cat.id ? null : cat.id;
                          });
                        },
                      );
                    }),
                  ],
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),

          SizedBox(height: 6.h),

          // Items list
          Expanded(
            child: inventoryAsync.when(
              data: (products) {
                final filtered = products.where((p) {
                  final matchesCat = _selectedCatId == null || p.categoryId == _selectedCatId;
                  final matchesQuery = _searchQuery.isEmpty ||
                      p.name.toLowerCase().contains(_searchQuery) ||
                      (p.sku != null && p.sku!.toLowerCase().contains(_searchQuery)) ||
                      (p.category != null && p.category!.toLowerCase().contains(_searchQuery));
                  return matchesCat && matchesQuery;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FlutterRemix.inbox_line, size: 48.sp, color: Colors.grey.shade300),
                        SizedBox(height: 12.h),
                        Text(
                          'No inventory items found',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty || _selectedCatId != null) ...[
                          SizedBox(height: 8.h),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _selectedCatId = null);
                            },
                            child: const Text('Reset filters'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.only(top: 4.h, bottom: 80.h),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.inventoryPage, extra: item);
                      },
                      child: InventoryCard(item: item),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading inventory: $error', style: const TextStyle(color: Colors.red)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 6,
        backgroundColor: colors.primary,
        shape: const CircleBorder(),
        onPressed: () => InventoryActions.show(context),
        child: const Icon(FlutterRemix.add_line, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildCategoryFilterChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsHeader(List<InventoryItem> products, ColorScheme colors) {
    final total = products.length;
    final lowStock = products.where((p) => p.stock > 0 && p.stock <= 5).length;
    final outOfStock = products.where((p) => p.stock <= 0).length;

    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 2.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Items', '$total', colors.primary, FlutterRemix.store_2_line),
          Container(width: 1, height: 24.h, color: Colors.grey.shade200),
          _buildStatItem('Low Stock', '$lowStock', const Color(0xFFD97706), FlutterRemix.error_warning_line),
          Container(width: 1, height: 24.h, color: Colors.grey.shade200),
          _buildStatItem('Out of Stock', '$outOfStock', const Color(0xFFDC2626), FlutterRemix.close_circle_line),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: color),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
