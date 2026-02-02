//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../controller/merchantreg_controller.dart';
// import '../view/merchantmap.dart';
//
// class MerchantRegform extends StatelessWidget {
//   MerchantRegform({super.key});
//
//   final MerchantRegController controller = Get.put(MerchantRegController());
//   final ImagePicker picker = ImagePicker();
//
//   // ------------------ PICK STORE IMAGE ------------------
//   Future pickImage() async {
//     final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       controller.setStoreImage(File(picked.path));
//     }
//   }
//
//   // ------------------ PICK SHOP LOCATION FROM MAP ------------------
//   Future pickShopLocation() async {
//     final result = await Get.to(() => ShopMapPicker(
//       initialLat: controller.shopLat.value,
//       initialLng: controller.shopLng.value,
//       initialAddress: controller.pickedLocation.value,
//     ));
//
//     if (result != null) {
//       controller.updateLocation(
//         result["lat"],
//         result["lng"],
//         result["address"],
//       );
//     }
//   }
//
//   // ------------------ INPUT STYLE ------------------
//   InputDecoration inputStyle(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.white70),
//       prefixIcon: Icon(icon, color: Colors.white70),
//       enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.white38),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.white),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       filled: true,
//       fillColor: Colors.white.withOpacity(0.10),
//     );
//   }
//
//   // ------------------ SOCIAL / OPTIONAL FIELDS ------------------
//   Widget _socialField(
//       IconData icon, String label, TextEditingController textController) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: Colors.white),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextFormField(
//               controller: textController,
//               style: const TextStyle(color: Colors.white),
//               decoration: inputStyle(label, icon),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // ------------------ STORE IMAGE ------------------
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text("Store Image *",
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold)),
//           ),
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: pickImage,
//             child: Obx(() {
//               File? img = controller.storeImage.value;
//               return Container(
//                 height: 130,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: Colors.white54),
//                 ),
//                 child: img == null
//                     ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.add_a_photo,
//                         size: 35, color: Colors.white),
//                     SizedBox(height: 6),
//                     Text("Tap to upload store image",
//                         style: TextStyle(color: Colors.white70)),
//                   ],
//                 )
//                     : ClipRRect(
//                   borderRadius: BorderRadius.circular(14),
//                   child: Image.file(img,
//                       fit: BoxFit.cover, width: double.infinity),
//                 ),
//               );
//             }),
//           ),
//
//           const SizedBox(height: 20),
//
//           // ------------------ BASIC DETAILS ------------------
//           TextFormField(
//             controller: controller.ownerNameController,
//             style: const TextStyle(color: Colors.white),
//             decoration: inputStyle("Owner Name *", Icons.person),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: controller.shopNameController,
//             style: const TextStyle(color: Colors.white),
//             decoration: inputStyle("Shop Name *", Icons.storefront),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: controller.emailController,
//             style: const TextStyle(color: Colors.white),
//             decoration: inputStyle("Email *", Icons.email),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: controller.passwordController,
//             style: const TextStyle(color: Colors.white),
//             decoration: inputStyle("Password *", Icons.lock),
//             obscureText: true,
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: controller.phoneNo1Controller,
//             style: const TextStyle(color: Colors.white),
//             decoration: inputStyle("Phone Number *", Icons.phone),
//             keyboardType: TextInputType.phone,
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: controller.phoneNo2Controller,
//             style: const TextStyle(color: Colors.white),
//             decoration: inputStyle("Alternate Phone Number (Optional)", Icons.phone),
//             keyboardType: TextInputType.phone,
//           ),
//           const SizedBox(height: 20),
//
//           // ------------------ DROPDOWN: STATE ------------------
//           Obx(() {
//             if (controller.isLoadingStates.value) {
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.10),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.white38),
//                 ),
//                 child: Row(
//                   children: const [
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       "Loading states...",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             if (controller.states.isEmpty) {
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.10),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.red),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.error, color: Colors.red),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Text(
//                         "Failed to load states. Please refresh.",
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.refresh, color: Colors.white),
//                       onPressed: () => controller.fetchStates(),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             return DropdownButtonFormField<String>(
//               value: controller.selectedState.value.isEmpty
//                   ? null
//                   : controller.selectedState.value,
//               decoration: inputStyle("State *", Icons.flag_outlined),
//               dropdownColor: Colors.black87,
//               style: const TextStyle(color: Colors.white),
//               items: controller.states
//                   .map((s) => DropdownMenuItem(
//                 value: s,
//                 child:
//                 Text(s, style: const TextStyle(color: Colors.white)),
//               ))
//                   .toList(),
//               onChanged: (v) {
//                 if (v != null) {
//                   controller.selectedState.value = v;
//                   controller.selectedDistrict.value = "";
//                   controller.selectedLocation.value = "";
//                   // Fetch districts for the selected state
//                   controller.fetchDistricts(v);
//                 }
//               },
//             );
//           }),
//           const SizedBox(height: 12),
//
//           // ------------------ DROPDOWN: DISTRICT ------------------
//           Obx(() {
//             if (controller.selectedState.value.isEmpty) {
//               return const SizedBox();
//             }
//
//             if (controller.isLoadingDistricts.value) {
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.10),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.white38),
//                 ),
//                 child: Row(
//                   children: const [
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       "Loading districts...",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             if (controller.districts.isEmpty) {
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.10),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.orange),
//                 ),
//                 child: const Text(
//                   "No districts available for this state",
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               );
//             }
//
//             return DropdownButtonFormField<String>(
//               value: controller.selectedDistrict.value.isEmpty
//                   ? null
//                   : controller.selectedDistrict.value,
//               decoration: inputStyle("District *", Icons.location_city),
//               dropdownColor: Colors.black87,
//               style: const TextStyle(color: Colors.white),
//               items: controller.districts
//                   .map((d) => DropdownMenuItem(
//                 value: d,
//                 child:
//                 Text(d, style: const TextStyle(color: Colors.white)),
//               ))
//                   .toList(),
//               onChanged: (v) {
//                 if (v != null) {
//                   controller.selectedDistrict.value = v;
//                   controller.selectedLocation.value = "";
//                   // Fetch locations for the selected state and district
//                   controller.fetchLocations(controller.selectedState.value, v);
//                 }
//               },
//             );
//           }),
//           const SizedBox(height: 12),
//
//           // ------------------ DROPDOWN: MAIN LOCATION ------------------
//           Obx(() {
//             if (controller.selectedDistrict.value.isEmpty) {
//               return const SizedBox();
//             }
//
//             if (controller.isLoadingLocations.value) {
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.10),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.white38),
//                 ),
//                 child: Row(
//                   children: const [
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       "Loading locations...",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             if (controller.locations.isEmpty) {
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.10),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.orange),
//                 ),
//                 child: const Text(
//                   "No locations available for this district",
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               );
//             }
//
//             return DropdownButtonFormField<String>(
//               value: controller.selectedLocation.value.isEmpty
//                   ? null
//                   : controller.selectedLocation.value,
//               decoration: inputStyle("Main Location *", Icons.place),
//               dropdownColor: Colors.black87,
//               style: const TextStyle(color: Colors.white),
//               items: controller.locations
//                   .map((l) => DropdownMenuItem(
//                 value: l,
//                 child:
//                 Text(l, style: const TextStyle(color: Colors.white)),
//               ))
//                   .toList(),
//               onChanged: (v) {
//                 if (v != null) {
//                   controller.selectedLocation.value = v;
//                 }
//               },
//             );
//           }),
//           const SizedBox(height: 20),
//
//           // ------------------ LOCATION SECTION ------------------
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: Colors.white38),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Shop Location *",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//
//                 // Current Location Button
//                 Obx(() => ElevatedButton.icon(
//                   onPressed: controller.isGettingCurrentLocation.value
//                       ? null
//                       : () => controller.getCurrentLocation(),
//                   icon: controller.isGettingCurrentLocation.value
//                       ? const SizedBox(
//                     width: 16,
//                     height: 16,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                       : const Icon(Icons.my_location, color: Colors.white),
//                   label: Text(
//                     controller.isGettingCurrentLocation.value
//                         ? "Getting Location..."
//                         : "Use Current Location",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     minimumSize: const Size(double.infinity, 48),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 )),
//
//                 const SizedBox(height: 12),
//
//                 const Row(
//                   children: [
//                     Expanded(child: Divider(color: Colors.white38)),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12),
//                       child: Text(
//                         "OR",
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ),
//                     Expanded(child: Divider(color: Colors.white38)),
//                   ],
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 // Map Picker
//                 Obx(() => InkWell(
//                   onTap: pickShopLocation,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.white38),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(
//                             Icons.map,
//                             size: 28,
//                             color: Colors.blue,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Pick Location on Map",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 controller.pickedLocation.value,
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 12,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.white54,
//                           size: 16,
//                         ),
//                       ],
//                     ),
//                   ),
//                 )),
//
//                 // Display coordinates if location is set
//                 Obx(() {
//                   if (controller.shopLat.value != 0.0 &&
//                       controller.shopLng.value != 0.0) {
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Text(
//                         "Coordinates: ${controller.shopLat.value.toStringAsFixed(6)}, ${controller.shopLng.value.toStringAsFixed(6)}",
//                         style: const TextStyle(
//                           color: Colors.green,
//                           fontSize: 12,
//                         ),
//                       ),
//                     );
//                   }
//                   return const SizedBox();
//                 }),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // ------------------ OPTIONAL FIELDS HEADER ------------------
//           const Divider(color: Colors.white38),
//           const SizedBox(height: 12),
//           const Text(
//             "Optional Information",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           // ------------------ OPTIONAL FIELDS ------------------
//           _socialField(
//               Icons.phone, "WhatsApp Number (Optional)", controller.whatsappController),
//           _socialField(
//               Icons.facebook, "Facebook Link (Optional)", controller.facebookController),
//           _socialField(Icons.camera_alt, "Instagram Link (Optional)",
//               controller.instagramController),
//           _socialField(
//               Icons.public, "Website Link (Optional)", controller.websiteController),
//
//           const SizedBox(height: 30),
//
//           // ------------------ REGISTER BUTTON ------------------
//           Obx(() => SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: controller.isLoading.value
//                   ? null
//                   : () {
//                 controller.registerMerchant();
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: controller.isLoading.value
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text(
//                 "Register",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ))
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/merchantreg_controller.dart';
import '../view/merchantmap.dart';

class MerchantRegform extends StatelessWidget {
  MerchantRegform({super.key});

  final MerchantRegController controller = Get.put(MerchantRegController());
  final ImagePicker picker = ImagePicker();

  // ------------------ PICK STORE IMAGE ------------------
  Future pickImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      controller.setStoreImage(File(picked.path));
    }
  }

  // ------------------ PICK SHOP LOCATION FROM MAP ------------------
  Future pickShopLocation() async {
    final result = await Get.to(() => ShopMapPicker(
      initialLat: controller.shopLat.value,
      initialLng: controller.shopLng.value,
      initialAddress: controller.pickedLocation.value,
    ));

    if (result != null) {
      controller.updateLocation(
        result["lat"],
        result["lng"],
        result["address"],
      );
    }
  }

  // ------------------ INPUT STYLE ------------------
  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: const TextStyle(
        color: Color(0xFF009788),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF757575),
        size: 20,
      ),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF009788),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE57373),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE57373),
          width: 2,
        ),
      ),
      errorStyle: const TextStyle(
        color: Color(0xFFD32F2F),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ------------------ STORE IMAGE ------------------
        _buildSectionHeader("Store Image", isRequired: true),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: pickImage,
          child: Obx(() {
            File? img = controller.storeImage.value;
            return Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1.5,
                ),
              ),
              child: img == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF009788).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: Color(0xFF009788),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Tap to upload store image",
                    style: TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.file(
                      img,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
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
            );
          }),
        ),

        const SizedBox(height: 24),

        // ------------------ BASIC DETAILS ------------------
        TextFormField(
          controller: controller.ownerNameController,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: inputStyle("Owner Name", Icons.person_outline),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: controller.shopNameController,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: inputStyle("Shop Name", Icons.storefront_outlined),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: controller.emailController,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: TextInputType.emailAddress,
          decoration: inputStyle("Email", Icons.email_outlined),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: controller.passwordController,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          obscureText: true,
          decoration: inputStyle("Password", Icons.lock_outline),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: controller.phoneNo1Controller,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: TextInputType.phone,
          decoration: inputStyle("Phone Number", Icons.phone_outlined),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: controller.phoneNo2Controller,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: TextInputType.phone,
          decoration: inputStyle("Alternate Phone (Optional)", Icons.phone_outlined),
        ),

        const SizedBox(height: 24),

        // ------------------ DROPDOWN: STATE ------------------
        Obx(() {
          if (controller.isLoadingStates.value) {
            return _buildLoadingContainer("Loading states...");
          }

          if (controller.states.isEmpty) {
            return _buildErrorContainer(
              "Failed to load states",
              onRefresh: () => controller.fetchStates(),
            );
          }

          return DropdownButtonFormField<String>(
            value: controller.selectedState.value.isEmpty
                ? null
                : controller.selectedState.value,
            decoration: inputStyle("State", Icons.flag_outlined),
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 15,
            ),
            dropdownColor: Colors.white,
            items: controller.states
                .map((s) => DropdownMenuItem(
              value: s,
              child: Text(s),
            ))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                controller.selectedState.value = v;
                controller.selectedDistrict.value = "";
                controller.selectedLocation.value = "";
                controller.fetchDistricts(v);
              }
            },
          );
        }),
        const SizedBox(height: 16),

        // ------------------ DROPDOWN: DISTRICT ------------------
        Obx(() {
          if (controller.selectedState.value.isEmpty) {
            return const SizedBox();
          }

          if (controller.isLoadingDistricts.value) {
            return _buildLoadingContainer("Loading districts...");
          }

          if (controller.districts.isEmpty) {
            return _buildInfoContainer("No districts available");
          }

          return Column(
            children: [
              DropdownButtonFormField<String>(
                value: controller.selectedDistrict.value.isEmpty
                    ? null
                    : controller.selectedDistrict.value,
                decoration: inputStyle("District", Icons.location_city_outlined),
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 15,
                ),
                dropdownColor: Colors.white,
                items: controller.districts
                    .map((d) => DropdownMenuItem(
                  value: d,
                  child: Text(d),
                ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    controller.selectedDistrict.value = v;
                    controller.selectedLocation.value = "";
                    controller.fetchLocations(
                        controller.selectedState.value, v);
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        }),

        // ------------------ DROPDOWN: MAIN LOCATION ------------------
        Obx(() {
          if (controller.selectedDistrict.value.isEmpty) {
            return const SizedBox();
          }

          if (controller.isLoadingLocations.value) {
            return _buildLoadingContainer("Loading locations...");
          }

          if (controller.locations.isEmpty) {
            return _buildInfoContainer("No locations available");
          }

          return Column(
            children: [
              DropdownButtonFormField<String>(
                value: controller.selectedLocation.value.isEmpty
                    ? null
                    : controller.selectedLocation.value,
                decoration: inputStyle("Main Location", Icons.place_outlined),
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 15,
                ),
                dropdownColor: Colors.white,
                items: controller.locations
                    .map((l) => DropdownMenuItem(
                  value: l,
                  child: Text(l),
                ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    controller.selectedLocation.value = v;
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        }),

        const SizedBox(height: 8),

        // ------------------ LOCATION SECTION ------------------
        _buildLocationSection(),

        const SizedBox(height: 24),

        // ------------------ OPTIONAL FIELDS DIVIDER ------------------
        _buildDivider("Optional Information"),
        const SizedBox(height: 20),

        // ------------------ OPTIONAL FIELDS ------------------
        TextFormField(
          controller: controller.whatsappController,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: TextInputType.phone,
          decoration: inputStyle("WhatsApp Number", Icons.phone_outlined),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: controller.facebookController,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: inputStyle("Facebook Link", Icons.facebook),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: controller.instagramController,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: inputStyle("Instagram Link", Icons.camera_alt_outlined),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: controller.websiteController,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: inputStyle("Website Link", Icons.language_outlined),
        ),

        const SizedBox(height: 32),

        // ------------------ REGISTER BUTTON ------------------
        Obx(() => SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
              controller.registerMerchant();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009788),
              foregroundColor: Colors.white,
              disabledBackgroundColor:
              const Color(0xFF009788).withOpacity(0.5),
              elevation: 0,
              shadowColor: const Color(0xFF009788).withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            )
                : const Text(
              "Register Merchant",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            "*",
            style: TextStyle(
              color: Color(0xFFD32F2F),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingContainer(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF009788)),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF757575),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContainer(String message, {VoidCallback? onRefresh}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFF9800),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFFF9800)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF424242),
                fontSize: 14,
              ),
            ),
          ),
          if (onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF009788)),
              onPressed: onRefresh,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF2196F3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF2196F3)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF424242),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.location_on_outlined,
                color: Color(0xFF009788),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Shop Location",
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 4),
              Text(
                "*",
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Current Location Button
          Obx(() => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: controller.isGettingCurrentLocation.value
                  ? null
                  : () => controller.getCurrentLocation(),
              icon: controller.isGettingCurrentLocation.value
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.my_location, size: 20),
              label: Text(
                controller.isGettingCurrentLocation.value
                    ? "Getting Location..."
                    : "Use Current Location",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          )),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                  child: Container(
                      height: 1, color: const Color(0xFFE0E0E0))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "OR",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      height: 1, color: const Color(0xFFE0E0E0))),
            ],
          ),

          const SizedBox(height: 12),

          // Map Picker
          Obx(() => InkWell(
            onTap: pickShopLocation,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.map_outlined,
                      size: 24,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pick from Map",
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.pickedLocation.value,
                          style: const TextStyle(
                            color: Color(0xFF757575),
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF9E9E9E),
                    size: 16,
                  ),
                ],
              ),
            ),
          )),

          // Display coordinates
          Obx(() {
            if (controller.shopLat.value != 0.0 &&
                controller.shopLng.value != 0.0) {
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF4CAF50),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Location set: ${controller.shopLat.value.toStringAsFixed(6)}, ${controller.shopLng.value.toStringAsFixed(6)}",
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildDivider(String title) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE0E0E0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF757575),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE0E0E0),
          ),
        ),
      ],
    );
  }
}