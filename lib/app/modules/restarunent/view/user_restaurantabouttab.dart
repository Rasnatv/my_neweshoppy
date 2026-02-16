
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/user_restaurantaboutsection_controller.dart';

class RestaurantAboutTab extends StatelessWidget {
  final String restaurantId;

  const RestaurantAboutTab({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final RestaurantDetailsController controller = Get.put(
      RestaurantDetailsController(restaurantId: restaurantId),
      tag: restaurantId,
    );

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.teal),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                controller.errorMessage.value,
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchRestaurantDetails(),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Restaurant Name
            _buildSectionTitle("Restaurant Information"),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.restaurant,
              title: "Name",
              value: controller.restaurantName.value,
            ),

            /// Address
            if (controller.address.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.location_on,
                title: "Address",
                value: controller.address.value,
              ),
            ],

            /// Contact Information
            const SizedBox(height: 24),
            _buildSectionTitle("Contact Information"),
            const SizedBox(height: 12),

            /// Phone
            if (controller.phone.isNotEmpty) ...[
              _buildClickableCard(
                icon: Icons.phone,
                title: "Phone",
                value: controller.phone.value,
                onTap: () => _makePhoneCall(controller.phone.value),
              ),
              const SizedBox(height: 12),
            ],

            /// Email
            if (controller.email.isNotEmpty) ...[
              _buildClickableCard(
                icon: Icons.email,
                title: "Email",
                value: controller.email.value,
                onTap: () => _sendEmail(controller.email.value),
              ),
              const SizedBox(height: 12),
            ],

            /// Website
            if (controller.website.isNotEmpty) ...[
              _buildClickableCard(
                icon: Icons.language,
                title: "Website",
                value: controller.website.value,
                onTap: () => _openWebsite(controller.website.value),
              ),
              const SizedBox(height: 12),
            ],

            /// WhatsApp
            if (controller.whatsapp.isNotEmpty) ...[
              _buildClickableCard(
                icon: Icons.chat,
                title: "WhatsApp",
                value: controller.whatsapp.value,
                onTap: () => _openWhatsApp(controller.whatsapp.value),
                color: Colors.green,
              ),
              const SizedBox(height: 12),
            ],

            /// Social Media
            if (controller.facebookLink.isNotEmpty ||
                controller.instagramLink.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionTitle("Social Media"),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (controller.facebookLink.isNotEmpty)
                    Expanded(
                      child: _buildSocialButton(
                        icon: Icons.facebook,
                        label: "Facebook",
                        color: const Color(0xFF1877F2),
                        onTap: () => _openUrl(controller.facebookLink.value),
                      ),
                    ),
                  if (controller.facebookLink.isNotEmpty &&
                      controller.instagramLink.isNotEmpty)
                    const SizedBox(width: 12),
                  if (controller.instagramLink.isNotEmpty)
                    Expanded(
                      child: _buildSocialButton(
                        icon: Icons.camera_alt,
                        label: "Instagram",
                        color: const Color(0xFFE4405F),
                        onTap: () => _openUrl(controller.instagramLink.value),
                      ),
                    ),
                ],
              ),
            ],
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
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.teal, size: 24),
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
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (color ?? Colors.teal).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color ?? Colors.teal, size: 24),
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
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// URL Launchers
  void _makePhoneCall(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar("Error", "Could not launch phone dialer");
    }
  }

  void _sendEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar("Error", "Could not launch email client");
    }
  }

  void _openWebsite(String url) async {
    _openUrl(url);
  }

  void _openWhatsApp(String phone) async {
    final Uri uri = Uri.parse("https://wa.me/$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not launch WhatsApp");
    }
  }

  void _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open link");
    }
  }
}