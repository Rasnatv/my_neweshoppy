// //
// // import 'dart:io';
// // import 'package:eshoppy/app/common/style/app_colors.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../../../common/style/app_text_style.dart';
// // import '../../merchantlogin/view/merchantmap.dart';
// // import '../controller/merchantsetting_controller.dart';
// //
// //
// // class MerchantSettingPage extends StatelessWidget {
// //   final MerchantUpdateController controller = Get.put(MerchantUpdateController());
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade50,
// //       appBar: AppBar(
// //         backgroundColor:AppColors.kPrimary,
// //         elevation: 0,
// //         automaticallyImplyLeading: true,
// //         iconTheme: const IconThemeData(
// //           color: Colors.white, // back arrow color
// //         ),
// //         title: Text(
// //           "Edit Profile",
// //           style:  AppTextStyle.rTextNunitoWhite17w700
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: Obx(() {
// //               if (controller.isLoading.value) {
// //                 return Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       const CircularProgressIndicator(
// //                         color: Colors.teal,
// //                         strokeWidth: 3,
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Text(
// //                         "Loading profile...",
// //                         style: TextStyle(
// //                           color: Colors.grey.shade600,
// //                           fontSize: 14,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               }
// //
// //               return SingleChildScrollView(
// //                 padding: const EdgeInsets.all(20),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // Store Image Section
// //                     Text(
// //                       "Store Image",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                         color: Colors.grey.shade800,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     GetBuilder<MerchantUpdateController>(
// //                       builder: (c) {
// //                         return GestureDetector(
// //                           onTap: () => controller.pickImage(),
// //                           child: Container(
// //                             height: 180,
// //                             width: double.infinity,
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: BorderRadius.circular(16),
// //                               border: Border.all(
// //                                 color: Colors.grey.shade300,
// //                                 width: 2,
// //                               ),
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.black.withOpacity(0.05),
// //                                   blurRadius: 10,
// //                                   offset: const Offset(0, 4),
// //                                 ),
// //                               ],
// //                             ),
// //                             child: c.pickedImage != null
// //                                 ? Stack(
// //                               children: [
// //                                 ClipRRect(
// //                                   borderRadius: BorderRadius.circular(14),
// //                                   child: Image.file(
// //                                     c.pickedImage!,
// //                                     fit: BoxFit.cover,
// //                                     width: double.infinity,
// //                                     height: double.infinity,
// //                                   ),
// //                                 ),
// //                                 Positioned(
// //                                   top: 12,
// //                                   right: 12,
// //                                   child: Container(
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.black.withOpacity(0.6),
// //                                       shape: BoxShape.circle,
// //                                     ),
// //                                     child: IconButton(
// //                                       icon: const Icon(
// //                                         Icons.edit,
// //                                         color: Colors.white,
// //                                         size: 20,
// //                                       ),
// //                                       onPressed: () => controller.pickImage(),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             )
// //                                 : c.networkImage.isNotEmpty
// //                                 ? Stack(
// //                               children: [
// //                                 ClipRRect(
// //                                   borderRadius: BorderRadius.circular(14),
// //                                   child: Image.network(
// //                                     c.networkImage,
// //                                     fit: BoxFit.cover,
// //                                     width: double.infinity,
// //                                     height: double.infinity,
// //                                   ),
// //                                 ),
// //                                 Positioned(
// //                                   top: 12,
// //                                   right: 12,
// //                                   child: Container(
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.black.withOpacity(0.6),
// //                                       shape: BoxShape.circle,
// //                                     ),
// //                                     child: IconButton(
// //                                       icon: const Icon(
// //                                         Icons.edit,
// //                                         color: Colors.white,
// //                                         size: 20,
// //                                       ),
// //                                       onPressed: () => controller.pickImage(),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             )
// //                                 : Column(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 Container(
// //                                   padding: const EdgeInsets.all(16),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.teal.withOpacity(0.1),
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                   child: const Icon(
// //                                     Icons.add_a_photo,
// //                                     size: 48,
// //                                     color: Colors.teal,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(height: 16),
// //                                 Text(
// //                                   "Tap to upload store image",
// //                                   style: TextStyle(
// //                                     fontSize: 14,
// //                                     color: Colors.grey.shade600,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     const SizedBox(height: 32),
// //
// //                     // Basic Details Section
// //                     Text(
// //                       "Basic Details",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                         color: Colors.grey.shade800,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     _buildTextField("Owner Name", controller.ownerCtrl, Icons.person_outline),
// //                     const SizedBox(height: 16),
// //                     _buildTextField("Shop Name", controller.shopCtrl, Icons.storefront_outlined),
// //                     const SizedBox(height: 16),
// //                     _buildTextField("Email", controller.emailCtrl, Icons.email_outlined),
// //                     const SizedBox(height: 16),
// //                     _buildTextField("Phone Number 1", controller.phone1Ctrl, Icons.phone_outlined),
// //                     const SizedBox(height: 16),
// //                     _buildTextField("Phone Number 2", controller.phone2Ctrl, Icons.phone_outlined),
// //                     const SizedBox(height: 32),
// //
// //                     // Location Section
// //                     Text(
// //                       "Location Details",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                         color: Colors.grey.shade800,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //
// //                     // State Dropdown
// //                     Obx(() => _buildDropdown(
// //                       "State",
// //                       controller.selectedState.value.isEmpty ? null : controller.selectedState.value,
// //                       controller.states,
// //                           (value) {
// //                         if (value != null) {
// //                           controller.selectedState.value = value;
// //                           controller.fetchDistricts(value);
// //                         }
// //                       },
// //                       Icons.flag_outlined,
// //                       controller.isLoadingStates.value,
// //                     )),
// //                     const SizedBox(height: 16),
// //
// //                     // District Dropdown
// //                     Obx(() {
// //                       if (controller.selectedState.value.isEmpty) {
// //                         return const SizedBox();
// //                       }
// //                       return _buildDropdown(
// //                         "District",
// //                         controller.selectedDistrict.value.isEmpty ? null : controller.selectedDistrict.value,
// //                         controller.districts,
// //                             (value) {
// //                           if (value != null) {
// //                             controller.selectedDistrict.value = value;
// //                             controller.fetchLocations(
// //                               controller.selectedState.value,
// //                               value,
// //                             );
// //                           }
// //                         },
// //                         Icons.location_city_outlined,
// //                         controller.isLoadingDistricts.value,
// //                       );
// //                     }),
// //                     const SizedBox(height: 16),
// //
// //                     // Location Dropdown
// //                     Obx(() {
// //                       if (controller.selectedDistrict.value.isEmpty) {
// //                         return const SizedBox();
// //                       }
// //                       return _buildDropdown(
// //                         "Main Location",
// //                         controller.selectedLocation.value.isEmpty ? null : controller.selectedLocation.value,
// //                         controller.locations,
// //                             (value) {
// //                           if (value != null) {
// //                             controller.selectedLocation.value = value;
// //                           }
// //                         },
// //                         Icons.place_outlined,
// //                         controller.isLoadingLocations.value,
// //                       );
// //                     }),
// //                     const SizedBox(height: 24),
// //
// //                     // Shop Location Section
// //                     Container(
// //                       padding: const EdgeInsets.all(20),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(16),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.05),
// //                             blurRadius: 10,
// //                             offset: const Offset(0, 4),
// //                           ),
// //                         ],
// //                       ),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Row(
// //                             children: [
// //                               Icon(Icons.location_on, color: Colors.teal, size: 24),
// //                               const SizedBox(width: 8),
// //                               Text(
// //                                 "Shop Location",
// //                                 style: TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.w600,
// //                                   color: Colors.grey.shade800,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           const SizedBox(height: 16),
// //
// //                           // Current Location Button
// //                           Obx(() => ElevatedButton.icon(
// //                             onPressed: controller.isGettingCurrentLocation.value
// //                                 ? null
// //                                 : () => controller.getCurrentLocation(),
// //                             icon: controller.isGettingCurrentLocation.value
// //                                 ? const SizedBox(
// //                               width: 16,
// //                               height: 16,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                                 : const Icon(Icons.my_location, color: Colors.white),
// //                             label: Text(
// //                               controller.isGettingCurrentLocation.value
// //                                   ? "Getting Location..."
// //                                   : "Use Current Location",
// //                               style: const TextStyle(color: Colors.white),
// //                             ),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor:AppColors.kPrimary,
// //                               minimumSize: const Size(double.infinity, 48),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12),
// //                               ),
// //                             ),
// //                           )),
// //                           const SizedBox(height: 12),
// //
// //                           const Row(
// //                             children: [
// //                               Expanded(child: Divider(color: Colors.grey)),
// //                               Padding(
// //                                 padding: EdgeInsets.symmetric(horizontal: 12),
// //                                 child: Text(
// //                                   "OR",
// //                                   style: TextStyle(color: Colors.grey),
// //                                 ),
// //                               ),
// //                               Expanded(child: Divider(color: Colors.grey)),
// //                             ],
// //                           ),
// //                           const SizedBox(height: 12),
// //
// //                           // Map Picker Button
// //                           Obx(() => InkWell(
// //                             onTap: () => _pickShopLocation(),
// //                             child: Container(
// //                               padding: const EdgeInsets.all(16),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.teal.withOpacity(0.1),
// //                                 borderRadius: BorderRadius.circular(12),
// //                                 border: Border.all(color: Colors.teal.withOpacity(0.3)),
// //                               ),
// //                               child: Row(
// //                                 children: [
// //                                   Container(
// //                                     padding: const EdgeInsets.all(10),
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.teal,
// //                                       borderRadius: BorderRadius.circular(10),
// //                                     ),
// //                                     child: const Icon(
// //                                       Icons.map,
// //                                       size: 24,
// //                                       color: Colors.white,
// //                                     ),
// //                                   ),
// //                                   const SizedBox(width: 12),
// //                                   Expanded(
// //                                     child: Column(
// //                                       crossAxisAlignment: CrossAxisAlignment.start,
// //                                       children: [
// //                                         const Text(
// //                                           "Pick Location on Map",
// //                                           style: TextStyle(
// //                                             fontWeight: FontWeight.w600,
// //                                             fontSize: 14,
// //                                           ),
// //                                         ),
// //                                         const SizedBox(height: 4),
// //                                         Text(
// //                                           controller.pickedLocation.value,
// //                                           style: TextStyle(
// //                                             color: Colors.grey.shade600,
// //                                             fontSize: 12,
// //                                           ),
// //                                           maxLines: 2,
// //                                           overflow: TextOverflow.ellipsis,
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   Icon(
// //                                     Icons.arrow_forward_ios,
// //                                     color: Colors.grey.shade400,
// //                                     size: 16,
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           )),
// //
// //                           // Display coordinates
// //                           Obx(() {
// //                             if (controller.latitude.value != 0.0 && controller.longitude.value != 0.0) {
// //                               return Padding(
// //                                 padding: const EdgeInsets.only(top: 12),
// //                                 child: Container(
// //                                   padding: const EdgeInsets.all(12),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.green.withOpacity(0.1),
// //                                     borderRadius: BorderRadius.circular(8),
// //                                     border: Border.all(color: Colors.green.withOpacity(0.3)),
// //                                   ),
// //                                   child: Row(
// //                                     children: [
// //                                       const Icon(Icons.check_circle, color: Colors.green, size: 20),
// //                                       const SizedBox(width: 8),
// //                                       Expanded(
// //                                         child: Text(
// //                                           "Lat: ${controller.latitude.value.toStringAsFixed(6)}, Lng: ${controller.longitude.value.toStringAsFixed(6)}",
// //                                           style: const TextStyle(
// //                                             color: Colors.green,
// //                                             fontSize: 12,
// //                                             fontWeight: FontWeight.w500,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               );
// //                             }
// //                             return const SizedBox();
// //                           }),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 32),
// //
// //                     // Social Links Section
// //                     Text(
// //                       "Social Links (Optional)",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                         color: Colors.grey.shade800,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     _buildTextField("WhatsApp Number", controller.whatsappCtrl, Icons.phone_outlined),
// //                     const SizedBox(height: 16),
// //                     _buildTextField("Facebook Link", controller.facebookCtrl, Icons.facebook_outlined),
// //                     const SizedBox(height: 16),
// //                     _buildTextField("Instagram Link", controller.instagramCtrl, Icons.camera_alt_outlined),
// //                     const SizedBox(height: 16),
// //                     _buildTextField("Website Link", controller.websiteCtrl, Icons.language_outlined),
// //                     const SizedBox(height: 40),
// //
// //                     // Update Button
// //                     Obx(() => Container(
// //                       width: double.infinity,
// //                       height: 56,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(16),
// //                         gradient: LinearGradient(
// //                           colors: controller.isUpdating.value
// //                               ? [
// //                             Colors.grey.shade400,
// //                             Colors.grey.shade400,
// //                           ]
// //                               : [
// //                             Colors.teal,
// //                             Colors.teal.shade700,
// //                           ],
// //                         ),
// //                         boxShadow: controller.isUpdating.value
// //                             ? []
// //                             : [
// //                           BoxShadow(
// //                             color: Colors.teal.withOpacity(0.3),
// //                             blurRadius: 12,
// //                             offset: const Offset(0, 6),
// //                           ),
// //                         ],
// //                       ),
// //                       child: ElevatedButton(
// //                         onPressed: controller.isUpdating.value ? null : () => controller.updateMerchant(),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.transparent,
// //                           shadowColor: Colors.transparent,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(16),
// //                           ),
// //                         ),
// //                         child: controller.isUpdating.value
// //                             ? const SizedBox(
// //                           height: 24,
// //                           width: 24,
// //                           child: CircularProgressIndicator(
// //                             color: Colors.white,
// //                             strokeWidth: 2.5,
// //                           ),
// //                         )
// //                             : Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: const [
// //                             Icon(Icons.check_circle_outline, color: Colors.white),
// //                             SizedBox(width: 8),
// //                             Text(
// //                               "Update Profile",
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.w600,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     )),
// //                     const SizedBox(height: 20),
// //                   ],
// //                 ),
// //               );
// //             }),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Pick shop location from map
// //   Future<void> _pickShopLocation() async {
// //     final result = await Get.to(() => ShopMapPicker(
// //       initialLat: controller.latitude.value,
// //       initialLng: controller.longitude.value,
// //       initialAddress: controller.pickedLocation.value,
// //     ));
// //
// //     if (result != null) {
// //       controller.updateLocation(
// //         result["lat"],
// //         result["lng"],
// //         result["address"],
// //       );
// //     }
// //   }
// //
// //   Widget _buildTextField(String label, TextEditingController ctrl, IconData icon) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: TextField(
// //         controller: ctrl,
// //         style: const TextStyle(fontSize: 15),
// //         decoration: InputDecoration(
// //           labelText: label,
// //           labelStyle: TextStyle(color: Colors.grey.shade600),
// //           prefixIcon: Icon(icon, color: Colors.teal),
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(16),
// //             borderSide: BorderSide.none,
// //           ),
// //           enabledBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(16),
// //             borderSide: BorderSide.none,
// //           ),
// //           focusedBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(16),
// //             borderSide: const BorderSide(
// //               color: Colors.teal,
// //               width: 2,
// //             ),
// //           ),
// //           filled: true,
// //           fillColor: Colors.white,
// //           contentPadding: const EdgeInsets.symmetric(
// //             horizontal: 20,
// //             vertical: 18,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDropdown(
// //       String label,
// //       String? value,
// //       List<String> items,
// //       Function(String?) onChanged,
// //       IconData icon,
// //       bool isLoading,
// //       ) {
// //     if (isLoading) {
// //       return Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           children: [
// //             const SizedBox(
// //               width: 20,
// //               height: 20,
// //               child: CircularProgressIndicator(
// //                 strokeWidth: 2,
// //                 color: Colors.teal,
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Text(
// //               "Loading $label...",
// //               style: TextStyle(color: Colors.grey.shade600),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //
// //     if (items.isEmpty) {
// //       return Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(color: Colors.orange),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Text(
// //           "No $label available",
// //           style: TextStyle(color: Colors.grey.shade600),
// //         ),
// //       );
// //     }
// //
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: DropdownButtonFormField<String>(
// //         value: value,
// //         decoration: InputDecoration(
// //           labelText: label,
// //           labelStyle: TextStyle(color: Colors.grey.shade600),
// //           prefixIcon: Icon(icon, color: Colors.teal),
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(16),
// //             borderSide: BorderSide.none,
// //           ),
// //           enabledBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(16),
// //             borderSide: BorderSide.none,
// //           ),
// //           focusedBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(16),
// //             borderSide: const BorderSide(
// //               color: Colors.teal,
// //               width: 2,
// //             ),
// //           ),
// //           filled: true,
// //           fillColor: Colors.white,
// //           contentPadding: const EdgeInsets.symmetric(
// //             horizontal: 20,
// //             vertical: 18,
// //           ),
// //         ),
// //         dropdownColor: Colors.white,
// //         style: const TextStyle(color: Colors.black87, fontSize: 15),
// //         items: items
// //             .map((item) => DropdownMenuItem<String>(
// //           value: item,
// //           child: Text(item),
// //         ))
// //             .toList(),
// //         onChanged: onChanged,
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:eshoppy/app/common/style/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_text_style.dart';
// import '../../merchantlogin/view/merchantmap.dart';
// import '../controller/merchantsetting_controller.dart';
//
// class MerchantSettingPage extends StatelessWidget {
//   final MerchantUpdateController controller =
//   Get.put(MerchantUpdateController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         backgroundColor: AppColors.kPrimary,
//         elevation: 0,
//         automaticallyImplyLeading: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "Edit Profile",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.3,
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             height: 1,
//             color: Colors.white.withOpacity(0.15),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         color: AppColors.kPrimary,
//                         strokeWidth: 2.5,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         "Loading profile...",
//                         style: TextStyle(
//                           color: Colors.grey.shade500,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20, vertical: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ── Store Image ──────────────────────────────────
//                     _SectionLabel(label: "Store Image"),
//                     const SizedBox(height: 12),
//                     GetBuilder<MerchantUpdateController>(
//                       builder: (c) {
//                         return GestureDetector(
//                           onTap: () => controller.pickImage(),
//                           child: Container(
//                             height: 190,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(14),
//                               border: Border.all(
//                                 color: const Color(0xFFE2E8F0),
//                                 width: 1.5,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.04),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: c.pickedImage != null
//                                 ? _ImageWithEditOverlay(
//                               child: Image.file(
//                                 c.pickedImage!,
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 height: double.infinity,
//                               ),
//                               onEdit: () => controller.pickImage(),
//                             )
//                                 : c.networkImage.isNotEmpty
//                                 ? _ImageWithEditOverlay(
//                               child: Image.network(
//                                 c.networkImage,
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 height: double.infinity,
//                               ),
//                               onEdit: () => controller.pickImage(),
//                             )
//                                 : Column(
//                               mainAxisAlignment:
//                               MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(18),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.kPrimary
//                                         .withOpacity(0.07),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(
//                                     Icons.add_a_photo_outlined,
//                                     size: 36,
//                                     color: AppColors.kPrimary,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 14),
//                                 Text(
//                                   "Tap to upload store image",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.grey.shade500,
//                                     letterSpacing: 0.2,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "JPG, PNG recommended",
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     color: Colors.grey.shade400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//
//                     const SizedBox(height: 32),
//
//                     // ── Basic Details ───────────────────────────────
//                     _SectionLabel(label: "Basic Details"),
//                     const SizedBox(height: 14),
//                     _buildTextField(
//                         "Owner Name", controller.ownerCtrl, Icons.person_outline),
//                     const SizedBox(height: 14),
//                     _buildTextField(
//                         "Shop Name", controller.shopCtrl, Icons.storefront_outlined),
//                     const SizedBox(height: 14),
//                     _buildTextField(
//                         "Email", controller.emailCtrl, Icons.email_outlined),
//                     const SizedBox(height: 14),
//                     _buildTextField("Phone Number 1", controller.phone1Ctrl,
//                         Icons.phone_outlined),
//                     const SizedBox(height: 14),
//                     _buildTextField("Phone Number 2", controller.phone2Ctrl,
//                         Icons.phone_outlined),
//
//                     const SizedBox(height: 32),
//
//                     // ── Location Details ────────────────────────────
//                     _SectionLabel(label: "Location Details"),
//                     const SizedBox(height: 14),
//
//                     Obx(() => _buildDropdown(
//                       "State",
//                       controller.selectedState.value.isEmpty
//                           ? null
//                           : controller.selectedState.value,
//                       controller.states,
//                           (value) {
//                         if (value != null) {
//                           controller.selectedState.value = value;
//                           controller.fetchDistricts(value);
//                         }
//                       },
//                       Icons.flag_outlined,
//                       controller.isLoadingStates.value,
//                     )),
//                     const SizedBox(height: 14),
//
//                     Obx(() {
//                       if (controller.selectedState.value.isEmpty) {
//                         return const SizedBox();
//                       }
//                       return Column(
//                         children: [
//                           _buildDropdown(
//                             "District",
//                             controller.selectedDistrict.value.isEmpty
//                                 ? null
//                                 : controller.selectedDistrict.value,
//                             controller.districts,
//                                 (value) {
//                               if (value != null) {
//                                 controller.selectedDistrict.value = value;
//                                 controller.fetchLocations(
//                                   controller.selectedState.value,
//                                   value,
//                                 );
//                               }
//                             },
//                             Icons.location_city_outlined,
//                             controller.isLoadingDistricts.value,
//                           ),
//                           const SizedBox(height: 14),
//                         ],
//                       );
//                     }),
//
//                     Obx(() {
//                       if (controller.selectedDistrict.value.isEmpty) {
//                         return const SizedBox();
//                       }
//                       return Column(
//                         children: [
//                           _buildDropdown(
//                             "Main Location",
//                             controller.selectedLocation.value.isEmpty
//                                 ? null
//                                 : controller.selectedLocation.value,
//                             controller.locations,
//                                 (value) {
//                               if (value != null) {
//                                 controller.selectedLocation.value = value;
//                               }
//                             },
//                             Icons.place_outlined,
//                             controller.isLoadingLocations.value,
//                           ),
//                           const SizedBox(height: 14),
//                         ],
//                       );
//                     }),
//
//                     const SizedBox(height: 8),
//
//                     // ── Shop Location Card ──────────────────────────
//                     _SectionLabel(label: "Shop Location"),
//                     const SizedBox(height: 14),
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(
//                           color: const Color(0xFFE2E8F0),
//                           width: 1,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.04),
//                             blurRadius: 8,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           // Use Current Location
//                           Obx(() => SizedBox(
//                             width: double.infinity,
//                             height: 48,
//                             child: ElevatedButton.icon(
//                               onPressed:
//                               controller.isGettingCurrentLocation.value
//                                   ? null
//                                   : () =>
//                                   controller.getCurrentLocation(),
//                               icon: controller
//                                   .isGettingCurrentLocation.value
//                                   ? const SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                                   : const Icon(Icons.my_location,
//                                   color: Colors.white, size: 18),
//                               label: Text(
//                                 controller.isGettingCurrentLocation.value
//                                     ? "Detecting Location..."
//                                     : "Use Current Location",
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.kPrimary,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                           )),
//
//                           const SizedBox(height: 16),
//                           Row(
//                             children: [
//                               Expanded(
//                                   child: Divider(
//                                       color: Colors.grey.shade200,
//                                       thickness: 1)),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14),
//                                 child: Text(
//                                   "OR",
//                                   style: TextStyle(
//                                     color: Colors.grey.shade400,
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w600,
//                                     letterSpacing: 1.2,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                   child: Divider(
//                                       color: Colors.grey.shade200,
//                                       thickness: 1)),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//
//                           // Map Picker
//                           Obx(() => InkWell(
//                             onTap: () => _pickShopLocation(),
//                             borderRadius: BorderRadius.circular(10),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 14),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFF8FAFB),
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: const Color(0xFFDDE3EA),
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: AppColors.kPrimary
//                                           .withOpacity(0.1),
//                                       borderRadius:
//                                       BorderRadius.circular(8),
//                                     ),
//                                     child: Icon(
//                                       Icons.map_outlined,
//                                       size: 20,
//                                       color: AppColors.kPrimary,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 14),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           "Pick Location on Map",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 13,
//                                             color: Color(0xFF1A202C),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 3),
//                                         Text(
//                                           controller.pickedLocation.value
//                                               .isEmpty
//                                               ? "No location selected yet"
//                                               : controller
//                                               .pickedLocation.value,
//                                           style: TextStyle(
//                                             color: Colors.grey.shade500,
//                                             fontSize: 12,
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.chevron_right_rounded,
//                                     color: Colors.grey.shade400,
//                                     size: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )),
//
//                           // Coordinates badge
//                           Obx(() {
//                             if (controller.latitude.value != 0.0 &&
//                                 controller.longitude.value != 0.0) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(top: 12),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 14, vertical: 10),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFF0FDF4),
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                       color: const Color(0xFFBBF7D0),
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.check_circle_rounded,
//                                         color: Color(0xFF16A34A),
//                                         size: 16,
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Expanded(
//                                         child: Text(
//                                           "Lat: ${controller.latitude.value.toStringAsFixed(6)}, "
//                                               "Lng: ${controller.longitude.value.toStringAsFixed(6)}",
//                                           style: const TextStyle(
//                                             color: Color(0xFF15803D),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }
//                             return const SizedBox();
//                           }),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 32),
//
//                     // ── Social Links ────────────────────────────────
//                     _SectionLabel(
//                       label: "Social Links",
//                       badge: "Optional",
//                     ),
//                     const SizedBox(height: 14),
//                     _buildTextField("WhatsApp Number", controller.whatsappCtrl,
//                         Icons.facebook_outlined),
//                     const SizedBox(height: 14),
//                     _buildTextField("Facebook Link", controller.facebookCtrl,
//                         Icons.facebook_outlined),
//                     const SizedBox(height: 14),
//                     _buildTextField("Instagram Link",
//                         controller.instagramCtrl, Icons.camera_alt_outlined),
//                     const SizedBox(height: 14),
//                     _buildTextField("Website Link", controller.websiteCtrl,
//                         Icons.language_outlined),
//
//                     const SizedBox(height: 36),
//
//                     // ── Update Button ───────────────────────────────
//                     Obx(() => SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: controller.isUpdating.value
//                             ? null
//                             : () => controller.updateMerchant(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: controller.isUpdating.value
//                               ? Colors.grey.shade300
//                               : AppColors.kPrimary,
//                           elevation: controller.isUpdating.value ? 0 : 2,
//                           shadowColor:
//                           AppColors.kPrimary.withOpacity(0.3),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: controller.isUpdating.value
//                             ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2.5,
//                           ),
//                         )
//                             : const Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.check_rounded,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               "Save Changes",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )),
//
//                     const SizedBox(height: 28),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _pickShopLocation() async {
//     final result = await Get.to(() => ShopMapPicker(
//       initialLat: controller.latitude.value,
//       initialLng: controller.longitude.value,
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
//   Widget _buildTextField(
//       String label, TextEditingController ctrl, IconData icon) {
//     return TextField(
//       controller: ctrl,
//       style: const TextStyle(
//         fontSize: 14,
//         color: Color(0xFF1A202C),
//         fontWeight: FontWeight.w400,
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(
//           color: Colors.grey.shade500,
//           fontSize: 13,
//           fontWeight: FontWeight.w400,
//         ),
//         prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.kPrimary, width: 1.5),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDropdown(
//       String label,
//       String? value,
//       List<String> items,
//       Function(String?) onChanged,
//       IconData icon,
//       bool isLoading,
//       ) {
//     if (isLoading) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
//         ),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: AppColors.kPrimary,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               "Loading $label...",
//               style: TextStyle(
//                 color: Colors.grey.shade500,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     if (items.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.orange.shade200, width: 1),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.info_outline, color: Colors.orange.shade400, size: 18),
//             const SizedBox(width: 10),
//             Text(
//               "No $label available",
//               style: TextStyle(
//                 color: Colors.grey.shade500,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return DropdownButtonFormField<String>(
//       value: value,
//       style: const TextStyle(
//         color: Color(0xFF1A202C),
//         fontSize: 14,
//       ),
//       dropdownColor: Colors.white,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(
//           color: Colors.grey.shade500,
//           fontSize: 13,
//           fontWeight: FontWeight.w400,
//         ),
//         prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.kPrimary, width: 1.5),
//         ),
//       ),
//       items: items
//           .map((item) => DropdownMenuItem<String>(
//         value: item,
//         child: Text(item),
//       ))
//           .toList(),
//       onChanged: onChanged,
//     );
//   }
// }
//
// // ────────────────────────────────────────────────
// // Supporting Widgets
// // ────────────────────────────────────────────────
//
// class _SectionLabel extends StatelessWidget {
//   final String label;
//   final String? badge;
//
//   const _SectionLabel({required this.label, this.badge});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF64748B),
//             letterSpacing: 0.8,
//           ),
//         ),
//         if (badge != null) ...[
//           const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               badge!,
//               style: const TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF94A3B8),
//                 letterSpacing: 0.4,
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }
//
// class _ImageWithEditOverlay extends StatelessWidget {
//   final Widget child;
//   final VoidCallback onEdit;
//
//   const _ImageWithEditOverlay({required this.child, required this.onEdit});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: SizedBox(
//             width: double.infinity,
//             height: double.infinity,
//             child: child,
//           ),
//         ),
//         Positioned(
//           top: 10,
//           right: 10,
//           child: GestureDetector(
//             onTap: onEdit,
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.55),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.edit_outlined,
//                 color: Colors.white,
//                 size: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:io';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../merchantlogin/view/merchantmap.dart';
import '../controller/merchantsetting_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Design Tokens
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const primary      = Color(0xFF0A6E5C);
  static const primaryLight = Color(0xFF0D8A72);
  static const primaryUltra = Color(0xFFE6F4F1);
  static const surface      = Colors.white;
  static const bg           = Color(0xFFF0F4F3);
  static const border       = Color(0xFFDDE5E3);
  static const divider      = Color(0xFFF1F5F4);
  static const textPrimary  = Color(0xFF111827);
  static const textSecond   = Color(0xFF6B7280);
  static const textMuted    = Color(0xFF9CA3AF);
  static const success      = Color(0xFF059669);
  static const successBg    = Color(0xFFECFDF5);
  static const locked       = Color(0xFFF8FAFB);
  static const lockedBorder = Color(0xFFE5E7EB);
  static const lockedText   = Color(0xFF9CA3AF);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Page
// ─────────────────────────────────────────────────────────────────────────────
class MerchantSettingPage extends StatelessWidget {
  final MerchantUpdateController controller =
  Get.put(MerchantUpdateController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.bg,
        appBar: _appBar(),
        body: Obx(() => controller.isLoading.value
            ? _loadingView()
            : _body()),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: _C.primary,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    automaticallyImplyLeading: true,
    iconTheme: const IconThemeData(color: Colors.white),
    title: const Text(
      "Edit Profile",
      style: TextStyle(
        color: Colors.white, fontSize: 17,
        fontWeight: FontWeight.w600, letterSpacing: 0.2,
      ),
    ),
    actions: [
      Obx(() => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Center(
          child: GestureDetector(
            onTap: controller.isUpdating.value
                ? null : () => controller.updateMerchant(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: controller.isUpdating.value
                    ? Colors.white.withOpacity(0.5) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: controller.isUpdating.value
                  ? const SizedBox(
                width: 14, height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2, color: _C.primary,
                ),
              )
                  : const Text(
                "Save",
                style: TextStyle(
                  color: _C.primary, fontSize: 13,
                  fontWeight: FontWeight.w700, letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      )),
    ],
  );

  // ── Loading ───────────────────────────────────────────────────────────────
  Widget _loadingView() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(color: _C.primary, strokeWidth: 2.5),
        SizedBox(height: 18),
        Text(
          "Loading profile…",
          style: TextStyle(color: _C.textMuted, fontSize: 14),
        ),
      ],
    ),
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  Widget _body() => SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _profileHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel("Basic Details"),
              const SizedBox(height: 12),
              _basicDetailsGroup(),

              const SizedBox(height: 28),
              _sectionLabel("Location"),
              const SizedBox(height: 12),
              _locationDropdowns(),
              const SizedBox(height: 10),
              _locationCard(),

              const SizedBox(height: 28),
              _sectionLabel("Social Links"),
              const SizedBox(height: 12),
              _socialFields(),

              const SizedBox(height: 36),
              _saveButton(),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Only you can see your account details",
                  style: TextStyle(fontSize: 11, color: _C.textMuted),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ── Profile Header ────────────────────────────────────────────────────────
  Widget _profileHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green banner
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 90,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF085E4E), Color(0xFF0A6E5C), Color(0xFF0F8870)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CustomPaint(
                  size: const Size(double.infinity, 90),
                  painter: _BannerPatternPainter(),
                ),
              ),
              Positioned(
                bottom: -34,
                left: 20,
                child: _avatarWidget(),
              ),
            ],
          ),
          // Name & shop
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 44, 20, 18),
            child: GetBuilder<MerchantUpdateController>(
              builder: (c) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.ownerCtrl.text.isNotEmpty ? c.ownerCtrl.text : "Your Name",
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: _C.textPrimary, letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _chip(
                        icon: Icons.storefront_outlined,
                        label: c.shopCtrl.text.isNotEmpty
                            ? c.shopCtrl.text : "Shop Name",
                      ),
                      const SizedBox(width: 8),
                      _activeDot(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarWidget() {
    return GetBuilder<MerchantUpdateController>(
      builder: (c) => GestureDetector(
        onTap: () => controller.pickImage(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                color: _C.primaryUltra,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10, offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: c.pickedImage != null
                  ? Image.file(c.pickedImage!, fit: BoxFit.cover)
                  : c.networkImage.isNotEmpty
                  ? Image.network(c.networkImage, fit: BoxFit.cover)
                  : const Icon(Icons.storefront_outlined,
                  size: 32, color: _C.primary),
            ),
            Positioned(
              bottom: -3, right: -3,
              child: Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: _C.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: _C.primary.withOpacity(0.3),
                      blurRadius: 4, offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _C.primaryUltra,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: _C.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: _C.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeDot() => Row(
    children: [
      Container(
        width: 6, height: 6,
        decoration: const BoxDecoration(color: _C.success, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      const Text(
        "Active",
        style: TextStyle(fontSize: 11, color: _C.success, fontWeight: FontWeight.w500),
      ),
    ],
  );

  // ── Section Label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) => Row(
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: _C.textMuted, letterSpacing: 0.9,
        ),
      ),
      const SizedBox(width: 10),
      const Expanded(child: Divider(color: _C.border, thickness: 1, height: 1)),
    ],
  );

  // ── Basic Details Group ───────────────────────────────────────────────────
  Widget _basicDetailsGroup() {
    return _CardGroup(
      children: [
        _EditableRow(
          label: "Owner Name",
          ctrl: controller.ownerCtrl,
          iconWidget: _iconBox(Icons.person_outline, _C.primary, _C.primaryUltra),
          keyboardType: TextInputType.name,
        ),
        _EditableRow(
          label: "Shop Name",
          ctrl: controller.shopCtrl,
          iconWidget: _iconBox(Icons.storefront_outlined, _C.primary, _C.primaryUltra),
          keyboardType: TextInputType.text,
        ),
        // Email – read-only, non-editable
        _LockedRow(
          label: "Email Address",
          ctrl: controller.emailCtrl,
          iconWidget: _iconBox(Icons.email_outlined, _C.textMuted, const Color(0xFFF3F4F6)),
        ),
        _EditableRow(
          label: "Phone Number 1",
          ctrl: controller.phone1Ctrl,
          iconWidget: _iconBox(Icons.phone_outlined, _C.primary, _C.primaryUltra),
          keyboardType: TextInputType.phone,
        ),
        _EditableRow(
          label: "Phone Number 2",
          ctrl: controller.phone2Ctrl,
          iconWidget: _iconBox(Icons.phone_outlined, _C.primary, _C.primaryUltra),
          keyboardType: TextInputType.phone,
          isLast: true,
        ),
      ],
    );
  }

  Widget _iconBox(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        color: bgColor, borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }

  // ── Location Dropdowns ────────────────────────────────────────────────────
  Widget _locationDropdowns() {
    return _CardGroup(
      children: [
        Obx(() => _DropdownRow(
          label: "State",
          value: controller.selectedState.value.isEmpty
              ? null : controller.selectedState.value,
          items: controller.states,
          onChanged: (v) {
            if (v != null) {
              controller.selectedState.value = v;
              controller.fetchDistricts(v);
            }
          },
          iconWidget: _iconBox(Icons.flag_outlined, _C.primary, _C.primaryUltra),
          isLoading: controller.isLoadingStates.value,
        )),
        Obx(() {
          if (controller.selectedState.value.isEmpty) return const SizedBox();
          return _DropdownRow(
            label: "District",
            value: controller.selectedDistrict.value.isEmpty
                ? null : controller.selectedDistrict.value,
            items: controller.districts,
            onChanged: (v) {
              if (v != null) {
                controller.selectedDistrict.value = v;
                controller.fetchLocations(controller.selectedState.value, v);
              }
            },
            iconWidget: _iconBox(Icons.location_city_outlined, _C.primary, _C.primaryUltra),
            isLoading: controller.isLoadingDistricts.value,
          );
        }),
        Obx(() {
          if (controller.selectedDistrict.value.isEmpty) return const SizedBox();
          return _DropdownRow(
            label: "Main Location",
            value: controller.selectedLocation.value.isEmpty
                ? null : controller.selectedLocation.value,
            items: controller.locations,
            onChanged: (v) {
              if (v != null) controller.selectedLocation.value = v;
            },
            iconWidget: _iconBox(Icons.place_outlined, _C.primary, _C.primaryUltra),
            isLoading: controller.isLoadingLocations.value,
            isLast: true,
          );
        }),
      ],
    );
  }

  // ── Location Card ─────────────────────────────────────────────────────────
  Widget _locationCard() {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Map preview
          Stack(
            children: [
              _MapPreview(),
              Positioned(
                top: 10, right: 10,
                child: GestureDetector(
                  onTap: _pickShopLocation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6, offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.edit_outlined, size: 12, color: _C.primary),
                        SizedBox(width: 4),
                        Text(
                          "Change",
                          style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600, color: _C.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Obx(() {
                  final hasLoc = controller.latitude.value != 0.0;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: hasLoc ? _C.successBg : _C.primaryUltra,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          hasLoc ? Icons.check_circle_outline : Icons.location_on_outlined,
                          size: 16,
                          color: hasLoc ? _C.success : _C.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "SHOP ADDRESS",
                              style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600,
                                color: _C.textMuted, letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              controller.pickedLocation.value.isNotEmpty
                                  ? controller.pickedLocation.value
                                  : "No location selected yet",
                              style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: controller.pickedLocation.value.isNotEmpty
                                    ? _C.textPrimary : _C.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                Obx(() {
                  if (controller.latitude.value == 0.0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        _coordChip(
                          "LAT",
                          controller.latitude.value.toStringAsFixed(6),
                        ),
                        const SizedBox(width: 8),
                        _coordChip(
                          "LNG",
                          controller.longitude.value.toStringAsFixed(6),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _locBtn(
                        label: controller.isGettingCurrentLocation.value
                            ? "Detecting…" : "Use GPS",
                        icon: Icons.my_location,
                        isPrimary: false,
                        isLoading: controller.isGettingCurrentLocation.value,
                        onTap: controller.isGettingCurrentLocation.value
                            ? null : controller.getCurrentLocation,
                      )),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _locBtn(
                        label: "Pin on Map",
                        icon: Icons.map_outlined,
                        isPrimary: true,
                        onTap: _pickShopLocation,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _coordChip(String axis, String val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFB),
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: _C.border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$axis  ",
          style: const TextStyle(
            fontSize: 9, fontWeight: FontWeight.w800,
            color: _C.primary, letterSpacing: 0.4,
          ),
        ),
        Text(
          val,
          style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, color: _C.textSecond,
          ),
        ),
      ],
    ),
  );

  Widget _locBtn({
    required String label,
    required IconData icon,
    required bool isPrimary,
    bool isLoading = false,
    VoidCallback? onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        color: isPrimary ? _C.primary : _C.primaryUltra,
        borderRadius: BorderRadius.circular(10),
        border: isPrimary ? null
            : Border.all(color: _C.primary.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox(
              width: 13, height: 13,
              child: CircularProgressIndicator(
                strokeWidth: 2, color: _C.primary,
              ),
            )
          else
            Icon(icon, size: 14, color: isPrimary ? Colors.white : _C.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: isPrimary ? Colors.white : _C.primary,
            ),
          ),
        ],
      ),
    ),
  );

  // ── Social Fields ─────────────────────────────────────────────────────────
  Widget _socialFields() {
    return _CardGroup(
      children: [
        _SocialRow(
          label: "WhatsApp",
          ctrl: controller.whatsappCtrl,
          hint: "+91 9876543210",
          iconPainter: _WhatsAppPainter(),
          iconBg: const Color(0xFFDCFCE7),
          keyboardType: TextInputType.phone,
        ),
        _SocialRow(
          label: "Facebook",
          ctrl: controller.facebookCtrl,
          hint: "facebook.com/yourpage",
          iconPainter: _FacebookPainter(),
          iconBg: const Color(0xFFEFF6FF),
          keyboardType: TextInputType.url,
        ),
        _SocialRow(
          label: "Instagram",
          ctrl: controller.instagramCtrl,
          hint: "instagram.com/yourhandle",
          iconPainter: _InstagramPainter(),
          iconBg: const Color(0xFFFDF2F8),
          keyboardType: TextInputType.url,
        ),
        _SocialRow(
          label: "Website",
          ctrl: controller.websiteCtrl,
          hint: "https://yourwebsite.com",
          iconPainter: _WebsitePainter(),
          iconBg: const Color(0xFFF0FDF4),
          keyboardType: TextInputType.url,
          isLast: true,
        ),
      ],
    );
  }

  // ── Save Button ───────────────────────────────────────────────────────────
  Widget _saveButton() => Obx(() => SizedBox(
    width: double.infinity,
    height: 54,
    child: ElevatedButton(
      onPressed: controller.isUpdating.value
          ? null : () => controller.updateMerchant(),
      style: ElevatedButton.styleFrom(
        backgroundColor: _C.primary,
        disabledBackgroundColor: _C.textMuted,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: controller.isUpdating.value
          ? const SizedBox(
        width: 20, height: 20,
        child: CircularProgressIndicator(
          color: Colors.white, strokeWidth: 2.5,
        ),
      )
          : const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_rounded, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            "Save Changes",
            style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700,
              color: Colors.white, letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    ),
  ));

  Future<void> _pickShopLocation() async {
    final result = await Get.to(() => ShopMapPicker(
      initialLat: controller.latitude.value,
      initialLng: controller.longitude.value,
      initialAddress: controller.pickedLocation.value,
    ));
    if (result != null) {
      controller.updateLocation(result["lat"], result["lng"], result["address"]);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Reusable Widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps rows in a grouped card
class _CardGroup extends StatelessWidget {
  final List<Widget> children;
  const _CardGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

/// Editable text row inside a card group
class _EditableRow extends StatefulWidget {
  final String label;
  final TextEditingController ctrl;
  final Widget iconWidget;
  final TextInputType keyboardType;
  final bool isLast;

  const _EditableRow({
    required this.label,
    required this.ctrl,
    required this.iconWidget,
    this.keyboardType = TextInputType.text,
    this.isLast = false,
  });

  @override
  State<_EditableRow> createState() => _EditableRowState();
}

class _EditableRowState extends State<_EditableRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            color: _focused ? const Color(0xFFFAFCFC) : _C.surface,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 3, height: 58,
                  decoration: BoxDecoration(
                    color: _focused ? _C.primary : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13, right: 12),
                  child: AnimatedScale(
                    scale: _focused ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 160),
                    child: _focused
                        ? Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: _C.primary,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.edit, size: 15, color: Colors.white,
                      ),
                    )
                        : widget.iconWidget,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.ctrl,
                    keyboardType: widget.keyboardType,
                    style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500,
                      color: _C.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.label,
                      labelStyle: const TextStyle(
                        fontSize: 11, color: _C.textMuted, fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 15,
                    color: _focused ? _C.primary : _C.border,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!widget.isLast)
          const Divider(height: 1, thickness: 1, color: _C.divider, indent: 62),
      ],
    );
  }
}

/// Read-only locked row (email)
class _LockedRow extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final Widget iconWidget;

  const _LockedRow({
    required this.label,
    required this.ctrl,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: _C.locked,
          child: Row(
            children: [
              const SizedBox(width: 3),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 12),
                child: iconWidget,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11, color: _C.textMuted, fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      ctrl.text.isNotEmpty ? ctrl.text : "—",
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500,
                        color: _C.lockedText,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _C.lockedBorder),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          size: 10, color: _C.textMuted),
                      SizedBox(width: 3),
                      Text(
                        "Locked",
                        style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600,
                          color: _C.textMuted, letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: _C.divider, indent: 62),
      ],
    );
  }
}

/// Social row with real SVG icon and editable text
class _SocialRow extends StatefulWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;
  final CustomPainter iconPainter;
  final Color iconBg;
  final TextInputType keyboardType;
  final bool isLast;

  const _SocialRow({
    required this.label,
    required this.ctrl,
    required this.hint,
    required this.iconPainter,
    required this.iconBg,
    this.keyboardType = TextInputType.url,
    this.isLast = false,
  });

  @override
  State<_SocialRow> createState() => _SocialRowState();
}

class _SocialRowState extends State<_SocialRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            color: _focused ? const Color(0xFFFAFCFC) : _C.surface,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 3, height: 60,
                  decoration: BoxDecoration(
                    color: _focused ? _C.primary : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13, right: 12),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _focused ? _C.primaryUltra : widget.iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomPaint(
                      painter: widget.iconPainter,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.ctrl,
                    keyboardType: widget.keyboardType,
                    style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500,
                      color: _C.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.label,
                      hintText: widget.hint,
                      labelStyle: const TextStyle(
                        fontSize: 11, color: _C.textMuted, fontWeight: FontWeight.w500,
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 12, color: _C.textMuted,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 15,
                    color: _focused ? _C.primary : _C.border,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!widget.isLast)
          const Divider(height: 1, thickness: 1, color: _C.divider, indent: 62),
      ],
    );
  }
}

