
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../controller/admin_locationcontroller.dart';
import 'locationlistpage.dart';

class AdminAddLocationPage extends StatelessWidget {
  final LocationController controller = Get.put(LocationController());
  final TextEditingController locationAddCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text(
          "Add Location",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => DistrictLocationListPage()),
            icon: Icon(Icons.location_on_outlined, color: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // ----------------- STATE -----------------
            _buildSectionCard(
              title: "State",
              child: Obx(
                    () => _inputField(
                  hint: "Enter State",
                  initialValue: controller.selectedState.value,
                  onChanged: (v) => controller.selectedState.value = v,
                ),
              ),
            ),
            SizedBox(height: 16),

            // ----------------- DISTRICT -----------------
            _buildSectionCard(
              title: "District",
              child: Obx(
                    () => _inputField(
                  hint: "Enter District",
                  initialValue: controller.selectedDistrict.value,
                  onChanged: (v) => controller.selectedDistrict.value = v,
                ),
              ),
            ),
            SizedBox(height: 16),

            // ----------------- LOCATIONS -----------------
            _buildSectionCard(
              title: "Locations",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _plainInput(
                          controller: locationAddCtrl,
                          hint: "Add Location",
                        ),
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: AppColors.kPrimary,
                        child: IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            if (locationAddCtrl.text.trim().isNotEmpty) {
                              controller.addTempLocation(locationAddCtrl.text);
                              locationAddCtrl.clear();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Obx(
                        () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.tempLocations
                          .map(
                            (loc) => Chip(
                          label: Text(loc),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () =>
                              controller.tempLocations.remove(loc),
                          backgroundColor: Colors.deepPurple.shade50,
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),

            // ----------------- SAVE ALL BUTTON -----------------
            Obx(
                  () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.saveAll(),
                  child: controller.isLoading.value
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text("SAVE ALL", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ REUSABLE WIDGETS ------------------
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          child
        ],
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      decoration:
      _decoration(hint: initialValue.isEmpty ? hint : initialValue),
    );
  }

  Widget _plainInput(
      {required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: _decoration(hint: hint),
    );
  }

  InputDecoration _decoration({required String hint}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade200,
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
