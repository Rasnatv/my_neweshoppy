import 'dart:io';

import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/merchant_updateadvertismentcontroller.dart';


// ─────────────────────────────────────────────────────────────
//  UpdateAdvertisementPage
// ─────────────────────────────────────────────────────────────

class UpdateAdvertisementPage extends StatelessWidget {
  const UpdateAdvertisementPage({super.key});

  // ── Palette (matches MerchantEventsPage style) ────────────
  static const Color _teal = Color(0xFF00BFA5);
  static const Color _bg = Color(0xFFF4F6FA);
  static const Color _surface = Colors.white;
  static const Color _textPrimary = Color(0xFF0D1B2A);
  static const Color _textSecondary = Color(0xFF8A95A3);
  static const Color _border = Color(0xFFDDE1E7);
  static const Color _error = Color(0xFFFF4D4F);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(UpdateAdvertisementController());

    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(ctrl),
      body: Obx(() {
        if (ctrl.isLoading.value) return _buildLoader();
        if (ctrl.errorMessage.value.isNotEmpty &&
            ctrl.advertisement.value == null) {
          return _buildError(ctrl);
        }
        return _buildBody(context, ctrl);
      }),
    );
  }

  // ── AppBar ────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(UpdateAdvertisementController ctrl) {
    return AppBar(
      backgroundColor: AppColors.kPrimary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Update Advertisement',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Obx(
              () => Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: ctrl.isSubmitting.value
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5),
            )
                : TextButton.icon(
              onPressed: ctrl.updateAdvertisement,
              icon: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 18),
              label: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor:
                const Color(0xFF00BFA5).withOpacity(0.20),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: Colors.white.withOpacity(0.3), width: 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Loader ────────────────────────────────────────────────
  Widget _buildLoader() => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: _teal, strokeWidth: 3),
        SizedBox(height: 16),
        Text(
          'Loading advertisement...',
          style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );

  // ── Error state ───────────────────────────────────────────
  Widget _buildError(UpdateAdvertisementController ctrl) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child:
            const Icon(Icons.error_outline, color: _error, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            ctrl.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: _textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ctrl.fetchAdvertisement(
                ctrl.advertisement.value?.id ?? ''),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ],
      ),
    ),
  );

  // ── Main body ─────────────────────────────────────────────
  Widget _buildBody(
      BuildContext context, UpdateAdvertisementController ctrl) {
    return Form(
      key: ctrl.formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: [
          // ── Banner card ──────────────────────────────────
          _buildBannerCard(context, ctrl),
          const SizedBox(height: 24),

          // ── Advertisement text card ───────────────────────
          _buildSectionHeader(
              icon: Icons.campaign_outlined, title: 'Advertisement Text'),
          const SizedBox(height: 12),
          _buildTextCard(ctrl),
          const SizedBox(height: 32),

          // ── Save button ───────────────────────────────────
          Obx(() => SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: ctrl.isSubmitting.value
                  ? null
                  : ctrl.updateAdvertisement,
              icon: ctrl.isSubmitting.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
                  : const Icon(Icons.check_circle_outline_rounded,
                  size: 22),
              label: Text(
                ctrl.isSubmitting.value
                    ? 'Saving...'
                    : 'Save Changes',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _teal.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          )),
        ],
      ),
    );
  }

  // ── Banner card ───────────────────────────────────────────
  Widget _buildBannerCard(
      BuildContext context, UpdateAdvertisementController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            icon: Icons.image_outlined, title: 'Banner Image'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Image preview
              Obx(() {
                final hasNew = ctrl.pickedImageFile.value != null;
                final hasUrl = ctrl.existingBannerUrl.value.isNotEmpty;

                return Stack(
                  children: [
                    // ── Image ────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 210,
                      child: hasNew
                          ? Image.file(
                        ctrl.pickedImageFile.value!,
                        fit: BoxFit.cover,
                      )
                          : hasUrl
                          ? Image.network(
                        ctrl.existingBannerUrl.value,
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (_, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : _imagePlaceholder(
                            isLoading: true),
                        errorBuilder: (_, __, ___) =>
                            _imagePlaceholder(isLoading: false),
                      )
                          : _imagePlaceholder(isLoading: false),
                    ),

                    // ── Gradient overlay ──────────────────
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── "NEW" badge ───────────────────────
                    if (hasNew)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _teal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),

                    // ── Change button ─────────────────────
                    Positioned(
                      bottom: 14,
                      right: 14,
                      child: GestureDetector(
                        onTap: () =>
                            ctrl.showImagePickerOptions(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                hasNew || hasUrl
                                    ? Icons.edit_outlined
                                    : Icons.add_photo_alternate_outlined,
                                size: 16,
                                color: _teal,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                hasNew || hasUrl
                                    ? 'Change Image'
                                    : 'Add Image',
                                style: const TextStyle(
                                  color: _teal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              // Info row below image
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 14, color: _textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Tap "Change Image" to update the banner. '
                            'If skipped, the existing image is kept.',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Advertisement text card ───────────────────────────────
  Widget _buildTextCard(UpdateAdvertisementController ctrl) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Advertisement',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: ctrl.advertisementController,
            maxLines: 4,
            validator: (v) =>
                ctrl.validateRequired(v, 'Advertisement text'),
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. Big Summer Offer - 50% OFF',
              hintStyle:
              const TextStyle(color: _textSecondary, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF4F6FA),
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _border, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _teal, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _error, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _error, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header ────────────────────────────────────────
  Widget _buildSectionHeader(
      {required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: _teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _teal, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  // ── Image placeholder ─────────────────────────────────────
  Widget _imagePlaceholder({required bool isLoading}) {
    return Container(
      height: 210,
      color: const Color(0xFFECEFF4),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: _teal, strokeWidth: 2)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_rounded,
                size: 48, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              'No image selected',
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}


