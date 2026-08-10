import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilepos/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobilepos/src/routing/app_routes.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isDeactivating = false;

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
  }

  Color _planColor(String plan) {
    switch (plan.toLowerCase()) {
      case 'pro':
      case 'premium':
        return const Color(0xFF7B1FA2);
      case 'enterprise':
        return const Color(0xFF1565C0);
      case 'trial':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF546E7A);
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ResetPasswordDialog(),
    );
  }

  void _showDeactivateDialog(String email) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            const Icon(FlutterRemix.error_warning_fill, color: Colors.red, size: 22),
            const SizedBox(width: 8),
            Text('Deactivate Account', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to deactivate your account?',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _warningItem('Your account and all data will be deactivated.'),
                  _warningItem('You will lose access to all company resources.'),
                  _warningItem('This action requires admin intervention to reverse.'),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text('To proceed, please contact your system administrator or send a deactivation request to support.', style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            icon: const Icon(FlutterRemix.mail_send_line, size: 16),
            label: const Text('Contact Support'),
            onPressed: () {
              ctx.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Please contact support@mberiko.com to deactivate your account.'),
                  backgroundColor: Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 5),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _warningItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(FlutterRemix.close_circle_fill, color: Colors.red.shade700, size: 14.sp),
          SizedBox(width: 6.w),
          Expanded(child: Text(text, style: TextStyle(fontSize: 11.sp, color: Colors.red.shade800))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionProvider);
    final session = sessionState.session;
    final user = session?.user;
    final tenant = session?.tenant;
    final companies = session?.companies ?? [];
    final company = companies.isNotEmpty ? companies.first : null;

    final displayName = tenant?.name ?? 'User';
    final email = user?.email ?? '';
    final companyName = company?.name ?? tenant?.name ?? 'My Company';
    final subscriptionPlan = company?.subscriptionPlan ?? tenant?.subscriptionPlan ?? 'trial';
    final subscriptionStatus = company?.subscriptionStatus ?? tenant?.subscriptionStatus ?? 'active';
    final role = company?.role ?? 'OWNER';
    final trialEndsAt = company?.trialEndsAt;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          // ─── HERO APP BAR ───────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220.h,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: const Icon(FlutterRemix.arrow_left_line, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      // Avatar
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(displayName),
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Role badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.white38),
                        ),
                        child: Text(
                          role.replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ─── CONTENT ────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ─── ACCOUNT INFORMATION ─────────────────────────────────
                _SectionHeader(title: 'Account Information', icon: FlutterRemix.user_3_line),
                SizedBox(height: 8.h),
                _InfoCard(
                  children: [
                    _InfoRow(icon: FlutterRemix.mail_line, label: 'Email', value: email, copyable: true),
                    const Divider(height: 1),
                    _InfoRow(icon: FlutterRemix.shield_user_line, label: 'Role', value: role.replaceAll('_', ' ')),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: FlutterRemix.fingerprint_line,
                      label: 'Account ID',
                      value: user != null ? '#${user.accountId}' : '—',
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ─── COMPANY DETAILS ──────────────────────────────────────
                _SectionHeader(title: 'Company Details', icon: FlutterRemix.building_2_line),
                SizedBox(height: 8.h),
                _InfoCard(
                  children: [
                    _InfoRow(icon: FlutterRemix.store_2_line, label: 'Company', value: companyName),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: FlutterRemix.global_line,
                      label: 'Slug / ID',
                      value: company?.slug ?? tenant?.slug ?? '—',
                      copyable: true,
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: FlutterRemix.git_branch_line,
                      label: 'Branches',
                      value: company?.branchCount != null ? '${company!.branchCount} branch(es)' : '—',
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ─── SUBSCRIPTION ─────────────────────────────────────────
                _SectionHeader(title: 'Subscription', icon: FlutterRemix.vip_crown_line),
                SizedBox(height: 8.h),
                _InfoCard(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      child: Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: _planColor(subscriptionPlan).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(FlutterRemix.vip_crown_fill, color: _planColor(subscriptionPlan), size: 18.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subscriptionPlan.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: _planColor(subscriptionPlan),
                                  ),
                                ),
                                Text(
                                  'Status: ${subscriptionStatus.toUpperCase()}',
                                  style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
                                ),
                                if (trialEndsAt != null && subscriptionStatus.toLowerCase() == 'trialing') ...[  
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(FlutterRemix.time_line, size: 11.sp, color: Colors.orange.shade700),
                                      SizedBox(width: 3.w),
                                      Text(
                                        'Ends: ${_formatDate(trialEndsAt)}',
                                        style: TextStyle(fontSize: 11.sp, color: Colors.orange.shade700, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: subscriptionStatus.toLowerCase() == 'trialing'
                                  ? Colors.orange.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: subscriptionStatus.toLowerCase() == 'trialing'
                                    ? Colors.orange.shade300
                                    : Colors.green.shade300,
                              ),
                            ),
                            child: Text(
                              subscriptionStatus.toLowerCase() == 'trialing' ? 'Trial' : 'Active',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: subscriptionStatus.toLowerCase() == 'trialing'
                                    ? Colors.orange.shade800
                                    : Colors.green.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ─── ACCOUNT ACTIONS ──────────────────────────────────────
                _SectionHeader(title: 'Account Actions', icon: FlutterRemix.settings_3_line),
                SizedBox(height: 8.h),

                _ActionTile(
                  icon: FlutterRemix.lock_password_line,
                  iconColor: const Color(0xFF1976D2),
                  title: 'Reset Password',
                  subtitle: 'Send a password reset link to your email',
                  onTap: _showResetPasswordDialog,
                ),

                SizedBox(height: 8.h),

                _ActionTile(
                  icon: FlutterRemix.logout_box_r_line,
                  iconColor: Colors.orange,
                  title: 'Sign Out',
                  subtitle: 'Log out from this device',
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                        title: const Text('Sign Out?'),
                        content: const Text('You will be logged out from this device.'),
                        actions: [
                          TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () => ctx.pop(true),
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && mounted) {
                      await ref.read(sessionProvider.notifier).logout();
                    }
                  },
                ),

                SizedBox(height: 8.h),

                _ActionTile(
                  icon: FlutterRemix.user_unfollow_line,
                  iconColor: Colors.red,
                  title: 'Deactivate Account',
                  subtitle: 'Permanently disable your account access',
                  onTap: () => _showDeactivateDialog(email),
                  destructive: true,
                ),

                SizedBox(height: 32.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── RESET PASSWORD DIALOG ──────────────────────────────────────────────────
class _ResetPasswordDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends ConsumerState<_ResetPasswordDialog> {
  bool _loading = false;
  bool _sent = false;

  Future<void> _send() async {
    final sessionState = ref.read(sessionProvider);
    final email = sessionState.user?.email ?? '';
    if (email.isEmpty) return;

    setState(() => _loading = true);
    final success = await ref.read(sessionProvider.notifier).forgotPassword(email: email);
    if (mounted) {
      setState(() {
        _loading = false;
        _sent = success;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionProvider);
    final email = sessionState.user?.email ?? '';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(FlutterRemix.lock_password_line, color: Color(0xFF1976D2), size: 22),
          const SizedBox(width: 8),
          const Text('Reset Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      content: _sent
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FlutterRemix.mail_check_line, size: 48, color: Colors.green),
                const SizedBox(height: 12),
                const Text('Reset link sent!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  'A password reset link has been sent to $email. Check your inbox and follow the instructions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('A password reset link will be sent to:'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    email,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1976D2)),
                  ),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(_sent ? 'Close' : 'Cancel'),
        ),
        if (!_sent)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _loading ? null : _send,
            icon: _loading
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(FlutterRemix.send_plane_line, size: 16),
            label: Text(_loading ? 'Sending...' : 'Send Reset Link'),
          ),
      ],
    );
  }
}

// ─── REUSABLE WIDGETS ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool copyable;
  const _InfoRow({required this.icon, required this.label, required this.value, this.copyable = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: copyable
          ? () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label copied!'), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            if (copyable)
              Icon(FlutterRemix.file_copy_line, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: destructive ? Colors.red : Colors.black87,
                      ),
                    ),
                    Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Icon(FlutterRemix.arrow_right_s_line, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
