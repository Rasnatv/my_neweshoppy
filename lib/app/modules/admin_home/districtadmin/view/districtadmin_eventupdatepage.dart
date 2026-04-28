
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../controller/districtadmin_eventupdatecontroller.dart';

class DistrictAdminUpdateEventPage extends StatelessWidget {
  final String eventId;
  const DistrictAdminUpdateEventPage({super.key, required this.eventId});

  static const _indigo   = Color(0xFF084E43);
  static const _slate900 = Color(0xFF0F172A);
  static const _slate500 = Color(0xFF64748B);
  static const _slate200 = Color(0xFFE2E8F0);
  static const _slate100 = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DistrictAdminUpdateEventController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEvent(eventId);
    });

    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor : AppColors.welcomecardclr,
        elevation       : 0,
        surfaceTintColor: Colors.transparent,
       automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Update Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),)),

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

              // ── State Dropdown ────────────────────
              _label('State'),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.isStatesLoading.value) {
                  return _loadingField('Loading states...');
                }
                return _dropdownField(
                  hint    : 'Select state',
                  value   : controller.selectedState.value,
                  items   : controller.states,
                  onChanged: (val) {
                    controller.selectedState.value    = val;
                    controller.selectedDistrict.value = null; // reset district
                  },
                );
              }),
              const SizedBox(height: 16),

              // ── District Dropdown ─────────────────
              _label('District'),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.isDistrictsLoading.value) {
                  return _loadingField('Loading districts...');
                }
                return _dropdownField(
                  hint    : 'Select district',
                  value   : controller.selectedDistrict.value,
                  items   : controller.districts,
                  onChanged: (val) => controller.selectedDistrict.value = val,
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
    ));
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
          hintText      : hint,
          hintStyle     : const TextStyle(color: _slate500, fontSize: 14),
          filled        : true,
          fillColor     : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 14),
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

  /// Editable dropdown field for state / district
  Widget _dropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    // If pre-filled value from API isn't in the list yet, still show it
    final effectiveValue = (value != null && value.isNotEmpty) ? value : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color       : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border      : Border.all(color: _slate200, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded  : true,
          value       : (effectiveValue != null && items.contains(effectiveValue))
              ? effectiveValue
              : null,
          hint        : Text(hint,
              style: const TextStyle(color: _slate500, fontSize: 14)),
          icon        : const Icon(Icons.keyboard_arrow_down_rounded,
              color: _slate500),
          style       : const TextStyle(fontSize: 14, color: _slate900),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged   : onChanged,
        ),
      ),
    );
  }

  /// Shown while states/districts are loading
  Widget _loadingField(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color       : _slate100,
      borderRadius: BorderRadius.circular(12),
      border      : Border.all(color: _slate200, width: 1.5),
    ),
    child: Row(children: [
      const SizedBox(
        width : 14,
        height: 14,
        child : CircularProgressIndicator(strokeWidth: 2, color: _slate500),
      ),
      const SizedBox(width: 10),
      Text(label,
          style: const TextStyle(fontSize: 13, color: _slate500)),
    ]),
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