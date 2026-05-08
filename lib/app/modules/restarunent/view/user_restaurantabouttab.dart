
import 'package:eshoppy/app/modules/merchantlogin/widget/successwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/user_restaurantaboutsection_controller.dart';

class _T {
  static const primary      = Color(0xFF0F5151);
  static const primaryLight = Color(0xFFE8F5F0);
  static const bg           = Color(0xFFFAF8F4);
  static const cardBg       = Colors.white;
  static const textDark     = Color(0xFF12211C);
  static const textMid      = Color(0xFF6B6B6B);
  static const textLight    = Color(0xFFAAAAAA);
  static const divider      = Color(0xFFECE8E1);
  static const facebook     = Color(0xFF1877F2);
  static const instagram    = Color(0xFFE4405F);
  static const whatsapp     = Color(0xFF25D366);
  static const red          = Color(0xFFE53935);
  static const indigo       = Color(0xFF5C6BC0);
  static const blue         = Color(0xFF0288D1);
}

class RestaurantAboutTab extends StatelessWidget {
  final String restaurantId;
  const RestaurantAboutTab({super.key, required this.restaurantId});

  /// ✅ Strips http:// or https:// and trailing slash for clean UI display.
  /// e.g. "https://example.com/" → "example.com"
  String _stripHttps(String url) {
    return url
        .replaceFirst(RegExp(r'^https?://'), '')
        .replaceFirst(RegExp(r'/$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      RestaurantDetailsController(restaurantId: restaurantId),
      tag: restaurantId,
    );

    return Scaffold(
      backgroundColor: _T.bg,
      body: Obx(() {
        // ── LOADING ──────────────────────────────────────────────────────────
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: _T.primary, strokeWidth: 2.5),
                const SizedBox(height: 16),
                Text('Loading details...',
                    style: TextStyle(color: _T.textLight, fontSize: 14)),
              ],
            ),
          );
        }

