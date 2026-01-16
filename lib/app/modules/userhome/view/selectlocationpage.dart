
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import '../controller/district _controller.dart';

class SelectLocationPage extends StatelessWidget {
  SelectLocationPage({super.key});

  final UserDistrictController controller = Get.put(UserDistrictController());
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Select Location",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
       backgroundColor: AppColors.kPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.kPrimary,
                        AppColors.kPrimary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kPrimary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Choose Your Location",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Select state, district and location",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Form Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // STATE
                      _buildLabel("State", Icons.map),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: controller.selectedState.value.isEmpty
                            ? null
                            : controller.selectedState.value,
                        hint: "Select State",
                        items: controller.states,
                        onChanged: (v) {
                          if (v != null) controller.onStateSelected(v);
                        },
                        enabled: true,
                      ),
                      const SizedBox(height: 20),

                      // DISTRICT
                      _buildLabel("District", Icons.location_city),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: controller.selectedDistrict.value.isEmpty
                            ? null
                            : controller.selectedDistrict.value,
                        hint: "Select District",
                        items: controller.districts,
                        onChanged: (v) {
                          if (v != null) controller.onDistrictSelected(v);
                        },
                        enabled: controller.districts.isNotEmpty,
                      ),
                      const SizedBox(height: 20),

                      // MAIN LOCATION
                      _buildLabel("Location", Icons.pin_drop),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: controller.selectedMainLocation.value.isEmpty
                            ? null
                            : controller.selectedMainLocation.value,
                        hint: "Select Location",
                        items: controller.mainLocations,
                        onChanged: (v) {
                          if (v != null) {
                            controller.selectedMainLocation.value = v;
                          }
                        },
                        enabled: controller.mainLocations.isNotEmpty,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isFormValid()
                        ? () {
                      box.write('state', controller.selectedState.value);
                      box.write('district', controller.selectedDistrict.value);
                      box.write('main_location', controller.selectedMainLocation.value);

                      Get.back(result: {
                        'state': controller.selectedState.value,
                        'district': controller.selectedDistrict.value,
                        'main_location': controller.selectedMainLocation.value,
                      });
                    }
                        : null,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Save Location",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
    required bool enabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          hint,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(
            e,
            style: const TextStyle(fontSize: 15),
          ),
        ))
            .toList(),
        onChanged: enabled ? onChanged : null,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
        ),
        dropdownColor: Colors.white,
        isExpanded: true,
      ),
    );
  }

  bool _isFormValid() {
    return controller.selectedState.value.isNotEmpty &&
        controller.selectedDistrict.value.isNotEmpty &&
        controller.selectedMainLocation.value.isNotEmpty;
  }
}