/// Dropdown row
class _DropdownRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Widget iconWidget;
  final bool isLoading;
  final bool isLast;

  const _DropdownRow({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.iconWidget,
    this.isLoading = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            const SizedBox(
              width: 14, height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: _C.primary),
            ),
            const SizedBox(width: 12),
            Text(
              "Loading $label…",
              style: const TextStyle(fontSize: 13, color: _C.textMuted),
            ),
          ],
        ),
      );
    }
    if (items.isEmpty) return const SizedBox();
    return Column(
      children: [
        Container(
          color: _C.surface,
          child: Row(
            children: [
              const SizedBox(width: 3),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 12),
                child: iconWidget,
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: value,
                  style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500,
                    color: _C.textPrimary,
                  ),
                  dropdownColor: _C.surface,
                  icon: const Icon(Icons.unfold_more_rounded,
                      size: 16, color: _C.textMuted),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: const TextStyle(
                      fontSize: 11, color: _C.textMuted, fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  items: items
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, thickness: 1, color: _C.divider, indent: 62),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Map Decorative Widget
// ─────────────────────────────────────────────────────────────────────────────
class _MapPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFCDE8E2), Color(0xFFB0D9D0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          CustomPaint(
            size: const Size(double.infinity, 128),
            painter: _MapGridPainter(),
          ),
          CustomPaint(
            size: const Size(double.infinity, 128),
            painter: _RoadPainter(),
          ),
          Center(
            child: Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _C.primary.withOpacity(0.06),
                border: Border.all(
                  color: _C.primary.withOpacity(0.2), width: 1.5,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _C.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: _C.primary.withOpacity(0.4),
                        blurRadius: 8, offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: -0.785398,
                    child: const Icon(
                      Icons.location_on, color: Colors.white, size: 17,
                    ),
                  ),
                ),
                Container(
                  width: 10, height: 4,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF0A6E5C).withOpacity(0.06)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 26) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 26) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r1 = Paint()
      ..color = Colors.white.withOpacity(0.65)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.52)
        ..cubicTo(
          size.width * 0.25, size.height * 0.42,
          size.width * 0.75, size.height * 0.60,
          size.width, size.height * 0.50,
        ),
      r1,
    );
    final r2 = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.38, 0)
        ..cubicTo(
          size.width * 0.39, size.height * 0.5,
          size.width * 0.39, size.height * 0.5,
          size.width * 0.40, size.height,
        ),
      r2,
    );
  }
  @override bool shouldRepaint(_) => false;
}

