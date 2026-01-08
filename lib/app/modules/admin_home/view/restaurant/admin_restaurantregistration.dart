
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/restaurant_regcontroller.dart';

class RestaurantRegistrationPage extends StatelessWidget {
  final controller = Get.put(RestaurantRegController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Restaurant Registration"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(
              title: "Restaurant Image",
              child: _imagePicker(),
            ),
            const SizedBox(height: 24),

            _section(
              title: "Basic Information",
              child: Column(
                children: [
                  _field("Owner Name", controller.ownerCtrl),
                  _field("Address", controller.addressCtrl),
                  _field("Phone", controller.phoneCtrl,
                      type: TextInputType.phone),
                  _field("Email", controller.emailCtrl,
                      type: TextInputType.emailAddress),
                  _field("Website", controller.websiteCtrl),
                  _field("Whatsapp", controller.whatsappCtrl),
                  _field("Facebook", controller.facebookCtrl),
                  _field("Instagram", controller.instaCtrl),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _section(
              title: "Additional Images",
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: controller.pickAdditionalImages,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Images"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => controller.additionalImages.isEmpty
                      ? const Text("No images selected")
                      : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.additionalImages
                        .asMap()
                        .entries
                        .map(
                          (e) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              e.value,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => controller
                                  .additionalImages
                                  .removeAt(e.key),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        .toList(),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed:
                controller.isLoading.value ? null : controller.submit,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2)
                    : const Text("Register Restaurant",
                    style: TextStyle(fontSize: 16)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Divider(height: 28),
          child,
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
      ),
    );
  }

  Widget _imagePicker() {
    return GestureDetector(
      onTap: controller.pickRestaurantImage,
      child: Obx(() => Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: controller.restaurantImage.value == null
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, size: 40),
              SizedBox(height: 6),
              Text("Tap to upload image"),
            ],
          ),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(controller.restaurantImage.value!,
              fit: BoxFit.cover),
        ),
      )),
    );
  }
}
