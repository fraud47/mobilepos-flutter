import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilepos/src/routing/app_routes.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';
import '../../../../branches/presentation/providers/branch_provider.dart';
import '../../../../branches/domain/entities/branch.dart';
import '../../providers/home_provider.dart';


class HeaderDrawer extends ConsumerWidget {
  const HeaderDrawer({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    final sessionState =
    ref.watch(sessionProvider);

    final session = sessionState.session;
    final user = session?.user;
    final tenant = session?.tenant;
    final companies = session?.companies ?? [];
    final company = companies.isNotEmpty ? companies.first : null;
    final userName = tenant?.name ?? 'User';

    final userEmail = user?.email ?? '';


    final companyName =
        company?.name ??
            tenant?.name ??
            'My Company';

    return Container(
      color: colorScheme.primary,
      child: Column(
        children: [
          SizedBox(height: 10.h),

          // =====================================================
          // APP NAME
          // =====================================================

          Text(
            "Mberiko POS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),

          Text(
            "v1.0.0",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 10.h),

          // =====================================================
          // COMPANY + USER DETAILS
          // =====================================================

          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => context.push(AppRoutes.profile),
              child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
              top: 10.h,
              left: 16.w,
              right: 16.w,
              bottom: 10.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // COMPANY LOGO
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    FlutterRemix.store_2_fill,
                    color: colorScheme.primary,
                    size: 30.sp,
                  ),
                ),

                SizedBox(width: 10.w),

                // COMPANY NAME + EMAIL + PLAN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        userEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // SUBSCRIPTION PLAN BADGE
                      if (company?.subscriptionPlan != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FlutterRemix.vip_crown_fill, color: Colors.amber, size: 12.sp),
                              SizedBox(width: 4.w),
                              Text(
                                company!.subscriptionPlan.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      SizedBox(height: 10.h),
                      
                      // BRANCH SELECTOR
                      Consumer(
                        builder: (context, ref, _) {
                          final activeBranch = ref.watch(activeBranchProvider);
                          final branchesAsync = ref.watch(branchesProvider);

                          return branchesAsync.when(
                            data: (branches) {
                              if (branches.isEmpty) {
                                return Text(
                                  'No branches available',
                                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                );
                              }

                              return Container(
                                height: 35.h,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Branch>(
                                    value: activeBranch ?? branches.first,
                                    isExpanded: true,
                                    icon: Icon(FlutterRemix.arrow_down_s_line, size: 16.sp),
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    onChanged: (Branch? newValue) {
                                      if (newValue != null) {
                                        ref.read(activeBranchProvider.notifier).setBranch(newValue);
                                        // Clear the cart so we don't carry over items to another branch's sale
                                        ref.read(homeControllerProvider.notifier).clearCart();
                                        
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Switched to ${newValue.name} branch'),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.black87,
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    items: branches.map<DropdownMenuItem<Branch>>((Branch branch) {
                                      return DropdownMenuItem<Branch>(
                                        value: branch,
                                        child: Text(branch.name),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                            loading: () => const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            error: (err, _) => Text(
                              'Failed to load branches',
                              style: TextStyle(fontSize: 10.sp, color: Colors.red),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 8.h),
                      // "View Profile" hint
                      Row(
                        children: [
                          Icon(FlutterRemix.user_line, size: 12.sp, color: Colors.grey.shade500),
                          SizedBox(width: 4.w),
                          Text('View Profile', style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade500)),
                          SizedBox(width: 2.w),
                          Icon(FlutterRemix.arrow_right_s_line, size: 12.sp, color: Colors.grey.shade400),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(
      String name,
      ) {
    final parts =
    name.trim().split(
      RegExp(r'\s+'),
    );

    if (parts.isEmpty ||
        parts.first.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first
          .substring(
        0,
        1,
      )
          .toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
