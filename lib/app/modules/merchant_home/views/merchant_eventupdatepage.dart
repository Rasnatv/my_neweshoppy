import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/merchant_eventupdatecontroller.dart';

class EventUpdatePage extends StatelessWidget {
  EventUpdatePage({super.key});

  final EventUpdateController controller = Get.put(EventUpdateController());

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

  // ─── AppBar ────────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: Get.back,
        color: const Color(0xFF1A1A2E),
      ),
      title: const Text(
        'Update Event',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFEEEEEE)),
      ),
    );
  }

  // ─── Body ──────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildBannerSection(context),
          const SizedBox(height: 28),
          _buildSectionLabel('Event Details'),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Event Name',
            controller: controller.eventNameCtrl,
            icon: Icons.event_rounded,
            validator: (v) =>
            v == null || v.trim().isEmpty ? 'Event name is required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Location',
            controller: controller.locationCtrl,
            icon: Icons.location_on_rounded,
            validator: (v) =>
            v == null || v.trim().isEmpty ? 'Location is required' : null,
          ),
          const SizedBox(height: 16),

          // ── Locked read-only field (mainLocation if present, else district) ──
          Obx(() {
            final hasMainLocation =
                controller.mainLocation.value != null &&
                    controller.mainLocation.value!.trim().isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel('Region Info'),
                const SizedBox(height: 6),
                _buildLockedNote(),
                const SizedBox(height: 12),
                if (hasMainLocation)
                  _buildLockedField(
                    label: 'Main Location',
                    value: controller.mainLocation.value!,
                    icon: Icons.place_rounded,
                  )
                else
                  _buildLockedField(
                    label: 'District',
                    value: controller.district.value?.isNotEmpty == true
                        ? controller.district.value!
                        : '—',
                    icon: Icons.map_rounded,
                  ),
              ],
            );
          }),

          const SizedBox(height: 28),
          _buildSectionLabel('Date & Time'),
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

  // ─── Banner section ────────────────────────────────────────────────────────
  Widget _buildBannerSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Banner Image'),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: controller.pickBannerImage,
          child: Obx(() {
            final hasNewImage = controller.pickedImageFile.value != null;
            final networkUrl = controller.event.value?.bannerImage ?? '';

            return Container(
              height: 180,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFEEEEF5),
                border: Border.all(
                  color: const Color(0xFFDDDDED),
                  width: 1.5,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image display
                  if (hasNewImage)
                    Image.file(controller.pickedImageFile.value!,
                        fit: BoxFit.cover)
                  else if (networkUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: networkUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (_, __, ___) => _buildImagePlaceholder(),
                    )
                  else
                    _buildImagePlaceholder(),

                  // Overlay
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

                  // Tap hint
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
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt_rounded,
                              size: 14, color: Color(0xFF6C63FF)),
                          SizedBox(width: 5),
                          Text(
                            'Change',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined,
            size: 40, color: Color(0xFFAAAAAA)),
        SizedBox(height: 8),
        Text(
          'Tap to add banner',
          style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
        ),
      ],
    );
  }

  // ─── Section label ─────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6C63FF),
        letterSpacing: 0.5,
      ),
    );
  }

  // ─── Locked note ───────────────────────────────────────────────────────────
  Widget _buildLockedNote() {
    return Row(
      children: [
        const Icon(Icons.info_outline_rounded,
            size: 13, color: Color(0xFFAAAAAA)),
        const SizedBox(width: 5),
        Text(
          'These fields are set by admin and cannot be changed.',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  // ─── Locked read-only field ────────────────────────────────────────────────
  Widget _buildLockedField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 20, color: const Color(0xFFB0ADE8)),
              Positioned(
                right: -5,
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F3F8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 9,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B6B8A),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.lock_rounded, size: 15, color: Color(0xFFCCCCCC)),
        ],
      ),
    );
  }

  // ─── Text field ────────────────────────────────────────────────────────────
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6C63FF)),
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
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF44336)),
        ),
      ),
    );
  }

  // ─── Date field ────────────────────────────────────────────────────────────
  Widget _buildDateField(BuildContext context, {required bool isStart}) {
    return Obx(() {
      final label = isStart ? 'Start Date' : 'End Date';
      final display =
      isStart ? controller.displayStartDate : controller.displayEndDate;
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
              Text(
                label,
                style:
                const TextStyle(fontSize: 11, color: Color(0xFF999999)),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 15,
                    color: hasValue
                        ? const Color(0xFF6C63FF)
                        : const Color(0xFFAAAAAA),
                  ),
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

  // ─── Time field ────────────────────────────────────────────────────────────
  Widget _buildTimeField(BuildContext context, {required bool isStart}) {
    return Obx(() {
      final label = isStart ? 'Start Time' : 'End Time';
      final display =
      isStart ? controller.displayStartTime : controller.displayEndTime;
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
              Text(
                label,
                style:
                const TextStyle(fontSize: 11, color: Color(0xFF999999)),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 15,
                    color: hasValue
                        ? const Color(0xFF6C63FF)
                        : const Color(0xFFAAAAAA),
                  ),
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

  // ─── Update button ─────────────────────────────────────────────────────────
  Widget _buildUpdateButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed:
        controller.isUpdating.value ? null : controller.updateEvent,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          disabledBackgroundColor: const Color(0xFFBBB8FF),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: controller.isUpdating.value
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        )
            : const Text(
          'Update Event',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    ));
  }
}