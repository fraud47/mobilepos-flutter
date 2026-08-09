import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../extensions/context_extension.dart';
import '../../domain/entities/product_variant.dart';
import '../../domain/entities/wholesale_price.dart';

class VariantCard extends StatefulWidget {
  final ProductVariant variant;
  final VoidCallback onDelete;

  const VariantCard({
    super.key,
    required this.variant,
    required this.onDelete,
  });

  @override
  State<VariantCard> createState() => _VariantCardState();
}

class _VariantCardState extends State<VariantCard> {
  bool expanded = true;
  bool trackStock = true;

  late TextEditingController variantController;
  late TextEditingController sellingController;
  late TextEditingController costController;
  late TextEditingController stockController;
  late TextEditingController skuController;
  late TextEditingController barcodeController;
  late TextEditingController lowStockController;

  @override
  void initState() {
    super.initState();

    variantController = TextEditingController(text: widget.variant.name);

    sellingController =
        TextEditingController(text: widget.variant.sellingPrice.toString());

    costController =
        TextEditingController(text: widget.variant.costPrice.toString());

    stockController =
        TextEditingController(text: widget.variant.stock.toString());

    skuController = TextEditingController(text: widget.variant.sku);

    barcodeController = TextEditingController(text: widget.variant.barcode);

    lowStockController =
        TextEditingController(text: widget.variant.lowStock.toString());
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            children: [
              //-----------------------------------------------------
              // Header
              //-----------------------------------------------------

              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 32,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          variantController.text.isEmpty
                              ? "Variant"
                              : variantController.text,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Tap image to change",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    icon: Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              if (!expanded) SizedBox(),

              SizedBox(height: 25.h),

              //-----------------------------------------------------
              // Variant Name
              //-----------------------------------------------------

              _field(
                controller: variantController,
                label: "Variant Name",
                icon: Icons.inventory_2_outlined,
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _field(
                      controller: sellingController,
                      label: "Selling Price",
                      icon: Icons.sell,
                      keyboard: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      controller: costController,
                      label: "Cost Price",
                      icon: Icons.attach_money,
                      keyboard: TextInputType.number,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),

              //-----------------------------------------------------
              // Stock
              //-----------------------------------------------------

              Row(
                children: [
                  Expanded(
                    child: _field(
                      controller: stockController,
                      label: "Stock",
                      icon: Icons.inventory,
                      keyboard: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      controller: lowStockController,
                      label: "Low Stock",
                      icon: Icons.warning_amber,
                      keyboard: TextInputType.number,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),

              //-----------------------------------------------------
              // Barcode
              //-----------------------------------------------------

              _field(
                controller: barcodeController,
                label: "Barcode",
                icon: Icons.barcode_reader,
              ),

              SizedBox(height: 15),

              //-----------------------------------------------------
              // Track Stock
              //-----------------------------------------------------

              SwitchListTile(
                value: trackStock,
                title: const Text('Track Stock',
                style:TextStyle(color: Colors.black),),
                contentPadding: EdgeInsets.zero,
                onChanged: (v) {
                  setState(() {
                    trackStock = v;
                  });
                },
              ),

              Divider(height: 30),

              //-----------------------------------------------------
              // Tax
              //-----------------------------------------------------

              DropdownButtonFormField<String>(
                value: "VAT",
                decoration:  InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  labelText: "Tax",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "VAT",
                    child: Text("VAT 15%"),
                  ),
                  DropdownMenuItem(
                    value: "None",
                    child: Text("No Tax"),
                  ),
                ],
                onChanged: (v) {},
              ),

              SizedBox(height: 25),

              //-----------------------------------------------------
              // Wholesale
              //-----------------------------------------------------

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Wholesale Pricing",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 15),

              ...widget.variant.wholesalePrices.asMap().entries.map(
                (entry) {
                  return _WholesaleTile(
                    wholesale: entry.value,
                    onDelete: () {
                      setState(() {
                        widget.variant.wholesalePrices.removeAt(entry.key);
                      });
                    },
                  );
                },
              ),

              SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(

                  icon: const Icon(Icons.add),
                  label: const Text('Add Wholesale Tier',
                  ),
                  onPressed: () {
                    setState(() {
                      widget.variant.wholesalePrices.add(
                        WholesalePrice(
                          quantity: 1,
                          price: 0,
                        ),
                      );
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _WholesaleTile extends StatelessWidget {
  final WholesalePrice wholesale;
  final VoidCallback onDelete;

  const _WholesaleTile({
    required this.wholesale,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final qty = TextEditingController(text: wholesale.quantity.toString());

    final price = TextEditingController(text: wholesale.price.toString());

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: qty,
              keyboardType: TextInputType.number,

              decoration:  InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                labelText: "Min Qty",
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration:  InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                labelText: "Wholesale Price",
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
