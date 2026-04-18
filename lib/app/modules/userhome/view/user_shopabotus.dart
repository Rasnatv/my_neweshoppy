
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/user_shopaboutcontroller.dart';

class MerchantAboutPage extends StatelessWidget {
  final int merchantId;

  MerchantAboutPage({super.key, required this.merchantId});

  final controller = Get.put(MerchantAboutController());

  @override
  Widget build(BuildContext context) {
    controller.loadAbout(merchantId);
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 2.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Loading merchant details...",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        );
      }

      final about = controller.about.value;

      if (about == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.info_outline_rounded, size: 56, color: Colors.grey[350]),
              ),
              const SizedBox(height: 24),
              Text(
                "No details available",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Merchant information is not available at the moment",
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Container(
        color: const Color(0xFFF7F8FA),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          children: [
            // ── Contact Information ──
            _SectionCard(
              title: "Contact Information",
              icon: Icons.contacts_rounded,
              children: [
                if (about.phone1.isNotEmpty)
                  _ContactTile(
                    icon: _SocialIcon.phone(),
                    label: "Primary Phone",
                    value: about.phone1,
                    onTap: () => _launchUrl('tel:${about.phone1}'),
                    trailingIcon: Icons.call_rounded,
                    accentColor: const Color(0xFF2196F3),
                  ),
                if (about.phone2.isNotEmpty)
                  _ContactTile(
                    icon: _SocialIcon.phoneMobile(),
                    label: "Secondary Phone",
                    value: about.phone2,
                    onTap: () => _launchUrl('tel:${about.phone2}'),
                    trailingIcon: Icons.call_rounded,
                    accentColor: const Color(0xFF00897B),
                  ),
                if (about.email.isNotEmpty)
                  _ContactTile(
                    icon: _SocialIcon.email(),
                    label: "Email Address",
                    value: about.email,
                    onTap: () => _launchUrl('mailto:${about.email}'),
                    trailingIcon: Icons.send_rounded,
                    accentColor: const Color(0xFFE53935),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Location ──
            if (about.address.isNotEmpty)
              _SectionCard(
                title: "Location",
                icon: Icons.location_on_rounded,
                children: [
                  _ContactTile(
                    icon: _SocialIcon.location(),
                    label: "Store Address",
                    value: about.address,
                    onTap: () => _launchUrl(
                        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(about.address)}'),
                    trailingIcon: Icons.arrow_circle_right,
                    accentColor: const Color(0xFFFF6F00),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // ── Online Presence ──
            _buildOnlinePresenceSection(about),

            const SizedBox(height: 32),
          ],
        ),
      );
    });
  }

  Widget _buildOnlinePresenceSection(dynamic about) {
    final hasOnline = about.website.isNotEmpty ||
        about.whatsapp.isNotEmpty ||
        about.facebook.isNotEmpty ||
        about.instagram.isNotEmpty;

    if (!hasOnline) return const SizedBox.shrink();

    return _SectionCard(
      title: "Online Presence",
      icon: Icons.public_rounded,
      children: [
        if (about.website.isNotEmpty)
          _SocialTile(
            iconWidget: _SocialIcon.website(),
            platform: "Website",
            value: about.website,
            accentColor: const Color(0xFF5C6BC0),
            bgColor: const Color(0xFFEDE7F6),
            onTap: () => _launchUrl(_formatUrl(about.website)),
          ),
        if (about.whatsapp.isNotEmpty)
          _SocialTile(
            iconWidget: _WhatsAppIcon(size: 22),
            platform: "WhatsApp",
            value: about.whatsapp,
            accentColor: const Color(0xFF25D366),
            bgColor: const Color(0xFFE8F5E9),
            onTap: () => _launchUrl('https://wa.me/${about.whatsapp}'),
          ),
        if (about.facebook.isNotEmpty)
          _SocialTile(
            iconWidget: _FacebookIcon(size: 22),
            platform: "Facebook",
            value: about.facebook,
            accentColor: const Color(0xFF1877F2),
            bgColor: const Color(0xFFE3F2FD),
            onTap: () => _launchUrl(_formatUrl(about.facebook)),
          ),
        if (about.instagram.isNotEmpty)
          _SocialTile(
            iconWidget: _InstagramIcon(size: 22),
            platform: "Instagram",
            value: about.instagram,
            accentColor: const Color(0xFFE1306C),
            bgColor: const Color(0xFFFCE4EC),
            onTap: () => _launchUrl(_formatUrl(about.instagram)),
          ),
      ],
    );
  }

  String _formatUrl(String url) {
    if (url.isEmpty) return url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar(
          'Error',
          'Could not open link',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Invalid URL',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  Section Card
// ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[500],
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 4),
          ...children,
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Contact Tile  (phone / email / address)
// ─────────────────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  final Widget icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final IconData trailingIcon;
  final Color accentColor;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    required this.trailingIcon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icon
              SizedBox(width: 28, height: 28, child: icon),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Action button
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(trailingIcon, size: 16, color: accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Social Tile  (website / whatsapp / facebook / instagram)
// ─────────────────────────────────────────────────────────────

class _SocialTile extends StatelessWidget {
  final Widget iconWidget;
  final String platform;
  final String value;
  final Color accentColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _SocialTile({
    required this.iconWidget,
    required this.platform,
    required this.value,
    required this.accentColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Platform icon badge
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: iconWidget,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platform,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 12,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: accentColor.withOpacity(0.4),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new_rounded, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Generic icon helpers (Material-based, styled)
// ─────────────────────────────────────────────────────────────

class _SocialIcon {
  static Widget phone() => Icon(Icons.phone_rounded, color: const Color(0xFF2196F3), size: 22);
  static Widget phoneMobile() => Icon(Icons.phone_android_rounded, color: const Color(0xFF00897B), size: 22);
  static Widget email() => Icon(Icons.mail_rounded, color: const Color(0xFFE53935), size: 22);
  static Widget location() => Icon(Icons.location_on_rounded, color: const Color(0xFFFF6F00), size: 22);
  static Widget website() => Icon(Icons.language_rounded, color: const Color(0xFF5C6BC0), size: 22);
}

// ─────────────────────────────────────────────────────────────
//  WhatsApp Icon  (custom painter – official green logo shape)
// ─────────────────────────────────────────────────────────────

class _WhatsAppIcon extends StatelessWidget {
  final double size;
  const _WhatsAppIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WhatsAppPainter(),
    );
  }
}

class _WhatsAppPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;

    // Green circle background
    final bgPaint = Paint()..color = const Color(0xFF25D366);
    canvas.drawCircle(Offset(s / 2, s / 2), s / 2, bgPaint);

    // White phone handset path (simplified WhatsApp icon)
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Scale path to size
    final Path path = Path();
    final double scale = s / 24.0;

    // Outer speech bubble shape
    path.moveTo(12 * scale, 2 * scale);
    path.cubicTo(6.48 * scale, 2 * scale, 2 * scale, 6.48 * scale, 2 * scale, 12 * scale);
    path.cubicTo(2 * scale, 13.85 * scale, 2.46 * scale, 15.58 * scale, 3.33 * scale, 17.12 * scale);
    path.lineTo(2.05 * scale, 21.95 * scale);
    path.lineTo(7.0 * scale, 20.69 * scale);
    path.cubicTo(8.49 * scale, 21.49 * scale, 10.22 * scale, 22 * scale, 12 * scale, 22 * scale);
    path.cubicTo(17.52 * scale, 22 * scale, 22 * scale, 17.52 * scale, 22 * scale, 12 * scale);
    path.cubicTo(22 * scale, 6.48 * scale, 17.52 * scale, 2 * scale, 12 * scale, 2 * scale);
    path.close();

    canvas.drawPath(path, bgPaint..color = const Color(0xFF25D366));

    // Phone handset (white)
    final phonePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final phonePath = Path();
    // Simplified phone handset path centered in icon
    phonePath.moveTo(9.0 * scale, 5.5 * scale);
    phonePath.cubicTo(8.5 * scale, 5.5 * scale, 7.5 * scale, 5.9 * scale, 7.0 * scale, 7.0 * scale);
    phonePath.cubicTo(6.5 * scale, 8.1 * scale, 6.6 * scale, 9.8 * scale, 7.8 * scale, 11.5 * scale);
    phonePath.cubicTo(9.0 * scale, 13.2 * scale, 10.8 * scale, 15.0 * scale, 12.5 * scale, 16.2 * scale);
    phonePath.cubicTo(14.2 * scale, 17.4 * scale, 15.9 * scale, 17.5 * scale, 17.0 * scale, 17.0 * scale);
    phonePath.cubicTo(18.1 * scale, 16.5 * scale, 18.5 * scale, 15.5 * scale, 18.5 * scale, 15.0 * scale);
    phonePath.cubicTo(18.5 * scale, 14.7 * scale, 18.3 * scale, 14.5 * scale, 18.0 * scale, 14.35 * scale);
    phonePath.lineTo(16.0 * scale, 13.35 * scale);
    phonePath.cubicTo(15.7 * scale, 13.2 * scale, 15.4 * scale, 13.25 * scale, 15.2 * scale, 13.5 * scale);
    phonePath.lineTo(14.5 * scale, 14.35 * scale);
    phonePath.cubicTo(14.3 * scale, 14.6 * scale, 13.95 * scale, 14.65 * scale, 13.7 * scale, 14.5 * scale);
    phonePath.cubicTo(12.85 * scale, 14.0 * scale, 11.95 * scale, 13.1 * scale, 11.5 * scale, 12.3 * scale);
    phonePath.cubicTo(11.35 * scale, 12.05 * scale, 11.4 * scale, 11.7 * scale, 11.65 * scale, 11.5 * scale);
    phonePath.lineTo(12.5 * scale, 10.8 * scale);
    phonePath.cubicTo(12.75 * scale, 10.6 * scale, 12.8 * scale, 10.3 * scale, 12.65 * scale, 10.0 * scale);
    phonePath.lineTo(11.65 * scale, 8.0 * scale);
    phonePath.cubicTo(11.5 * scale, 7.7 * scale, 11.3 * scale, 7.5 * scale, 11.0 * scale, 7.5 * scale);
    phonePath.cubicTo(10.5 * scale, 7.5 * scale, 9.5 * scale, 5.5 * scale, 9.0 * scale, 5.5 * scale);
    phonePath.close();

    canvas.drawPath(phonePath, phonePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────
//  Facebook Icon  (custom painter – official "f" letterform)
// ─────────────────────────────────────────────────────────────

class _FacebookIcon extends StatelessWidget {
  final double size;
  const _FacebookIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FacebookPainter(),
    );
  }
}

class _FacebookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;

    // Blue circle
    final bgPaint = Paint()..color = const Color(0xFF1877F2);
    canvas.drawCircle(Offset(s / 2, s / 2), s / 2, bgPaint);

    // White "f" letterform
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double sc = s / 24.0;

    // "f" shape
    final path = Path();
    path.moveTo(13.5 * sc, 7.5 * sc);
    path.lineTo(15.0 * sc, 7.5 * sc);
    path.lineTo(15.0 * sc, 5.5 * sc);
    path.cubicTo(15.0 * sc, 5.5 * sc, 14.0 * sc, 5.0 * sc, 12.8 * sc, 5.0 * sc);
    path.cubicTo(10.9 * sc, 5.0 * sc, 9.5 * sc, 6.3 * sc, 9.5 * sc, 8.3 * sc);
    path.lineTo(9.5 * sc, 10.5 * sc);
    path.lineTo(7.5 * sc, 10.5 * sc);
    path.lineTo(7.5 * sc, 12.8 * sc);
    path.lineTo(9.5 * sc, 12.8 * sc);
    path.lineTo(9.5 * sc, 19.0 * sc);
    path.lineTo(12.0 * sc, 19.0 * sc);
    path.lineTo(12.0 * sc, 12.8 * sc);
    path.lineTo(14.5 * sc, 12.8 * sc);
    path.lineTo(14.8 * sc, 10.5 * sc);
    path.lineTo(12.0 * sc, 10.5 * sc);
    path.lineTo(12.0 * sc, 8.6 * sc);
    path.cubicTo(12.0 * sc, 7.95 * sc, 12.5 * sc, 7.5 * sc, 13.5 * sc, 7.5 * sc);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────
//  Instagram Icon  (custom painter – camera + gradient)
// ─────────────────────────────────────────────────────────────

class _InstagramIcon extends StatelessWidget {
  final double size;
  const _InstagramIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _InstagramPainter(),
    );
  }
}

class _InstagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final double sc = s / 24.0;
    final rect = Rect.fromLTWH(0, 0, s, s);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(s * 0.22));

    // Instagram gradient background
    final gradient = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        Color(0xFFFDA901),
        Color(0xFFFC6B00),
        Color(0xFFE1306C),
        Color(0xFFC13584),
        Color(0xFF833AB4),
        Color(0xFF405DE6),
      ],
    ).createShader(rect);

    canvas.drawRRect(rrect, Paint()..shader = gradient);

    // White camera outline
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * sc
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Outer rounded rectangle (camera body)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4.5 * sc, 4.5 * sc, 15 * sc, 15 * sc),
        Radius.circular(4 * sc),
      ),
      paint,
    );

    // Inner circle (lens)
    canvas.drawCircle(Offset(12 * sc, 12 * sc), 4.0 * sc, paint);

    // Dot (top-right flash)
    canvas.drawCircle(
      Offset(16.5 * sc, 7.5 * sc),
      1.2 * sc,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}