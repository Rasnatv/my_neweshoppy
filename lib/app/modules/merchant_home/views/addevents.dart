//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../controller/addevent_controller.dart';
//
// class AddEventPage extends StatelessWidget {
//   AddEventPage({super.key});
//   final AddEventController controller = Get.put(AddEventController());
//
//   static const Color _teal          = Color(0xFF00897B);
//   static const Color _bg            = Color(0xFFF5F6FA);
//   static const Color _card          = Colors.white;
//   static const Color _textPrimary   = Color(0xFF1C1C1E);
//   static const Color _textSecondary = Color(0xFF6B7280);
//   static const Color _border        = Color(0xFFE5E7EB);
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _bg,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: _teal,
//           surfaceTintColor: Colors.transparent,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
//             onPressed: () => Get.back(),
//           ),
//           title: const Text(
//             "Add Event",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.2,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Stack(
//           children: [
//             SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   // ── Event Details Card ──────────────────────────
//                   _sectionCard(
//                     title: "EVENT DETAILS",
//                     icon: Icons.info_outline_rounded,
//                     children: [
//                       _fieldLabel("Event Name"),
//                       const SizedBox(height: 6),
//                       _inputField(
//                         controller: controller.eventName,
//                         hint: "e.g. Annual Tech Summit",
//                         icon: Icons.title_rounded,
//                       ),
//                       const SizedBox(height: 16),
//                       _fieldLabel("Event Location"),
//                       const SizedBox(height: 6),
//                       _inputField(
//                         controller: controller.eventLocation,
//                         hint: "e.g. City Convention Hall",
//                         icon: Icons.place_outlined,
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   // ── Area / District Card ────────────────────────
//                   _sectionCard(
//                     title: "EVENT COVERAGE",
//                     icon: Icons.map_outlined,
//                     children: [_buildAreaDistrictSection()],
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   // ── Schedule Card ───────────────────────────────
//                   _sectionCard(
//                     title: "SCHEDULE",
//                     icon: Icons.calendar_month_outlined,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Obx(() => GestureDetector(
//                               onTap: () => controller.pickDate(context),
//                               child: _pickerTile(
//                                 label: "Start Date",
//                                 value: controller.eventDate.value,
//                                 icon: Icons.calendar_today_rounded,
//                               ),
//                             )),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Obx(() => GestureDetector(
//                               onTap: () => controller.pickEndDate(context),
//                               child: _pickerTile(
//                                 label: "End Date",
//                                 value: controller.eventEndDate.value,
//                                 icon: Icons.event_rounded,
//                               ),
//                             )),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Obx(() => GestureDetector(
//                               onTap: () => controller.pickStartTime(context),
//                               child: _pickerTile(
//                                 label: "Start Time",
//                                 value: controller.eventStartTime.value,
//                                 icon: Icons.access_time_rounded,
//                               ),
//                             )),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Obx(() => GestureDetector(
//                               onTap: () => controller.pickEndTime(context),
//                               child: _pickerTile(
//                                 label: "End Time",
//                                 value: controller.eventEndTime.value,
//                                 icon: Icons.access_time_filled_rounded,
//                               ),
//                             )),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   // ── Banner Card ─────────────────────────────────
//                   _sectionCard(
//                     title: "EVENT BANNER",
//                     icon: Icons.image_outlined,
//                     children: [_buildBanner()],
//                   ),
//                 ],
//               ),
//             ),
//
//             // ── Sticky Submit ───────────────────────────────────
//             Positioned(
//               bottom: 0, left: 0, right: 0,
//               child: _buildSubmitButton(),
//             ),
//
//             // ── Loading Overlay ─────────────────────────────────
//             Obx(() => controller.isLoading.value
//                 ? Container(
//               color: Colors.black45,
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 32, vertical: 28),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: const Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircularProgressIndicator(
//                           color: _teal, strokeWidth: 2.5),
//                       SizedBox(height: 16),
//                       Text(
//                         "Creating event…",
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: _textSecondary),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//                 : const SizedBox.shrink()),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   // Widget _buildAreaDistrictSection() {
//   //   return Obx(() {
//   //     final isArea     = controller.showMode.value == "area";
//   //     final isDistrict = controller.showMode.value == "district";
//   //
//   //     return Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //
//   //         // ── Toggle Tabs ──────────────────────────────────
//   //         Container(
//   //           decoration: BoxDecoration(
//   //             color: _bg,
//   //             borderRadius: BorderRadius.circular(10),
//   //             border: Border.all(color: _border),
//   //           ),
//   //           child: Row(
//   //             children: [
//   //               _modeTab(
//   //                 label: "Area Wise",
//   //                 icon: Icons.grid_view_rounded,
//   //                 selected: isArea,
//   //                 onTap: () {
//   //                   controller.showMode.value = "area";
//   //                   controller.selectedDistrict.value = null;
//   //                   controller.selectedLocation.value = null;
//   //                 },
//   //               ),
//   //               _modeTab(
//   //                 label: "District Wise",
//   //                 icon: Icons.location_city_rounded,
//   //                 selected: isDistrict,
//   //                 onTap: () {
//   //                   controller.showMode.value = "district";
//   //                   controller.selectedArea.value = null;
//   //                 },
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //
//   //         const SizedBox(height: 14),
//   //
//   //         // ── STATE DROPDOWN (shown in BOTH modes) ─────────
//   //         _fieldLabel("Select State"),
//   //         const SizedBox(height: 8),
//   //         Obx(() {
//   //           if (controller.isLoadingStates.value) {
//   //             return _loadingDropdown("Loading states…");
//   //           }
//   //           if (controller.stateList.isEmpty) {
//   //             return _emptyState("No states available");
//   //           }
//   //           return _dropdownField(
//   //             value: controller.selectedState.value,
//   //             hint: "Choose a state",
//   //             icon: Icons.flag_outlined,
//   //             items: controller.stateList,
//   //             onChanged: (val) => controller.selectedState.value = val,
//   //           );
//   //         }),
//   //
//   //         const SizedBox(height: 14),
//   //
//   //         // ── AREA MODE ────────────────────────────────────
//   //         if (isArea) ...[
//   //           _fieldLabel("Select Area"),
//   //           const SizedBox(height: 8),
//   //           Obx(() {
//   //             if (controller.isLoadingAreas.value) {
//   //               return _loadingDropdown("Loading areas…");
//   //             }
//   //             if (controller.areaList.isEmpty) {
//   //               return _emptyState("No areas available");
//   //             }
//   //             return _dropdownField(
//   //               value: controller.selectedArea.value,
//   //               hint: "Choose an area",
//   //               icon: Icons.grid_view_rounded,
//   //               items: controller.areaList,
//   //               onChanged: (val) => controller.selectedArea.value = val,
//   //             );
//   //           }),
//   //           const SizedBox(height: 10),
//   //         ],
//   //
//   //         // ── DISTRICT MODE ────────────────────────────────
//   //         if (isDistrict) ...[
//   //           // District dropdown
//   //           _fieldLabel("Select District"),
//   //           const SizedBox(height: 8),
//   //           Obx(() {
//   //             if (controller.isLoadingDistricts.value) {
//   //               return _loadingDropdown("Loading districts…");
//   //             }
//   //             if (controller.districtList.isEmpty) {
//   //               return _emptyState("No districts available");
//   //             }
//   //             return _dropdownField(
//   //               value: controller.selectedDistrict.value,
//   //               hint: "Choose a district",
//   //               icon: Icons.location_city_rounded,
//   //               items: controller.districtList,
//   //               onChanged: (val) => controller.selectedDistrict.value = val,
//   //             );
//   //           }),
//   //
//   //           const SizedBox(height: 14),
//   //
//   //           // Location dropdown (uses area list as source)
//   //           _fieldLabel("Select Location"),
//   //           const SizedBox(height: 8),
//   //           Obx(() {
//   //             if (controller.isLoadingAreas.value) {
//   //               return _loadingDropdown("Loading locations…");
//   //             }
//   //             if (controller.areaList.isEmpty) {
//   //               return _emptyState("No locations available");
//   //             }
//   //             return _dropdownField(
//   //               value: controller.selectedLocation.value,
//   //               hint: "Choose a location",
//   //               icon: Icons.place_outlined,
//   //               items: controller.areaList,
//   //               onChanged: (val) => controller.selectedLocation.value = val,
//   //             );
//   //           }),
//   //           const SizedBox(height: 10),
//   //         ],
//   //       ],
//   //     );
//   //   });
//   // }
//   Widget _buildAreaDistrictSection() {
//     return Obx(() {
//       final isArea     = controller.showMode.value == "area";
//       final isDistrict = controller.showMode.value == "district";
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           // ── Toggle Tabs ──────────────────────────────────
//           Container(
//             decoration: BoxDecoration(
//               color: _bg,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: _border),
//             ),
//             child: Row(
//               children: [
//                 _modeTab(
//                   label: "Area Wise",
//                   icon: Icons.grid_view_rounded,
//                   selected: isArea,
//                   onTap: () {
//                     controller.showMode.value = "area";
//                     controller.selectedDistrict.value = null;
//                     controller.selectedLocation.value = null;
//                   },
//                 ),
//                 _modeTab(
//                   label: "District Wise",
//                   icon: Icons.location_city_rounded,
//                   selected: isDistrict,
//                   onTap: () {
//                     controller.showMode.value = "district";
//                     controller.selectedArea.value = null;
//                   },
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 14),
//
//           // ── STATE DROPDOWN (always first) ─────────────────
//           _fieldLabel("Select State"),
//           const SizedBox(height: 8),
//           Obx(() {
//             if (controller.isLoadingStates.value) {
//               return _loadingDropdown("Loading states…");
//             }
//             if (controller.stateList.isEmpty) {
//               return _emptyState("No states available");
//             }
//             return _dropdownField(
//               value: controller.selectedState.value,
//               hint: "Choose a state",
//               icon: Icons.flag_outlined,
//               items: controller.stateList,
//               onChanged: (val) => controller.selectedState.value = val,
//             );
//           }),
//
//           const SizedBox(height: 14),
//
//           // ── AREA MODE: State → Area (main_location) ───────
//           if (isArea) ...[
//             _fieldLabel("Select Area"),
//             const SizedBox(height: 8),
//             Obx(() {
//               if (controller.isLoadingAreas.value) {
//                 return _loadingDropdown("Loading areas…");
//               }
//               if (controller.areaList.isEmpty) {
//                 return _emptyState("No areas available");
//               }
//               return _dropdownField(
//                 value: controller.selectedArea.value,
//                 hint: "Choose an area",
//                 icon: Icons.grid_view_rounded,
//                 items: controller.areaList,
//                 onChanged: (val) => controller.selectedArea.value = val,
//               );
//             }),
//             const SizedBox(height: 10),
//           ],
//
//           // ── DISTRICT MODE: State → District → Main Location ──
//           if (isDistrict) ...[
//             _fieldLabel("Select District"),
//             const SizedBox(height: 8),
//             Obx(() {
//               if (controller.isLoadingDistricts.value) {
//                 return _loadingDropdown("Loading districts…");
//               }
//               if (controller.districtList.isEmpty) {
//                 return _emptyState("No districts available");
//               }
//               return _dropdownField(
//                 value: controller.selectedDistrict.value,
//                 hint: "Choose a district",
//                 icon: Icons.location_city_rounded,
//                 items: controller.districtList,
//                 onChanged: (val) => controller.selectedDistrict.value = val,
//               );
//             }),
//
//             const SizedBox(height: 14),
//
//             _fieldLabel("Select Main Location"),
//             const SizedBox(height: 8),
//             Obx(() {
//               if (controller.isLoadingAreas.value) {
//                 return _loadingDropdown("Loading locations…");
//               }
//               if (controller.areaList.isEmpty) {
//                 return _emptyState("No locations available");
//               }
//               return _dropdownField(
//                 value: controller.selectedLocation.value,
//                 hint: "Choose a location",
//                 icon: Icons.place_outlined,
//                 items: controller.areaList,
//                 onChanged: (val) => controller.selectedLocation.value = val,
//               );
//             }),
//             const SizedBox(height: 10),
//           ],
//
//         ],
//       );
//     });
//   }
//
//   // ── MODE TAB ──────────────────────────────────────────────
//   Widget _modeTab({
//     required String label,
//     required IconData icon,
//     required bool selected,
//     required VoidCallback onTap,
//   }) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           margin: const EdgeInsets.all(3),
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: selected ? _teal : Colors.transparent,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon,
//                   size: 14,
//                   color: selected ? Colors.white : _textSecondary),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: selected ? Colors.white : _textSecondary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── DROPDOWN FIELD ────────────────────────────────────────
//   Widget _dropdownField({
//     required String? value,
//     required String hint,
//     required IconData icon,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _bg,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: value != null ? _teal.withOpacity(0.45) : _border,
//           width: value != null ? 1.4 : 1,
//         ),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           isExpanded: true,
//           hint: Padding(
//             padding: const EdgeInsets.only(left: 12),
//             child: Row(
//               children: [
//                 Icon(icon, size: 16, color: _textSecondary),
//                 const SizedBox(width: 8),
//                 Text(hint,
//                     style: const TextStyle(
//                         fontSize: 14, color: _textSecondary)),
//               ],
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           borderRadius: BorderRadius.circular(10),
//           dropdownColor: Colors.white,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//               color: _textSecondary, size: 20),
//           items: items.map((item) {
//             return DropdownMenuItem<String>(
//               value: item,
//               child: Row(
//                 children: [
//                   Icon(icon, size: 15, color: _teal),
//                   const SizedBox(width: 8),
//                   Text(item,
//                       style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: _textPrimary)),
//                 ],
//               ),
//             );
//           }).toList(),
//           onChanged: onChanged,
//           selectedItemBuilder: (context) => items.map((item) {
//             return Row(
//               children: [
//                 Icon(icon, size: 16, color: _teal),
//                 const SizedBox(width: 8),
//                 Text(item,
//                     style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: _textPrimary)),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   // ── LOADING DROPDOWN PLACEHOLDER ─────────────────────────
//   Widget _loadingDropdown(String msg) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: _bg,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: _border),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(
//             width: 14,
//             height: 14,
//             child: CircularProgressIndicator(strokeWidth: 2, color: _teal),
//           ),
//           const SizedBox(width: 10),
//           Text(msg,
//               style: const TextStyle(fontSize: 13, color: _textSecondary)),
//         ],
//       ),
//     );
//   }
//
//   // ── EMPTY STATE ───────────────────────────────────────────
//   Widget _emptyState(String msg) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: _bg,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: _border),
//       ),
//       child: Center(
//         child: Text(msg,
//             style: const TextStyle(fontSize: 13, color: _textSecondary)),
//       ),
//     );
//   }
//
//   // ── SECTION CARD ──────────────────────────────────────────
//   Widget _sectionCard({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _border),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 14, color: _teal),
//               const SizedBox(width: 6),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   color: _teal,
//                   letterSpacing: 0.8,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Divider(color: _border, height: 20),
//           ...children,
//         ],
//       ),
//     );
//   }
//
//   // ── FIELD LABEL ───────────────────────────────────────────
//   Widget _fieldLabel(String text) => Text(
//     text,
//     style: const TextStyle(
//       fontSize: 13,
//       fontWeight: FontWeight.w500,
//       color: _textPrimary,
//     ),
//   );
//
//   // ── TEXT INPUT ────────────────────────────────────────────
//   Widget _inputField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//   }) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(
//           fontSize: 14, color: _textPrimary, fontWeight: FontWeight.w500),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(fontSize: 14, color: _textSecondary),
//         prefixIcon: Icon(icon, color: _textSecondary, size: 18),
//         contentPadding:
//         const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//         filled: true,
//         fillColor: _bg,
//         border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: _border)),
//         enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: _border)),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: _teal, width: 1.6)),
//       ),
//     );
//   }
//
//   // ── PICKER TILE ───────────────────────────────────────────
//   Widget _pickerTile({
//     required String label,
//     required String value,
//     required IconData icon,
//   }) {
//     final bool has = value.isNotEmpty;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       decoration: BoxDecoration(
//         color: _bg,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: has ? _teal.withOpacity(0.45) : _border,
//           width: has ? 1.4 : 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: has ? _teal : _textSecondary),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: _textSecondary,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   has ? value : "Select",
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: has ? _textPrimary : _textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Icon(Icons.chevron_right_rounded, size: 15, color: _textSecondary),
//         ],
//       ),
//     );
//   }
//
//   // ── BANNER ────────────────────────────────────────────────
//   Widget _buildBanner() {
//     return Obx(() => GestureDetector(
//       onTap: controller.pickBannerImage,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         height: 180,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: _bg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: controller.bannerImage.value != null
//                 ? _teal.withOpacity(0.45)
//                 : _border,
//             width: 1.4,
//           ),
//         ),
//         child: controller.bannerImage.value == null
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(13),
//               decoration: BoxDecoration(
//                 color: _teal.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.add_photo_alternate_outlined,
//                   color: _teal, size: 26),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Tap to upload banner",
//               style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: _textPrimary),
//             ),
//             const SizedBox(height: 3),
//             const Text(
//               "Recommended: 1280 × 720px",
//               style:
//               TextStyle(fontSize: 11, color: _textSecondary),
//             ),
//           ],
//         )
//             : Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(9),
//               child: Image.file(
//                 controller.bannerImage.value!,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             ),
//             Positioned(
//               top: 8,
//               right: 8,
//               child: GestureDetector(
//                 onTap: controller.removeBannerImage,
//                 child: Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.12),
//                         blurRadius: 6,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(Icons.close_rounded,
//                       size: 14, color: Colors.red),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 8,
//               left: 8,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 6,
//                     ),
//                   ],
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.check_circle_rounded,
//                         size: 12, color: _teal),
//                     SizedBox(width: 4),
//                     Text(
//                       "Banner selected",
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                         color: _textPrimary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
//
//   // ── SUBMIT BUTTON ─────────────────────────────────────────
//   Widget _buildSubmitButton() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: const Border(top: BorderSide(color: _border)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Obx(() => SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: ElevatedButton(
//             onPressed: controller.isLoading.value
//                 ? null
//                 : controller.saveEvent,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _teal,
//               foregroundColor: Colors.white,
//               disabledBackgroundColor: _border,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               "Create Event",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.3,
//               ),
//             ),
//           ),
//         )),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/addevent_controller.dart';

