//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../controller/user_restaurantaboutsection_controller.dart';
//
// class RestaurantAboutTab extends StatelessWidget {
//   final String restaurantId;
//
//   const RestaurantAboutTab({super.key, required this.restaurantId});
//
//   @override
//   Widget build(BuildContext context) {
//     final RestaurantDetailsController controller = Get.put(
//       RestaurantDetailsController(restaurantId: restaurantId),
//       tag: restaurantId,
//     );
//
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const Center(
//           child: CircularProgressIndicator(color: Colors.teal),
//         );
//       }
//
//       if (controller.errorMessage.isNotEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
//               const SizedBox(height: 16),
//               Text(
//                 controller.errorMessage.value,
//                 style: const TextStyle(fontSize: 16, color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () => controller.fetchRestaurantDetails(),
//                 child: const Text("Retry"),
//               ),
//             ],
//           ),
//         );
//       }
//
//       return SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Restaurant Name
//             _buildSectionTitle("Restaurant Information"),
//             const SizedBox(height: 12),
//             _buildInfoCard(
//               icon: Icons.restaurant,
//               title: "Name",
//               value: controller.restaurantName.value,
//             ),
//
//             /// Address
//             if (controller.address.isNotEmpty) ...[
//               const SizedBox(height: 12),
//               _buildInfoCard(
//                 icon: Icons.location_on,
//                 title: "Address",
//                 value: controller.address.value,
//               ),
//             ],
//
//             /// Contact Information
//             const SizedBox(height: 24),
//             _buildSectionTitle("Contact Information"),
//             const SizedBox(height: 12),
//
//             /// Phone
//             if (controller.phone.isNotEmpty) ...[
//               _buildClickableCard(
//                 icon: Icons.phone,
//                 title: "Phone",
//                 value: controller.phone.value,
//                 onTap: () => _makePhoneCall(controller.phone.value),
//               ),
//               const SizedBox(height: 12),
//             ],
//
//             /// Email
//             if (controller.email.isNotEmpty) ...[
//               _buildClickableCard(
//                 icon: Icons.email,
//                 title: "Email",
//                 value: controller.email.value,
//                 onTap: () => _sendEmail(controller.email.value),
//               ),
//               const SizedBox(height: 12),
//             ],
//
//             /// Website
//             if (controller.website.isNotEmpty) ...[
//               _buildClickableCard(
//                 icon: Icons.language,
//                 title: "Website",
//                 value: controller.website.value,
//                 onTap: () => _openWebsite(controller.website.value),
//               ),
//               const SizedBox(height: 12),
//             ],
//
//             /// WhatsApp
//             if (controller.whatsapp.isNotEmpty) ...[
//               _buildClickableCard(
//                 icon: Icons.chat,
//                 title: "WhatsApp",
//                 value: controller.whatsapp.value,
//                 onTap: () => _openWhatsApp(controller.whatsapp.value),
//                 color: Colors.green,
//               ),
//               const SizedBox(height: 12),
//             ],
//
//             /// Social Media
//             if (controller.facebookLink.isNotEmpty ||
//                 controller.instagramLink.isNotEmpty) ...[
//               const SizedBox(height: 24),
//               _buildSectionTitle("Social Media"),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   if (controller.facebookLink.isNotEmpty)
//                     Expanded(
//                       child: _buildSocialButton(
//                         icon: Icons.facebook,
//                         label: "Facebook",
//                         color: const Color(0xFF1877F2),
//                         onTap: () => _openUrl(controller.facebookLink.value),
//                       ),
//                     ),
//                   if (controller.facebookLink.isNotEmpty &&
//                       controller.instagramLink.isNotEmpty)
//                     const SizedBox(width: 12),
//                   if (controller.instagramLink.isNotEmpty)
//                     Expanded(
//                       child: _buildSocialButton(
//                         icon: Icons.camera_alt,
//                         label: "Instagram",
//                         color: const Color(0xFFE4405F),
//                         onTap: () => _openUrl(controller.instagramLink.value),
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.black87,
//       ),
//     );
//   }
//
//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.teal.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: Colors.teal, size: 24),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildClickableCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: (color ?? Colors.teal).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: color ?? Colors.teal, size: 24),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     value,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios,
//                 size: 16, color: Colors.grey.shade400),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSocialButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return ElevatedButton.icon(
//       onPressed: onTap,
//       icon: Icon(icon, size: 20),
//       label: Text(label),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
//
//   /// URL Launchers
//   void _makePhoneCall(String phone) async {
//     final Uri uri = Uri(scheme: 'tel', path: phone);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       Get.snackbar("Error", "Could not launch phone dialer");
//     }
//   }
//
//   void _sendEmail(String email) async {
//     final Uri uri = Uri(scheme: 'mailto', path: email);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       Get.snackbar("Error", "Could not launch email client");
//     }
//   }
//
//   void _openWebsite(String url) async {
//     _openUrl(url);
//   }
//
//   void _openWhatsApp(String phone) async {
//     final Uri uri = Uri.parse("https://wa.me/$phone");
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       Get.snackbar("Error", "Could not launch WhatsApp");
//     }
//   }
//
//   void _openUrl(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       Get.snackbar("Error", "Could not open link");
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/user_restaurantaboutsection_controller.dart';

// ── THEME CONSTANTS (shared with menu tab) ────────────────────────────────────
class _T {
  static const primary = Color(0xFF1A7A5E);
  static const primaryLight = Color(0xFFE8F5F0);
  static const primarySoft = Color(0xFFB2DDD2);
  static const bg = Color(0xFFF8F9FA);
  static const cardBg = Colors.white;
  static const textDark = Color(0xFF1C1C1E);
  static const textMid = Color(0xFF6B6B6B);
  static const textLight = Color(0xFFAAAAAA);
  static const divider = Color(0xFFF0F0F0);
  static const facebook = Color(0xFF1877F2);
  static const instagram = Color(0xFFE4405F);
  static const whatsapp = Color(0xFF25D366);
}

class RestaurantAboutTab extends StatelessWidget {
  final String restaurantId;

  const RestaurantAboutTab({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final RestaurantDetailsController controller = Get.put(
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
                CircularProgressIndicator(
                    color: _T.primary, strokeWidth: 2.5),
                const SizedBox(height: 16),
                Text(
                  'Loading details...',
                  style: TextStyle(color: _T.textLight, fontSize: 14),
                ),
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF0F0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.wifi_off_rounded,
                        size: 40, color: Color(0xFFE53935)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _T.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    style:
                    const TextStyle(fontSize: 13, color: _T.textMid),
                    textAlign: TextAlign.center,
                  ),
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
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── SECTION: RESTAURANT INFO ──────────────────────────────────
              _SectionLabel(label: 'Restaurant Information'),
              const SizedBox(height: 12),

              _InfoCard(
                icon: Icons.storefront_rounded,
                label: 'Name',
                value: controller.restaurantName.value,
              ),

              if (controller.address.isNotEmpty) ...[
                const SizedBox(height: 10),
                _InfoCard(
                  icon: Icons.location_on_rounded,
                  label: 'Address',
                  value: controller.address.value,
                  iconColor: const Color(0xFFE53935),
                  onLongPress: () =>
                      _copyToClipboard(controller.address.value, 'Address'),
                ),
              ],

              // ── SECTION: CONTACT ──────────────────────────────────────────
              const SizedBox(height: 28),
              _SectionLabel(label: 'Contact Information'),
              const SizedBox(height: 12),

              if (controller.phone.isNotEmpty) ...[
                _ActionCard(
                  icon: Icons.phone_rounded,
                  label: 'Phone',
                  value: controller.phone.value,
                  iconColor: _T.primary,
                  badgeLabel: 'Call',
                  badgeColor: _T.primary,
                  onTap: () => _makePhoneCall(controller.phone.value),
                ),
                const SizedBox(height: 10),
              ],

              if (controller.email.isNotEmpty) ...[
                _ActionCard(
                  icon: Icons.mail_rounded,
                  label: 'Email',
                  value: controller.email.value,
                  iconColor: const Color(0xFF5C6BC0),
                  badgeLabel: 'Mail',
                  badgeColor: const Color(0xFF5C6BC0),
                  onTap: () => _sendEmail(controller.email.value),
                ),
                const SizedBox(height: 10),
              ],

              if (controller.website.isNotEmpty) ...[
                _ActionCard(
                  icon: Icons.language_rounded,
                  label: 'Website',
                  value: controller.website.value,
                  iconColor: const Color(0xFF0288D1),
                  badgeLabel: 'Visit',
                  badgeColor: const Color(0xFF0288D1),
                  onTap: () => _openUrl(controller.website.value),
                ),
                const SizedBox(height: 10),
              ],

              if (controller.whatsapp.isNotEmpty) ...[
                _ActionCard(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  value: controller.whatsapp.value,
                  iconColor: _T.whatsapp,
                  badgeLabel: 'Chat',
                  badgeColor: _T.whatsapp,
                  onTap: () => _openWhatsApp(controller.whatsapp.value),
                ),
                const SizedBox(height: 10),
              ],

              // ── SECTION: SOCIAL MEDIA ────────────────────────────────────
              if (controller.facebookLink.isNotEmpty ||
                  controller.instagramLink.isNotEmpty) ...[
                const SizedBox(height: 28),
                _SectionLabel(label: 'Social Media'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (controller.facebookLink.isNotEmpty)
                      Expanded(
                        child: _SocialCard(
                          icon: Icons.facebook_rounded,
                          label: 'Facebook',
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
                      const SizedBox(width: 12),
                    if (controller.instagramLink.isNotEmpty)
                      Expanded(
                        child: _SocialCard(
                          icon: Icons.camera_alt_rounded,
                          label: 'Instagram',
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

  String _extractHandle(String url) {
    try {
      final uri = Uri.parse(url);
      final segments =
      uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.isNotEmpty) return '@${segments.last}';
    } catch (_) {}
    return url;
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          const Icon(Icons.copy_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            '$label copied to clipboard',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      backgroundColor: _T.textDark,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
    );
  }

  void _makePhoneCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch phone dialer');
    }
  }

  void _sendEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch email client');
    }
  }

  void _openWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not launch WhatsApp');
    }
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open link');
    }
  }
}

// ── SECTION LABEL ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: _T.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _T.textDark,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ── INFO CARD (non-clickable) ─────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final VoidCallback? onLongPress;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = _T.primary,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.055),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _T.textLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _T.textDark,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (onLongPress != null) ...[
              const SizedBox(width: 8),
              Tooltip(
                message: 'Long press to copy',
                child: Icon(Icons.copy_rounded,
                    size: 16, color: _T.textLight),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── ACTION CARD (clickable) ───────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final String badgeLabel;
  final Color badgeColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.badgeLabel,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: iconColor.withOpacity(0.08),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.055),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _T.textLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _T.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Action badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                    letterSpacing: 0.3,
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

// ── SOCIAL CARD ───────────────────────────────────────────────────────────────
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.055),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Icon circle
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                handle,
                style: const TextStyle(
                  fontSize: 11,
                  color: _T.textLight,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Open',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 12, color: color),
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

// ── RETRY BUTTON ──────────────────────────────────────────────────────────────
class _RetryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RetryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: _T.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _T.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Try Again',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}