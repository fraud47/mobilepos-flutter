import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';

class ReceiptDetailScreen extends StatefulWidget {
  final HomeState state;

  const ReceiptDetailScreen({super.key, required this.state});

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> {
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
        final imagePath = await File('${directory.path}/receipt.png').create();
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

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.state.subtotal;
    final total = subtotal + (subtotal * 0.155);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Receipt'),
        leading: IconButton(
          icon: const Icon(FlutterRemix.close_line),
          onPressed: () => context.pop(),
        ),
        actions: [
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
      body: SingleChildScrollView(
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
                      'Payment Method: CASH',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Date: ${DateTime.now().toString().split('.')[0]}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Divider(thickness: 1, color: Colors.grey.shade400),
                    SizedBox(height: 16.h),
                    
                    // Items List
                    ...widget.state.cartItems.map((item) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item.quantity.toInt()}x '),
                            Expanded(
                              child: Text(
                                item.product.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
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
                        Text('\$${subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('VAT 15.5%', style: TextStyle(color: Colors.grey.shade600)),
                        Text('\$${(subtotal * 0.155).toStringAsFixed(2)}'),
                      ],
                    ),
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
                          '\$${total.toStringAsFixed(2)}',
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
