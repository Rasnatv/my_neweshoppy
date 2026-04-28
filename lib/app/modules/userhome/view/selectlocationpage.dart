
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_text_style.dart';
import '../controller/district _controller.dart';

class SelectLocationPage extends StatelessWidget {
  SelectLocationPage({super.key});

  final controller = Get.find<UserLocationController>();

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.kPrimary,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Select Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await controller.skipLocation();
              Get.back();
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.12),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return _buildLoader();
        return _buildBody();
      }),
    ));
  }

  Widget _buildLoader() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.kPrimary,
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntro(),
                const SizedBox(height: 22),
                _buildFormCard(),
                Obx(() {
                  if (controller.selectedMainLocation.value.isEmpty &&
                      controller.selectedDistrict.value.isEmpty &&
                      controller.selectedState.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 14),
                      _buildSummaryCard(),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildIntro() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.kPrimary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Your Location',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1D2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),

            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEFF4), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── State (always enabled) ──────────────────────────────
          Obx(() => _buildDropdownTile(
            label: 'State',
            hint: 'Select your state (optional)',
            icon: Icons.map_outlined,
            value: controller.selectedState.value.isEmpty
                ? null
                : controller.selectedState.value,
            items: controller.states,
            enabled: true,
            onChanged: (v) {
              if (v != null) controller.onStateSelected(v);
            },
            showDivider: true,
          )),

          // ── District (enabled only after state is picked) ────────
          Obx(() {
            final enabled = controller.selectedState.value.isNotEmpty;
            return _buildDropdownTile(
              label: 'District',
              hint: enabled
                  ? 'Select your district (optional)'
                  : 'Select a state first',
              icon: Icons.location_city_outlined,
              value: controller.selectedDistrict.value.isEmpty
                  ? null
                  : controller.selectedDistrict.value,
              items: controller.districts,
              enabled: enabled,
              onChanged: enabled
                  ? (v) {
                if (v != null) controller.onDistrictSelected(v);
              }
                  : null,
              showDivider: true,
            );
          }),

          // ── Area (enabled only after district is picked) ─────────
          Obx(() {
            final enabled = controller.selectedDistrict.value.isNotEmpty;
            return _buildDropdownTile(
              label: 'Area',
              hint: enabled
                  ? 'Select your area (optional)'
                  : 'Select a district first',
              icon: Icons.pin_drop_outlined,
              value: controller.selectedMainLocation.value.isEmpty
                  ? null
                  : controller.selectedMainLocation.value,
              items: controller.mainLocations,
              enabled: enabled,
              onChanged: enabled
                  ? (v) {
                if (v != null)
                  controller.selectedMainLocation.value = v;
              }
                  : null,
              showDivider: false,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    required bool enabled,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 15,
                      color: enabled
                          ? AppColors.kPrimary
                          : Colors.grey.shade300,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: enabled
                            ? const Color(0xFF3D3F50)
                            : Colors.grey.shade400,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // ── "Optional" badge replaces the red * ──────────

                  ],
                ),
              ),
              DropdownButtonFormField<String>(
                value: value,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: enabled
                      ? const Color(0xFFF8F9FC)
                      : const Color(0xFFF2F3F6),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE4E6EE)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE4E6EE)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: AppColors.kPrimary, width: 1.5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFEEEFF4)),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: enabled
                      ? Colors.grey.shade400
                      : Colors.grey.shade300,
                  size: 20,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 2,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1D2E),
                ),
                items: items.isEmpty
                    ? null
                    : items
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: enabled ? onChanged : null,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
              height: 1, thickness: 1, color: Color(0xFFF0F1F5)),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Obx(() {
      // Build a readable summary from whatever fields are filled
      final parts = [
        if (controller.selectedMainLocation.value.isNotEmpty)
          controller.selectedMainLocation.value,
        if (controller.selectedDistrict.value.isNotEmpty)
          controller.selectedDistrict.value,
        if (controller.selectedState.value.isNotEmpty)
          controller.selectedState.value,
      ];

      final title = parts.first;
      final subtitle = parts.length > 1
          ? parts.sublist(1).join(', ')
          : 'Location selected';

      return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB8EDD6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF9F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2ECC87),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D2E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF8B8FA8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => controller.clearSelected(),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 15,
                  color: Color(0xFF8B8FA8),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildConfirmButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final hasSelection = controller.hasAnySelection;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (hasSelection) {
                      await controller.saveLocation();
                    } else {
                      await controller.skipLocation();
                    }
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    hasSelection
                        ? 'Confirm Location'
                        : 'Continue Without Location',
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
              if (!hasSelection) ...[
                const SizedBox(height: 8),
                Text(
                  'You can set your location later from your profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}