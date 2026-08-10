import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/inventory/presentation/providers/inventory_provider.dart';
import '../../domain/entities/product_category.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => _showCategoryDialog(context, ref, null),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories found.', style: TextStyle(color: Colors.black)));
          }
          return ListView.separated(
            itemCount: categories.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return ListTile(
                title: Text(cat.name, style: const TextStyle(color: Colors.black)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showCategoryDialog(context, ref, cat),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCategory(context, ref, cat),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _showCategoryDialog(BuildContext context, WidgetRef ref, ProductCategory? category) async {
    final controller = TextEditingController(text: category?.name ?? '');
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(category == null ? 'New Category' : 'Edit Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: Text(category == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty && context.mounted) {
      final repo = ref.read(inventoryRepositoryProvider);
      
      try {
        if (category == null) {
          final res = await repo.createCategory(name);
          res.fold(
            (l) => _showError(context, l.message),
            (_) => _refreshAndShowSuccess(context, ref, 'Category "$name" created!'),
          );
        } else {
          final res = await repo.updateCategory(category.id, name);
          res.fold(
            (l) => _showError(context, l.message),
            (_) => _refreshAndShowSuccess(context, ref, 'Category "$name" updated!'),
          );
        }
      } catch (e) {
        _showError(context, e.toString());
      }
    }
  }

  Future<void> _deleteCategory(BuildContext context, WidgetRef ref, ProductCategory category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text('Delete')
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final repo = ref.read(inventoryRepositoryProvider);
      final res = await repo.deleteCategory(category.id);
      res.fold(
        (l) => _showError(context, l.message),
        (_) => _refreshAndShowSuccess(context, ref, 'Category "${category.name}" deleted!'),
      );
    }
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _refreshAndShowSuccess(BuildContext context, WidgetRef ref, String msg) {
    ref.invalidate(categoriesProvider);
    ref.invalidate(inventoryListProvider);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
