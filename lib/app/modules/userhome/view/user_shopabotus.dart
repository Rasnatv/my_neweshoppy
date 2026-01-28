
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
              ),
              const SizedBox(height: 16),
              Text(
                "Loading details...",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
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
              Icon(
                Icons.info_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                "No details available",
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

      return Container(
        color: Colors.grey[50],
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header Card
            // _buildHeaderCard(about),

            const SizedBox(height: 24),

            // Contact Information Section
            _buildSectionHeader("Contact Information"),
            const SizedBox(height: 12),

            if (about.phone1.isNotEmpty)
              _buildInfoCard(
                icon: Icons.phone_rounded,
                title: "Primary Phone",
                value: about.phone1,

              ),

            if (about.phone2.isNotEmpty)
              _buildInfoCard(
                icon: Icons.phone_android_rounded,
                title: "Secondary Phone",
                value: about.phone2,
                onTap: () => _makePhoneCall(about.phone2),

              ),

            if (about.email.isNotEmpty)
              _buildInfoCard(
                icon: Icons.email_rounded,
                title: "Email",
                value: about.email,
                onTap: () => _sendEmail(about.email),
              ),

            const SizedBox(height: 24),

            // Location & Web Section
            _buildSectionHeader("Location & Web"),
            const SizedBox(height: 12),

            if (about.address.isNotEmpty)
              _buildInfoCard(
                icon: Icons.location_on_rounded,
                title: "Address",
                value: about.address,
                onTap: () => _openMaps(about.address),
              ),

            if (about.website.isNotEmpty)
              _buildInfoCard(
                icon: Icons.language_rounded,
                title: "Website",
                value: about.website,
                onTap: () => _openWebsite(about.website),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildHeaderCard(dynamic about) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.store_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Merchant Information",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Contact details and location",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.green[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
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
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(String phone) {
    // Implement phone call functionality
    // You might want to use url_launcher package
    Get.snackbar(
      "Call",
      "Calling $phone",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      duration: const Duration(seconds: 2),
    );
  }

  void _sendEmail(String email) {
    // Implement email functionality
    Clipboard.setData(ClipboardData(text: email));
    Get.snackbar(
      "Email",
      "Email copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      duration: const Duration(seconds: 2),
    );
  }

  void _openMaps(String address) {
    // Implement maps functionality
    Clipboard.setData(ClipboardData(text: address));
    Get.snackbar(
      "Address",
      "Address copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      duration: const Duration(seconds: 2),
    );
  }

  void _openWebsite(String website) {
    // Implement website opening functionality
    Clipboard.setData(ClipboardData(text: website));
    Get.snackbar(
      "Website",
      "Website URL copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      duration: const Duration(seconds: 2),
    );
  }
}
