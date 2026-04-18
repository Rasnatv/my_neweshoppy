
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/merchant_addadcertismentcontroller.dart';

class MerchantAddAdvertisementPage extends StatelessWidget {
  MerchantAddAdvertisementPage({super.key});

  final controller = Get.put(MerchantAdvertisementController());

  static const Color _bg = Color(0xFFF5F6FA);
  static const Color _card = Colors.white;
  static const Color _textPrimary = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.kPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Create Advertisement",
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

            // ── MAIN UI ───────────────────────────────
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
              child: Column(
                children: [

                  _sectionCard(
                    title: "ADVERTISEMENT BANNER",
                    icon: Icons.image_outlined,
                    children: [_buildBanner()],
                  ),

                  const SizedBox(height: 14),

                  _sectionCard(
                    title: "ADVERTISEMENT DETAILS",
                    icon: Icons.campaign_outlined,
                    children: [
                      _fieldLabel("Advertisement Name"),
                      const SizedBox(height: 6),
                      _inputField(
                        ctrl: controller.adNameController,
                        hint: "Enter advertisement name",
                        icon: Icons.title,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _sectionCard(
                    title: "AD COVERAGE",
                    icon: Icons.map_outlined,
                    children: [_buildCoverage()],
                  ),
                ],
              ),
            ),

            // ── LOADING OVERLAY ───────────────────────
            Obx(() => controller.isLoading.value
                ? Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
                : const SizedBox()),

            // ── SUBMIT BUTTON ─────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _submitButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ── COVERAGE UI ─────────────────────────────
  Widget _buildCoverage() {
    return Obx(() {
      final isArea = controller.showMode.value == "area";

      return Column(
        children: [

          // toggle
          Row(
            children: [
              _tab("District", !isArea, () {
                controller.showMode.value = "district";
                controller.selectedArea.value = null;
              }),
              _tab("Area", isArea, () {
                controller.showMode.value = "area";
              }),
            ],
          ),

          const SizedBox(height: 14),

          _dropdown("State", controller.stateList,
              controller.selectedState),

          const SizedBox(height: 12),

          _dropdown("District", controller.districtList,
              controller.selectedDistrict),

          if (isArea) ...[
            const SizedBox(height: 12),
            _dropdown("Area", controller.areaList,
                controller.selectedArea),
          ],
        ],
      );
    });
  }

  Widget _tab(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? AppColors.kPrimary : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : _textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropdown(String hint, List<String> items, Rx<String?> value) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.value,
          isExpanded: true,
          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
              .toList(),
          onChanged: (v) => value.value = v,
        ),
      ),
    ));
  }
  Widget _buildBanner() {
    return Obx(() => GestureDetector(
      onTap: controller.pickBanner,
      child: Container(
        width: double.infinity,
        height: 180,  // ✅ Same height as carousel
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(20), // ✅ Match carousel radius
          border: Border.all(color: _border),
        ),
        child: controller.bannerImage.value == null
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, size: 36),
              SizedBox(height: 8),
              Text(
                "Tap to upload banner",
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
              SizedBox(height: 4),
              Text(
                "Recommended ratio: 2:1",  // ✅ hint for user
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                controller.bannerImage.value!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
                cacheWidth: 800,
                cacheHeight: 400,
              ),
            ),
            // ✅ Remove / re-pick button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: controller.removeBanner,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // ── CARD ───────────────────────────────────────
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.kPrimary),
              const SizedBox(width: 6),
              Text(title,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kPrimary)),
            ],
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(text,
      style: const TextStyle(fontWeight: FontWeight.w500));

  Widget _inputField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: _bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.postAdvertisement,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimary,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text("Post Advertisement"),
        )),
      ),
    );
  }
}