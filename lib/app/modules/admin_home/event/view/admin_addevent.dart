

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../../../common/utils/validators.dart';
import '../../controller/admin_addeventcontroller.dart';

class AdminAddEventPage extends StatelessWidget {
  AdminAddEventPage({super.key});

  final AdminEventAddController controller =
  Get.put(AdminEventAddController());

  final _formKey = GlobalKey<FormState>();

  /// 🔑 submit flag (VERY IMPORTANT)
  final RxBool _submitted = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Create Event",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
        elevation: 1,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= EVENT DETAILS =================
              _sectionTitle("Event Details"),

              _outlinedField(
                controller: controller.eventName,
                label: "Event Name",
                validator: (v) =>
                    DValidator.validateEmptyText("Event Name", v),
              ),
              const SizedBox(height: 14),

              _outlinedField(
                controller: controller.eventLocation,
                label: "Location",
                validator: (v) =>
                    DValidator.validateEmptyText("Location", v),
              ),

              const SizedBox(height: 24),

              /// ================= SCHEDULE =================
              _sectionTitle("Schedule"),

              _pickerRow(
                label: "Start Date",
                value: controller.startDate,
                onTap: () => controller.pickStartDate(context),
                errorText: "Start Date is required",
              ),
              const SizedBox(height: 12),

              _pickerRow(
                label: "End Date",
                value: controller.endDate,
                onTap: () => controller.pickEndDate(context),
                errorText: "End Date is required",
              ),
              const SizedBox(height: 12),

              _pickerRow(
                label: "Event Time",
                value: controller.eventTime,
                onTap: () => controller.pickTime(context),
                errorText: "Event Time is required",
              ),

              const SizedBox(height: 24),

              /// ================= IMAGE =================
              _sectionTitle("Banner Image"),

              Obx(() => InkWell(
                onTap: controller.pickBannerImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border:
                    Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: controller.bannerImage.value == null
                      ? Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_upload_outlined,
                          size: 36,
                          color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        "Upload Event Banner",
                        style: TextStyle(
                            color: Colors.black54),
                      ),
                    ],
                  )
                      : ClipRRect(
                    borderRadius:
                    BorderRadius.circular(8),
                    child: Image.file(
                      controller.bannerImage.value!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),

              /// image validation
              Obx(() => _submitted.value &&
                  controller.bannerImage.value == null
                  ? Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  "Banner image is required",
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                  ),
                ),
              )
                  : const SizedBox()),

              const SizedBox(height: 32),

              /// ================= SAVE BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _submitted.value = true;

                    if (_formKey.currentState!.validate() &&
                        controller.startDate.value.isNotEmpty &&
                        controller.endDate.value.isNotEmpty &&
                        controller.eventTime.value.isNotEmpty &&
                        controller.bannerImage.value != null) {
                      controller.addEvent();
                    } else {
                      Get.snackbar(
                        "Validation Error",
                        "Please fill all required fields",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade400,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: const Text(
                    "SAVE EVENT",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// ================= TEXT FIELD =================
  Widget _outlinedField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.kPrimary),
        ),
      ),
    );
  }

  /// ================= DATE / TIME PICKER =================
  Widget _pickerRow({
    required String label,
    required RxString value,
    required VoidCallback onTap,
    required String errorText,
  }) {
    return Obx(() => InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
          errorText: _submitted.value && value.value.isEmpty
              ? errorText
              : null,
        ),
        child: Text(
          value.value.isEmpty
              ? "Select $label"
              : value.value,
          style: TextStyle(
            color: value.value.isEmpty
                ? Colors.grey
                : Colors.black87,
          ),
        ),
      ),
    ));
  }
}

