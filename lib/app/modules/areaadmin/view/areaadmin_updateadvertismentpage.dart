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

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Update Advertisement",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
      ),
      body: Obx(() {
        // ── Fetching state ──────────────────────────────
        if (controller.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error state ─────────────────────────────────
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

        // ── Form ────────────────────────────────────────
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  /// ─── Banner Image ───────────────────
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
                                color: Colors.grey.shade400,
                                fontSize: 13),
                            prefixIcon: Icon(Icons.campaign_outlined,
                                color: AppColors.kPrimary),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300),
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
                            controller.isTitleEmpty.value =
                                v.trim().isEmpty;
                          },
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ─── Location Dropdown ──────────────
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel("Select Location"),
                        const SizedBox(height: 12),
                        Obx(() {
                          if (controller.isLocationLoading.value) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 18),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (controller.locations.isEmpty) {
                            return Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  "No locations available",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 13),
                                ),
                              ),
                            );
                          }
                          return Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(
                                color: controller.selectedLocation.value.isEmpty
                                    ? Colors.grey.shade300
                                    : AppColors.kPrimary,
                                width:
                                controller.selectedLocation.value.isEmpty
                                    ? 1
                                    : 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedLocation.value.isEmpty
                                    ? null
                                    : controller.selectedLocation.value,
                                hint: Text(
                                  "Select a location",
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 13),
                                ),
                                isExpanded: true,
                                icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.kPrimary),
                                items: controller.locations.map((loc) {
                                  return DropdownMenuItem(
                                    value: loc,
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            size: 16,
                                            color: AppColors.kPrimary),
                                        const SizedBox(width: 8),
                                        Text(loc,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w500)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  controller.selectedLocation.value =
                                      val ?? '';
                                },
                              ),
                            ),
                          );
                        }),
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
                        backgroundColor: AppColors.kPrimary,
                        disabledBackgroundColor:
                        AppColors.kPrimary.withOpacity(0.6),
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
    );
  }

  Widget _buildBannerContent(AreaAdminUpdateAdvertisementController controller) {
    // New image picked
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
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      );
    }

    // Existing image from server
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
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
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

    // No image yet
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
        Text(
          "Tap to upload banner image",
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text("JPG, PNG supported",
            style:
            TextStyle(color: Colors.grey.shade400, fontSize: 11)),
      ],
    );
  }
}

// ── Shared Helpers ────────────────────────────────────────────────────────────

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
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(width: 4),
        const Text("*", style: TextStyle(color: Colors.red, fontSize: 14)),
      ],
    );
  }
}