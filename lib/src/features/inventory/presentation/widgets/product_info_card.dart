import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/product_category.dart';

class ProductInfoCard extends StatelessWidget {
  const ProductInfoCard({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.selectedCategoryId,
    required this.categories,
    required this.sellBy,
    required this.onCategoryChanged,
    required this.onAddNewCategory,
    required this.onSellByChanged,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;

  final int? selectedCategoryId;
  final List<ProductCategory> categories;
  final String sellBy;

  final ValueChanged<int?> onCategoryChanged;
  final VoidCallback onAddNewCategory;
  final ValueChanged<String> onSellByChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _sectionCard(
          children: [
            _title("Item Name *"),
            SizedBox(height: 10.h),
            TextFormField(
              controller: nameController,
              decoration: _decoration(
                "Enter Product Name",
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        _sectionCard(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _title("Category"),
                TextButton.icon(
                  onPressed: onAddNewCategory,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("New Category", style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            DropdownButtonFormField<int?>(
              icon: const Icon(FlutterRemix.arrow_down_s_line),
              value: categories.any((c) => c.id == selectedCategoryId) ? selectedCategoryId : null,
              decoration: _decoration("Select Category"),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text("Uncategorized"),
                ),
                ...categories.map(
                  (cat) => DropdownMenuItem<int?>(
                    value: cat.id,
                    child: Text(cat.name),
                  ),
                ),
              ],
              onChanged: (value) {
                onCategoryChanged(value);
              },
            ),
          ],
        ),
        SizedBox(height: 14.h),
        _sectionCard(
          children: [
            _title("Sell By"),
            SizedBox(height: 10.h),
            DropdownButtonFormField<String>(
              value: sellBy,
              icon: const Icon(FlutterRemix.arrow_down_s_line),
              decoration: _decoration(""),
              items: const [
                DropdownMenuItem(
                  value: "Unit",
                  child: Text("Sell by Unit"),
                ),
                DropdownMenuItem(
                  value: "Weight",
                  child: Text("Sell by Weight"),
                ),
                DropdownMenuItem(
                  value: "Length",
                  child: Text("Sell by Length"),
                ),
                DropdownMenuItem(
                  value: "Volume",
                  child: Text("Sell by Volume"),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  onSellByChanged(value);
                }
              },
            ),
          ],
        ),
        SizedBox(height: 14.h),
        _sectionCard(
          children: [
            _title("Description"),
            SizedBox(height: 10.h),
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: _decoration(
                "Product Description",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionCard({
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _decoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
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
    );
  }
}
