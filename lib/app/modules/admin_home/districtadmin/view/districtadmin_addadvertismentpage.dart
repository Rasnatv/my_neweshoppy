
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../controller/distrcitadd_addadvertsimentcontroller.dart';

class DistrictAdminAddAdvertisementPage extends StatelessWidget {
  DistrictAdminAddAdvertisementPage({super.key});

  final DistrictAdminAdvertisementController controller =
  Get.put(DistrictAdminAdvertisementController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(
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
                _requiredLabel("Banner Image"),
                const SizedBox(height: 10),

                Obx(() => GestureDetector(
                  onTap: controller.pickBanner,
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
                        Icon(Icons.add_photo_alternate_outlined, size: 60),
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
                _requiredLabel("Advertisement Title"),
                const SizedBox(height: 10),

                Obx(() => TextField(
                  controller: controller.adName,
                  decoration: InputDecoration(
                    hintText   : "Enter title",
                    prefixIcon : Icon(Icons.campaign, color: AppColors.kPrimary),
                    border     : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    errorText  : controller.isTitleEmpty.value
                        ? "Title required"
                        : null,
                  ),
                  onChanged: (v) {
                    controller.isTitleEmpty.value = v.trim().isEmpty;
                  },
                )),

                const SizedBox(height: 25),

                /// ─── State Dropdown ───────────────────────
                _requiredLabel("Select State"),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.isStatesLoading.value) {
                    return _loadingField("Loading states...");
                  }

                  if (controller.states.isEmpty) {
                    return _emptyField("No states available");
                  }

                  return _dropdownField(
                    hint    : "Select State",
                    value   : controller.selectedState.value.isEmpty
                        ? null
                        : controller.selectedState.value,
                    items   : controller.states,
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedState.value    = val;
                        controller.selectedDistrict.value = ''; // reset district
                      }
                    },
                  );
                }),

                const SizedBox(height: 25),

                /// ─── District Dropdown ────────────────────
                _requiredLabel("Select District"),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.isDistrictLoading.value) {
                    return _loadingField("Loading districts...");
                  }

                  if (controller.districts.isEmpty) {
                    return _emptyField("No districts available");
                  }

                  return _dropdownField(
                    hint    : "Select District",
                    value   : controller.selectedDistrict.value.isEmpty
                        ? null
                        : controller.selectedDistrict.value,
                    items   : controller.districts,
                    onChanged: (val) {
                      if (val != null) controller.selectedDistrict.value = val;
                    },
                  );
                }),

                const SizedBox(height: 35),

                /// ─── Submit Button ────────────────────────
                Obx(() => SizedBox(
                  width : double.infinity,
                  height: 55,
                  child : ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.addAdvertisement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.welcomecardclr,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Add Advertisement",
                        style: TextStyle(fontSize: 16)),
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

  // ── Reusable Widgets ────────────────────────────

  Widget _requiredLabel(String text) => Row(
    children: [
      Text(text,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(width: 4),
      const Text("*", style: TextStyle(color: Colors.red)),
    ],
  );

  Widget _dropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border      : Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<String>(
          value     : value,
          hint      : Text(hint),
          isExpanded: true,
          underline : const SizedBox(),
          items     : items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item[0].toUpperCase() + item.substring(1),
              ),
            );
          }).toList(),
          onChanged : onChanged,
        ),
      );

  Widget _loadingField(String label) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      border      : Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(children: [
      const SizedBox(
        width : 16,
        height: 16,
        child : CircularProgressIndicator(strokeWidth: 2),
      ),
      const SizedBox(width: 10),
      Text(label, style: const TextStyle(color: Colors.grey)),
    ]),
  );

  Widget _emptyField(String label) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border      : Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(children: [
      Icon(Icons.info_outline, color: Colors.grey.shade400, size: 18),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(color: Colors.grey)),
    ]),
  );
}