class _BannerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 0; i < 5; i++) {
      final r = 30.0 + i * 22;
      canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.3), r, p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  SVG-style Icon Painters (brand accurate paths)
// ─────────────────────────────────────────────────────────────────────────────

/// WhatsApp logo painter
class _WhatsAppPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF16A34A)
      ..style = PaintingStyle.fill;

    final s = size.width / 24;
    final path = Path();
    // Outer circle body
    path.addOval(Rect.fromCenter(
      center: Offset(12 * s, 12 * s), width: 20 * s, height: 20 * s,
    ));
    canvas.drawPath(path, paint);

    // White phone shape inside
    final phonePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final wp = Path();
    wp.moveTo(16.75 * s, 14.39 * s);
    wp.cubicTo(16.50 * s, 14.27 * s, 15.26 * s, 13.67 * s, 15.04 * s, 13.59 * s);
    wp.cubicTo(14.82 * s, 13.51 * s, 14.66 * s, 13.47 * s, 14.50 * s, 13.72 * s);
    wp.cubicTo(14.34 * s, 13.97 * s, 13.86 * s, 14.53 * s, 13.72 * s, 14.70 * s);
    wp.cubicTo(13.58 * s, 14.87 * s, 13.44 * s, 14.89 * s, 13.19 * s, 14.77 * s);
    wp.cubicTo(12.94 * s, 14.65 * s, 12.13 * s, 14.38 * s, 11.17 * s, 13.53 * s);
    wp.cubicTo(10.42 * s, 12.86 * s, 9.92 * s, 12.03 * s, 9.78 * s, 11.78 * s);
    wp.cubicTo(9.64 * s, 11.53 * s, 9.77 * s, 11.40 * s, 9.89 * s, 11.28 * s);
    wp.cubicTo(10.00 * s, 11.17 * s, 10.14 * s, 10.99 * s, 10.26 * s, 10.85 * s);
    wp.cubicTo(10.38 * s, 10.71 * s, 10.42 * s, 10.61 * s, 10.50 * s, 10.45 * s);
    wp.cubicTo(10.58 * s, 10.29 * s, 10.54 * s, 10.15 * s, 10.48 * s, 10.03 * s);
    wp.cubicTo(10.42 * s, 9.91 * s, 9.94 * s, 8.72 * s, 9.74 * s, 8.26 * s);
    wp.cubicTo(9.55 * s, 7.81 * s, 9.35 * s, 7.87 * s, 9.20 * s, 7.86 * s);
    wp.cubicTo(9.06 * s, 7.85 * s, 8.90 * s, 7.85 * s, 8.74 * s, 7.85 * s);
    wp.cubicTo(8.58 * s, 7.85 * s, 8.31 * s, 7.91 * s, 8.09 * s, 8.16 * s);
    wp.cubicTo(7.87 * s, 8.41 * s, 7.25 * s, 8.99 * s, 7.25 * s, 10.19 * s);
    wp.cubicTo(7.25 * s, 11.39 * s, 8.11 * s, 12.55 * s, 8.23 * s, 12.71 * s);
    wp.cubicTo(8.35 * s, 12.87 * s, 9.92 * s, 15.27 * s, 12.33 * s, 16.32 * s);
    wp.cubicTo(13.02 * s, 16.62 * s, 13.56 * s, 16.78 * s, 13.99 * s, 16.90 * s);
    wp.cubicTo(14.67 * s, 17.09 * s, 15.29 * s, 17.07 * s, 15.78 * s, 17.00 * s);
    wp.cubicTo(16.33 * s, 16.92 * s, 17.50 * s, 16.39 * s, 17.72 * s, 15.81 * s);
    wp.cubicTo(17.94 * s, 15.23 * s, 17.94 * s, 14.73 * s, 17.87 * s, 14.62 * s);
    wp.cubicTo(17.80 * s, 14.51 * s, 17.00 * s, 14.51 * s, 16.75 * s, 14.39 * s);
    wp.close();
    canvas.drawPath(wp, phonePaint);
  }
  @override bool shouldRepaint(_) => false;
}

