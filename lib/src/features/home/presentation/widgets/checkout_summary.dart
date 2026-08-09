import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'checkout_link.dart';
import 'flat_panel.dart';
import 'summary_row.dart';

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({super.key, required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final total = state.subtotal.toStringAsFixed(2);

    return FlatPanel(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 14.h),
        child: Column(
          children: [
            SummaryRow(label: 'Subtotal', value: total),
            SizedBox(height: 12.h),
            const SummaryRow(
              label: 'Round Off (Click here to Enable)',
              value: '',
            ),
            SizedBox(height: 10.h),
            const Divider(height: 1, color: Colors.black54),
            SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  'Grand Total',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'ZWD$total',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                CheckoutLink(label: 'Add Tax', onPressed: () {}),
                const Spacer(),
                Text(
                  '${state.itemCount} Items | ${formatQuantity(state.unitCount)} Units',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                CheckoutLink(label: 'Add Discount', onPressed: () {}),
                const Spacer(),
                CheckoutLink(label: 'Add Other Charges', onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
