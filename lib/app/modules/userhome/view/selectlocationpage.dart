//
// import 'package:eshoppy/app/common/style/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../common/style/app_text_style.dart';
// import '../controller/district _controller.dart';
//
//
// class SelectLocationPage extends StatelessWidget {
//   SelectLocationPage({super.key});
//
//   final controller = Get.find<UserLocationController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: AppColors.kPrimary,
//         title:  Text(
//           "Select Location",style:AppTextStyle.rTextNunitoWhite16w600),
//
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             height: 1,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.grey.shade200,
//                   Colors.grey.shade100,
//                   Colors.grey.shade200,
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return _buildLoadingState();
//         }
//         return _buildMainContent(context);
//       }),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TweenAnimationBuilder(
//             tween: Tween<double>(begin: 0, end: 1),
//             duration: const Duration(milliseconds: 800),
//             builder: (context, double value, child) {
//               return Transform.scale(
//                 scale: value,
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.kPrimary,
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: const CircularProgressIndicator(
//                     strokeWidth: 3,
//                     valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF009688)),
//                   ),
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             "Loading locations...",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF666666),
//               letterSpacing: 0.2,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Please wait a moment",
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMainContent(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeaderCard(),
//                 const SizedBox(height: 32),
//                 _buildProgressIndicator(),
//                 const SizedBox(height: 32),
//                 _buildStateSelection(),
//                 const SizedBox(height: 24),
//                 _buildDistrictSelection(),
//                 const SizedBox(height: 24),
//                 _buildAreaSelection(),
//                 const SizedBox(height: 28),
//                 _buildLocationPreview(),
//                 const SizedBox(height: 100), // Space for bottom button
//               ],
//             ),
//           ),
//         ),
//         _buildBottomButton(),
//       ],
//     );
//   }
//
//   Widget _buildHeaderCard() {
//     return TweenAnimationBuilder(
//       tween: Tween<double>(begin: 0, end: 1),
//       duration: const Duration(milliseconds: 600),
//       curve: Curves.easeOutCubic,
//       builder: (context, double value, child) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(0, 20 * (1 - value)),
//             child: child,
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//
//              color:  AppColors.kPrimary,
//
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF009688).withOpacity(0.3),
//               blurRadius: 20,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: const Icon(
//                 Icons.location_on_rounded,
//                 size: 32,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(width: 18),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Choose Your Location",
//                     style: TextStyle(
//                       fontSize: 19,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     "Select state, district and area to continue",
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.white.withOpacity(0.9),
//                       height: 1.3,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProgressIndicator() {
//     final selectedState = controller.selectedState.value.isNotEmpty;
//     final selectedDistrict = controller.selectedDistrict.value.isNotEmpty;
//     final selectedArea = controller.selectedMainLocation.value.isNotEmpty;
//
//     int completedSteps = 0;
//     if (selectedState) completedSteps++;
//     if (selectedDistrict) completedSteps++;
//     if (selectedArea) completedSteps++;
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Selection Progress",
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1A1A1A),
//                 ),
//               ),
//               Text(
//                 "$completedSteps/3 Completed",
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: const Color(0xFF009688),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: LinearProgressIndicator(
//               value: completedSteps / 3,
//               minHeight: 8,
//               backgroundColor: Colors.grey[200],
//               valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF33AE8C)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStateSelection() {
//     return _buildAnimatedSection(
//       delay: 200,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionLabel(
//             "State",
//             1,
//             controller.selectedState.value.isNotEmpty,
//           ),
//           const SizedBox(height: 12),
//           _buildDropdownField(
//             value: controller.selectedState.value.isEmpty
//                 ? null
//                 : controller.selectedState.value,
//             hint: "Select your state",
//             icon: Icons.map_rounded,
//             items: controller.states,
//             onChanged: (v) {
//               if (v != null) controller.onStateSelected(v);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDistrictSelection() {
//     return _buildAnimatedSection(
//       delay: 300,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionLabel(
//             "District",
//             2,
//             controller.selectedDistrict.value.isNotEmpty,
//           ),
//           const SizedBox(height: 12),
//           _buildDropdownField(
//             value: controller.selectedDistrict.value.isEmpty
//                 ? null
//                 : controller.selectedDistrict.value,
//             hint: "Select your district",
//             icon: Icons.location_city_rounded,
//             items: controller.districts,
//             enabled: controller.districts.isNotEmpty,
//             onChanged: controller.districts.isEmpty
//                 ? null
//                 : (v) {
//               if (v != null) controller.onDistrictSelected(v);
//             },
//           ),
//           if (controller.selectedState.value.isNotEmpty &&
//               controller.districts.isEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 8, left: 4),
//               child: Text(
//                 "Please select a state first",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.orange[700],
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAreaSelection() {
//     return _buildAnimatedSection(
//       delay: 400,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionLabel(
//             "Area",
//             3,
//             controller.selectedMainLocation.value.isNotEmpty,
//           ),
//           const SizedBox(height: 12),
//           _buildDropdownField(
//             value: controller.selectedMainLocation.value.isEmpty
//                 ? null
//                 : controller.selectedMainLocation.value,
//             hint: "Select your area",
//             icon: Icons.place_rounded,
//             items: controller.mainLocations,
//             enabled: controller.mainLocations.isNotEmpty,
//             onChanged: controller.mainLocations.isEmpty
//                 ? null
//                 : (v) {
//               if (v != null) {
//                 controller.selectedMainLocation.value = v;
//               }
//             },
//           ),
//           if (controller.selectedDistrict.value.isNotEmpty &&
//               controller.mainLocations.isEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 8, left: 4),
//               child: Text(
//                 "Please select a district first",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.orange[700],
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocationPreview() {
//     return Obx(() {
//       if (controller.selectedMainLocation.value.isEmpty) {
//         return const SizedBox.shrink();
//       }
//
//       return _buildAnimatedSection(
//         delay: 500,
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 const Color(0xFF2E7D32).withOpacity(0.08),
//                 const Color(0xFF388E3C).withOpacity(0.06),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: const Color(0xFF2E7D32).withOpacity(0.3),
//               width: 1.5,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF2E7D32),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.check_circle_rounded,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     "Selected Location",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color:AppColors.kPrimary,
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       color: Color(0xFF2E7D32),
//                       size: 22,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             controller.selectedMainLocation.value,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF1A1A1A),
//                               height: 1.3,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "${controller.selectedDistrict.value}, ${controller.selectedState.value}",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey[600],
//                               height: 1.3,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _buildBottomButton() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Obx(() {
//             final isEnabled = controller.selectedMainLocation.value.isNotEmpty;
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: isEnabled
//                       ? () async {
//                     await controller.saveLocation();
//                     Get.back();
//                   }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF009688),
//                     disabledBackgroundColor: Colors.grey[300],
//                     elevation: isEnabled ? 4 : 0,
//                     shadowColor: const Color(0xFF009688).withOpacity(0.4),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         isEnabled
//                             ? Icons.check_circle_outline_rounded
//                             : Icons.location_on_outlined,
//                         size: 22,
//                         color: isEnabled ? Colors.white : Colors.grey[500],
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         isEnabled ? "Confirm & Continue" : "Please Select All Fields",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.3,
//                           color: isEnabled ? Colors.white : Colors.grey[500],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionLabel(String label, int step, bool isCompleted) {
//     return Row(
//       children: [
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           width: 28,
//           height: 28,
//           decoration: BoxDecoration(
//             gradient: isCompleted
//                 ? const LinearGradient(
//               colors: [Color(0xFF009688), Color(0xFF009688)],
//             )
//                 : null,
//             color: isCompleted ? null : Colors.grey[300],
//             shape: BoxShape.circle,
//             boxShadow: isCompleted
//                 ? [
//               BoxShadow(
//                 color: const Color(0xFF009688).withOpacity(0.4),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ]
//                 : null,
//           ),
//           child: Center(
//             child: isCompleted
//                 ? const Icon(
//               Icons.check,
//               size: 16,
//               color: Colors.white,
//             )
//                 : Text(
//               step.toString(),
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1A1A1A),
//             letterSpacing: 0.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdownField({
//     required String? value,
//     required String hint,
//     required IconData icon,
//     required List<String> items,
//     required ValueChanged<String?>? onChanged,
//     bool enabled = true,
//   }) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         color: enabled ? Colors.white : Colors.grey[50],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: enabled
//               ? (value != null ? const Color(0xFF009688) : Colors.grey[300]!)
//               : Colors.grey[200]!,
//           width: enabled && value != null ? 2 : 1.5,
//         ),
//         boxShadow: enabled
//             ? [
//           BoxShadow(
//             color: value != null
//                 ? const Color(0xFF009688).withOpacity(0.1)
//                 : Colors.black.withOpacity(0.03),
//             blurRadius: value != null ? 12 : 8,
//             offset: const Offset(0, 2),
//           ),
//         ]
//             : null,
//       ),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(
//             fontSize: 15,
//             color: Colors.grey[400],
//             fontWeight: FontWeight.w500,
//           ),
//           prefixIcon: Padding(
//             padding: const EdgeInsets.all(14),
//             child: Icon(
//               icon,
//               color: enabled
//                   ? (value != null ? const Color(0xFF009688) : Colors.grey[400])
//                   : Colors.grey[300],
//               size: 22,
//             ),
//           ),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 18,
//           ),
//           enabled: enabled,
//         ),
//         dropdownColor: Colors.white,
//         icon: Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: enabled ? Colors.grey[700] : Colors.grey[400],
//           size: 24,
//         ),
//         items: items.isEmpty
//             ? null
//             : items
//             .map((e) => DropdownMenuItem(
//           value: e,
//           child: Text(
//             e,
//             style: const TextStyle(
//               fontSize: 15,
//               color: Color(0xFF1A1A1A),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ))
//             .toList(),
//         onChanged: enabled ? onChanged : null,
//         borderRadius: BorderRadius.circular(16),
//         elevation: 8,
//       ),
//     );
//   }
//
//   Widget _buildAnimatedSection({required int delay, required Widget child}) {
//     return TweenAnimationBuilder(
//       tween: Tween<double>(begin: 0, end: 1),
//       duration: Duration(milliseconds: 600 + delay),
//       curve: Curves.easeOutCubic,
//       builder: (context, double value, child) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(0, 30 * (1 - value)),
//             child: child,
//           ),
//         );
//       },
//       child: child,
//     );
//   }
// }
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_text_style.dart';
import '../controller/district _controller.dart';

// ── Same teal constants as AddEventPage ───────────────────────────────────
const _kTeal      = Colors.teal;
const _kTealDark  = Color(0xFF00897B);
const _kTealMid   = Color(0xFF009688);

class SelectLocationPage extends StatelessWidget {
  SelectLocationPage({super.key});

  final controller = Get.find<UserLocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.kPrimary,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Select Location",
          style: AppTextStyle.rTextNunitoWhite16w600,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return _buildLoadingState();
        return _buildMainContent(context);
      }),
    );
  }

  // ─── Loading ──────────────────────────────────────────────────────────────
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, double value, child) => Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _kTeal.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(_kTealMid),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Loading locations...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Please wait a moment",
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // ─── Main Content ─────────────────────────────────────────────────────────
  Widget _buildMainContent(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 24),
              _buildProgressCard(),
              const SizedBox(height: 24),
              _buildSectionTitle("Select Location"),
              const SizedBox(height: 14),
              _buildStateSelection(),
              const SizedBox(height: 14),
              _buildDistrictSelection(),
              const SizedBox(height: 14),
              _buildAreaSelection(),
              const SizedBox(height: 20),
              _buildLocationPreview(),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: _buildBottomButton(),
        ),
      ],
    );
  }

  // ─── Header Card — same gradient as AddEventPage _buildHeaderCard ─────────
  Widget _buildHeaderCard() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // ← exact same gradient as AddEventPage header
          gradient: const LinearGradient(
            colors: [_kTealDark, _kTealMid],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _kTeal.withOpacity(0.30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                size: 32,
                color: Colors.white,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Select state, district and area to continue",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Progress Card ────────────────────────────────────────────────────────
  Widget _buildProgressCard() {
    return Obx(() {
      final done = [
        controller.selectedState.value.isNotEmpty,
        controller.selectedDistrict.value.isNotEmpty,
        controller.selectedMainLocation.value.isNotEmpty,
      ].where((e) => e).length;

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Selection Progress",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                Text(
                  "$done/3 Completed",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kTealMid,           // ← teal like AddEventPage
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: done / 3,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(_kTealMid),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── Section Title — exact same as AddEventPage _buildSectionTitle ────────
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: _kTeal,                      // ← teal bar
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A202C),
          ),
        ),
      ],
    );
  }

  // ─── State / District / Area — each uses _buildDropdownCard ──────────────
  Widget _buildStateSelection() {
    return _animated(
      delay: 100,
      child: Obx(() => _buildDropdownCard(
        step: 1,
        label: "State",
        icon: Icons.map_rounded,
        hint: "Select your state",
        value: controller.selectedState.value.isEmpty
            ? null
            : controller.selectedState.value,
        items: controller.states,
        enabled: true,
        onChanged: (v) { if (v != null) controller.onStateSelected(v); },
      )),
    );
  }

  Widget _buildDistrictSelection() {
    return _animated(
      delay: 200,
      child: Obx(() {
        final enabled = controller.districts.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownCard(
              step: 2,
              label: "District",
              icon: Icons.location_city_rounded,
              hint: "Select your district",
              value: controller.selectedDistrict.value.isEmpty
                  ? null
                  : controller.selectedDistrict.value,
              items: controller.districts,
              enabled: enabled,
              onChanged: enabled
                  ? (v) { if (v != null) controller.onDistrictSelected(v); }
                  : null,
            ),
            if (controller.selectedState.value.isNotEmpty && !enabled)
              _hint("Please select a state first"),
          ],
        );
      }),
    );
  }

  Widget _buildAreaSelection() {
    return _animated(
      delay: 300,
      child: Obx(() {
        final enabled = controller.mainLocations.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownCard(
              step: 3,
              label: "Area",
              icon: Icons.place_rounded,
              hint: "Select your area",
              value: controller.selectedMainLocation.value.isEmpty
                  ? null
                  : controller.selectedMainLocation.value,
              items: controller.mainLocations,
              enabled: enabled,
              onChanged: enabled
                  ? (v) { if (v != null) controller.selectedMainLocation.value = v; }
                  : null,
            ),
            if (controller.selectedDistrict.value.isNotEmpty && !enabled)
              _hint("Please select a district first"),
          ],
        );
      }),
    );
  }

  // ─── Dropdown Card — styled like AddEventPage _buildDateTimeCard ──────────
  Widget _buildDropdownCard({
    required int step,
    required String label,
    required IconData icon,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    bool enabled = true,
  }) {
    final isSelected = value != null;

    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? _kTeal.withOpacity(0.30)   // ← teal border like AddEventPage
              : Colors.grey[300]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
          ),
          // Icon container — same as AddEventPage date/time icon container
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: _kTeal.withOpacity(0.10), // ← teal tint
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: enabled ? _kTeal : Colors.grey[300], // ← teal icon
                size: 20,
              ),
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Step badge → checkmark when done
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? _kTeal : Colors.grey[300],
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: _kTeal.withOpacity(0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                        : null,
                  ),
                  child: Center(
                    child: isSelected
                        ? const Icon(Icons.check, size: 13, color: Colors.white)
                        : Text(
                      "$step",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: enabled ? Colors.grey[700] : Colors.grey[400],
                  size: 24,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          enabled: enabled,
        ),
        dropdownColor: Colors.white,
        icon: const SizedBox.shrink(),
        items: items.isEmpty
            ? null
            : items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(
            e,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1A202C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ))
            .toList(),
        onChanged: enabled ? onChanged : null,
        borderRadius: BorderRadius.circular(14),
        elevation: 8,
      ),
    );
  }

  // ─── Location Preview ─────────────────────────────────────────────────────
  Widget _buildLocationPreview() {
    return Obx(() {
      if (controller.selectedMainLocation.value.isEmpty) {
        return const SizedBox.shrink();
      }
      return _animated(
        delay: 400,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF2E7D32).withOpacity(0.25),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Selected Location",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xFF2E7D32), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.selectedMainLocation.value,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${controller.selectedDistrict.value}, ${controller.selectedState.value}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ─── Bottom Button — same as AddEventPage _buildSubmitButton ─────────────
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final isEnabled = controller.selectedMainLocation.value.isNotEmpty;
          return SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: isEnabled
                  ? () async {
                await controller.saveLocation();
                Get.back();
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kTeal,        // ← teal like AddEventPage
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                elevation: isEnabled ? 4 : 0,
                shadowColor: _kTeal.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEnabled
                        ? Icons.check_circle_rounded
                        : Icons.location_on_outlined,
                    size: 22,
                    color: isEnabled ? Colors.white : Colors.grey[500],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEnabled
                        ? "Confirm & Continue"
                        : "Please Select All Fields",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: isEnabled ? Colors.white : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  Widget _hint(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 7, left: 6),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              size: 13, color: Colors.orange[700]),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange[700],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _animated({required int delay, required Widget child}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}