
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../controller/admin_merchantdetailedcontroller.dart';

class AdminMerchantDetailPageUI extends StatelessWidget {
  final int merchantId;

  AdminMerchantDetailPageUI({super.key, required this.merchantId});

  final controller = Get.put(AdminMerchantDetailController());

  @override
  Widget build(BuildContext context) {
    controller.fetchMerchantDetail(merchantId);

    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Merchant Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            )
        ),
        backgroundColor: AppColors.kPrimary,
       automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.kPrimary),
                const SizedBox(height: 16),
                Text(
                  "Loading merchant details...",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          );
        }

        final m = controller.merchant.value;
        if (m == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No merchant data available",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER SECTION WITH IMAGE AND STATUS
              _buildHeader(m),

              /// CONTENT SECTIONS
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoCard(
                      icon: Icons.store_rounded,
                      title: "Merchant Information",
                      children: [
                        _buildInfoRow(
                          icon: Icons.badge_outlined,
                          label: "Merchant ID",
                          value: "#${m.id}",
                        ),
                        _buildInfoRow(
                          icon: Icons.storefront,
                          label: "Shop Name",
                          value: m.shopName,
                        ),
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          label: "Owner Name",
                          value: m.ownerName,
                        ),
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: "Email",
                          value: m.email,
                          isLink: true,
                        ),
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          label: "Primary Phone",
                          value: m.phone1,
                          isLink: true,
                        ),
                        if (m.phone2.isNotEmpty)
                          _buildInfoRow(
                            icon: Icons.phone_android_outlined,
                            label: "Secondary Phone",
                            value: m.phone2,
                            isLink: true,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.location_on_rounded,
                      title: "Location Details",
                      children: [
                        _buildInfoRow(
                          icon: Icons.public,
                          label: "State",
                          value: m.state,
                        ),
                        _buildInfoRow(
                          icon: Icons.location_city,
                          label: "District",
                          value: m.district,
                        ),
                        _buildInfoRow(
                          icon: Icons.place_outlined,
                          label: "Location",
                          value: m.mainLocation,
                        ),
                        _buildCoordinatesRow(
                          latitude: m.latitude,
                          longitude: m.longitude,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.share_rounded,
                      title: "Social Media & Web",
                      children: [
                        if (m.whatsapp.isNotEmpty)
                          _buildSocialRow(
                            icon: Icons.chat,
                            label: "WhatsApp",
                            value: m.whatsapp,
                            color: const Color(0xFF25D366),
                          ),
                        if (m.facebook.isNotEmpty)
                          _buildSocialRow(
                            icon: Icons.facebook,
                            label: "Facebook",
                            value: m.facebook,
                            color: const Color(0xFF1877F2),
                          ),
                        if (m.instagram.isNotEmpty)
                          _buildSocialRow(
                            icon: Icons.camera_alt,
                            label: "Instagram",
                            value: m.instagram,
                            color: const Color(0xFFE4405F),
                          ),
                        if (m.website.isNotEmpty)
                          _buildSocialRow(
                            icon: Icons.language,
                            label: "Website",
                            value: m.website,
                            color: Colors.blue,
                          ),
                        if (m.whatsapp.isEmpty &&
                            m.facebook.isEmpty &&
                            m.instagram.isEmpty &&
                            m.website.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "No social media information available",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

            ],
          ),
        );
      }),
    ));
  }

  Widget _buildHeader(dynamic merchant) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          /// STORE IMAGE
          Hero(
            tag: 'merchant_${merchant.id}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  merchant.storeImage,
                  height: 140,
                  width: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.kPrimary.withOpacity(0.1),
                          AppColors.kPrimary.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.store_rounded,
                      size: 60,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// SHOP NAME
          Text(
            merchant.shopName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),


        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case "approved":
        backgroundColor = const Color(0xFF10B981);
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case "rejected":
        backgroundColor = const Color(0xFFEF4444);
        textColor = Colors.white;
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = const Color(0xFFF59E0B);
        textColor = Colors.white;
        icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CARD HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.05),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.kPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kPrimary,
                  ),
                ),
              ],
            ),
          ),

          /// CARD CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    final displayValue = value.isEmpty ? "Not provided" : value;
    final isEmptyValue = value.isEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isEmptyValue ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 15,
                    color: isEmptyValue
                        ? Colors.grey[400]
                        : (isLink ? Colors.blue[700] : const Color(0xFF1A1A1A)),
                    fontWeight: FontWeight.w500,
                    decoration:
                    isLink && !isEmptyValue ? TextDecoration.underline : null,
                    fontStyle: isEmptyValue ? FontStyle.italic : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.open_in_new, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildCoordinatesRow({
    required String latitude,
    required String longitude,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.map_outlined, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Coordinates",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$latitude, $longitude",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.my_location, color: AppColors.kPrimary, size: 20),
            onPressed: () {
              // Open in maps
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

}