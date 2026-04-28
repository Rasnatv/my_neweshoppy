
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/areadmin_advertismentupdate_controller.dart';

class AreaAdminUpdateAdvertisementPage extends StatelessWidget {
  final int adId;
  const AreaAdminUpdateAdvertisementPage({super.key, required this.adId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AreaAdminUpdateAdvertisementController(adId: adId),
      tag: adId.toString(),
    );

    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Update Advertisement",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
        ),
        backgroundColor: AppColors.welcomecardclr,
        elevation: 0,
      ),
      body: Obx(() {
        // ── Fetching ──────────────────────────────
        if (controller.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error ─────────────────────────────────
        if (controller.hasError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.redAccent, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.redAccent, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: controller.fetchAdvertisement,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Form ──────────────────────────────────
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  /// ─── Banner Image ──────────────────
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel("Banner Image"),
                        const SizedBox(height: 12),
                        Obx(() => GestureDetector(
                          onTap: controller.pickBannerImage,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: (controller.bannerImage.value !=
                                    null ||
                                    controller.existingBannerUrl.value
                                        .isNotEmpty)
                                    ? AppColors.kPrimary
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.grey.shade50,
                            ),
                            child: _buildBannerContent(controller),
                          ),
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ─── Advertisement Title ────────────
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel("Advertisement Title"),
                        const SizedBox(height: 12),
                        Obx(() => TextField(
                          controller: controller.adName,
                          decoration: InputDecoration(
                            hintText: "Enter advertisement title",
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400, fontSize: 13),
                            prefixIcon: Icon(Icons.campaign_outlined,
                                color: AppColors.kPrimary),
                            filled: true,
                            fillColor: Colors.grey.shade50,
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
                                  color: AppColors.kPrimary, width: 1.5),
                            ),
                            errorText: controller.isTitleEmpty.value
                                ? "Title is required"
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                          ),
                          onChanged: (v) {
                            controller.isTitleEmpty.value = v.trim().isEmpty;
                          },
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ─── Location Dropdowns Card ────────
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 15, color: AppColors.kPrimary),
                            const SizedBox(width: 6),
                            Text(
                              "Location Details",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Select state, district and location for this advertisement.",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade400),
                        ),
                        const SizedBox(height: 16),

                        // ─── State Dropdown ───────────
                        _DropdownLabel("State", required: true),
                        const SizedBox(height: 8),
                        Obx(() => _buildDropdown(
                          context: context,
                          icon: Icons.map_outlined,
                          hint: "Select State",
                          value: controller.selectedState.value,
                          items: controller.stateList,
                          isLoading: controller.isLoadingStates.value,
                          onChanged: (val) =>
                          controller.selectedState.value = val,
                        )),

                        const SizedBox(height: 14),

                        // ─── District Dropdown ────────
                        _DropdownLabel("District", required: true),
                        const SizedBox(height: 8),
                        Obx(() => _buildDropdown(
                          context: context,
                          icon: Icons.location_city_outlined,
                          hint: "Select District",
                          value: controller.selectedDistrict.value,
                          items: controller.districtList,
                          isLoading: controller.isLoadingDistricts.value,
                          enabled: controller.selectedState.value != null,
                          onChanged: (val) =>
                          controller.selectedDistrict.value = val,
                        )),

                        const SizedBox(height: 14),

                        // ─── Main Location Dropdown ───
                        _DropdownLabel("Main Location", required: true),
                        const SizedBox(height: 8),
                        Obx(() => _buildDropdown(
                          context: context,
                          icon: Icons.location_on_outlined,
                          hint: "Select Location",
                          value: controller.selectedLocation.value,
                          items: controller.locationList,
                          isLoading: controller.isLoadingLocations.value,
                          enabled: controller.selectedDistrict.value != null,
                          onChanged: (val) =>
                          controller.selectedLocation.value = val,
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ─── Update Button ──────────────────
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.updateAdvertisement,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.welcomecardclr,
                        disabledBackgroundColor:
                        AppColors.welcomecardclr.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_outlined,
                              color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Update Advertisement",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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

            /// ─── Full Screen Loader ─────────────────
            Obx(() => controller.isLoading.value
                ? Container(
              color: Colors.black38,
              child: const Center(child: CircularProgressIndicator()),
            )
                : const SizedBox()),
          ],
        );
      }),
    ));
  }

  // ─── Reusable Dropdown Builder ────────────────
  Widget _buildDropdown({
    required BuildContext context,
    required IconData icon,
    required String hint,
    required String? value,
    required RxList<String> items,
    required bool isLoading,
    bool enabled = true,
    required void Function(String?) onChanged,
  }) {
    if (isLoading) {
      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade400),
            const SizedBox(width: 10),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            Text("Loading...",
                style:
                TextStyle(fontSize: 13, color: Colors.grey.shade400)),
          ],
        ),
      );
    }

    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: (value != null && items.contains(value)) ? value : null,
              hint: Row(
                children: [
                  Icon(icon, size: 18, color: Colors.grey.shade400),
                  const SizedBox(width: 10),
                  Text(hint,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade400)),
                ],
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.kPrimary),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A)),
              items: items
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    Icon(icon,
                        size: 16, color: AppColors.kPrimary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(item,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ))
                  .toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerContent(
      AreaAdminUpdateAdvertisementController controller) {
    if (controller.bannerImage.value != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              controller.bannerImage.value!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: controller.removeBannerImage,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    color: Colors.black54, shape: BoxShape.circle),
                child:
                const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      );
    }

    if (controller.existingBannerUrl.value.isNotEmpty) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              controller.existingBannerUrl.value,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : const Center(child: CircularProgressIndicator()),
              errorBuilder: (_, __, ___) => Center(
                child: Icon(Icons.broken_image,
                    size: 40, color: Colors.grey.shade400),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: controller.pickBannerImage,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    color: Colors.black54, shape: BoxShape.circle),
                child:
                const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.touch_app_outlined,
                      color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text("Tap to change",
                      style:
                      TextStyle(color: Colors.white, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add_photo_alternate_outlined,
              size: 36, color: AppColors.kPrimary),
        ),
        const SizedBox(height: 12),
        Text("Tap to upload banner image",
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text("JPG, PNG supported",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
      ],
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A))),
        const SizedBox(width: 4),
        const Text("*", style: TextStyle(color: Colors.red, fontSize: 14)),
      ],
    );
  }
}

class _DropdownLabel extends StatelessWidget {
  final String text;
  final bool required;
  const _DropdownLabel(this.text, {this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text("*", style: TextStyle(color: Colors.red, fontSize: 13)),
        ],
      ],
    );
  }
}