
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/areaadmin_updateeventcontroller.dart';


class AreaAdminUpdateEventPage extends StatelessWidget {
  final String eventId;
  const AreaAdminUpdateEventPage({super.key, required this.eventId});

  static const _indigo   = Color(0xFF4F46E5);
  static const _slate900 = Color(0xFF0F172A);
  static const _slate500 = Color(0xFF64748B);
  static const _slate200 = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AreaAdminUpdateEventController());

    // Fetch event data from API on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEvent(eventId);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor : Colors.white,
        elevation       : 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon     : const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: _slate900),
          onPressed: () => Get.back(),
        ),
        title: const Text('Update Event',
            style: TextStyle(
                fontSize  : 17,
                fontWeight: FontWeight.w700,
                color     : _slate900)),
        centerTitle: true,
      ),

      // Full-page loader while fetching event
      body: Obx(() {
        if (controller.isEventLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _indigo),
          );
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
                  onTap: controller.pickImage,
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

              // ── Area / Main Location Dropdown ─────
              _label('Area / Main Location'),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.isLocationsLoading.value) {
                  return Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color       : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border      : Border.all(color: _slate200, width: 1.5),
                    ),
                    child: const Center(
                      child: SizedBox(
                          width : 20,
                          height: 20,
                          child : CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  );
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color       : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border      : Border.all(color: _slate200, width: 1.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Select area',
                          style: TextStyle(color: _slate500, fontSize: 14)),
                      value: controller.selectedMainLocation.value,
                      icon : const Icon(Icons.keyboard_arrow_down_rounded,
                          color: _slate500),
                      items: controller.mainLocations
                          .map((loc) => DropdownMenuItem(
                        value: loc,
                        child: Text(loc,
                            style: const TextStyle(
                                fontSize: 14, color: _slate900)),
                      ))
                          .toList(),
                      onChanged: (val) =>
                      controller.selectedMainLocation.value = val,
                    ),
                  ),
                );
              }),
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

              // ── Start & End Time (tap → time picker) ──
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

  // ── Reusable Widgets ───────────────────────────────

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize  : 13,
          fontWeight: FontWeight.w700,
          color     : _slate900));

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
          hintText    : hint,
          hintStyle   : const TextStyle(color: _slate500, fontSize: 14),
          filled      : true,
          fillColor   : Colors.white,
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

  /// Shared tappable field used for both date and time pickers
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