//
// import 'dart:io';
// import 'package:eshoppy/app/common/style/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_text_style.dart';
// import '../controller/addevent_controller.dart';
//
// class AddEventPage extends StatelessWidget {
//   AddEventPage({super.key});
//   final AddEventController controller = Get.put(AddEventController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         title: Text(
//           "Add Events",
//           style:  AppTextStyle.rTextNunitoWhite16w600,
//         ),
//         backgroundColor: AppColors.kPrimary,
//           automaticallyImplyLeading: true,
//         iconTheme: const IconThemeData(
//           color: Colors.white, // back arrow color
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Card
//                 _buildHeaderCard(),
//                 const SizedBox(height: 24),
//
//                 // Event Details Section
//                 _buildSectionTitle("Event Details"),
//                 const SizedBox(height: 12),
//                 _buildEventNameField(),
//                 const SizedBox(height: 16),
//                 _buildLocationField(),
//                 const SizedBox(height: 24),
//
//                 // Date & Time Section
//                 _buildSectionTitle("Schedule"),
//                 const SizedBox(height: 12),
//                 _buildDateTimeRow(context),
//                 const SizedBox(height: 16),
//                 _buildTimeField(context),
//                 const SizedBox(height: 24),
//
//                 // Banner Section
//                 _buildSectionTitle("Event Banner"),
//                 const SizedBox(height: 12),
//                 _buildBannerSection(),
//                 const SizedBox(height: 100), // Space for button
//               ],
//             ),
//           ),
//
//           // Submit Button (Sticky at bottom)
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: _buildSubmitButton(),
//           ),
//
//           // Full Screen Loader
//           Obx(() => controller.isLoading.value
//               ? Container(
//             color: Colors.black87,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 3,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "Creating Event...",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//               : const SizedBox.shrink()),
//         ],
//       ),
//     );
//   }
//
//   // ----------- HEADER CARD -----------
//   Widget _buildHeaderCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF00897B), Color(0xFF009688)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.teal.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.event_rounded,
//               color: Colors.white,
//               size: 32,
//             ),
//           ),
//           const SizedBox(width: 16),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Create New Event",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   "Fill in the details below",
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ----------- SECTION TITLE -----------
//   Widget _buildSectionTitle(String title) {
//     return Row(
//       children: [
//         Container(
//           width: 4,
//           height: 20,
//           decoration: BoxDecoration(
//             color: Colors.teal,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1A202C),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ----------- EVENT NAME FIELD -----------
//   Widget _buildEventNameField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller.eventName,
//         style: const TextStyle(fontSize: 15),
//         decoration: InputDecoration(
//           labelText: "Event Name",
//           hintText: "Enter event name",
//           prefixIcon: const Icon(Icons.text_fields_rounded, color: Colors.teal),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.teal, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   // ----------- LOCATION FIELD -----------
//   Widget _buildLocationField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller.eventLocation,
//         style: const TextStyle(fontSize: 15),
//         decoration: InputDecoration(
//           labelText: "Event Location",
//           hintText: "Enter event location",
//           prefixIcon: const Icon(Icons.location_on_rounded, color: Colors.teal),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.teal, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   // ----------- DATE & TIME ROW -----------
//   Widget _buildDateTimeRow(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Obx(() => GestureDetector(
//             onTap: () => controller.pickDate(context),
//             child: _buildDateTimeCard(
//               controller.eventDate.value,
//               "Start Date",
//               Icons.calendar_today_rounded,
//               Colors.teal,
//             ),
//           )),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Obx(() => GestureDetector(
//             onTap: () => controller.pickEndDate(context),
//             child: _buildDateTimeCard(
//               controller.eventEndDate.value,
//               "End Date",
//               Icons.event_rounded,
//               Colors.teal,
//             ),
//           )),
//         ),
//       ],
//     );
//   }
//
//   // ----------- TIME FIELD -----------
//   Widget _buildTimeField(BuildContext context) {
//     return Obx(() => GestureDetector(
//       onTap: () => controller.pickTime(context),
//       child: _buildDateTimeCard(
//         controller.eventTime.value,
//         "Event Time",
//         Icons.access_time_rounded,
//         Colors.teal,
//       ),
//     ));
//   }
//
//   // ----------- DATE TIME CARD -----------
//   Widget _buildDateTimeCard(
//       String value, String label, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: value.isEmpty ? Colors.grey[300]! : Colors.teal.withOpacity(0.3),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value.isEmpty ? "Not selected" : value,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: value.isEmpty ? Colors.grey[400] : const Color(0xFF1A202C),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Icon(
//             Icons.arrow_forward_ios_rounded,
//             size: 14,
//             color: Colors.grey[400],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ----------- BANNER SECTION -----------
//   Widget _buildBannerSection() {
//     return Obx(() => GestureDetector(
//       onTap: controller.pickBannerImage,
//       child: Container(
//         height: 220,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: controller.bannerImage.value == null
//                 ? Colors.grey[300]!
//                 : Colors.teal.withOpacity(0.3),
//             width: 2,
//             strokeAlign: BorderSide.strokeAlignInside,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: controller.bannerImage.value == null
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.teal.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.add_photo_alternate_rounded,
//                 size: 40,
//                 color: Colors.teal,
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Upload Event Banner",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A202C),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "Tap to select an image",
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         )
//             : Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(14),
//               child: Image.file(
//                 controller.bannerImage.value!,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             ),
//             // Dark overlay
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(14),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.3),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//             // Delete Button
//             Positioned(
//               right: 12,
//               top: 12,
//               child: InkWell(
//                 onTap: controller.removeBannerImage,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         blurRadius: 8,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.delete_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//             // Edit Indicator
//             Positioned(
//               left: 12,
//               top: 12,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.teal,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 8,
//                     ),
//                   ],
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.check_circle_rounded,
//                       color: Colors.white,
//                       size: 14,
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       "Banner Selected",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
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
//   // ----------- SUBMIT BUTTON -----------
//   Widget _buildSubmitButton() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Obx(() => ElevatedButton(
//           onPressed: controller.isLoading.value ? null : controller.saveEvent,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.teal,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 0,
//             disabledBackgroundColor: Colors.grey[300],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.check_circle_rounded, size: 22),
//               SizedBox(width: 8),
//               Text(
//                 "Create Event",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//         )),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/style/app_text_style.dart';
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Colors.white),
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
                  // ── Event Details Card
                  _sectionCard(
                    title: "Event Details",
                    children: [
                      _fieldLabel("Event Name"),
                      const SizedBox(height: 6),
                      _inputField(
                        controller: controller.eventName,
                        hint: "e.g. Annual Tech Summit",
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: 16),
                      _fieldLabel("Location"),
                      const SizedBox(height: 6),
                      _inputField(
                        controller: controller.eventLocation,
                        hint: "e.g. City Convention Hall",
                        icon: Icons.place_outlined,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Schedule Card
                  _sectionCard(
                    title: "Schedule",
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
                      Obx(() => GestureDetector(
                        onTap: () => controller.pickTime(context),
                        child: _pickerTile(
                          label: "Event Time",
                          value: controller.eventTime.value,
                          icon: Icons.access_time_rounded,
                          fullWidth: true,
                        ),
                      )),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Banner Card
                  _sectionCard(
                    title: "Event Banner",
                    children: [_buildBanner()],
                  ),
                ],
              ),
            ),

            // ── Sticky Submit
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildSubmitButton(),
            ),

            // ── Loading overlay
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                          color: _teal, strokeWidth: 2.5),
                      const SizedBox(height: 16),
                      const Text(
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

  // ── SECTION CARD ──────────────────────────────────────────────────────────
  Widget _sectionCard({required String title, required List<Widget> children}) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _textSecondary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // ── FIELD LABEL ───────────────────────────────────────────────────────────
  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _textPrimary,
      ),
    );
  }

  // ── TEXT INPUT ────────────────────────────────────────────────────────────
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14,
        color: _textPrimary,
        fontWeight: FontWeight.w500,
      ),
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
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _teal, width: 1.6),
        ),
      ),
    );
  }

  // ── PICKER TILE ───────────────────────────────────────────────────────────
  Widget _pickerTile({
    required String label,
    required String value,
    required IconData icon,
    bool fullWidth = false,
  }) {
    final bool has = value.isNotEmpty;
    return Container(
      width: fullWidth ? double.infinity : null,
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
          Icon(Icons.chevron_right_rounded,
              size: 15, color: _textSecondary),
        ],
      ),
    );
  }

  // ── BANNER ────────────────────────────────────────────────────────────────
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
              style: TextStyle(
                  fontSize: 11, color: _textSecondary),
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

  // ── SUBMIT BUTTON ─────────────────────────────────────────────────────────
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