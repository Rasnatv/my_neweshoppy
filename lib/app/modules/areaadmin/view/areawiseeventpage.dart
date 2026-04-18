
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../common/utils/validators.dart';
import '../controller/areaadmin_eventcontroller.dart';

class AreaAdminAddEventPage extends StatelessWidget {
  AreaAdminAddEventPage({super.key});

  final AreaAdminEventAddController controller =
  Get.put(AreaAdminEventAddController());
  final _formKey = GlobalKey<FormState>();
  final RxBool _submitted = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Create Event",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
        ),
        backgroundColor: AppColors.welcomecardclr,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ================= EVENT DETAILS CARD =================
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            icon: Icons.event_note_rounded,
                            title: "Event Details",
                          ),
                          const SizedBox(height: 20),
                          _modernTextField(
                            controller: controller.eventName,
                            label: "Event Name",
                            hint: "Enter event name",
                            icon: Icons.celebration_outlined,
                            validator: (v) =>
                                DValidator.validateEmptyText("Event Name", v),
                          ),
                          const SizedBox(height: 16),

                          /// ---- State Dropdown ----
                          _stateDropdown(),
                          const SizedBox(height: 16),

                          /// ---- District Dropdown ----
                          _districtDropdown(),
                          const SizedBox(height: 16),

                          /// ---- Main Location Dropdown ----
                          _mainLocationDropdown(),
                          const SizedBox(height: 16),

                          _modernTextField(
                            controller: controller.eventLocation,
                            label: "Event Location",
                            hint: "Enter specific event location",
                            icon: Icons.location_on_outlined,
                            validator: (v) => DValidator.validateEmptyText(
                                "Event Location", v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ================= SCHEDULE CARD =================
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            icon: Icons.access_time_rounded,
                            title: "Schedule",
                          ),
                          const SizedBox(height: 20),
                          _modernPickerField(
                            label: "Start Date",
                            value: controller.startDate,
                            icon: Icons.calendar_today_outlined,
                            onTap: () => controller.pickStartDate(context),
                            errorText: "Start Date is required",
                          ),
                          const SizedBox(height: 16),
                          _modernPickerField(
                            label: "End Date",
                            value: controller.endDate,
                            icon: Icons.event_outlined,
                            onTap: () => controller.pickEndDate(context),
                            errorText: "End Date is required",
                          ),
                          const SizedBox(height: 16),
                          _modernPickerField(
                            label: "Start Time",
                            value: controller.startTime,
                            icon: Icons.access_time,
                            onTap: () => controller.pickStartTime(context),
                            errorText: "Start Time is required",
                          ),
                          const SizedBox(height: 16),
                          _modernPickerField(
                            label: "End Time",
                            value: controller.endTime,
                            icon: Icons.access_time_filled_outlined,
                            onTap: () => controller.pickEndTime(context),
                            errorText: "End Time is required",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ================= IMAGE UPLOAD CARD =================
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            icon: Icons.image_rounded,
                            title: "Banner Image",
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
                                  strokeAlign:
                                  BorderSide.strokeAlignInside,
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
                                    "Upload Event Banner",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Click to browse",
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
                                    child: Container(
                                      padding:
                                      const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
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
                                  "Banner image is required",
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                              : const SizedBox()),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// ================= SAVE BUTTON =================
                    Obx(() => Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.welcomecardclr,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                          _submitted.value = true;
                          if (_formKey.currentState!.validate() &&
                              controller.startDate.value.isNotEmpty &&
                              controller.endDate.value.isNotEmpty &&
                              controller.startTime.value.isNotEmpty &&
                              controller.endTime.value.isNotEmpty &&
                              controller
                                  .selectedState.value.isNotEmpty &&
                              controller.selectedDistrict.value
                                  .isNotEmpty &&
                              controller.selectedMainLocation.value
                                  .isNotEmpty &&
                              controller.bannerImage.value != null) {
                            controller.addEvent();
                          } else {
                            Get.snackbar(
                              "Validation Error",
                              "Please fill all required fields",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.shade400,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                              icon: const Icon(
                                Icons.error_outline,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                        child: controller.isLoading.value
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_circle_outline,
                                size: 22),
                            SizedBox(width: 10),
                            Text(
                              "CREATE EVENT",
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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  /// STATE DROPDOWN
  // ─────────────────────────────────────────────────
  Widget _stateDropdown() {
    return Obx(() {
      final bool hasError =
          _submitted.value && controller.selectedState.value.isEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: "State",
              prefixIcon: const Icon(Icons.flag_outlined, size: 22),
              suffixIcon: controller.isStatesLoading.value
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              )
                  : const Icon(Icons.arrow_drop_down, size: 28),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? Colors.red.shade300 : Colors.grey.shade300,
                  width: hasError ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.kPrimary, width: 2)),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedState.value.isEmpty
                    ? null
                    : controller.selectedState.value,
                hint: Text("Select State",
                    style: TextStyle(
                        fontSize: 15, color: Colors.grey.shade600)),
                isExpanded: true,
                icon: const SizedBox.shrink(),
                items: controller.states
                    .map((s) => DropdownMenuItem<String>(
                  value: s,
                  child: Text(s,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500)),
                ))
                    .toList(),
                onChanged: controller.isStatesLoading.value
                    ? null
                    : (value) {
                  if (value != null) controller.onStateSelected(value);
                },
              ),
            ),
          ),
          if (hasError)
            _errorLabel("State is required"),
        ],
      );
    });
  }

  // ─────────────────────────────────────────────────
  /// DISTRICT DROPDOWN
  // ─────────────────────────────────────────────────
  Widget _districtDropdown() {
    return Obx(() {
      final bool hasError =
          _submitted.value && controller.selectedDistrict.value.isEmpty;
      final bool isDisabled = controller.selectedState.value.isEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: "District",
              prefixIcon: const Icon(Icons.location_city_outlined, size: 22),
              suffixIcon: controller.isDistrictsLoading.value
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              )
                  : const Icon(Icons.arrow_drop_down, size: 28),
              filled: true,
              fillColor:
              isDisabled ? Colors.grey.shade100 : Colors.grey.shade50,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? Colors.red.shade300 : Colors.grey.shade300,
                  width: hasError ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.kPrimary, width: 2)),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedDistrict.value.isEmpty
                    ? null
                    : controller.selectedDistrict.value,
                hint: Text(
                  isDisabled ? "Select State first" : "Select District",
                  style: TextStyle(
                      fontSize: 15, color: Colors.grey.shade600),
                ),
                isExpanded: true,
                icon: const SizedBox.shrink(),
                items: controller.districts
                    .map((d) => DropdownMenuItem<String>(
                  value: d,
                  child: Text(d,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500)),
                ))
                    .toList(),
                onChanged: isDisabled || controller.isDistrictsLoading.value
                    ? null
                    : (value) {
                  if (value != null) {
                    controller.selectedDistrict.value = value;
                  }
                },
              ),
            ),
          ),
          if (hasError)
            _errorLabel("District is required"),
        ],
      );
    });
  }

  // ─────────────────────────────────────────────────
  /// MAIN LOCATION DROPDOWN
  // ─────────────────────────────────────────────────
  Widget _mainLocationDropdown() {
    return Obx(() {
      final bool hasError =
          _submitted.value && controller.selectedMainLocation.value.isEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: "Main Location",
              prefixIcon: const Icon(Icons.map_outlined, size: 22),
              suffixIcon: controller.isLocationsLoading.value
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              )
                  : const Icon(Icons.arrow_drop_down, size: 28),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? Colors.red.shade300 : Colors.grey.shade300,
                  width: hasError ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.kPrimary, width: 2)),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedMainLocation.value.isEmpty
                    ? null
                    : controller.selectedMainLocation.value,
                hint: Text("Select Main Location",
                    style: TextStyle(
                        fontSize: 15, color: Colors.grey.shade600)),
                isExpanded: true,
                icon: const SizedBox.shrink(),
                items: controller.mainLocations
                    .map((loc) => DropdownMenuItem<String>(
                  value: loc,
                  child: Text(loc,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500)),
                ))
                    .toList(),
                onChanged: controller.isLocationsLoading.value
                    ? null
                    : (value) {
                  if (value != null) {
                    controller.selectedMainLocation.value = value;
                  }
                },
              ),
            ),
          ),
          if (hasError)
            _errorLabel("Main Location is required"),
        ],
      );
    });
  }

  // ─────────────────────────────────────────────────
  /// HELPERS
  // ─────────────────────────────────────────────────
  Widget _errorLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 12),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 14, color: Colors.red.shade700),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
        ],
      ),
    );
  }

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
              offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

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
        Text(title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
      ],
    );
  }

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
          prefixIcon: Icon(icon, size: 22),
          suffixIcon: const Icon(Icons.arrow_drop_down, size: 28),
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
          errorText:
          _submitted.value && value.value.isEmpty ? errorText : null,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        child: Text(
          value.value.isEmpty ? "Select $label" : value.value,
          style: TextStyle(
            fontSize: 15,
            color: value.value.isEmpty
                ? Colors.grey.shade600
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