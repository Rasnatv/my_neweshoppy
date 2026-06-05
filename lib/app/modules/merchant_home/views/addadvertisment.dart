
import 'dart:io';
import 'package:entenaadu/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../controller/merchant_addadcertismentcontroller.dart';

class MerchantAddAdvertisementPage extends StatelessWidget {
  MerchantAddAdvertisementPage({super.key});

  final controller = Get.put(MerchantAdvertisementController());

  static const Color _teal          = Color(0xFF00897B);
  static const Color _bg            = Color(0xFFF5F6FA);
  static const Color _card          = Colors.white;
  static const Color _textPrimary   = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _border        = Color(0xFFE5E7EB);
  static const Color _errorColor    = Color(0xFFEF5350);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: NetworkAwareWrapper(
        child: Scaffold(
          backgroundColor: _bg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.kPrimary,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            centerTitle: false,
            title: const Text(
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

              // ── MAIN SCROLL ──────────────────────────────────
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── BANNER CARD ────────────────────────
                      _sectionCard(
                        title: "ADVERTISEMENT BANNER",
                        icon: Icons.image_outlined,
                        children: [_buildBanner()],
                      ),

                      const SizedBox(height: 14),

                      // ── DETAILS CARD ───────────────────────
                      _sectionCard(
                        title: "ADVERTISEMENT DETAILS",
                        icon: Icons.campaign_outlined,
                        children: [
                          _fieldLabel("Advertisement Name"),
                          const SizedBox(height: 6),
                          _validatedField(
                            ctrl: controller.adNameController,
                            hint: "Enter advertisement name",
                            icon: Icons.title_rounded,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? "Advertisement name is required"
                                : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ── COVERAGE CARD ──────────────────────
                      _sectionCard(
                        title: "AD COVERAGE",
                        icon: Icons.map_outlined,
                        children: [_buildCoverage()],
                      ),
                    ],
                  ),
                ),
              ),

              // ── LOADING OVERLAY ──────────────────────────────
              Obx(() => controller.isLoading.value
                  ? Container(
                color: Colors.black45,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                            color: _teal, strokeWidth: 2.5),
                        SizedBox(height: 16),
                        Text(
                          "Posting advertisement…",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink()),

              // ── SUBMIT BUTTON ────────────────────────────────
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _buildSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // BANNER
  // ─────────────────────────────────────────────────────────
  Widget _buildBanner() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: controller.pickBannerImage,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: controller.errorBanner.value != null
                    ? _errorColor
                    : controller.bannerImage.value != null
                    ? _teal.withOpacity(0.45)
                    : _border,
                width: 1.4,
              ),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: controller.bannerImage.value == null
                    ? _bannerPlaceholder()
                    : _bannerPreview(),
              ),
            ),
          ),
        ),
        _inlineError(controller.errorBanner.value),
      ],
    ));
  }

  Widget _bannerPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: _teal.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add_photo_alternate_outlined,
              color: _teal, size: 26),
        ),
        const SizedBox(height: 10),
        const Text("Tap to upload banner",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textPrimary)),
        const SizedBox(height: 3),
        const Text("Recommended: 2 : 1 ratio",
            style: TextStyle(fontSize: 11, color: _textSecondary)),
      ],
    );
  }

  Widget _bannerPreview() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            controller.bannerImage.value!,
            fit: BoxFit.cover,
          ),
        ),
        // Remove button
        Positioned(
          top: 8, right: 8,
          child: GestureDetector(
            onTap: controller.removeBanner,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 6),
                ],
              ),
              child: const Icon(Icons.close_rounded,
                  size: 14, color: Colors.red),
            ),
          ),
        ),
        // Selected badge
        Positioned(
          bottom: 8, left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded,
                    size: 12, color: _teal),
                SizedBox(width: 4),
                Text("Banner selected",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // COVERAGE
  // ─────────────────────────────────────────────────────────
  Widget _buildCoverage() {
    return Obx(() {
      final isArea = controller.showMode.value == "area";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Toggle ────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                _modeTab(
                  label: "District Wise",
                  icon: Icons.location_city_rounded,
                  selected: !isArea,
                  onTap: () {
                    controller.showMode.value = "district";
                    controller.selectedArea.value = null;
                  },
                ),
                _modeTab(
                  label: "Area Wise",
                  icon: Icons.grid_view_rounded,
                  selected: isArea,
                  onTap: () => controller.showMode.value = "area",
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── State ─────────────────────────────────────
          _fieldLabel("Select State"),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isLoadingStates.value) {
              return _loadingDropdown("Loading states…");
            }
            if (controller.stateList.isEmpty) {
              return _emptyDropdown("No states available");
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dropdownField(
                  value: controller.selectedState.value,
                  hint: "Choose a state",
                  icon: Icons.flag_outlined,
                  items: controller.stateList,
                  hasError: controller.errorState.value != null,
                  onChanged: (val) {
                    controller.selectedState.value = val;
                    controller.errorState.value = null;
                  },
                ),
                _inlineError(controller.errorState.value),
              ],
            );
          }),

          const SizedBox(height: 14),

          // ── District ──────────────────────────────────
          _fieldLabel("Select District"),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isLoadingDistricts.value) {
              return _loadingDropdown("Loading districts…");
            }
            if (controller.selectedState.value == null) {
              return _disabledDropdown(
                  "Select state first", Icons.location_city_rounded);
            }
            if (controller.districtList.isEmpty) {
              return _emptyDropdown("No districts available");
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dropdownField(
                  value: controller.selectedDistrict.value,
                  hint: "Choose a district",
                  icon: Icons.location_city_rounded,
                  items: controller.districtList,
                  hasError: controller.errorDistrict.value != null,
                  onChanged: (val) {
                    controller.selectedDistrict.value = val;
                    controller.errorDistrict.value = null;
                  },
                ),
                _inlineError(controller.errorDistrict.value),
              ],
            );
          }),

          // ── Area (area mode only) ─────────────────────
          if (isArea) ...[
            const SizedBox(height: 14),
            _fieldLabel("Select Area"),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoadingAreas.value) {
                return _loadingDropdown("Loading areas…");
              }
              if (controller.selectedDistrict.value == null) {
                return _disabledDropdown(
                    "Select district first", Icons.grid_view_rounded);
              }
              if (controller.areaList.isEmpty) {
                return _emptyDropdown("No areas available");
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dropdownField(
                    value: controller.selectedArea.value,
                    hint: "Choose an area",
                    icon: Icons.grid_view_rounded,
                    items: controller.areaList,
                    hasError: controller.errorArea.value != null,
                    onChanged: (val) {
                      controller.selectedArea.value = val;
                      controller.errorArea.value = null;
                    },
                  ),
                  _inlineError(controller.errorArea.value),
                ],
              );
            }),
          ],

          const SizedBox(height: 10),
        ],
      );
    });
  }

  // ─────────────────────────────────────────────────────────
  // SUBMIT BUTTON
  // ─────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() => SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
              final formValid =
                  _formKey.currentState?.validate() ?? false;
              final pickersValid = _validateFields();
              if (formValid && pickersValid) {
                controller.postAdvertisement();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Post Advertisement",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3),
            ),
          ),
        )),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // LOCAL VALIDATION (banner + dropdowns)
  // ─────────────────────────────────────────────────────────
  bool _validateFields() {
    bool valid = true;

    if (controller.bannerImage.value == null) {
      controller.errorBanner.value = "Please select a banner image";
      valid = false;
    }
    if (controller.selectedState.value == null) {
      controller.errorState.value = "State is required";
      valid = false;
    }
    if (controller.selectedDistrict.value == null) {
      controller.errorDistrict.value = "District is required";
      valid = false;
    }
    if (controller.showMode.value == "area" &&
        controller.selectedArea.value == null) {
      controller.errorArea.value = "Area is required";
      valid = false;
    }

    return valid;
  }

  // ─────────────────────────────────────────────────────────
  // SHARED UI COMPONENTS
  // ─────────────────────────────────────────────────────────

  Widget _inlineError(String? error) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 4),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 12, color: _errorColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              error,
              style: const TextStyle(
                  fontSize: 11,
                  color: _errorColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeTab({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _teal : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: selected ? Colors.white : _textSecondary),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : _textSecondary,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool hasError = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasError
              ? _errorColor
              : value != null
              ? _teal.withOpacity(0.45)
              : _border,
          width: hasError || value != null ? 1.4 : 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Icon(icon, size: 16, color: _textSecondary),
                const SizedBox(width: 8),
                Text(hint,
                    style: const TextStyle(
                        fontSize: 14, color: _textSecondary)),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.circular(10),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: _textSecondary, size: 20),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(children: [
                Icon(icon, size: 15, color: _teal),
                const SizedBox(width: 8),
                Text(item,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _textPrimary)),
              ]),
            );
          }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: (context) => items.map((item) {
            return Row(children: [
              Icon(icon, size: 16, color: _teal),
              const SizedBox(width: 8),
              Text(item,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _loadingDropdown(String msg) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: _teal),
          ),
          const SizedBox(width: 10),
          Text(msg,
              style: const TextStyle(
                  fontSize: 13, color: _textSecondary)),
        ],
      ),
    );
  }

  Widget _emptyDropdown(String msg) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Center(
        child: Text(msg,
            style: const TextStyle(
                fontSize: 13, color: _textSecondary)),
      ),
    );
  }

  /// Greyed-out tile shown when a parent dropdown hasn't been selected yet
  Widget _disabledDropdown(String msg, IconData icon) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _textSecondary.withOpacity(0.5)),
          const SizedBox(width: 8),
          Text(msg,
              style: TextStyle(
                  fontSize: 13,
                  color: _textSecondary.withOpacity(0.5))),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 14, color: _teal),
            const SizedBox(width: 6),
            Text(title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _teal,
                  letterSpacing: 0.8,
                )),
          ]),
          const SizedBox(height: 4),
          Divider(color: _border, height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _textPrimary),
  );

  Widget _validatedField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
          fontSize: 14,
          color: _textPrimary,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: _textSecondary),
        prefixIcon: Icon(icon, color: _textSecondary, size: 18),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        filled: true,
        fillColor: _bg,
        errorStyle: const TextStyle(
            fontSize: 11,
            color: _errorColor,
            fontWeight: FontWeight.w500),
        errorMaxLines: 2,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _teal, width: 1.6)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _errorColor, width: 1.4)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            const BorderSide(color: _errorColor, width: 1.6)),
      ),
    );
  }
}