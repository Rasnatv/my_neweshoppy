
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../../../common/utils/validators.dart';
import '../../controller/admin_addeventcontroller.dart';

class AdminAddEventPage extends StatelessWidget {
  AdminAddEventPage({super.key});

  final AdminEventAddController controller = Get.put(AdminEventAddController());
  final _formKey   = GlobalKey<FormState>();
  final _submitted = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(result: true), // ✅ always return true on back
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Create Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // ── Gradient accent bar ──────────────────────
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.kPrimary,
                        AppColors.kPrimary.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ════════════════════════════════════
                        // EVENT DETAILS CARD
                        // ════════════════════════════════════
                        _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader(
                                icon: Icons.event_note_rounded,
                                title: 'Event Details',
                              ),
                              const SizedBox(height: 20),
                              _modernTextField(
                                controller: controller.eventName,
                                label: 'Event Name',
                                hint: 'Enter event name',
                                icon: Icons.celebration_outlined,
                                validator: (v) =>
                                    DValidator.validateEmptyText('Event Name', v),
                              ),
                              const SizedBox(height: 16),
                              _modernTextField(
                                controller: controller.eventLocation,
                                label: 'Event Location',
                                hint: 'Enter event location',
                                icon: Icons.location_on_outlined,
                                validator: (v) =>
                                    DValidator.validateEmptyText('Location', v),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ════════════════════════════════════
                        // SCHEDULE CARD
                        // ════════════════════════════════════
                        _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader(
                                icon: Icons.access_time_rounded,
                                title: 'Schedule',
                              ),
                              const SizedBox(height: 20),
                              _modernPickerField(
                                label: 'Start Date',
                                value: controller.startDate,
                                icon: Icons.calendar_today_outlined,
                                onTap: () => controller.pickStartDate(context),
                                errorText: 'Start Date is required',
                              ),
                              const SizedBox(height: 16),
                              _modernPickerField(
                                label: 'End Date',
                                value: controller.endDate,
                                icon: Icons.event_outlined,
                                onTap: () => controller.pickEndDate(context),
                                errorText: 'End Date is required',
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _modernPickerField(
                                      label: 'Start Time',
                                      value: controller.startTime,
                                      icon: Icons.access_time,
                                      onTap: () =>
                                          controller.pickStartTime(context),
                                      errorText: 'Required',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _modernPickerField(
                                      label: 'End Time',
                                      value: controller.endTime,
                                      icon: Icons.access_time_filled,
                                      onTap: () =>
                                          controller.pickEndTime(context),
                                      errorText: 'Required',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ════════════════════════════════════
                        // EVENT COVERAGE CARD
                        // ════════════════════════════════════
                        _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader(
                                icon: Icons.map_outlined,
                                title: 'Event Coverage',
                              ),
                              const SizedBox(height: 20),

                              // ── Mode Toggle ───────────────
                              Obx(() => _buildModeToggle()),

                              const SizedBox(height: 16),

                              // ── State Dropdown (always) ───
                              _fieldLabel('Select State'),
                              const SizedBox(height: 8),
                              Obx(() {
                                if (controller.isLoadingStates.value) {
                                  return _buildLoadingRow('Loading states...');
                                }
                                if (controller.stateList.isEmpty) {
                                  return _buildEmptyRow('No states available');
                                }
                                return _buildDropdown(
                                  value: controller.selectedState.value,
                                  hint: 'Choose a state',
                                  icon: Icons.flag_outlined,
                                  items: controller.stateList,
                                  onChanged: (val) =>
                                  controller.selectedState.value = val,
                                );
                              }),

                              const SizedBox(height: 16),

                              // ── District Dropdown (always) ─
                              _fieldLabel('Select District'),
                              const SizedBox(height: 8),
                              Obx(() {
                                if (controller.isLoadingDistricts.value) {
                                  return _buildLoadingRow(
                                      'Loading districts...');
                                }
                                if (controller.districtList.isEmpty) {
                                  return _buildEmptyRow(
                                      'No districts available');
                                }
                                return _buildDropdown(
                                  value: controller.selectedDistrict.value,
                                  hint: 'Choose a district',
                                  icon: Icons.location_city_outlined,
                                  items: controller.districtList,
                                  onChanged: (val) =>
                                  controller.selectedDistrict.value = val,
                                );
                              }),

                              // ── Area Dropdown (area mode only) ─
                              Obx(() {
                                if (controller.showMode.value != 'area') {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    _fieldLabel('Select Area'),
                                    const SizedBox(height: 8),
                                    controller.isLoadingAreas.value
                                        ? _buildLoadingRow('Loading areas...')
                                        : controller.areaList.isEmpty
                                        ? _buildEmptyRow(
                                        'No areas available')
                                        : _buildDropdown(
                                      value: controller
                                          .selectedArea.value,
                                      hint: 'Choose an area',
                                      icon: Icons.place_outlined,
                                      items: controller.areaList,
                                      onChanged: (val) => controller
                                          .selectedArea.value = val,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ════════════════════════════════════
                        // BANNER IMAGE CARD
                        // ════════════════════════════════════
                        _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader(
                                icon: Icons.image_rounded,
                                title: 'Banner Image',
                              ),
                              const SizedBox(height: 20),

                              Obx(() => InkWell(
                                onTap: controller.pickBannerImage,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _submitted.value &&
                                          controller.bannerImage.value ==
                                              null
                                          ? Colors.red.shade300
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade50,
                                  ),
                                  child: controller.bannerImage.value == null
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding:
                                        const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.kPrimary
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 40,
                                          color: AppColors.kPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Upload Event Banner',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Tap to browse from gallery',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  )
                                      : Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        child: Image.file(
                                          controller.bannerImage.value!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: controller
                                              .removeBannerImage,
                                          child: Container(
                                            padding:
                                            const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  8),
                                            ),
                                            child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: [
                                              Icon(
                                                  Icons
                                                      .check_circle_rounded,
                                                  size: 12,
                                                  color:
                                                  AppColors.kPrimary),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Banner selected',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),

                              Obx(() => _submitted.value &&
                                  controller.bannerImage.value == null
                                  ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, left: 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        size: 14,
                                        color: Colors.red.shade700),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Banner image is required',
                                      style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                                  : const SizedBox()),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ════════════════════════════════════
                        // CREATE BUTTON
                        // ════════════════════════════════════
                        Obx(() => SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                              _submitted.value = true;
                              if (_formKey.currentState!.validate()) {
                                controller.addEvent();
                              }
                            },
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : const Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline,
                                    size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'CREATE EVENT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Full Screen Loader ────────────────────────────
          Obx(() => controller.isLoading.value
              ? Container(
            color: Colors.black38,
            child: const Center(child: CircularProgressIndicator()),
          )
              : const SizedBox()),
        ],
      ),
    );
  }

  // ─── Mode Toggle (District / Area) ───────────────────────
  Widget _buildModeToggle() {
    final isArea = controller.showMode.value == 'area';
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _modeTab(
            label: 'District Wise',
            icon: Icons.location_city_rounded,
            selected: !isArea,
            onTap: () => controller.setShowMode('district'),
          ),
          _modeTab(
            label: 'Area Wise',
            icon: Icons.grid_view_rounded,
            selected: isArea,
            onTap: () => controller.setShowMode('area'),
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
            color: selected ? AppColors.kPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
              BoxShadow(
                color: AppColors.kPrimary.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Field Label ──────────────────────────────────────────
  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
  );

  // ─── Dropdown ─────────────────────────────────────────────
  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value != null
              ? AppColors.kPrimary.withOpacity(0.5)
              : Colors.grey.shade300,
          width: value != null ? 1.4 : 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: AppColors.kPrimary),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        items: items
            .map((s) => DropdownMenuItem(
          value: s,
          child: Row(
            children: [
              Icon(icon, size: 15, color: AppColors.kPrimary),
              const SizedBox(width: 8),
              Text(s,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ))
            .toList(),
        selectedItemBuilder: (context) => items
            .map((s) => Row(
          children: [
            Icon(icon, size: 16, color: AppColors.kPrimary),
            const SizedBox(width: 8),
            Text(s,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ))
            .toList(),
        onChanged: onChanged,
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.kPrimary),
        dropdownColor: Colors.white,
      ),
    );
  }

  // ─── Loading Row ──────────────────────────────────────────
  Widget _buildLoadingRow(String label) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.kPrimary),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ],
      ),
    );
  }

  // ─── Empty Row ────────────────────────────────────────────
  Widget _buildEmptyRow(String label) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
      ),
    );
  }

  // ─── Card Wrapper ─────────────────────────────────────────
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // ─── Section Header ───────────────────────────────────────
  Widget _sectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.kPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ─── Text Field ───────────────────────────────────────────
  Widget _modernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.kPrimary, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade300, width: 2)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // ─── Picker Field ─────────────────────────────────────────
  Widget _modernPickerField({
    required String label,
    required RxString value,
    required IconData icon,
    required VoidCallback onTap,
    required String errorText,
  }) {
    return Obx(() => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          suffixIcon: const Icon(Icons.arrow_drop_down, size: 26),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: AppColors.kPrimary, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: Colors.red.shade300, width: 2)),
          errorText:
          _submitted.value && value.value.isEmpty ? errorText : null,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        child: Text(
          value.value.isEmpty ? 'Select $label' : value.value,
          style: TextStyle(
            fontSize: 14,
            color: value.value.isEmpty
                ? Colors.grey.shade500
                : Colors.black87,
            fontWeight: value.value.isEmpty
                ? FontWeight.w400
                : FontWeight.w500,
          ),
        ),
      ),
    ));
  }
}