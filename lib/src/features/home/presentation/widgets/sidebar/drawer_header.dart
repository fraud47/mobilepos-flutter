import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';

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
              fontWeight:
              FontWeight.w500,
            ),
          ),

          SizedBox(height: 10.h),

          // =====================================================
          // COMPANY + USER DETAILS
          // =====================================================

          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: 10.h,
              left: 16.w,
              right: 5.w,
              bottom: 10.h,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // COMPANY LOGO
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration:
                        BoxDecoration(
                          color: colorScheme
                              .primary
                              .withOpacity(.1),
                          borderRadius:
                          BorderRadius
                              .circular(
                            4.r,
                          ),
                        ),
                        child: Icon(
                          FlutterRemix
                              .store_2_fill,
                          color:
                          colorScheme
                              .primary,
                          size: 40.sp,
                        ),
                      ),

                      SizedBox(width: 10.w),

                      // COMPANY DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              companyName,
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style:
                              TextStyle(
                                fontWeight:
                                FontWeight
                                    .w700,
                                fontSize:
                                14.sp,
                              ),
                            ),

                            SizedBox(
                              height: 3.h,
                            ),

                            Text(
                              userEmail,
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style:
                              TextStyle(
                                color:
                                Colors.grey[
                                600],
                                fontSize:
                                10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ACTIONS
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FlutterRemix
                            .edit_box_line,
                        size: 16.sp,
                        color:
                        colorScheme
                            .primary,
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        color:
                        colorScheme
                            .primary,
                        Icons.unfold_more,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =====================================================
          // SUBSCRIPTION
          // =====================================================

          Container(
            width: double.infinity,
            padding:
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 4.h,
            ),
            decoration:
            const BoxDecoration(
              gradient:
              LinearGradient(
                colors: [
                  Color(0xFF9C27B0),
                  Color(0xFF7B1FA2),
                ],
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  FlutterRemix
                      .vip_crown_fill,
                  color: Colors.amber,
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                       session!.companies.first.subscriptionPlan.toUpperCase(),
                        style:
                        TextStyle(
                          color:
                          Colors.white,
                          fontSize:
                          14.sp,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),

                      Text(
                        session.companies.first.subscriptionStatus,
                        style:
                        TextStyle(
                          color:
                          Colors.white70,
                          fontSize:
                          10.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  FlutterRemix
                      .arrow_down_s_line,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          // =====================================================
          // LOGGED-IN USER
          // =====================================================

          Container(
            color: Colors.white,
            padding:
            EdgeInsets.symmetric(
              horizontal: 10.w,
            ),
            child: Row(
              children: [
                // USER AVATAR
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration:
                  BoxDecoration(
                    color: colorScheme
                        .primary
                        .withOpacity(.1),
                    shape:
                    BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(
                        userName,
                      ),
                      style:
                      TextStyle(
                        color:
                        colorScheme
                            .primary,
                        fontSize:
                        10.sp,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        userName,
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style:
                        TextStyle(
                          fontSize:
                          13.sp,
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),

                      SizedBox(
                        height: 2.h,
                      ),

                      Text(
                        userEmail,
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style:
                        TextStyle(
                          color:
                          Colors.grey[
                          600],
                          fontSize:
                          10.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FlutterRemix
                        .edit_box_line,
                    color:
                    colorScheme
                        .primary,
                    size: 16.sp,
                  ),
                ),
              ],
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
