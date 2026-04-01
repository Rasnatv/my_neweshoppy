//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../common/style/app_text_style.dart';
// import '../../../../common/style/app_colors.dart';
// import '../../controller/add_advertismentcontroller.dart';
// import 'admin_addavertisment.dart';
//
//
// class AdminAdvertisementPage extends StatelessWidget {
//   AdminAdvertisementPage({super.key});
//
//   final AdminAdvertisementController controller =
//   Get.put(AdminAdvertisementController());
//
//   // ── Type helpers ──
//   IconData _typeIcon(String type) {
//     switch (type) {
//       case 'admin':
//         return Icons.admin_panel_settings_rounded;
//       case 'district_admin':
//         return Icons.location_city_rounded;
//       case 'area_admin':
//         return Icons.holiday_village_rounded;
//       case 'merchant':
//         return Icons.storefront_rounded;
//       default:
//         return Icons.person_rounded;
//     }
//   }
//
//   Color _typeColor(String type) {
//     switch (type) {
//       case 'admin':
//         return const Color(0xFF1565C0);
//       case 'district_admin':
//         return const Color(0xFF2E7D32);
//       case 'area_admin':
//         return const Color(0xFF6A1B9A);
//       case 'merchant':
//         return const Color(0xFFE65100);
//       default:
//         return Colors.grey.shade600;
//     }
//   }
//
//   String _typeLabel(String type) {
//     switch (type) {
//       case 'admin':
//         return 'Admin';
//       case 'district_admin':
//         return 'District Admin';
//       case 'area_admin':
//         return 'Area Admin';
//       case 'merchant':
//         return 'Merchant';
//       default:
//         return type;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F8),
//       appBar: _buildAppBar(),
//       floatingActionButton: _buildFAB(),
//       body: Column(
//         children: [
//           _buildFilterTabs(),
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     color: AppColors.kPrimary,
//                   ),
//                 );
//               }
//
//               final ads = controller.filteredAdvertisements;
//
//               if (ads.isEmpty) {
//                 return _buildEmptyState();
//               }
//
//               return RefreshIndicator(
//                 color: AppColors.kPrimary,
//                 onRefresh: controller.fetchAdvertisements,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
//                   itemCount: ads.length,
//                   itemBuilder: (context, index) =>
//                       _buildAdCard(context, ads[index], index),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── AppBar ──
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: AppColors.kPrimary,
//       elevation: 0,
//       centerTitle: false,
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Advertisements",
//             style: AppTextStyle.rTextNunitoWhite17w700,
//           ),
//           Obx(() => Text(
//             "${controller.filteredAdvertisements.length} entries",
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 11,
//               fontWeight: FontWeight.w400,
//             ),
//           )),
//         ],
//       ),
//       actions: [
//         IconButton(
//           onPressed: controller.fetchAdvertisements,
//           icon: const Icon(Icons.refresh_rounded, color: Colors.white),
//           tooltip: "Refresh",
//         ),
//         const SizedBox(width: 4),
//       ],
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
//       ),
//     );
//   }
//
//   // ── FAB ──
//   Widget _buildFAB() {
//     return FloatingActionButton.extended(
//       onPressed: () async {
//         await Get.to(() => AdminAddAdvertisementPage());
//         controller.fetchAdvertisements();
//       },
//       backgroundColor: AppColors.kPrimary,
//       elevation: 4,
//       icon: const Icon(Icons.add_rounded, color: Colors.white),
//       label: const Text(
//         "Add New",
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//           fontSize: 13,
//         ),
//       ),
//     );
//   }
//
//   // ── Empty State ──
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.campaign_outlined,
//               size: 52,
//               color: Colors.grey.shade400,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "No advertisements found",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             "Tap + to add a new advertisement",
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.grey.shade400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Filter Tab Bar ──
//   Widget _buildFilterTabs() {
//     final filters = [
//       {
//         'key': 'all',
//         'label': 'All',
//         'icon': Icons.grid_view_rounded,
//       },
//       {
//         'key': 'admin',
//         'label': 'Admin',
//         'icon': Icons.admin_panel_settings_rounded,
//       },
//       {
//         'key': 'district_admin',
//         'label': 'District',
//         'icon': Icons.location_city_rounded,
//       },
//       {
//         'key': 'area_admin',
//         'label': 'Area',
//         'icon': Icons.holiday_village_rounded,
//       },
//       {
//         'key': 'merchant',
//         'label': 'Merchant',
//         'icon': Icons.storefront_rounded,
//       },
//     ];
//
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       child: Obx(() => Row(
//         children: filters.map((f) {
//           final key = f['key'] as String;
//           final label = f['label'] as String;
//           final icon = f['icon'] as IconData;
//           final isSelected = controller.selectedFilter.value == key;
//
//           final Color activeColor = key == 'all'
//               ? AppColors.kPrimary
//               : _typeColor(key);
//
//           int count = key == 'all'
//               ? controller.advertisements.length
//               : controller.advertisements
//               .where((a) => a['created_by_type'] == key)
//               .length;
//
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => controller.setFilter(key),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 220),
//                 curve: Curves.easeOut,
//                 margin: const EdgeInsets.symmetric(horizontal: 3),
//                 padding: const EdgeInsets.symmetric(
//                     vertical: 8, horizontal: 2),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? activeColor
//                       : Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: isSelected
//                       ? [
//                     BoxShadow(
//                       color: activeColor.withOpacity(0.28),
//                       blurRadius: 8,
//                       offset: const Offset(0, 3),
//                     )
//                   ]
//                       : [],
//                   border: isSelected
//                       ? null
//                       : Border.all(
//                     color: Colors.grey.shade200,
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       icon,
//                       size: 17,
//                       color: isSelected
//                           ? Colors.white
//                           : Colors.grey.shade500,
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       label,
//                       style: TextStyle(
//                         fontSize: 9.5,
//                         fontWeight: FontWeight.w700,
//                         color: isSelected
//                             ? Colors.white
//                             : Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     // Count badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 5, vertical: 1.5),
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? Colors.white.withOpacity(0.25)
//                             : Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         '$count',
//                         style: TextStyle(
//                           fontSize: 9,
//                           fontWeight: FontWeight.bold,
//                           color: isSelected
//                               ? Colors.white
//                               : Colors.grey.shade700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       )),
//     );
//   }
//
//   // ── Advertisement Card ──
//   Widget _buildAdCard(
//       BuildContext context, Map<String, dynamic> ad, int index) {
//     final type = ad['created_by_type'] ?? '';
//     final typeColor = _typeColor(type);
//     final adId = ad['id'] ?? '';
//
//     return Obx(() {
//       final isExpanded = controller.expandedId.value == adId;
//
//       return Dismissible(
//         key: Key('dismissible_$adId'),
//         direction: DismissDirection.endToStart,
//         background: _swipeDeleteBg(),
//         confirmDismiss: (_) => _showDeleteDialog(context),
//         onDismissed: (_) => controller.deleteAdvertisement(index),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 280),
//           curve: Curves.easeInOut,
//           margin: const EdgeInsets.symmetric(vertical: 7),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.06),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//             border: Border(
//               left: BorderSide(color: typeColor, width: 4.5),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Banner ──
//               GestureDetector(
//                 onTap: () => controller.toggleExpand(adId),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(16),
//                   ),
//                   child: Stack(
//                     children: [
//                       // Banner image
//                       ad["banner"] != null &&
//                           ad["banner"].toString().isNotEmpty
//                           ? Image.network(
//                         ad["banner"],
//                         width: double.infinity,
//                         height: 165,
//                         fit: BoxFit.cover,
//                         loadingBuilder: (_, child, progress) =>
//                         progress == null
//                             ? child
//                             : _imagePlaceholder(isLoading: true),
//                         errorBuilder: (_, __, ___) =>
//                             _imagePlaceholder(),
//                       )
//                           : _imagePlaceholder(),
//
//                       // Gradient overlay bottom
//                       Positioned(
//                         bottom: 0,
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           height: 60,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                               colors: [
//                                 Colors.black.withOpacity(0.45),
//                                 Colors.transparent,
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // Type badge top-right
//                       Positioned(
//                         top: 10,
//                         right: 10,
//                         child: _postedByBadge(type, typeColor),
//                       ),
//
//                       // Expand toggle bottom-right
//                       Positioned(
//                         bottom: 8,
//                         right: 10,
//                         child: _expandIndicator(isExpanded),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // ── Card Body ──
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => controller.toggleExpand(adId),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Title
//                             Text(
//                               ad["name"] ?? "",
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFF1A1A2E),
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             _buildLocationChips(ad),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     // ── Action buttons (Edit + Delete) ──
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Edit button
//                         _actionBtn(
//                           icon: Icons.edit_rounded,
//                           color: const Color(0xFF1565C0),
//                           bgColor: const Color(0xFFE3F0FF),
//                           onTap:(){}
//
//                         ),
//                         const SizedBox(width: 6),
//                         // Delete button
//                         _actionBtn(
//                           icon: Icons.delete_rounded,
//                           color: Colors.redAccent,
//                           bgColor: const Color(0xFFFFEBEE),
//                           onTap: () async {
//                             final confirmed = await _showDeleteDialog(context);
//                             if (confirmed == true) {
//                               controller.deleteAdvertisement(index);
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // ── Expandable Details ──
//               AnimatedCrossFade(
//                 duration: const Duration(milliseconds: 280),
//                 crossFadeState: isExpanded
//                     ? CrossFadeState.showSecond
//                     : CrossFadeState.showFirst,
//                 firstChild: const SizedBox.shrink(),
//                 secondChild: _buildExpandedDetails(ad, type, typeColor),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _actionBtn({
//     required IconData icon,
//     required Color color,
//     required Color bgColor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(7),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, color: color, size: 18),
//       ),
//     );
//   }
//
//   // ── Swipe delete background ──
//   Widget _swipeDeleteBg() {
//     return Container(
//       alignment: Alignment.centerRight,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       margin: const EdgeInsets.symmetric(vertical: 7),
//       decoration: BoxDecoration(
//         color: Colors.red.shade400,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: const Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.delete_rounded, color: Colors.white, size: 26),
//           SizedBox(height: 4),
//           Text(
//             "Delete",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<bool?> _showDeleteDialog(BuildContext context) async {
//     return showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: const [
//             Icon(Icons.warning_rounded, color: Colors.red, size: 22),
//             SizedBox(width: 8),
//             Text("Delete Ad", style: TextStyle(fontSize: 16)),
//           ],
//         ),
//         content:
//         const Text("Are you sure you want to delete this advertisement?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(false),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(ctx).pop(true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Expand indicator ──
//   Widget _expandIndicator(bool isExpanded) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       padding: const EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.45),
//         shape: BoxShape.circle,
//       ),
//       child: AnimatedRotation(
//         turns: isExpanded ? 0.5 : 0.0,
//         duration: const Duration(milliseconds: 250),
//         child: const Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: Colors.white,
//           size: 16,
//         ),
//       ),
//     );
//   }
//
//   // ── Posted-by badge ──
//   Widget _postedByBadge(String type, Color typeColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: typeColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: typeColor.withOpacity(0.4),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(_typeIcon(type), color: Colors.white, size: 12),
//           const SizedBox(width: 4),
//           Text(
//             _typeLabel(type),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Location Chips ──
//   Widget _buildLocationChips(Map<String, dynamic> ad) {
//     final mainLoc = (ad['main_location'] ?? '').toString().trim();
//     final district = (ad['district'] ?? '').toString().trim();
//     final eventLoc = (ad['event_location'] ?? '').toString().trim();
//
//     List<Widget> chips = [];
//
//     if (mainLoc.isNotEmpty) {
//       chips.add(_locationChip(
//           Icons.location_on_rounded, mainLoc, const Color(0xFF6A1B9A)));
//     }
//     if (district.isNotEmpty) {
//       chips.add(_locationChip(
//           Icons.map_rounded, district, const Color(0xFF00695C)));
//     }
//     if (eventLoc.isNotEmpty) {
//       chips.add(_locationChip(
//           Icons.event_available_rounded, eventLoc, const Color(0xFFBF360C)));
//     }
//     if (chips.isEmpty) {
//       chips.add(_locationChip(
//           Icons.public_rounded, 'All Areas', Colors.grey.shade600));
//     }
//
//     return Wrap(spacing: 6, runSpacing: 5, children: chips);
//   }
//
//   Widget _locationChip(IconData icon, String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.09),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.35), width: 0.8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: color),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: color,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Expanded Details ──
//   Widget _buildExpandedDetails(
//       Map<String, dynamic> ad, String type, Color typeColor) {
//     final createdAt = ad['created_at'] ?? '';
//     final createdById = ad['created_by_id'] ?? '';
//     final mainLoc = (ad['main_location'] ?? '').toString().trim();
//     final district = (ad['district'] ?? '').toString().trim();
//     final eventLoc = (ad['event_location'] ?? '').toString().trim();
//
//     return Container(
//       margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
//       padding: const EdgeInsets.all(13),
//       decoration: BoxDecoration(
//         color: typeColor.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: typeColor.withOpacity(0.18), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(_typeIcon(type), color: typeColor, size: 15),
//               const SizedBox(width: 6),
//               Text(
//                 "Posted by ${_typeLabel(type)}",
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: typeColor,
//                 ),
//               ),
//             ],
//           ),
//           const Divider(height: 16),
//           _detailRow(Icons.badge_outlined, "Posted By",
//               "${_typeLabel(type)} (ID: $createdById)", typeColor),
//           if (mainLoc.isNotEmpty)
//             _detailRow(Icons.location_on_rounded, "Main Location", mainLoc,
//                 const Color(0xFF6A1B9A)),
//           if (district.isNotEmpty)
//             _detailRow(Icons.map_rounded, "District", district,
//                 const Color(0xFF00695C)),
//           if (eventLoc.isNotEmpty)
//             _detailRow(Icons.event_available_rounded, "Event Location",
//                 eventLoc, const Color(0xFFBF360C)),
//           if (mainLoc.isEmpty && district.isEmpty && eventLoc.isEmpty)
//             _detailRow(
//                 Icons.public_rounded, "Coverage", "All Areas", Colors.grey),
//           if (createdAt.isNotEmpty)
//             _detailRow(Icons.access_time_rounded, "Posted On",
//                 _formatDate(createdAt), Colors.blueGrey),
//         ],
//       ),
//     );
//   }
//
//   Widget _detailRow(
//       IconData icon, String label, String value, Color iconColor) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 14, color: iconColor),
//           const SizedBox(width: 8),
//           Text(
//             "$label: ",
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF555555),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _imagePlaceholder({bool isLoading = false}) {
//     return Container(
//       width: double.infinity,
//       height: 165,
//       color: Colors.grey.shade100,
//       child: isLoading
//           ? const Center(
//         child: SizedBox(
//           width: 28,
//           height: 28,
//           child: CircularProgressIndicator(strokeWidth: 2),
//         ),
//       )
//           : Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade300),
//     );
//   }
//
//   String _formatDate(String dateStr) {
//     try {
//       final dt = DateTime.parse(dateStr);
//       const months = [
//         'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//       ];
//       return "${dt.day} ${months[dt.month - 1]} ${dt.year}, "
//           "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
//     } catch (_) {
//       return dateStr;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_text_style.dart';
import '../../../../common/style/app_colors.dart';
import '../../controller/add_advertismentcontroller.dart';
import 'admin_addavertisment.dart';
import 'admin_updateadvertismentsction.dart';


class AdminAdvertisementPage extends StatelessWidget {
  AdminAdvertisementPage({super.key});

  final AdminAdvertisementController controller =
  Get.put(AdminAdvertisementController());

  // ── Type helpers ──
  IconData _typeIcon(String type) {
    switch (type) {
      case 'admin':        return Icons.admin_panel_settings_rounded;
      case 'district_admin': return Icons.location_city_rounded;
      case 'area_admin':   return Icons.holiday_village_rounded;
      case 'merchant':     return Icons.storefront_rounded;
      default:             return Icons.person_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'admin':          return const Color(0xFF1565C0);
      case 'district_admin': return const Color(0xFF2E7D32);
      case 'area_admin':     return const Color(0xFF6A1B9A);
      case 'merchant':       return const Color(0xFFE65100);
      default:               return Colors.grey.shade600;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'admin':          return 'Admin';
      case 'district_admin': return 'District Admin';
      case 'area_admin':     return 'Area Admin';
      case 'merchant':       return 'Merchant';
      default:               return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: _buildAppBar(),
      floatingActionButton: _buildFAB(),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.kPrimary));
              }
              final ads = controller.filteredAdvertisements;
              if (ads.isEmpty) return _buildEmptyState();
              return RefreshIndicator(
                color: AppColors.kPrimary,
                onRefresh: controller.fetchAdvertisements,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: ads.length,
                  itemBuilder: (context, index) =>
                      _buildAdCard(context, ads[index], index),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.kPrimary,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Advertisements", style: AppTextStyle.rTextNunitoWhite17w700),
          Obx(() => Text(
            "${controller.filteredAdvertisements.length} entries",
            style: const TextStyle(
                color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w400),
          )),
        ],
      ),
      actions: [
        IconButton(
          onPressed: controller.fetchAdvertisements,
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
        ),
        const SizedBox(width: 4),
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        await Get.to(() => AdminAddAdvertisementPage());
        controller.fetchAdvertisements();
      },
      backgroundColor: AppColors.kPrimary,
      elevation: 4,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text("Add New",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(Icons.campaign_outlined,
                size: 52, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          Text("No advertisements found",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          Text("Tap + to add a new advertisement",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  // ── Filter Tab Bar (5 tabs) ──
  Widget _buildFilterTabs() {
    final filters = [
      {'key': 'all',           'label': 'All',      'icon': Icons.grid_view_rounded},
      {'key': 'admin',         'label': 'Admin',    'icon': Icons.admin_panel_settings_rounded},
      {'key': 'district_admin','label': 'District', 'icon': Icons.location_city_rounded},
      {'key': 'area_admin',    'label': 'Area',     'icon': Icons.holiday_village_rounded},
      {'key': 'merchant',      'label': 'Merchant', 'icon': Icons.storefront_rounded},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Obx(() => Row(
        children: filters.map((f) {
          final key = f['key'] as String;
          final label = f['label'] as String;
          final icon = f['icon'] as IconData;
          final isSelected = controller.selectedFilter.value == key;
          final Color activeColor =
          key == 'all' ? AppColors.kPrimary : _typeColor(key);

          int count = key == 'all'
              ? controller.advertisements.length
              : controller.advertisements
              .where((a) => a['created_by_type'] == key)
              .length;

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.setFilter(key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                        color: activeColor.withOpacity(0.28),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ]
                      : [],
                  border: isSelected
                      ? null
                      : Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon,
                        size: 17,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade500),
                    const SizedBox(height: 3),
                    Text(label,
                        style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600)),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.25)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('$count',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade700)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      )),
    );
  }

  // ── Advertisement Card ──
  Widget _buildAdCard(
      BuildContext context, Map<String, dynamic> ad, int index) {
    final type = ad['created_by_type'] ?? '';
    final typeColor = _typeColor(type);
    final adId = ad['id'] ?? '';

    return Obx(() {
      final isExpanded = controller.expandedId.value == adId;

      return Dismissible(
        key: Key('dismissible_$adId'),
        direction: DismissDirection.endToStart,
        background: _swipeDeleteBg(),
        confirmDismiss: (_) => _showDeleteDialog(context),
        onDismissed: (_) => controller.deleteAdvertisement(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ],
            border: Border(left: BorderSide(color: typeColor, width: 4.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Banner ──
              GestureDetector(
                onTap: () => controller.toggleExpand(adId),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      ad["banner"] != null && ad["banner"].toString().isNotEmpty
                          ? Image.network(
                        ad["banner"],
                        width: double.infinity,
                        height: 165,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) => progress == null
                            ? child
                            : _imagePlaceholder(isLoading: true),
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                          : _imagePlaceholder(),
                      // Gradient overlay
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.42),
                                Colors.transparent
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Type badge
                      Positioned(
                          top: 10, right: 10,
                          child: _postedByBadge(type, typeColor)),
                      // Expand chevron
                      Positioned(
                          bottom: 8, right: 10,
                          child: _expandIndicator(isExpanded)),
                    ],
                  ),
                ),
              ),

              // ── Card Body ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.toggleExpand(adId),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad["name"] ?? "",
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E)),
                            ),
                            const SizedBox(height: 7),
                            _buildLocationChips(ad),
                          ],
                        ),
                      ),
                    ),

                    // ── Edit + Delete buttons ──
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✏ Edit — navigates with adId
                        _actionBtn(
                          icon: Icons.edit_rounded,
                          color: const Color(0xFF1565C0),
                          bgColor: const Color(0xFFE3F0FF),
                          onTap: () async {
                            await Get.to(
                                  () => AdminEditAdvertisementPage(adId: adId),
                              routeName: '/admin-edit-advertisement',
                            );
                            // Refresh list after coming back
                            controller.fetchAdvertisements();
                          },
                        ),
                        const SizedBox(width: 6),
                        // 🗑 Delete
                        _actionBtn(
                          icon: Icons.delete_rounded,
                          color: Colors.redAccent,
                          bgColor: const Color(0xFFFFEBEE),
                          onTap: () async {
                            final confirmed = await _showDeleteDialog(context);
                            if (confirmed == true) {
                              controller.deleteAdvertisement(index);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Expandable Details ──
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 280),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: _buildExpandedDetails(ad, type, typeColor),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration:
        BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _swipeDeleteBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
          color: Colors.red.shade400, borderRadius: BorderRadius.circular(16)),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_rounded, color: Colors.white, size: 26),
          SizedBox(height: 4),
          Text("Delete",
              style: TextStyle(
                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.red, size: 22),
            SizedBox(width: 8),
            Text("Delete Ad", style: TextStyle(fontSize: 16)),
          ],
        ),
        content:
        const Text("Are you sure you want to delete this advertisement?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _expandIndicator(bool isExpanded) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45), shape: BoxShape.circle),
      child: AnimatedRotation(
        turns: isExpanded ? 0.5 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: const Icon(Icons.keyboard_arrow_down_rounded,
            color: Colors.white, size: 16),
      ),
    );
  }

  Widget _postedByBadge(String type, Color typeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: typeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: typeColor.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_typeIcon(type), color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(_typeLabel(type),
              style: const TextStyle(
                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildLocationChips(Map<String, dynamic> ad) {
    final mainLoc = (ad['main_location'] ?? '').toString().trim();
    final district = (ad['district'] ?? '').toString().trim();
    final eventLoc = (ad['event_location'] ?? '').toString().trim();
    List<Widget> chips = [];
    if (mainLoc.isNotEmpty)
      chips.add(_locationChip(
          Icons.location_on_rounded, mainLoc, const Color(0xFF6A1B9A)));
    if (district.isNotEmpty)
      chips.add(
          _locationChip(Icons.map_rounded, district, const Color(0xFF00695C)));
    if (eventLoc.isNotEmpty)
      chips.add(_locationChip(
          Icons.event_available_rounded, eventLoc, const Color(0xFFBF360C)));
    if (chips.isEmpty)
      chips.add(_locationChip(
          Icons.public_rounded, 'All Areas', Colors.grey.shade600));
    return Wrap(spacing: 6, runSpacing: 5, children: chips);
  }

  Widget _locationChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildExpandedDetails(
      Map<String, dynamic> ad, String type, Color typeColor) {
    final createdAt = ad['created_at'] ?? '';
    final createdById = ad['created_by_id'] ?? '';
    final mainLoc = (ad['main_location'] ?? '').toString().trim();
    final district = (ad['district'] ?? '').toString().trim();
    final eventLoc = (ad['event_location'] ?? '').toString().trim();

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: typeColor.withOpacity(0.18), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_typeIcon(type), color: typeColor, size: 15),
              const SizedBox(width: 6),
              Text("Posted by ${_typeLabel(type)}",
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: typeColor)),
            ],
          ),
          const Divider(height: 16),
          _detailRow(Icons.badge_outlined, "Posted By",
              "${_typeLabel(type)} (ID: $createdById)", typeColor),
          if (mainLoc.isNotEmpty)
            _detailRow(Icons.location_on_rounded, "Main Location", mainLoc,
                const Color(0xFF6A1B9A)),
          if (district.isNotEmpty)
            _detailRow(Icons.map_rounded, "District", district,
                const Color(0xFF00695C)),
          if (eventLoc.isNotEmpty)
            _detailRow(Icons.event_available_rounded, "Event Location",
                eventLoc, const Color(0xFFBF360C)),
          if (mainLoc.isEmpty && district.isEmpty && eventLoc.isEmpty)
            _detailRow(
                Icons.public_rounded, "Coverage", "All Areas", Colors.grey),
          if (createdAt.isNotEmpty)
            _detailRow(Icons.access_time_rounded, "Posted On",
                _formatDate(createdAt), Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _detailRow(
      IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 8),
          Text("$label: ",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF333333)))),
        ],
      ),
    );
  }

  Widget _imagePlaceholder({bool isLoading = false}) {
    return Container(
      width: double.infinity,
      height: 165,
      color: Colors.grey.shade100,
      child: isLoading
          ? const Center(
          child: SizedBox(
              width: 26, height: 26,
              child: CircularProgressIndicator(strokeWidth: 2)))
          : Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade300),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'
      ];
      return "${dt.day} ${months[dt.month - 1]} ${dt.year}, "
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return dateStr;
    }
  }
}