
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/areaadmin_updateeventcontroller.dart';

class AreaAdminUpdateEventPage extends StatelessWidget {
  final String eventId;
  const AreaAdminUpdateEventPage({super.key, required this.eventId});

  static const _indigo   = Color(0xFF084E43);
  static const _slate900 = Color(0xFF0F172A);
  static const _slate500 = Color(0xFF64748B);
  static const _slate200 = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AreaAdminUpdateEventController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEvent(eventId);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor : AppColors.welcomecardclr,
        elevation       : 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData( color: Colors.white),
        title: const Text('Update Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,))
      ),
      body: Obx(() {
        if (controller.isEventLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: _indigo));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Banner Image ──────────────────────
              _label('Banner Image'),
              const SizedBox(height: 8),
              Obx(() {
                final hasNew      = controller.pickedImage.value != null;
                final hasExisting = controller.existingBannerUrl.value != null;
                return GestureDetector(
                  onTap: controller.pickBannerImage,
                  child: Container(
                    height: 160,
                    width : double.infinity,
                    decoration: BoxDecoration(
                      color       : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border      : Border.all(color: _slate200, width: 1.5),
                      image: hasNew
                          ? DecorationImage(
                          image: FileImage(controller.pickedImage.value!),
                          fit  : BoxFit.cover)
                          : hasExisting
                          ? DecorationImage(
                          image: NetworkImage(
                              controller.existingBannerUrl.value!),
                          fit: BoxFit.cover)
                          : null,
                    ),
                    child: (!hasNew && !hasExisting)
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined,
                            size: 36, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('Tap to upload banner',
                            style: TextStyle(
                                fontSize: 13,
                                color   : Colors.grey.shade500)),
                      ],
                    )
                        : Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color       : _indigo,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit,
                                    size: 12, color: Colors.white),
                                SizedBox(width: 4),
                                Text('Change',
                                    style: TextStyle(
                                        fontSize  : 11,
                                        color     : Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ]),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              // ── Event Name ────────────────────────
              _label('Event Name'),
              const SizedBox(height: 8),
              _inputField(
                  controller: controller.eventName,
                  hint      : 'Enter event name'),
              const SizedBox(height: 16),

              // ── Location Details Card ─────────────
              Container(
                width  : double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color       : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow   : [
                    BoxShadow(
                      color    : Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset   : const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Header
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 15, color: _indigo),
                        const SizedBox(width: 6),
                        const Text(
                          'Location Details',
                          style: TextStyle(
                            fontSize  : 13,
                            fontWeight: FontWeight.w600,
                            color     : _slate900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Select state, district and main location.',
                      style: TextStyle(fontSize: 11, color: _slate500),
                    ),
                    const SizedBox(height: 16),

                    // ── State Dropdown ────────────────
                    _dropdownLabel('State'),
                    const SizedBox(height: 8),
                    Obx(() => _buildDropdown(
                      icon    : Icons.map_outlined,
                      hint    : 'Select State',
                      value   : controller.selectedState.value,
                      items   : controller.stateList,
                      isLoading: controller.isLoadingStates.value,
                      enabled : true,
                      onChanged: (val) =>
                      controller.selectedState.value = val,
                    )),
                    const SizedBox(height: 14),

                    // ── District Dropdown ─────────────
                    _dropdownLabel('District'),
                    const SizedBox(height: 8),
                    Obx(() => _buildDropdown(
                      icon    : Icons.location_city_outlined,
                      hint    : 'Select District',
                      value   : controller.selectedDistrict.value,
                      items   : controller.districtList,
                      isLoading: controller.isLoadingDistricts.value,
                      enabled : controller.selectedState.value != null,
                      onChanged: (val) =>
                      controller.selectedDistrict.value = val,
                    )),
                    const SizedBox(height: 14),

                    // ── Main Location Dropdown ────────
                    _dropdownLabel('Main Location'),
                    const SizedBox(height: 8),
                    Obx(() => _buildDropdown(
                      icon    : Icons.location_on_outlined,
                      hint    : 'Select Location',
                      value   : controller.selectedMainLocation.value,
                      items   : controller.locationList,
                      isLoading: controller.isLoadingLocations.value,
                      enabled : controller.selectedDistrict.value != null,
                      onChanged: (val) =>
                      controller.selectedMainLocation.value = val,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Event Location ────────────────────
              _label('Event Location'),
              const SizedBox(height: 8),
              _inputField(
                  controller: controller.eventLocation,
                  hint      : 'Enter specific location'),
              const SizedBox(height: 16),

              // ── Start & End Date ──────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Start Date'),
                        const SizedBox(height: 8),
                        Obx(() => _tappableField(
                          icon : Icons.calendar_today_outlined,
                          value: controller.startDate.value ?? 'Select date',
                          hint : 'Select date',
                          onTap: () =>
                              controller.pickDate(context, isStart: true),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('End Date'),
                        const SizedBox(height: 8),
                        Obx(() => _tappableField(
                          icon : Icons.calendar_today_outlined,
                          value: controller.endDate.value ?? 'Select date',
                          hint : 'Select date',
                          onTap: () =>
                              controller.pickDate(context, isStart: false),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Start & End Time ──────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Start Time'),
                        const SizedBox(height: 8),
                        Obx(() => _tappableField(
                          icon : Icons.access_time_rounded,
                          value: controller.startTime.value ?? 'Select time',
                          hint : 'Select time',
                          onTap: () =>
                              controller.pickTime(context, isStart: true),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('End Time'),
                        const SizedBox(height: 8),
                        Obx(() => _tappableField(
                          icon : Icons.access_time_rounded,
                          value: controller.endTime.value ?? 'Select time',
                          hint : 'Select time',
                          onTap: () =>
                              controller.pickTime(context, isStart: false),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Update Button ─────────────────────
              Obx(() => SizedBox(
                width : double.infinity,
                height: 52,
                child : ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.updateEvent(eventId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor        : _indigo,
                    disabledBackgroundColor: _indigo.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                      width : 22,
                      height: 22,
                      child : CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                      : const Text('Update Event',
                      style: TextStyle(
                          fontSize  : 15,
                          fontWeight: FontWeight.w700,
                          color     : Colors.white)),
                ),
              )),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // ─── Reusable Dropdown ────────────────────────────
  Widget _buildDropdown({
    required IconData icon,
    required String hint,
    required String? value,
    required RxList<String> items,
    required bool isLoading,
    required bool enabled,
    required void Function(String?) onChanged,
  }) {
    if (isLoading) {
      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color       : Colors.grey.shade100,
          border      : Border.all(color: _slate200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade400),
            const SizedBox(width: 10),
            const SizedBox(
              width : 16,
              height: 16,
              child : CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            Text('Loading...',
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
            color       : enabled ? Colors.grey.shade50 : Colors.grey.shade100,
            border      : Border.all(color: _slate200),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value     : (value != null && items.contains(value)) ? value : null,
              hint: Row(
                children: [
                  Icon(icon, size: 18, color: Colors.grey.shade400),
                  const SizedBox(width: 10),
                  Text(hint,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade400)),
                ],
              ),
              icon : const Icon(Icons.keyboard_arrow_down_rounded,
                  color: _indigo),
              style: const TextStyle(
                  fontSize  : 14,
                  fontWeight: FontWeight.w500,
                  color     : _slate900),
              items: items
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: _indigo),
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

  // ─── Shared Widgets ───────────────────────────────
  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize  : 13,
          fontWeight: FontWeight.w700,
          color     : _slate900));

  Widget _dropdownLabel(String text) => Row(
    children: [
      Text(text,
          style: const TextStyle(
              fontSize  : 13,
              fontWeight: FontWeight.w600,
              color     : _slate500)),
      const SizedBox(width: 4),
      const Text('*', style: TextStyle(color: Colors.red, fontSize: 13)),
    ],
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) =>
      TextField(
        controller: controller,
        maxLines  : maxLines,
        style     : const TextStyle(fontSize: 14, color: _slate900),
        decoration: InputDecoration(
          hintText      : hint,
          hintStyle     : const TextStyle(color: _slate500, fontSize: 14),
          filled        : true,
          fillColor     : Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide  : const BorderSide(color: _slate200, width: 1.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide  : const BorderSide(color: _slate200, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide  : const BorderSide(color: _indigo, width: 1.5)),
        ),
      );

  Widget _tappableField({
    required IconData icon,
    required String value,
    required String hint,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color       : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border      : Border.all(color: _slate200, width: 1.5),
          ),
          child: Row(children: [
            Icon(icon, size: 15, color: _slate500),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                    fontSize  : 13,
                    color     : value == hint ? _slate500 : _slate900,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ]),
        ),
      );
}