        // ── ERROR ─────────────────────────────────────────────────────────────
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _T.red.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.wifi_off_rounded,
                        size: 40, color: _T.red),
                  ),
                  const SizedBox(height: 20),
                  const Text('Something went wrong',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _T.textDark)),
                  const SizedBox(height: 8),
                  Text(controller.errorMessage.value,
                      style:
                      const TextStyle(fontSize: 13, color: _T.textMid),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  _RetryButton(
                      onTap: () => controller.fetchRestaurantDetails()),
                ],
              ),
            ),
          );
        }

        // ── CONTENT ───────────────────────────────────────────────────────────
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Restaurant Info ───────────────────────────────────────────
              _SectionHeader(label: 'Restaurant Information'),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.storefront_rounded,
                label: 'NAME',
                value: controller.restaurantName.value,
                iconBg: _T.primaryLight,
                iconColor: _T.primary,
              ),
              if (controller.address.isNotEmpty) ...[
                const SizedBox(height: 8),
                _InfoCard(
                  icon: Icons.location_on_rounded,
                  label: 'ADDRESS',
                  value: controller.address.value,
                  iconBg: _T.red.withOpacity(0.08),
                  iconColor: _T.red,
                  trailing: const Icon(Icons.copy_rounded,
                      size: 15, color: _T.textLight),
                  onLongPress: () =>
                      _copyToClipboard(controller.address.value, 'Address'),
                ),
              ],

              // ── Contact ───────────────────────────────────────────────────
              const SizedBox(height: 28),
              _SectionHeader(label: 'Contact Information'),
              const SizedBox(height: 12),

              if (controller.phone.isNotEmpty) ...[
                _ActionCard(
                  icon: Icons.phone_rounded,
                  label: 'PHONE',
                  value: controller.phone.value,
                  iconBg: _T.primaryLight,
                  iconColor: _T.primary,
                  badgeLabel: 'Call',
                  badgeColor: _T.primary,
                  onTap: () => _makePhoneCall(controller.phone.value),
                ),
                const SizedBox(height: 8),
              ],
              if (controller.email.isNotEmpty) ...[
                _ActionCard(
                  icon: Icons.mail_rounded,
                  label: 'EMAIL',
                  value: controller.email.value,
                  iconBg: _T.indigo.withOpacity(0.08),
                  iconColor: _T.indigo,
                  badgeLabel: 'Mail',
                  badgeColor: _T.indigo,
                  onTap: () => _sendEmail(controller.email.value),
                ),
                const SizedBox(height: 8),
              ],
              if (controller.website.isNotEmpty) ...[
                _ActionCard(
                  icon: Icons.language_rounded,
                  label: 'WEBSITE',
                  // ✅ Display: strips http/https → shows "example.com"
                  value: _stripHttps(controller.website.value),
                  iconBg: _T.blue.withOpacity(0.08),
                  iconColor: _T.blue,
                  badgeLabel: 'Visit',
                  badgeColor: _T.blue,
                  // ✅ Launch: uses original full URL
                  onTap: () => _openUrl(controller.website.value),
                ),
                const SizedBox(height: 8),
              ],
              if (controller.whatsapp.isNotEmpty) ...[
                _ActionCard(
                  icon: Icons.chat_rounded,
                  label: 'WHATSAPP',
                  value: controller.whatsapp.value,
                  iconBg: _T.whatsapp.withOpacity(0.08),
                  iconColor: _T.whatsapp,
                  badgeLabel: 'Chat',
                  badgeColor: _T.whatsapp,
                  onTap: () => _openWhatsApp(controller.whatsapp.value),
                ),
              ],

              // ── Social ────────────────────────────────────────────────────
              if (controller.facebookLink.isNotEmpty ||
                  controller.instagramLink.isNotEmpty) ...[
                const SizedBox(height: 28),
                _SectionHeader(label: 'Social Media'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (controller.facebookLink.isNotEmpty)
                      Expanded(
                        child: _SocialCard(
                          icon: Icons.facebook_rounded,
                          label: 'Facebook',
                          // ✅ Display: strips http/https → shows clean handle
                          handle: _extractHandle(
                              controller.facebookLink.value),
                          color: _T.facebook,
                          bgColor: const Color(0xFFEDF3FF),
                          onTap: () =>
                              _openUrl(controller.facebookLink.value),
                        ),
                      ),
                    if (controller.facebookLink.isNotEmpty &&
                        controller.instagramLink.isNotEmpty)
                      const SizedBox(width: 10),
                    if (controller.instagramLink.isNotEmpty)
                      Expanded(
                        child: _SocialCard(
                          icon: Icons.camera_alt_rounded,
                          label: 'Instagram',
                          // ✅ Display: strips http/https → shows clean handle
                          handle: _extractHandle(
                              controller.instagramLink.value),
                          color: _T.instagram,
                          bgColor: const Color(0xFFFFF0F3),
                          onTap: () =>
                              _openUrl(controller.instagramLink.value),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  /// Extracts @handle from URL, or strips http if no path segments found.
  /// e.g. "https://facebook.com/mypage" → "@mypage"
  /// e.g. "https://facebook.com" → "facebook.com"
  String _extractHandle(String url) {
    try {
      final uri = Uri.parse(url);
      final segments =
      uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.isNotEmpty) return '@${segments.last}';
      // No path segment — fall back to clean domain
      return _stripHttps(url);
    } catch (_) {}
    return _stripHttps(url);
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('', '',
        titleText: const SizedBox.shrink(),
        messageText: Row(children: [
          const Icon(Icons.copy_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text('$label copied',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: _T.textDark,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        borderRadius: 14,
        duration: const Duration(seconds: 2));
  }

  void _makePhoneCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.error('Could not launch phone dialer');
    }
  }

  void _sendEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.error('Could not launch email client');
    }
  }

  void _openWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackbar.error('Could not launch WhatsApp');
    }
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackbar.error('Could not open link');
    }
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: _T.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: _T.textLight,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(color: _T.divider, thickness: 0.5),
        ),
      ],
    );
  }
}

// ── Info Card ──────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconBg;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onLongPress;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBg,
    required this.iconColor,
    this.trailing,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _T.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _T.divider, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _T.textLight,
                        letterSpacing: 0.8,
                      )),
                  const SizedBox(height: 3),
                  Text(value,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: _T.textDark,
                        height: 1.35,
                      )),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

// ── Action Card ────────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconBg;
  final Color iconColor;
  final String badgeLabel;
  final Color badgeColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBg,
    required this.iconColor,
    required this.badgeLabel,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _T.cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: iconColor.withOpacity(0.06),
        highlightColor: iconColor.withOpacity(0.03),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _T.divider, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _T.textLight,
                          letterSpacing: 0.8,
                        )),
                    const SizedBox(height: 3),
                    Text(value,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: _T.textDark,
                        ),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Social Card ────────────────────────────────────────────────────────────────
class _SocialCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String handle;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _SocialCard({
    required this.icon,
    required this.label,
    required this.handle,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _T.cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.08),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _T.divider, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.1,
                  )),
              const SizedBox(height: 3),
              Text(handle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: _T.textLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Open',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: color,
                        )),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 11, color: color),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Retry Button ───────────────────────────────────────────────────────────────
class _RetryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RetryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
        decoration: BoxDecoration(
          color: _T.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _T.primary.withOpacity(0.25),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, color: Colors.white, size: 17),
            SizedBox(width: 8),
            Text('Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                )),
          ],
        ),
      ),
    );
  }
}