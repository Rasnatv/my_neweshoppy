
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/admin_updateeventcontroller.dart';

class AdminEventUpdatePage extends StatelessWidget {
  AdminEventUpdatePage({super.key});

  final AdminEventUpdateController controller =
  Get.put(AdminEventUpdateController());

  static const _teal = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.event.value == null) {
          return const Center(child: Text('No event data found.'));
        }
        return _buildBody(context);
      }),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.kPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(result: true), // ✅ always return true on back
          ),
          // ... rest of your appbar

      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        'Update Event',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFEEEEEE)),
      ),
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildBannerSection(),
          const SizedBox(height: 28),

          // ── Event Details ──────────────────────────────────
          _sectionLabel('Event Details'),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Event Name',
            ctrl: controller.eventNameCtrl,
            icon: Icons.event_rounded,
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Event name is required'
                : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Location',
            ctrl: controller.locationCtrl,
            icon: Icons.location_on_rounded,
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Location is required'
                : null,
          ),

          const SizedBox(height: 28),

          // ── Region ─────────────────────────────────────────
          _buildRegionSection(),

          const SizedBox(height: 28),

          // ── Date & Time ────────────────────────────────────
          _sectionLabel('Date & Time'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDateField(context, isStart: true)),
              const SizedBox(width: 12),
              Expanded(child: _buildDateField(context, isStart: false)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTimeField(context, isStart: true)),
              const SizedBox(width: 12),
              Expanded(child: _buildTimeField(context, isStart: false)),
            ],
          ),

          const SizedBox(height: 40),
          _buildUpdateButton(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ─── Region Section ───────────────────────────────────────────────────────
  Widget _buildRegionSection() {
    return Obx(() {
      final isArea = controller.showMode.value == "area";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Region Info'),
          const SizedBox(height: 12),

          // ── Mode toggle tabs ─────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                _modeTab(
                  label: "District Wise",
                  icon: Icons.location_city_rounded,
                  selected: !isArea,
                  onTap: controller.switchToDistrict,
                ),
                _modeTab(
                  label: "Area Wise",
                  icon: Icons.grid_view_rounded,
                  selected: isArea,
                  onTap: controller.switchToArea,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── State ────────────────────────────────────────
          Obx(() => _buildDropdownField(
            label: 'State',
            icon: Icons.flag_outlined,
            value: controller.selectedState.value,
            items: controller.statesList,
            isLoading: controller.isLoadingStates.value,
            onChanged: (v) => controller.selectedState.value = v,
            validator: (v) =>
            v == null || v.isEmpty ? 'Please select a state' : null,
          )),
          const SizedBox(height: 16),

          // ── District ─────────────────────────────────────
          Obx(() => _buildDropdownField(
            label: 'District',
            icon: Icons.location_city_rounded,
            value: controller.selectedDistrict.value,
            items: controller.districtsList,
            isLoading: controller.isLoadingDistricts.value,
            onChanged: (v) => controller.selectedDistrict.value = v,
            validator: (v) =>
            v == null || v.isEmpty ? 'Please select a district' : null,
          )),

          // ── Area (area mode only) ─────────────────────────
          if (isArea) ...[
            const SizedBox(height: 16),
            Obx(() => _buildDropdownField(
              label: 'Main Location',
              icon: Icons.place_rounded,
              value: controller.selectedArea.value,
              items: controller.areasList,
              isLoading: controller.isLoadingAreas.value,
              onChanged: (v) => controller.selectedArea.value = v,
              validator: (v) =>
              v == null || v.isEmpty ? 'Please select a location' : null,
            )),
          ],
        ],
      );
    });
  }

  // ─── Mode Tab ─────────────────────────────────────────────────────────────
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
            color: selected ? Colors.teal : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: selected ? Colors.white : const Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Dropdown field ───────────────────────────────────────────────────────
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required bool isLoading,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    final effectiveItems =
    (value != null && value.isNotEmpty && !items.contains(value))
        ? [value, ...items]
        : items;

    return DropdownButtonFormField<String>(
      value: (value != null && value.isNotEmpty) ? value : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
        prefixIcon: isLoading
            ? Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.teal.withOpacity(0.5),
            ),
          ),
        )
            : Icon(icon, size: 20, color: Colors.teal),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF44336)),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.teal),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A1A2E),
      ),
      items: effectiveItems
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: isLoading ? null : onChanged,
    );
  }

  // ─── Banner section ───────────────────────────────────────────────────────
  Widget _buildBannerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Banner Image'),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: controller.pickBannerImage,
          child: Obx(() {
            final hasNewImage = controller.pickedImageFile.value != null;
            final networkUrl  = controller.event.value?.bannerImage ?? '';

            return Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFEEEEF5),
                border: Border.all(
                    color: const Color(0xFFDDDDED), width: 1.5),
              ),
              child: AspectRatio(
                aspectRatio: 2 / 1, // ✅ matches upload ratio
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (hasNewImage)
                      Image.file(controller.pickedImageFile.value!,
                          fit: BoxFit.cover)
                    else if (networkUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: networkUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (_, __, ___) => _imagePlaceholder(),
                      )
                    else
                      _imagePlaceholder(),

                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.45),
                          ],
                        ),
                      ),
                    ),

                    // Change button
                    Positioned(
                      bottom: 12,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 8),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt_rounded,
                                size: 14, color: Colors.teal),
                            SizedBox(width: 5),
                            Text('Change',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined,
            size: 40, color: Color(0xFFAAAAAA)),
        SizedBox(height: 8),
        Text('Tap to add banner',
            style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA))),
      ],
    );
  }

  // ─── Section label ────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.teal,
        letterSpacing: 0.5,
      ),
    );
  }

  // ─── Text field ───────────────────────────────────────────────────────────
  Widget _buildTextField({
    required String label,
    required TextEditingController ctrl,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
        prefixIcon: Icon(icon, size: 20, color: Colors.teal),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.teal, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFF44336))),
      ),
    );
  }

  // ─── Date field ───────────────────────────────────────────────────────────
  Widget _buildDateField(BuildContext context, {required bool isStart}) {
    return Obx(() {
      final label   = isStart ? 'Start Date' : 'End Date';
      final display = isStart
          ? controller.displayStartDate
          : controller.displayEndDate;
      final hasValue = isStart
          ? controller.startDate.value != null
          : controller.endDate.value != null;

      return GestureDetector(
        onTap: () => isStart
            ? controller.selectStartDate(context)
            : controller.selectEndDate(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF999999))),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 15,
                      color: hasValue ? Colors.teal : const Color(0xFFAAAAAA)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      display,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                        hasValue ? FontWeight.w600 : FontWeight.w400,
                        color: hasValue
                            ? const Color(0xFF1A1A2E)
                            : const Color(0xFFAAAAAA),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // ─── Time field ───────────────────────────────────────────────────────────
  Widget _buildTimeField(BuildContext context, {required bool isStart}) {
    return Obx(() {
      final label   = isStart ? 'Start Time' : 'End Time';
      final display = isStart
          ? controller.displayStartTime
          : controller.displayEndTime;
      final hasValue = isStart
          ? controller.startTime.value != null
          : controller.endTime.value != null;

      return GestureDetector(
        onTap: () => isStart
            ? controller.selectStartTime(context)
            : controller.selectEndTime(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF999999))),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 15,
                      color: hasValue ? Colors.teal : const Color(0xFFAAAAAA)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      display,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                        hasValue ? FontWeight.w600 : FontWeight.w400,
                        color: hasValue
                            ? const Color(0xFF1A1A2E)
                            : const Color(0xFFAAAAAA),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // ─── Update button ────────────────────────────────────────────────────────
  Widget _buildUpdateButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed:
        controller.isUpdating.value ? null : controller.updateEvent,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          disabledBackgroundColor: Colors.teal.withOpacity(0.4),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
        child: controller.isUpdating.value
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor:
              AlwaysStoppedAnimation(Colors.white)),
        )
            : const Text(
          'Update Event',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3),
        ),
      ),
    ));
  }
}