
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/merchant_addadcertismentcontroller.dart';

class MerchantAddAdvertisementPage extends StatelessWidget {
  MerchantAddAdvertisementPage({super.key});

  final controller = Get.put(MerchantAdvertisementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.kPrimary,
        title: Text(
          "Create Advertisement",
          style: AppTextStyle.rTextNunitoWhite16w600,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Banner Upload ──────────────────────────────────
                  Text(
                    "Advertisement Banner",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Obx(() => GestureDetector(
                    onTap: controller.pickBanner,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: controller.bannerImage.value == null
                              ? Colors.grey.shade300
                              : AppColors.kPrimary.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: controller.bannerImage.value == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimary
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: AppColors.kPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Tap to upload banner",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Recommended: 1200 x 628 pixels",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      )
                          : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              controller.bannerImage.value!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: controller.pickBanner,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

                  const SizedBox(height: 32),

                  // ── Advertisement Details ──────────────────────────
                  Text(
                    "Advertisement Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Ad Name
                  _buildCard(
                    child: TextField(
                      controller: controller.adNameController,
                      style: const TextStyle(fontSize: 15),
                      decoration: _inputDecoration(
                        label: "Advertisement Name",
                        hint: "Enter a catchy name",
                        icon: Icons.campaign_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Location Type Label ────────────────────────────
                  Text(
                    "Location Type",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Toggle Buttons: District | Area ────────────────
                  Obx(() => Row(
                    children: [
                      Expanded(
                        child: _locationToggleButton(
                          label: "District",
                          icon: Icons.location_city_outlined,
                          isSelected:
                          controller.locationType.value == 'district',
                          onTap: () =>
                              controller.setLocationType('district'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _locationToggleButton(
                          label: "Area",
                          icon: Icons.place_outlined,
                          isSelected:
                          controller.locationType.value == 'area',
                          onTap: () => controller.setLocationType('area'),
                        ),
                      ),
                    ],
                  )),

                  // ── Conditional Dropdown below toggle ──────────────
                  Obx(() {
                    final type = controller.locationType.value;
                    if (type == null) return const SizedBox.shrink();

                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        if (type == 'district') ...[
                          controller.isLoadingDistricts.value
                              ? _buildLoadingDropdown("Loading districts...")
                              : _buildCard(
                            child: DropdownButtonFormField<String>(
                              value: controller.selectedDistrict.value,
                              decoration: _inputDecoration(
                                label: "Select District",
                                hint: "Choose a district",
                                icon: Icons.location_city_outlined,
                              ),
                              items: controller.districts
                                  .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text(d),
                              ))
                                  .toList(),
                              onChanged: (val) =>
                              controller.selectedDistrict.value = val,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.kPrimary),
                              dropdownColor: Colors.white,
                            ),
                          ),
                        ] else if (type == 'area') ...[
                          controller.isLoadingAreas.value
                              ? _buildLoadingDropdown("Loading areas...")
                              : _buildCard(
                            child: DropdownButtonFormField<String>(
                              value: controller.selectedArea.value,
                              decoration: _inputDecoration(
                                label: "Select Area",
                                hint: "Choose an area",
                                icon: Icons.place_outlined,
                              ),
                              items: controller.areas
                                  .map((a) => DropdownMenuItem(
                                value: a,
                                child: Text(a),
                              ))
                                  .toList(),
                              onChanged: (val) =>
                              controller.selectedArea.value = val,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.kPrimary),
                              dropdownColor: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    );
                  }),

                  const SizedBox(height: 40),

                  // ── Post Button ───────────────────────────────────
                  Obx(() => Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: controller.isLoading.value
                            ? [Colors.grey.shade400, Colors.grey.shade400]
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
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.postAdvertisement,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.publish, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Post Advertisement",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Location Toggle Button ─────────────────────────────────────────
  Widget _locationToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.kPrimary : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.kPrimary.withOpacity(0.25)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLoadingDropdown(String label) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.kPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade600),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      prefixIcon: Icon(icon, color: AppColors.kPrimary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.kPrimary, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }
}