/// Facebook "f" painter
class _FacebookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF1877F2)
      ..style = PaintingStyle.fill;
    final s = size.width;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.08, s * 0.08, s * 0.84, s * 0.84),
        Radius.circular(s * 0.22),
      ),
      bg,
    );
    final f = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    // Draw "f" letterform
    final fPath = Path();
    fPath.moveTo(s * 0.615, s * 0.25);
    fPath.lineTo(s * 0.52, s * 0.25);
    fPath.cubicTo(s * 0.47, s * 0.25, s * 0.46, s * 0.27, s * 0.46, s * 0.32);
    fPath.lineTo(s * 0.46, s * 0.40);
    fPath.lineTo(s * 0.62, s * 0.40);
    fPath.lineTo(s * 0.595, s * 0.525);
    fPath.lineTo(s * 0.46, s * 0.525);
    fPath.lineTo(s * 0.46, s * 0.80);
    fPath.lineTo(s * 0.34, s * 0.80);
    fPath.lineTo(s * 0.34, s * 0.525);
    fPath.lineTo(s * 0.26, s * 0.525);
    fPath.lineTo(s * 0.26, s * 0.40);
    fPath.lineTo(s * 0.34, s * 0.40);
    fPath.lineTo(s * 0.34, s * 0.31);
    fPath.cubicTo(s * 0.34, s * 0.19, s * 0.41, s * 0.13, s * 0.54, s * 0.13);
    fPath.lineTo(s * 0.615, s * 0.13);
    fPath.close();
    canvas.drawPath(fPath, f);
  }
  @override bool shouldRepaint(_) => false;
}

