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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Advertisement",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
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
                Row(
                  children: const [
                    Text("Banner Image",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(width: 4),
                    Text("*", style: TextStyle(color: Colors.red)),
                  ],
                ),
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
                            onPressed:
                            controller.removeBannerImage,
                            icon: const Icon(Icons.close,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),

                const SizedBox(height: 25),

                /// ─── Advertisement Title ─────────────────
                Row(
                  children: const [
                    Text("Advertisement Title",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(width: 4),
                    Text("*", style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 10),

                Obx(() => TextField(
                  controller: controller.adName,
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    prefixIcon: Icon(Icons.campaign,
                        color: AppColors.kPrimary),
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

                /// ─── Location Dropdown ─────────────────
                Row(
                  children: const [
                    Text("Select Location",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(width: 4),
                    Text("*", style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.isLocationLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: controller.selectedLocation.value.isEmpty
                          ? null
                          : controller.selectedLocation.value,
                      hint: const Text("Select Location"),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: controller.locations.map((loc) {
                        return DropdownMenuItem(
                          value: loc,
                          child: Text(loc),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.selectedLocation.value = val ?? '';
                      },
                    ),
                  );
                }),

                const SizedBox(height: 35),

                /// ─── Submit Button ─────────────────────
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.addAdvertisement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
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
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
              : const SizedBox()),
        ],
      ),
    );
  }
}