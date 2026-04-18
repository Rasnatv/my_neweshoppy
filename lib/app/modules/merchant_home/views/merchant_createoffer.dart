
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../controller/merchant_createoffercontroller.dart';

class CreateOfferPage extends StatelessWidget {
  final CreateOfferController controller = Get.put(CreateOfferController());

  CreateOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.kPrimary,
        foregroundColor: Colors.white,
        title: const Text(
          'Create New Offer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 24),
                _buildSectionCard(
                  title: 'Discount Percentage',
                  icon: Icons.percent_rounded,
                  child: _buildDiscountField(),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Offer Banner',
                  icon: Icons.image_outlined,
                  child: _buildBannerPicker(context),
                ),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
          _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // ── Header card ────────────────────────────────────────────
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_offer_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(height: 14),
          const Text(
            'New Offer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Set your discount and banner, then add products in the next step.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── Section card ───────────────────────────────────────────
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                Icon(icon, color: const Color(0xFF6366F1), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // ── Discount field ─────────────────────────────────────────
  Widget _buildDiscountField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller.discountController,
        keyboardType:
        const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        decoration: const InputDecoration(
          hintText: 'e.g. 20',
          hintStyle:
          TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
          prefixIcon:
          Icon(Icons.percent, color: Color(0xFF6366F1), size: 20),
          suffixText: '%',
          suffixStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF6366F1),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // ── Banner picker ──────────────────────────────────────────
  Widget _buildBannerPicker(BuildContext context) {
    return Obx(() {
      final file     = controller.pickedBannerFile.value;
      final hasImage = file != null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ratio hint ───────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border:
              Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: 14, color: Colors.amber.shade800),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Only 2:1 ratio images accepted (e.g. 1200×600, 800×400)",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Preview / placeholder ────────────────────────
          GestureDetector(
            onTap: () =>
                controller.showImagePickerOptions(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasImage
                      ? const Color(0xFF6366F1)
                      : const Color(0xFFE5E7EB),
                  width: hasImage ? 2 : 1,
                ),
              ),
              child: hasImage
                  ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(10),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // ── NEW badge ──────────────────
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA5),
                        borderRadius:
                        BorderRadius.circular(20),
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
                  // ── Edit button ────────────────
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => controller
                          .showImagePickerOptions(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.15),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.edit,
                              color: Color(0xFF6366F1),
                              size: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 44,
                      color: Color(0xFF6366F1)),
                  SizedBox(height: 10),
                  Text(
                    'Tap to select banner image',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Required: 2:1 ratio (e.g. 1200×600)',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  // ── Submit button ──────────────────────────────────────────
  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: controller.isSubmitting.value
            ? null
            : controller.createOffer,
        icon: controller.isSubmitting.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: Colors.white),
        )
            : const Icon(Icons.arrow_forward_rounded,
            color: Colors.white),
        label: Text(
          controller.isSubmitting.value
              ? 'Creating...'
              : 'Create Offer & Add Products',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimary,
          disabledBackgroundColor:
          AppColors.kPrimary.withOpacity(0.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    ));
  }

  // ── Loading overlay ────────────────────────────────────────
  Widget _buildLoadingOverlay() {
    return Obx(() {
      if (!controller.isSubmitting.value)
        return const SizedBox.shrink();
      return Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 32, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                      color: Color(0xFF00BFA5)),
                  SizedBox(height: 16),
                  Text(
                    'Creating offer...',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}