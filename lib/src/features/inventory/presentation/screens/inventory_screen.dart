import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/extensions/context_extension.dart';
import '../../domain/entities/product_variant.dart';
import '../../domain/entities/wholesale_price.dart';
import '../widgets/product_info_card.dart';
import '../widgets/variant_card.dart';

import '../../domain/entities/inventory_item.dart';

import '../providers/inventory_provider.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  final InventoryItem? item;
  
  const InventoryScreen({super.key, this.item});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String category = "General";
  String sellBy = "Unit";

  bool favourite = false;

  List<ProductVariant> variants = [
    ProductVariant(
      name: 'Default',
      sellingPrice: 3.50,
      costPrice: 2.00,
      stock: 44,
      sku: 'SKU001',
      barcode: '6001234567890',
      lowStock: 5,
      wholesalePrices: [
        WholesalePrice(quantity: 6, price: 3.20),
        WholesalePrice(quantity: 12, price: 3.00),
      ],
    )
  ];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      nameController.text = widget.item!.name;
      // You can extract and set other fields like variants from widget.item here
    } else {
      nameController.text = '';
      descriptionController.text = '';
    }
  }

  void _submitProduct() {
    if (!_formKey.currentState!.validate()) return;
    if (variants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one variant (or default)')),
      );
      return;
    }

    final firstVariant = variants.first;
    
    // Map the wholesale prices
    final wholesaleTiers = firstVariant.wholesalePrices.map((wp) {
      return {
        'minQty': wp.quantity,
        'price': wp.price.toStringAsFixed(2),
      };
    }).toList();

    // The backend CreateProductDto expects these fields
    final payload = {
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'sku': firstVariant.sku.isEmpty ? 'SKU-${DateTime.now().millisecondsSinceEpoch}' : firstVariant.sku,
      if (firstVariant.barcode.isNotEmpty) 'barcode': firstVariant.barcode,
      'sellingPrice': firstVariant.sellingPrice.toStringAsFixed(2),
      'costPrice': firstVariant.costPrice.toStringAsFixed(2),
      if (wholesaleTiers.isNotEmpty) 'wholesaleTiers': wholesaleTiers,
      // Pass remaining variants if they exist (optional, depends on backend handling)
      if (variants.length > 1) 
        'variants': variants.skip(1).map((v) => {
           'name': v.name,
           'sku': v.sku,
           'barcode': v.barcode,
           'sellingPrice': v.sellingPrice.toStringAsFixed(2),
           'costPrice': v.costPrice.toStringAsFixed(2),
        }).toList(),
    };

    if (widget.item != null && widget.item!.id != null) {
      // NOTE: Here you would call an updateProduct provider method 
      // but for now we only have createProduct and deleteProduct
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update item not implemented yet')),
      );
    } else {
      ref.read(addProductProvider.notifier).createProduct(payload);
    }
  }

  void _deleteProduct() {
    if (widget.item != null && widget.item!.id != null) {
      ref.read(addProductProvider.notifier).deleteProduct(widget.item!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tx = context.theme.textTheme;
    final addProductState = ref.watch(addProductProvider);
    
    ref.listen<AsyncValue<void>>(addProductProvider, (previous, next) {
      next.when(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')),
          );
          Navigator.pop(context);
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        loading: () {},
      );
    });
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Manage Item',
          style: TextStyle(
            color: cs.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          if (widget.item != null)
            IconButton(
              onPressed: _deleteProduct,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
              ),
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SizedBox(
            height: 45.h,
            child: ElevatedButton.icon(
              label: addProductState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Save Product'),
              icon: addProductState.isLoading
                  ? const SizedBox.shrink()
                  : const Icon(FlutterRemix.save_line),
              onPressed: addProductState.isLoading ? null : _submitProduct,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            variants.add(
              ProductVariant.empty(),
            );
          });
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Variant',
            style:
                tx.labelSmall?.copyWith(color: Colors.white, fontSize: 12.sp)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            ProductInfoCard(
              nameController: nameController,
              descriptionController: descriptionController,
              category: category,
              sellBy: sellBy,
              onCategoryChanged: (value) {
                setState(() {
                  category = value;
                });
              },
              onSellByChanged: (value) {
                setState(() {
                  sellBy = value;
                });
              },
            ),
            SizedBox(height: 20.h),
            Card(
              margin: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Variants",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            ...variants.asMap().entries.map(
              (entry) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: VariantCard(
                    variant: entry.value,
                    onDelete: () {
                      setState(() {
                        variants.removeAt(entry.key);
                      });
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
