
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../controller/admin_addadvertsimentcontroller.dart';


class AdminAddAdvertisementPage extends StatelessWidget {
  AdminAddAdvertisementPage({super.key});

  final AdminaddAdvertisementController controller =
  Get.put(AdminaddAdvertisementController(), permanent: true);

  final _submitted = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Add Advertisement',
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // ── Gradient accent bar ──────────────────────
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.kPrimary,
                        AppColors.kPrimary.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ════════════════════════════════════
                      // BANNER IMAGE CARD
                      // ════════════════════════════════════
                      _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader(
                              icon: Icons.image_rounded,
                              title: 'Banner Image',
                            ),
                            const SizedBox(height: 20),

                            Obx(() => InkWell(
                              onTap: controller.pickBannerImage,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _submitted.value &&
                                        controller.bannerImage.value == null
                                        ? Colors.red.shade300
                                        : controller.bannerImage.value != null
                                        ? AppColors.kPrimary
                                        .withOpacity(0.5)
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade50,
                                ),
                                child: controller.bannerImage.value == null
                                    ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
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
                                        size: 40,
                                        color: AppColors.kPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Upload Banner Image',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Recommended: 1200×400 px',
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
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: Image.file(
                                        controller.bannerImage.value!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap:
                                        controller.removeBannerImage,
                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.close,
                                              color: Colors.white,
                                              size: 20),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black
                                                  .withOpacity(0.7),
                                              Colors.transparent,
                                            ],
                                          ),
                                          borderRadius:
                                          const BorderRadius.only(
                                            bottomLeft:
                                            Radius.circular(10),
                                            bottomRight:
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.edit,
                                                color: Colors.white,
                                                size: 16),
                                            SizedBox(width: 6),
                                            Text(
                                              'Tap to change image',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),

                            Obx(() => _submitted.value &&
                                controller.bannerImage.value == null
                                ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      size: 14,
                                      color: Colors.red.shade700),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Banner image is required',
                                    style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            )
                                : const SizedBox()),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ════════════════════════════════════
                      // ADVERTISEMENT DETAILS CARD
                      // ════════════════════════════════════
                      _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader(
                              icon: Icons.campaign_rounded,
                              title: 'Advertisement Details',
                            ),
                            const SizedBox(height: 20),

                            // Title field
                            Obx(() => TextFormField(
                              controller: controller.adTitle,
                              maxLength: 100,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                labelText: 'Advertisement Title',
                                hintText:
                                'e.g., Big Christmas Sale – Up to 50% Off!',
                                prefixIcon: Icon(Icons.title_rounded,
                                    size: 22, color: AppColors.kPrimary),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: AppColors.kPrimary, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.red.shade300, width: 2),
                                ),
                                errorText: _submitted.value &&
                                    controller.adTitle.text.trim().isEmpty
                                    ? 'Advertisement title is required'
                                    : null,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (v) {
                                // trigger Obx rebuild for inline error
                                controller.isTitleEmpty.value = v.trim().isEmpty;
                              },
                            )),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ════════════════════════════════════
                      // LOCATION CARD
                      // ════════════════════════════════════
                      _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader(
                              icon: Icons.location_on_outlined,
                              title: 'Location (Optional)',
                            ),
                            const SizedBox(height: 20),

                            // ── Toggle buttons ────────────
                            Obx(() => Row(
                              children: [
                                Expanded(
                                  child: _locationToggleButton(
                                    label: 'District',
                                    icon: Icons.location_city_outlined,
                                    isSelected: controller
                                        .locationType.value ==
                                        'district',
                                    onTap: () =>
                                        controller.setLocationType('district'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _locationToggleButton(
                                    label: 'Area',
                                    icon: Icons.place_outlined,
                                    isSelected:
                                    controller.locationType.value == 'area',
                                    onTap: () =>
                                        controller.setLocationType('area'),
                                  ),
                                ),
                              ],
                            )),

                            // ── Conditional dropdown ───────
                            Obx(() {
                              final type = controller.locationType.value;
                              if (type == null) return const SizedBox.shrink();

                              return Column(
                                children: [
                                  const SizedBox(height: 16),
                                  if (type == 'district') ...[
                                    controller.isLoadingDistricts.value
                                        ? _buildLoadingRow(
                                        'Loading districts...')
                                        : _buildDropdown(
                                      value: controller
                                          .selectedDistrict.value,
                                      hint: 'Select District',
                                      icon:
                                      Icons.location_city_outlined,
                                      items: controller.districts,
                                      onChanged: (val) => controller
                                          .selectedDistrict.value = val,
                                    ),
                                  ] else if (type == 'area') ...[
                                    controller.isLoadingAreas.value
                                        ? _buildLoadingRow('Loading areas...')
                                        : _buildDropdown(
                                      value:
                                      controller.selectedArea.value,
                                      hint: 'Select Area',
                                      icon: Icons.place_outlined,
                                      items: controller.areas,
                                      onChanged: (val) => controller
                                          .selectedArea.value = val,
                                    ),
                                  ],
                                ],
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ════════════════════════════════════
                      // SUBMIT BUTTON
                      // ════════════════════════════════════
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kPrimary,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                            _submitted.value = true;

                            final titleOk = controller.adTitle.text
                                .trim()
                                .isNotEmpty;
                            final imageOk =
                                controller.bannerImage.value != null;

                            // If a location type is chosen, a value must be selected
                            final locType =
                                controller.locationType.value;
                            final locationOk = locType == null ||
                                (locType == 'district' &&
                                    controller.selectedDistrict.value !=
                                        null) ||
                                (locType == 'area' &&
                                    controller.selectedArea.value !=
                                        null);

                            if (titleOk && imageOk && locationOk) {
                              await controller.addAdvertisement();
                            } else {
                              String msg =
                                  'Please fill all required fields';
                              if (!locationOk) {
                                msg = locType == 'district'
                                    ? 'Please select a district'
                                    : 'Please select an area';
                              }
                              Get.snackbar(
                                'Validation Error',
                                msg,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade400,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                                icon: const Icon(Icons.error_outline,
                                    color: Colors.white),
                              );
                            }
                          },
                          child: controller.isLoading.value
                              ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Uploading...',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'ADD ADVERTISEMENT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Full-screen loader overlay ────────────────────
          Obx(() => controller.isLoading.value
              ? Container(
            color: Colors.black38,
            child: const Center(child: CircularProgressIndicator()),
          )
              : const SizedBox()),
        ],
      ),
    );
  }

  // ─── Location Toggle Button ───────────────────────────────
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
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimary : Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Icon(icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey.shade600),
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

  // ─── Dropdown ─────────────────────────────────────────────
  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: AppColors.kPrimary),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        items: items
            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
            .toList(),
        onChanged: onChanged,
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.kPrimary),
        dropdownColor: Colors.white,
      ),
    );
  }

  // ─── Loading Row ──────────────────────────────────────────
  Widget _buildLoadingRow(String label) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.kPrimary),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ],
      ),
    );
  }

  // ─── Card Wrapper ─────────────────────────────────────────
  Widget _buildCard({required Widget child}) {
    return Container(
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

  // ─── Section Header ───────────────────────────────────────
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
}
