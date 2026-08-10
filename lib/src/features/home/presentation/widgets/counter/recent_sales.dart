import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/features/reciepts/presentation/providers/reciept_provider.dart';

class RecentSalesSection extends ConsumerWidget {
  const RecentSalesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptsAsync = ref.watch(receiptProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Sales',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('See all'),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        receiptsAsync.when(
          data: (receipts) {
            if (receipts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No recent sales'),
              );
            }
            
            // Sort by date descending and take top 3
            final sorted = [...receipts]..sort((a, b) => b.date.compareTo(a.date));
            final recent = sorted.take(3).toList();

            return Column(
              children: recent.map((receipt) {
                final difference = DateTime.now().difference(receipt.date);
                String timeAgo = '';
                if (difference.inDays > 0) {
                  timeAgo = '${difference.inDays} days ago';
                } else if (difference.inHours > 0) {
                  timeAgo = '${difference.inHours} hours ago';
                } else {
                  timeAgo = '${difference.inMinutes} min ago';
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _SaleTile(
                    invoice: '#${receipt.id}',
                    amount: '\$${receipt.amount.toStringAsFixed(2)}',
                    time: timeAgo,
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }
}

class _SaleTile extends StatelessWidget {
  const _SaleTile({
    required this.invoice,
    required this.amount,
    required this.time,
  });

  final String invoice;
  final String amount;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            child: const Icon(Icons.receipt_long),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
