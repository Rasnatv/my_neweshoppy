
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/areaadmin_advertismentcontroller.dart';

class AreaAdminAddAdvertisementPage extends StatelessWidget {
  AreaAdminAddAdvertisementPage({super.key});

  final AreaAdminAdvertisementController controller =
  Get.put(AreaAdminAdvertisementController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Add Advertisement",
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ─── Banner Image ─────────────────────────
                _sectionLabel("Banner Image"),
                const SizedBox(height: 10),

                Obx(() => GestureDetector(
                  onTap: controller.pickBannerImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.bannerImage.value == null
                            ? Colors.grey.shade300
                            : AppColors.kPrimary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: controller.bannerImage.value == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_photo_alternate_outlined,
                            size: 60),
                        SizedBox(height: 10),
                        Text("Tap to upload image"),
                      ],
                    )
                        : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            controller.bannerImage.value!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: controller.removeBannerImage,
                            icon: const Icon(Icons.close,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),

                const SizedBox(height: 25),

                /// ─── Advertisement Title ──────────────────
                _sectionLabel("Advertisement Title"),
                const SizedBox(height: 10),

                Obx(() => TextField(
                  controller: controller.adName,
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    prefixIcon:
                    Icon(Icons.campaign, color: AppColors.kPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: controller.isTitleEmpty.value
                        ? "Title required"
                        : null,
                  ),
                  onChanged: (v) {
                    controller.isTitleEmpty.value = v.trim().isEmpty;
                  },
                )),

                const SizedBox(height: 25),

                /// ─── State Dropdown ───────────────────────
                _sectionLabel("Select State"),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.isStateLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildDropdown(
                    hint: "Select State",
                    value: controller.selectedState.value.isEmpty
                        ? null
                        : controller.selectedState.value,
                    items: controller.states,
                    onChanged: controller.onStateChanged,
                  );
                }),

                const SizedBox(height: 25),

                /// ─── District Dropdown ────────────────────
                _sectionLabel("Select District"),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.isDistrictLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildDropdown(
                    hint: controller.selectedState.value.isEmpty
                        ? "Select state first"
                        : "Select District",
                    value: controller.selectedDistrict.value.isEmpty
                        ? null
                        : controller.selectedDistrict.value,
                    items: controller.districts,
                    onChanged: controller.districts.isEmpty
                        ? null
                        : (val) {
                      controller.selectedDistrict.value = val ?? '';
                    },
                  );
                }),

                const SizedBox(height: 25),

                /// ─── Location Dropdown ────────────────────
                _sectionLabel("Select Location"),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.isLocationLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildDropdown(
                    hint: "Select Location",
                    value: controller.selectedLocation.value.isEmpty
                        ? null
                        : controller.selectedLocation.value,
                    items: controller.locations,
                    onChanged: (val) {
                      controller.selectedLocation.value = val ?? '';
                    },
                  );
                }),

                const SizedBox(height: 35),

                /// ─── Submit Button ────────────────────────
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.addAdvertisement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.welcomecardclr,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                        color: Colors.white)
                        : const Text(
                      "Add Advertisement",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )),

                const SizedBox(height: 20),
              ],
            ),
          ),

          /// ─── Full Screen Loader ───────────────────
          Obx(() => controller.isLoading.value
              ? Container(
            color: Colors.black45,
            child: const Center(child: CircularProgressIndicator()),
          )
              : const SizedBox()),
        ],
      ),
    ));
  }

  // ─── Shared Widgets ───────────────────────────
  Widget _sectionLabel(String label) {
    return Row(
      children: [
        Text(label,
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        const Text("*", style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: onChanged == null ? Colors.grey.shade100 : Colors.white,
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint,
            style: TextStyle(
                color: onChanged == null
                    ? Colors.grey.shade400
                    : Colors.grey.shade600)),
        isExpanded: true,
        underline: const SizedBox(),
        items: items
            .map((item) =>
            DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}