// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/district _controller.dart';
//
// class SelectLocationPage extends StatelessWidget {
//   final DistrictController controller = Get.find();
//   final TextEditingController locationController = TextEditingController();
//
//   SelectLocationPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     locationController.text = controller.userLocation.value;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Your Location"),
//         backgroundColor: Colors.teal,
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // ---------------- STATE ----------------
//             const Text("State", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//
//             Obx(() => DropdownButtonFormField<String>(
//               value: controller.selectedState.value,
//               items: controller.stateList.map((e) {
//                 return DropdownMenuItem(value: e, child: Text(e));
//               }).toList(),
//               onChanged: (v) => controller.updateState(v!),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//             )),
//
//             const SizedBox(height: 20),
//
//             // ---------------- DISTRICT ----------------
//             const Text("District", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//
//             Obx(() => DropdownButtonFormField<String>(
//               value: controller.selectedDistrict.value,
//               items: controller.districtList.map((e) {
//                 return DropdownMenuItem(value: e, child: Text(e));
//               }).toList(),
//               onChanged: (v) => controller.updateDistrict(v!),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//             )),
//
//             const SizedBox(height: 20),
//
//             // ---------------- LOCATION TEXTFIELD ----------------
//             const Text("Your Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//
//             TextField(
//               controller: locationController,
//               decoration: InputDecoration(
//                 hintText: "Enter your location",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//             ),
//
//             const Spacer(),
//
//             // ---------------- SUBMIT BUTTON ----------------
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   controller.updateUserLocation(locationController.text);
//
//                   Get.back(); // return to home
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: const Text("Save Location", style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/district _controller.dart';

class SelectLocationPage extends StatelessWidget {
  SelectLocationPage({super.key});

  final DistrictController controller = Get.find();
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    locationController.text = controller.userLocation.value;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        title:  Text("Select Location",style:AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// HEADER CARD
              SizedBox(height: 50,),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Choose your location",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// STATE DROPDOWN
                      _label("State"),
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedState.value,
                        items: controller.stateList
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                            .toList(),
                        onChanged: (v) =>
                            controller.updateState(v ?? ""),
                        decoration:
                        _inputDecoration(Icons.map_outlined, "Select State"),
                      )),

                      const SizedBox(height: 16),

                      /// DISTRICT DROPDOWN
                      _label("District"),
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedDistrict.value,
                        items: controller.districtList
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                            .toList(),
                        onChanged: (v) =>
                            controller.updateDistrict(v ?? ""),
                        decoration: _inputDecoration(
                            Icons.location_city_outlined, "Select District"),
                      )),

                      const SizedBox(height: 16),

                      /// LOCATION TEXTFIELD
                      _label("Your Location"),
                      TextField(
                        controller: locationController,
                        decoration: _inputDecoration(
                            Icons.place_outlined, "Enter location"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller
                        .updateUserLocation(locationController.text.trim());
                    Get.back();
                  },
                  child: const Text(
                    "Save Location",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  /// ---------------- HELPER WIDGETS ----------------
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
