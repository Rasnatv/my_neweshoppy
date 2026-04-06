                       

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../controller/restaurant_regcontroller.dart';

class RestaurantRegistrationPage extends StatelessWidget {
  final controller = Get.put(RestaurantRegController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Restaurant Registration",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Restaurant Banner Image ─────────────────────────────
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(
                          icon: Icons.store_mall_directory_rounded,
                          title: "Restaurant Image",
                        ),
                        const SizedBox(height: 20),
                        _imagePicker(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),


                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(
                          icon: Icons.info_outline_rounded,
                          title: "Basic Information",
                        ),
                        const SizedBox(height: 20),
                        _modernTextField(
                          controller: controller.restaurantNameCtrl,
                          label: "Restaurant Name",
                          hint: "Enter restaurant name",
                          icon: Icons.restaurant_rounded,
                        ),
                        const SizedBox(height: 16),
                        _modernTextField(
                          controller: controller.ownerCtrl,
                          label: "Owner Name",
                          hint: "Enter owner name",
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 16),
                        _modernTextField(
                          controller: controller.addressCtrl,
                          label: "Address",
                          hint: "Enter full address",
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        _modernTextField(
                          controller: controller.phoneCtrl,
                          label: "Phone",
                          hint: "Enter phone number",
                          icon: Icons.phone_outlined,
                          type: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _modernTextField(
                          controller: controller.emailCtrl,
                          label: "Email",
                          hint: "Enter email address",
                          icon: Icons.email_outlined,
                          type: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _modernTextField(
                          controller: controller.websiteCtrl,
                          label: "Website",
                          hint: "https://yourwebsite.com",
                          icon: Icons.language_outlined,
                          type: TextInputType.url,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Social & Contact ────────────────────────────────────
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(
                          icon: Icons.share_outlined,
                          title: "Social & Contact",
                        ),
                        const SizedBox(height: 20),
                        _modernTextField(
                          controller: controller.whatsappCtrl,
                          label: "WhatsApp",
                          hint: "Enter WhatsApp number",
                          icon: Icons.chat_outlined,
                          type: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _modernTextField(
                          controller: controller.facebookCtrl,
                          label: "Facebook",
                          hint: "Facebook profile or page URL",
                          icon: Icons.facebook_outlined,
                          type: TextInputType.url,
                        ),
                        const SizedBox(height: 16),
                        _modernTextField(
                          controller: controller.instaCtrl,
                          label: "Instagram",
                          hint: "@yourhandle or profile URL",
                          icon: Icons.photo_camera_outlined,
                          type: TextInputType.url,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _sectionHeader(
                                icon: Icons.photo_library_outlined,
                                title: "Additional Images",
                              ),
                            ),
                            // Add button aligned to the right of header
                            InkWell(
                              onTap: controller.pickAdditionalImages,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.kPrimary.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add_photo_alternate_outlined,
                                        color: AppColors.kPrimary, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Add",
                                      style: TextStyle(
                                        color: AppColors.kPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Obx(() => controller.additionalImages.isEmpty
                            ? Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1.5),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    size: 28,
                                    color: Colors.grey.shade400),
                                const SizedBox(height: 6),
                                Text(
                                  "No additional images selected",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                          ),
                        )
                            : Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: controller.additionalImages
                              .asMap()
                              .entries
                              .map(
                                (e) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  child: Image.file(
                                    e.value,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: GestureDetector(
                                    onTap: () => controller
                                        .additionalImages
                                        .removeAt(e.key),
                                    child: Container(
                                      padding:
                                      const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                          Icons.close_rounded,
                                          size: 14,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              .toList(),
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Submit Button ───────────────────────────────────────
                  Obx(() => Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: controller.isLoading.value
                            ? [Colors.grey.shade400, Colors.grey.shade300]
                            : [
                          AppColors.kPrimary,
                          AppColors.kPrimary.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: controller.isLoading.value
                          ? []
                          : [
                        BoxShadow(
                          color: AppColors.kPrimary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submit,
                      child: controller.isLoading.value
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle_outline, size: 22),
                          SizedBox(width: 10),
                          Text(
                            "REGISTER RESTAURANT",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Card wrapper ──────────────────────────────────────────────────────────
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: child,
    );
  }

  // ── Section header ────────────────────────────────────────────────────────
  Widget _sectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.kPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ── Modern text field ─────────────────────────────────────────────────────
  Widget _modernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.kPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // ── Main image picker ─────────────────────────────────────────────────────
  Widget _imagePicker() {
    return Obx(() => InkWell(
      onTap: controller.pickRestaurantImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: controller.restaurantImage.value == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_upload_outlined,
                size: 40,
                color: AppColors.kPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Upload Restaurant Photo",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Click to browse",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                controller.restaurantImage.value!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}