/// Instagram gradient camera painter
class _InstagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final rect = Rect.fromLTWH(s * 0.08, s * 0.08, s * 0.84, s * 0.84);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(s * 0.22));

    final gradient = LinearGradient(
      colors: const [
        Color(0xFFF9CE34), Color(0xFFEE2A7B), Color(0xFF6228D7),
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
    canvas.drawRRect(rrect, Paint()..shader = gradient.createShader(rect));

    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.065;

    // Outer rounded rect
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(s / 2, s / 2),
            width: s * 0.52, height: s * 0.52),
        Radius.circular(s * 0.14),
      ),
      white,
    );
    // Circle
    canvas.drawCircle(Offset(s / 2, s / 2), s * 0.155, white);
    // Dot
    final dot = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(s * 0.64, s * 0.36), s * 0.055, dot);
  }
  @override bool shouldRepaint(_) => false;
}

/// Website globe painter
class _WebsitePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2, cy = s / 2, r = s * 0.34;

    final bg = Paint()
      ..color = const Color(0xFF059669)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), s * 0.44, bg);

    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.055;

    // Globe outline
    canvas.drawCircle(Offset(cx, cy), r, p);
    // Horizontal equator
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), p);
    // Vertical axis
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), p);
    // Ellipses
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 0.9, height: r * 2),
      p,
    );
  }
  @override bool shouldRepaint(_) => false;
}



