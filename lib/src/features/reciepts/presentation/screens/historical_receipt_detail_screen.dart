import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/reciept_provider.dart';
import '../../domain/entities/reciept.dart';

class HistoricalReceiptDetailScreen extends ConsumerStatefulWidget {
  final Receipt receipt;

  const HistoricalReceiptDetailScreen({super.key, required this.receipt});

  @override
  ConsumerState<HistoricalReceiptDetailScreen> createState() => _HistoricalReceiptDetailScreenState();
}

class _HistoricalReceiptDetailScreenState extends ConsumerState<HistoricalReceiptDetailScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool _isSharing = false;

  Future<void> _shareReceipt() async {
    setState(() {
      _isSharing = true;
    });

    try {
      final image = await screenshotController.capture(delay: const Duration(milliseconds: 10));
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/receipt_${widget.receipt.id}.png').create();
        await imagePath.writeAsBytes(image);

        // Share the image using share_plus
        await Share.shareXFiles(
          [XFile(imagePath.path)],
          text: 'Here is your receipt from Mobile POS!',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share receipt: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void _cancelReceipt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Receipt'),
        content: const Text('Are you sure you want to cancel this receipt? This action cannot be undone and will reverse stock and accounting entries.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              context.pop();
              final success = await ref.read(cancelReceiptControllerProvider.notifier).cancelReceipt(widget.receipt.invoiceId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receipt cancelled successfully')));
                context.pop(); // Go back to list
              } else if (mounted) {
                final error = ref.read(cancelReceiptControllerProvider).error;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error?.toString() ?? 'Failed to cancel receipt')));
              }
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receipt = widget.receipt;
    final isCancelling = ref.watch(cancelReceiptControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text('Receipt ${receipt.id}'),
        leading: IconButton(
          icon: const Icon(FlutterRemix.close_line),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(FlutterRemix.delete_bin_line, color: Colors.red),
            tooltip: 'Cancel / Delete Receipt',
            onPressed: isCancelling ? null : _cancelReceipt,
          ),
          _isSharing
              ? const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(FlutterRemix.share_line),
                  onPressed: _shareReceipt,
                ),
        ],
      ),
      body: isCancelling
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400.w),
                  child: Screenshot(
                    controller: screenshotController,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Mobile POS',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Payment Method: ${receipt.paymentMethod}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Date: ${receipt.date.toString().split('.')[0]}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Divider(thickness: 1, color: Colors.grey.shade400),
                          SizedBox(height: 16.h),
                          
                          // Items List
                          if (receipt.items.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text('${receipt.itemsCount} Items (Details unavailable)'),
                            )
                          else
                            ...receipt.items.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${item.qty.toInt()}x '),
                                    Expanded(
                                      child: Text(
                                        item.productName,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text('\$${item.lineTotal.toStringAsFixed(2)}'),
                                  ],
                                ),
                              );
                            }),
                          
                          SizedBox(height: 16.h),
                          Divider(thickness: 1, color: Colors.grey.shade400),
                          SizedBox(height: 16.h),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subtotal', style: TextStyle(color: Colors.grey.shade600)),
                              Text('\$${receipt.subtotal.toStringAsFixed(2)}'),
                            ],
                          ),
                          if (receipt.taxTotal > 0) ...[
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tax', style: TextStyle(color: Colors.grey.shade600)),
                                Text('\$${receipt.taxTotal.toStringAsFixed(2)}'),
                              ],
                            ),
                          ],
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                '\$${receipt.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          Text(
                            'Thank you for your purchase!',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
