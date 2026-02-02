import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              Text(
                "Loading merchant details...",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
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
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "No details available",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Merchant information is not available at the moment",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header Section
            // _buildHeaderSection(context),

            const SizedBox(height: 24),

            // Contact Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Contact Information"),
                  const SizedBox(height: 16),
                  _buildContactSection(about),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Location & Social Media Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Location & Social Media"),
                  const SizedBox(height: 16),
                  _buildLocationWebSection(about),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      );
    });
  }



  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildContactSection(dynamic about) {
    return Column(
      children: [
        if (about.phone1.isNotEmpty)
          _buildInfoTile(
            icon: Icons.phone_rounded,
            title: "Primary Phone",
            value: about.phone1,
            iconColor: Colors.blue,
            iconBgColor: Colors.blue.shade50,
          ),
        if (about.phone2.isNotEmpty)
          _buildInfoTile(
            icon: Icons.phone_android_rounded,
            title: "Secondary Phone",
            value: about.phone2,
            iconColor: Colors.teal,
            iconBgColor: Colors.teal.shade50,
          ),
        if (about.email.isNotEmpty)
          _buildInfoTile(
            icon: Icons.email_rounded,
            title: "Email",
            value: about.email,
            iconColor: Colors.red,
            iconBgColor: Colors.red.shade50,
          ),
      ],
    );
  }

  Widget _buildLocationWebSection(dynamic about) {
    return Column(
      children: [
        if (about.address.isNotEmpty)
          _buildInfoTile(
            icon: Icons.location_on_rounded,
            title: "Address",
            value: about.address,
            iconColor: Colors.orange,
            iconBgColor: Colors.orange.shade50,
          ),
        if (about.website.isNotEmpty)
          _buildInfoTile(
            icon: Icons.language_rounded,
            title: "Website",
            value: about.website,
            iconColor: Colors.indigo,
            iconBgColor: Colors.indigo.shade50,

          ),
        if (about.whatsapp.isNotEmpty)
          _buildInfoTile(
            icon: Icons.chat_bubble_rounded,
            title: "WhatsApp",
            value: about.whatsapp,
            iconColor: Colors.green,
            iconBgColor: Colors.green.shade50,
          ),
        if (about.facebook.isNotEmpty)
          _buildInfoTile(
            icon: Icons.facebook_rounded,
            title: "Facebook",
            value: about.facebook,
            iconColor: Color(0xFF1877F2),
            iconBgColor: Color(0xFF1877F2).withOpacity(0.1),

          ),
        if (about.instagram.isNotEmpty)
          _buildInfoTile(
            icon: Icons.camera_alt_rounded,
            title: "Instagram",
            value: about.instagram,
            iconColor: Colors.pink,
            iconBgColor: Colors.pink.shade50,
          ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required Color iconBgColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey[400],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}