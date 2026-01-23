
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/district _controller.dart';


class SelectLocationPage extends StatelessWidget {
  SelectLocationPage({super.key});

  final controller = Get.put(UserLocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: controller.selectedState.value.isEmpty
                    ? null
                    : controller.selectedState.value,
                hint: const Text("Select State"),
                items: controller.states
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.onStateSelected(v);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: controller.selectedDistrict.value.isEmpty
                    ? null
                    : controller.selectedDistrict.value,
                hint: const Text("Select District"),
                items: controller.districts
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: controller.districts.isEmpty
                    ? null
                    : (v) {
                  if (v != null) controller.onDistrictSelected(v);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: controller.selectedMainLocation.value.isEmpty
                    ? null
                    : controller.selectedMainLocation.value,
                hint: const Text("Select Location"),
                items: controller.mainLocations
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: controller.mainLocations.isEmpty
                    ? null
                    : (v) {
                  if (v != null) {
                    controller.selectedMainLocation.value = v;
                  }
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: controller.selectedMainLocation.value.isEmpty
                    ? null
                    : () async {
                  await controller.saveLocation();
                  Get.back();
                },
                child: const Text("Save Location"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
