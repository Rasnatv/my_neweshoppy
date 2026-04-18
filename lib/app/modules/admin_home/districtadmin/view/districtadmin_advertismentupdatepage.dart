import 'dart:io';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/districtadmin_advupdatecontroller.dart';


class DistrictAdvertisementUpdatePage extends StatelessWidget{
  DistrictAdvertisementUpdatePage({super.key});
  final AdvertisementUpdateController controller =Get.put(AdvertisementUpdateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isFetching.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF084E43)),
          );
        }
        return _buildBody(context);
      }),
    );
  }

  // ─── APP BAR ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.welcomecardclr,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      automaticallyImplyLeading: true,
      title: const Text(
        'Update Advertisement',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF084E43), Color(0xFF084E43)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  // ─── BODY ───────────────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildHeaderCard(),
            const SizedBox(height: 24),

            // Advertisement text field
            _buildSectionLabel('Advertisement Title', isRequired: true),
            const SizedBox(height: 8),
            _buildAdvertisementField(),
            const SizedBox(height: 20),
            _buildSectionLabel('State', isRequired: true),
            const SizedBox(height: 8),
            _buildStateDropdown(),
            const SizedBox(height: 20),

            _buildSectionLabel('District', isRequired: true),
            const SizedBox(height: 8),
            _buildDistrictDropdown(),
            const SizedBox(height: 20),
            const SizedBox(height: 20),

            // Banner Image
            _buildSectionLabel('Banner Image'),
            const SizedBox(height: 8),
            _buildBannerImageSection(context),
            const SizedBox(height: 32),

            // Update Button
            _buildUpdateButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─── HEADER CARD ─────────────────────────────────────────────────────────────

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF084E43), Color(0xFF084E43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF084E43).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.campaign_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Advertisement',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  'ID: #${controller.advertisementId}  •  District: ${controller.selectedDistrict.value.isEmpty ? '...' : controller.selectedDistrict.value}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── LABELS ──────────────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String label,
      {bool isRequired = false, bool isLocked = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text('*', style: TextStyle(color: Color(0xFFEF4444))),
        ],
        if (isLocked) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline_rounded,
                    size: 11, color: Color(0xFF6B7280)),
                SizedBox(width: 3),
                Text(
                  'Locked',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ─── ADVERTISEMENT FIELD ──────────────────────────────────────────────────────

  Widget _buildAdvertisementField() {
    return TextFormField(
      controller: controller.advertisementController,
      maxLines: 3,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: 'Enter advertisement title or description...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 40),
          child: Icon(Icons.edit_note_rounded,
              color: Color(0xFF084E43), size: 22),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF084E43), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Advertisement title is required';
        }
        if (value.trim().length < 5) {
          return 'Title must be at least 5 characters';
        }
        return null;
      },
    );
  }

  // ─── DISTRICT FIELD (LOCKED) ──────────────────────────────────────────────────
  Widget _buildDistrictDropdown() {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonFormField<String>(
        value: controller.selectedDistrict.value.isEmpty
            ? null
            : controller.selectedDistrict.value,
        hint: const Text('Select District'),
        items: controller.districtList.map((district) {
          return DropdownMenuItem(
            value: district,
            child: Text(
              district.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedDistrict.value = value ?? '';
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'District is required';
          }
          return null;
        },
      ),
    ));
  }
  Widget _buildStateDropdown() {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonFormField<String>(
        value: controller.selectedState.value.isEmpty
            ? null
            : controller.selectedState.value,
        hint: const Text('Select State'),
        items: controller.stateList.map((state) {
          return DropdownMenuItem(
            value: state,
            child: Text(state),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedState.value = value ?? '';
        },
        decoration: const InputDecoration(border: InputBorder.none),
        validator: (value) =>
        value == null || value.isEmpty ? 'State required' : null,
      ),
    ));
  }

  // ─── BANNER IMAGE SECTION ─────────────────────────────────────────────────────

  Widget _buildBannerImageSection(BuildContext context) {
    return Obx(() {
      final hasNewImage = controller.pickedImageFile.value != null;
      final hasExistingImage = controller.bannerImageUrl.value.isNotEmpty;

      return Column(
        children: [
          // Image preview container
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasNewImage
                    ? const Color(0xFF084E43)
                    : const Color(0xFFE5E7EB),
                width: hasNewImage ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: hasNewImage
                  ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    controller.pickedImageFile.value!,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: controller.removeImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF084E43),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'New Image',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              )
                  : hasExistingImage
                  ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    controller.bannerImageUrl.value,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image_outlined,
                          color: Color(0xFFD1D5DB), size: 48),
                    ),
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF084E43)),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Current Banner',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              )
                  : _buildEmptyImagePlaceholder(),
            ),
          ),

          const SizedBox(height: 12),

          // Image action buttons
          Row(
            children: [
              Expanded(
                child: _buildImageActionButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: controller.pickBanner,
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildImageActionButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  onTap: controller.captureImage,
                  isPrimary: false,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildEmptyImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_photo_alternate_outlined,
              color: Color(0xFF084E43), size: 36),
        ),
        const SizedBox(height: 12),
        const Text(
          'No banner image selected',
          style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap Gallery or Camera to upload',
          style: TextStyle(fontSize: 12, color: Color(0xFFD1D5DB)),
        ),
      ],
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF084E43) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary ? const Color(0xFF084E43) : const Color(0xFFE5E7EB),
          ),
          boxShadow: isPrimary
              ? [
            BoxShadow(
              color: const Color(0xFF084E43).withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18,
                color: isPrimary ? Colors.white : const Color(0xFF084E43)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : const Color(0xFF084E43),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── UPDATE BUTTON ────────────────────────────────────────────────────────────

  Widget _buildUpdateButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed:
        controller.isLoading.value ? null : controller.updateAdvertisement,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF084E43),
          disabledBackgroundColor: const Color(0xFF084E43).withOpacity(0.6),
          elevation: 4,
          shadowColor: const Color(0xFF084E43).withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Update Advertisement',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