class AddEventPage extends StatelessWidget {
  AddEventPage({super.key});
  final AddEventController controller = Get.put(AddEventController());

  static const Color _teal          = Color(0xFF00897B);
  static const Color _bg            = Color(0xFFF5F6FA);
  static const Color _card          = Colors.white;
  static const Color _textPrimary   = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _border        = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: _teal,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "Add Event",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Event Details Card ──────────────────────────
                  _sectionCard(
                    title: "EVENT DETAILS",
                    icon: Icons.info_outline_rounded,
                    children: [
                      _fieldLabel("Event Name"),
                      const SizedBox(height: 6),
                      _inputField(
                        controller: controller.eventName,
                        hint: "e.g. Annual Tech Summit",
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: 16),
                      _fieldLabel("Event Location"),
                      const SizedBox(height: 6),
                      _inputField(
                        controller: controller.eventLocation,
                        hint: "e.g. City Convention Hall",
                        icon: Icons.place_outlined,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Area / District Card ────────────────────────
                  _sectionCard(
                    title: "EVENT COVERAGE",
                    icon: Icons.map_outlined,
                    children: [_buildAreaDistrictSection()],
                  ),

                  const SizedBox(height: 14),

                  // ── Schedule Card ───────────────────────────────
                  _sectionCard(
                    title: "SCHEDULE",
                    icon: Icons.calendar_month_outlined,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => GestureDetector(
                              onTap: () => controller.pickDate(context),
                              child: _pickerTile(
                                label: "Start Date",
                                value: controller.eventDate.value,
                                icon: Icons.calendar_today_rounded,
                              ),
                            )),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() => GestureDetector(
                              onTap: () => controller.pickEndDate(context),
                              child: _pickerTile(
                                label: "End Date",
                                value: controller.eventEndDate.value,
                                icon: Icons.event_rounded,
                              ),
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => GestureDetector(
                              onTap: () => controller.pickStartTime(context),
                              child: _pickerTile(
                                label: "Start Time",
                                value: controller.eventStartTime.value,
                                icon: Icons.access_time_rounded,
                              ),
                            )),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() => GestureDetector(
                              onTap: () => controller.pickEndTime(context),
                              child: _pickerTile(
                                label: "End Time",
                                value: controller.eventEndTime.value,
                                icon: Icons.access_time_filled_rounded,
                              ),
                            )),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Banner Card ─────────────────────────────────
                  _sectionCard(
                    title: "EVENT BANNER",
                    icon: Icons.image_outlined,
                    children: [_buildBanner()],
                  ),
                ],
              ),
            ),

            // ── Sticky Submit ───────────────────────────────────
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildSubmitButton(),
            ),

            // ── Loading Overlay ─────────────────────────────────
            Obx(() => controller.isLoading.value
                ? Container(
              color: Colors.black45,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                          color: _teal, strokeWidth: 2.5),
                      SizedBox(height: 16),
                      Text(
                        "Creating event…",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  // ── AREA / DISTRICT SECTION ───────────────────────────────
  Widget _buildAreaDistrictSection() {
    return Obx(() {
      final isArea = controller.showMode.value == "area";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Toggle Tabs ────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                _modeTab(
                  label: "District Wise",
                  icon: Icons.location_city_rounded,
                  selected: !isArea,
                  onTap: () {
                    controller.showMode.value = "district";
                    controller.selectedArea.value = null;
                  },
                ),
                _modeTab(
                  label: "Area Wise",
                  icon: Icons.grid_view_rounded,
                  selected: isArea,
                  onTap: () {
                    controller.showMode.value = "area";
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── STATE (always shown) ───────────────────────────
          _fieldLabel("Select State"),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isLoadingStates.value) {
              return _loadingDropdown("Loading states…");
            }
            if (controller.stateList.isEmpty) {
              return _emptyState("No states available");
            }
            return _dropdownField(
              value: controller.selectedState.value,
              hint: "Choose a state",
              icon: Icons.flag_outlined,
              items: controller.stateList,
              onChanged: (val) => controller.selectedState.value = val,
            );
          }),

          const SizedBox(height: 14),

          // ── DISTRICT (always shown in both modes) ──────────
          _fieldLabel("Select District"),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isLoadingDistricts.value) {
              return _loadingDropdown("Loading districts…");
            }
            if (controller.districtList.isEmpty) {
              return _emptyState("No districts available");
            }
            return _dropdownField(
              value: controller.selectedDistrict.value,
              hint: "Choose a district",
              icon: Icons.location_city_rounded,
              items: controller.districtList,
              onChanged: (val) => controller.selectedDistrict.value = val,
            );
          }),

          // ── AREA (only in Area Wise mode) ──────────────────
          if (isArea) ...[
            const SizedBox(height: 14),
            _fieldLabel("Select Area"),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoadingAreas.value) {
                return _loadingDropdown("Loading areas…");
              }
              if (controller.areaList.isEmpty) {
                return _emptyState("No areas available");
              }
              return _dropdownField(
                value: controller.selectedArea.value,
                hint: "Choose an area",
                icon: Icons.grid_view_rounded,
                items: controller.areaList,
                onChanged: (val) => controller.selectedArea.value = val,
              );
            }),
          ],

          const SizedBox(height: 10),
        ],
      );
    });
  }

  // ── MODE TAB ──────────────────────────────────────────────
  Widget _modeTab({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _teal : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: selected ? Colors.white : _textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : _textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── DROPDOWN FIELD ────────────────────────────────────────
  Widget _dropdownField({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value != null ? _teal.withOpacity(0.45) : _border,
          width: value != null ? 1.4 : 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Icon(icon, size: 16, color: _textSecondary),
                const SizedBox(width: 8),
                Text(hint,
                    style: const TextStyle(
                        fontSize: 14, color: _textSecondary)),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.circular(10),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: _textSecondary, size: 20),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 15, color: _teal),
                  const SizedBox(width: 8),
                  Text(item,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: (context) => items.map((item) {
            return Row(
              children: [
                Icon(icon, size: 16, color: _teal),
                const SizedBox(width: 8),
                Text(item,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── LOADING DROPDOWN PLACEHOLDER ─────────────────────────
  Widget _loadingDropdown(String msg) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: _teal),
          ),
          const SizedBox(width: 10),
          Text(msg,
              style: const TextStyle(fontSize: 13, color: _textSecondary)),
        ],
      ),
    );
  }

  // ── EMPTY STATE ───────────────────────────────────────────
  Widget _emptyState(String msg) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Center(
        child: Text(msg,
            style: const TextStyle(fontSize: 13, color: _textSecondary)),
      ),
    );
  }

  // ── SECTION CARD ──────────────────────────────────────────
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: _teal),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _teal,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Divider(color: _border, height: 20),
          ...children,
        ],
      ),
    );
  }

  // ── FIELD LABEL ───────────────────────────────────────────
  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: _textPrimary,
    ),
  );

  // ── TEXT INPUT ────────────────────────────────────────────
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
          fontSize: 14, color: _textPrimary, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: _textSecondary),
        prefixIcon: Icon(icon, color: _textSecondary, size: 18),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        filled: true,
        fillColor: _bg,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _teal, width: 1.6)),
      ),
    );
  }

  // ── PICKER TILE ───────────────────────────────────────────
  Widget _pickerTile({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final bool has = value.isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: has ? _teal.withOpacity(0.45) : _border,
          width: has ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: has ? _teal : _textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  has ? value : "Select",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: has ? _textPrimary : _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 15, color: _textSecondary),
        ],
      ),
    );
  }

  // ── BANNER ────────────────────────────────────────────────
  Widget _buildBanner() {
    return Obx(() => GestureDetector(
      onTap: controller.pickBannerImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: controller.bannerImage.value != null
                ? _teal.withOpacity(0.45)
                : _border,
            width: 1.4,
          ),
        ),
        child: controller.bannerImage.value == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _teal.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_photo_alternate_outlined,
                  color: _teal, size: 26),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap to upload banner",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary),
            ),
            const SizedBox(height: 3),
            const Text(
              "Recommended: 1280 × 720px",
              style: TextStyle(fontSize: 11, color: _textSecondary),
            ),
          ],
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.file(
                controller.bannerImage.value!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: controller.removeBannerImage,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 14, color: Colors.red),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 12, color: _teal),
                    SizedBox(width: 4),
                    Text(
                      "Banner selected",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // ── SUBMIT BUTTON ─────────────────────────────────────────
  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() => SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.saveEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _border,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Create Event",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        )),
      ),
    );
  }
}