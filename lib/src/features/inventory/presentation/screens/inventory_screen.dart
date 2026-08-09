 import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/extensions/context_extension.dart';
import '../../domain/entities/product_variant.dart';
import '../../domain/entities/wholesale_price.dart';
import '../widgets/product_info_card.dart';
import '../widgets/variant_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
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

    nameController.text = 'Afrokinky';
    descriptionController.text =
        'Premium quality hair extension suitable for all styles.';
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tx = context.theme.textTheme;
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
          IconButton(
            onPressed: () {},
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
              label:const Text('product'),
              icon:const Icon(FlutterRemix.save_line) ,
              onPressed: () {},
            
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
