import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilepos/src/routing/app_routes.dart';
import 'package:mobilepos/src/features/inventory/presentation/screens/inventory_actions.dart';
import 'package:mobilepos/src/features/inventory/presentation/widgets/inventory_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final inventoryAsync = ref.watch(inventoryListProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(FlutterRemix.arrow_left_line, color: colors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Inventory Management',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colors.primary,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search inventory',
                hintStyle: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  FlutterRemix.search_line,
                  color: Colors.grey.shade700,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          categoriesAsync.maybeWhen(
            data: (cats) {
              if (cats.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 38.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ChoiceChip(
                        label: const Text("All"),
                        selected: _selectedCatId == null,
                        onSelected: (_) {
                          setState(() {
                            _selectedCatId = null;
                          });
                        },
                      ),
                    ),
                    ...cats.map((cat) => Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: ChoiceChip(
                            label: Text(cat.name),
                            selected: _selectedCatId == cat.id,
                            onSelected: (_) {
                              setState(() {
                                _selectedCatId = _selectedCatId == cat.id ? null : cat.id;
                              });
                            },
                          ),
                        )),
                  ],
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          SizedBox(height: 10.h),
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
                  return const Center(child: Text('No inventory items found'));
                }
                return ListView.builder(
                  itemCount: filtered.length,
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
                child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => InventoryActions.show(context),
        child: const Icon(FlutterRemix.add_box_line, color: Colors.black, size: 28),
      ),
    );
  }
}
