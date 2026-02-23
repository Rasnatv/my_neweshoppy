//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../data/models/admin_restarant_menuupdatemodel.dart';
// import 'controller/restaurant_menuupdatecontroller.dart';
//
// // ─── Design Tokens ────────────────────────────────────────────────────────────
// class _DS {
//   static const bg              = Color(0xFFF5F6FA);
//   static const surface         = Color(0xFFFFFFFF);
//   static const surfaceElevated = Color(0xFFF0F1F8);
//   static const border          = Color(0xFFE0E3F0);
//   static const amber           = Color(0xFFE07B00);
//   static const amberSoft       = Color(0xFFF5A623);
//   static const amberDim        = Color(0x1AE07B00);
//   static const textPrimary     = Color(0xFF1A1D2E);
//   static const textSecondary   = Color(0xFF5C6080);
//   static const textMuted       = Color(0xFF9BA3C2);
//   static const success         = Color(0xFF1DA87A);
//   static const successDim      = Color(0x1A1DA87A);
//   static const danger          = Color(0xFFE05252);
//   static const dangerDim       = Color(0x1AE05252);
//   static const mealBreakfast   = Color(0xFFE07B00);
//   static const mealLunch       = Color(0xFF0AA0A0);
//   static const mealDinner      = Color(0xFF7B4FA6);
//
//   static const p4  = 4.0;
//   static const p8  = 8.0;
//   static const p12 = 12.0;
//   static const p16 = 16.0;
//   static const p20 = 20.0;
//   static const p24 = 24.0;
//   static const p32 = 32.0;
//
//   static final cardShadow = BoxShadow(
//     color: Colors.black.withOpacity(0.06),
//     blurRadius: 16,
//     offset: const Offset(0, 4),
//   );
//
//   static const tsPageTitle = TextStyle(
//     fontFamily: 'Georgia', fontSize: 19, fontWeight: FontWeight.w700,
//     color: textPrimary, letterSpacing: 0.2,
//   );
//   static const tsSectionTitle = TextStyle(
//     fontSize: 13, fontWeight: FontWeight.w700, color: amber, letterSpacing: 2.0,
//   );
//   static const tsLabel = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary);
//   static const tsBody  = TextStyle(fontSize: 14, color: textSecondary, height: 1.5);
//   static const tsMuted = TextStyle(fontSize: 12, color: textMuted);
//   static const tsPrice = TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: success, letterSpacing: 0.3);
// }
//
// // ─── Shared Helpers ──────────────────────────────────────────────────────────
// InputDecoration _field(String label, {Widget? suffix, String? hint}) => InputDecoration(
//   labelText: label,
//   hintText: hint,
//   labelStyle: const TextStyle(color: _DS.textSecondary, fontSize: 13),
//   hintStyle: const TextStyle(color: _DS.textMuted, fontSize: 13),
//   suffixIcon: suffix,
//   filled: true,
//   fillColor: _DS.surfaceElevated,
//   contentPadding: const EdgeInsets.symmetric(horizontal: _DS.p16, vertical: _DS.p12),
//   border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _DS.border)),
//   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _DS.border)),
//   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _DS.amber, width: 1.5)),
// );
//
// Color _mealColor(String m) {
//   switch (m) {
//     case 'breakfast': return _DS.mealBreakfast;
//     case 'lunch':     return _DS.mealLunch;
//     case 'dinner':    return _DS.mealDinner;
//     default:          return _DS.amber;
//   }
// }
//
// IconData _mealIcon(String m) {
//   switch (m) {
//     case 'breakfast': return Icons.free_breakfast_outlined;
//     case 'lunch':     return Icons.lunch_dining_outlined;
//     case 'dinner':    return Icons.dinner_dining_outlined;
//     default:          return Icons.restaurant_outlined;
//   }
// }
//
// // ─── Primary Button ──────────────────────────────────────────────────────────
// class _PrimaryBtn extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool loading;
//   final VoidCallback? onPressed;
//   final Color? color;
//
//   const _PrimaryBtn({
//     required this.label,
//     required this.icon,
//     required this.loading,
//     this.onPressed,
//     this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final c = color ?? _DS.amber;
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: LinearGradient(
//             colors: onPressed == null
//                 ? [_DS.textMuted, _DS.textMuted]
//                 : [c, Color.lerp(c, Colors.white, 0.15)!],
//           ),
//           boxShadow: onPressed != null
//               ? [BoxShadow(color: c.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 4))]
//               : [],
//         ),
//         child: ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           icon: loading
//               ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
//               : Icon(icon, size: 18),
//           label: Text(loading ? 'Saving…' : label,
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
//           onPressed: onPressed,
//         ),
//       ),
//     );
//   }
// }
//
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   const _SectionHeader(this.title, {this.subtitle});
//
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.only(bottom: _DS.p16),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(title.toUpperCase(), style: _DS.tsSectionTitle),
//       if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle!, style: _DS.tsBody)],
//     ]),
//   );
// }
//
// class _Card extends StatelessWidget {
//   final Widget child;
//   final EdgeInsetsGeometry? padding;
//   const _Card({required this.child, this.padding});
//
//   @override
//   Widget build(BuildContext context) => Container(
//     margin: const EdgeInsets.symmetric(vertical: _DS.p8),
//     padding: padding ?? const EdgeInsets.all(_DS.p20),
//     decoration: BoxDecoration(
//       color: _DS.surface,
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: _DS.border),
//       boxShadow: [_DS.cardShadow],
//     ),
//     child: child,
//   );
// }
//
// class _EmptyState extends StatelessWidget {
//   final IconData icon;
//   final String message;
//   final String sub;
//   const _EmptyState({required this.icon, required this.message, required this.sub});
//
//   @override
//   Widget build(BuildContext context) => Container(
//     padding: const EdgeInsets.all(40),
//     alignment: Alignment.center,
//     child: Column(mainAxisSize: MainAxisSize.min, children: [
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(color: _DS.surfaceElevated, shape: BoxShape.circle, border: Border.all(color: _DS.border)),
//         child: Icon(icon, size: 32, color: _DS.textMuted),
//       ),
//       const SizedBox(height: 16),
//       Text(message, style: _DS.tsLabel.copyWith(color: _DS.textSecondary)),
//       const SizedBox(height: 4),
//       Text(sub, style: _DS.tsMuted),
//     ]),
//   );
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// // MAIN PAGE
// // ═══════════════════════════════════════════════════════════════════════════════
// class MenuUpdatePage extends StatelessWidget {
//   final int restaurantId; // ← dynamic restaurant id passed from home
//
//   const MenuUpdatePage({super.key, required this.restaurantId});
//
//   // Use tag so each restaurant has its own isolated controller instance
//   RestaurantMenuUpdateController get c =>
//       Get.find<RestaurantMenuUpdateController>(tag: restaurantId.toString());
//
//   @override
//   Widget build(BuildContext context) {
//     // Register controller with tag — safe to call multiple times (Get handles it)
//     Get.put(
//       RestaurantMenuUpdateController(restaurantId: restaurantId),
//       tag: restaurantId.toString(),
//     );
//
//     return Theme(
//       data: ThemeData.light().copyWith(
//         scaffoldBackgroundColor: _DS.bg,
//         colorScheme: const ColorScheme.light(primary: _DS.amber, surface: _DS.surface),
//       ),
//       child: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           backgroundColor: _DS.bg,
//           appBar: _buildAppBar(),
//           body: TabBarView(
//             children: [
//               _buildTablesTab(context),
//               _buildTimingsTab(context),
//               _buildMenuTab(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() => AppBar(
//     backgroundColor: _DS.surface,
//     elevation: 0,
//     surfaceTintColor: Colors.transparent,
//     leading: Container(
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(color: _DS.amberDim, borderRadius: BorderRadius.circular(10)),
//       child: const Icon(Icons.edit_note_rounded, color: _DS.amber, size: 20),
//     ),
//     title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const Text('Update Menu', style: _DS.tsPageTitle),
//       Text('Restaurant #$restaurantId', style: _DS.tsMuted), // shows which restaurant
//     ]),
//     actions: [
//       Obx(() {
//         final loading = c.isLoadingTables.value || c.isLoadingTimings.value || c.isLoadingMenuItems.value;
//         return loading
//             ? const Padding(
//           padding: EdgeInsets.all(14),
//           child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _DS.amber, strokeWidth: 2)),
//         )
//             : _IconBtn(icon: Icons.refresh_rounded, tooltip: 'Refresh All', onTap: c.fetchAll);
//       }),
//     ],
//     bottom: PreferredSize(
//       preferredSize: const Size.fromHeight(56),
//       child: Container(
//         decoration: const BoxDecoration(border: Border(top: BorderSide(color: _DS.border))),
//         child: const TabBar(
//           labelColor: _DS.amber,
//           unselectedLabelColor: _DS.textSecondary,
//           indicatorColor: _DS.amber,
//           indicatorWeight: 2.5,
//           labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.8),
//           unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//           tabs: [
//             Tab(text: 'TABLES'),
//             Tab(text: 'TIMINGS'),
//             Tab(text: 'MENU'),
//           ],
//         ),
//       ),
//     ),
//   );
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // TAB 1 — TABLES
//   // ═══════════════════════════════════════════════════════════════════════════
//   Widget _buildTablesTab(BuildContext context) => SingleChildScrollView(
//     padding: const EdgeInsets.all(_DS.p20),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const SizedBox(height: 4),
//
//       // ── Inline edit form (shown when a table is selected) ──
//       Obx(() {
//         final sel = c.selectedTable.value;
//         if (sel == null) return const SizedBox();
//         return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           _SectionHeader('Edit Table', subtitle: 'Updating: ${sel.tableType}'),
//           _Card(child: Column(children: [
//             TextField(
//               controller: c.tableTypeCtrl,
//               style: const TextStyle(color: _DS.textPrimary),
//               decoration: _field('Table Type / Name'),
//             ),
//             const SizedBox(height: _DS.p12),
//             TextField(
//               controller: c.capacityRangeCtrl,
//               style: const TextStyle(color: _DS.textPrimary),
//               decoration: _field('Capacity Range', hint: 'e.g. 2–6'),
//             ),
//             const SizedBox(height: _DS.p12),
//             TextField(
//               controller: c.tableNameCtrl,
//               style: const TextStyle(color: _DS.textPrimary, letterSpacing: 1.0),
//               textCapitalization: TextCapitalization.characters,
//               decoration: _field('Table IDs (comma-separated)', hint: 'T1, T2, T3'),
//             ),
//             const SizedBox(height: _DS.p12),
//             Obx(() => DropdownButtonFormField<SeatingTypeUpdate>(
//               value: c.seatingTypeEdit.value,
//               dropdownColor: _DS.surface,
//               style: const TextStyle(color: _DS.textPrimary, fontSize: 14),
//               decoration: _field('Seating Type'),
//               items: SeatingTypeUpdate.values
//                   .map((e) => DropdownMenuItem(
//                 value: e,
//                 child: Text(e.name.capitalizeFirst!),
//               ))
//                   .toList(),
//               onChanged: (v) => c.seatingTypeEdit.value = v!,
//             )),
//             const SizedBox(height: _DS.p20),
//             Row(children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: _DS.textSecondary,
//                     side: const BorderSide(color: _DS.border),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   icon: const Icon(Icons.close_rounded, size: 16),
//                   label: const Text('Cancel'),
//                   onPressed: c.clearTableSelection,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 2,
//                 child: Obx(() => _PrimaryBtn(
//                   label: 'Save Changes',
//                   icon: Icons.save_rounded,
//                   loading: c.isUpdatingTable.value,
//                   onPressed: c.isUpdatingTable.value ? null : c.updateTable,
//                 )),
//               ),
//             ]),
//           ])),
//           const SizedBox(height: _DS.p8),
//         ]);
//       }),
//
//       const _SectionHeader('Restaurant Tables', subtitle: 'Tap a table to edit its details'),
//       Obx(() {
//         if (c.isLoadingTables.value) {
//           return const Center(child: Padding(
//             padding: EdgeInsets.all(40),
//             child: CircularProgressIndicator(color: _DS.amber),
//           ));
//         }
//         if (c.tables.isEmpty) {
//           return const _EmptyState(
//             icon: Icons.table_restaurant_outlined,
//             message: 'No tables found',
//             sub: 'Tables for this restaurant will appear here',
//           );
//         }
//         return Column(
//           children: c.tables.map((table) => _TableCard(table: table, tag: restaurantId.toString())).toList(),
//         );
//       }),
//     ]),
//   );
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // TAB 2 — TIMINGS
//   // ═══════════════════════════════════════════════════════════════════════════
//   Widget _buildTimingsTab(BuildContext context) {
//     Future<void> pickTime(TextEditingController ctrl) async {
//       final parts = ctrl.text.split(':');
//       final initial = parts.length >= 2
//           ? TimeOfDay(
//         hour: int.tryParse(parts[0]) ?? 0,
//         minute: int.tryParse(parts[1]) ?? 0,
//       )
//           : TimeOfDay.now();
//
//       final picked = await showTimePicker(
//         context: context,
//         initialTime: initial,
//         builder: (ctx, child) => Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: _DS.amber, onPrimary: Colors.white,
//               surface: _DS.surface, onSurface: _DS.textPrimary,
//             ),
//           ),
//           child: child!,
//         ),
//       );
//       if (picked != null) {
//         ctrl.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
//       }
//     }
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(_DS.p20),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const SizedBox(height: 4),
//         const _SectionHeader('Meal Timings', subtitle: 'Adjust service windows for each meal period'),
//
//         Obx(() {
//           if (c.isLoadingTimings.value) {
//             return const Center(child: Padding(
//               padding: EdgeInsets.all(40),
//               child: CircularProgressIndicator(color: _DS.amber),
//             ));
//           }
//           if (c.timings.isEmpty) {
//             return const _EmptyState(
//               icon: Icons.schedule_outlined,
//               message: 'No timings found',
//               sub: 'Add timings from the Menu Management page',
//             );
//           }
//
//           return Column(
//             children: [
//               ...['breakfast', 'lunch', 'dinner'].map((meal) {
//                 final timing = c.getTimingByMeal(meal);
//                 if (timing == null) return const SizedBox();
//
//                 final ctrls = c.timingControllers[meal];
//                 if (ctrls == null) return const SizedBox();
//
//                 final color = _mealColor(meal);
//                 return _Card(
//                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     Row(children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.12),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(_mealIcon(meal), color: color, size: 18),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(meal.capitalizeFirst!, style: _DS.tsLabel),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.10),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text('ID: ${timing.id}', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
//                       ),
//                     ]),
//                     const SizedBox(height: _DS.p16),
//                     Row(children: [
//                       Expanded(
//                         child: TextField(
//                           controller: ctrls['start'],
//                           readOnly: true,
//                           style: const TextStyle(color: _DS.textPrimary),
//                           onTap: () => pickTime(ctrls['start']!),
//                           decoration: _field('Start Time',
//                               suffix: Icon(Icons.schedule, size: 18, color: color)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Icon(Icons.arrow_forward, color: _DS.textMuted, size: 18),
//                       ),
//                       Expanded(
//                         child: TextField(
//                           controller: ctrls['end'],
//                           readOnly: true,
//                           style: const TextStyle(color: _DS.textPrimary),
//                           onTap: () => pickTime(ctrls['end']!),
//                           decoration: _field('End Time',
//                               suffix: Icon(Icons.schedule, size: 18, color: color)),
//                         ),
//                       ),
//                     ]),
//                   ]),
//                 );
//               }),
//               const SizedBox(height: _DS.p16),
//               Obx(() => _PrimaryBtn(
//                 label: 'Save All Timings',
//                 icon: Icons.save_rounded,
//                 loading: c.isUpdatingTimings.value,
//                 onPressed: c.isUpdatingTimings.value ? null : c.updateTimings,
//               )),
//             ],
//           );
//         }),
//       ]),
//     );
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   // TAB 3 — MENU
//   // ═══════════════════════════════════════════════════════════════════════════
//   Widget _buildMenuTab(BuildContext context) => SingleChildScrollView(
//     padding: const EdgeInsets.all(_DS.p20),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const SizedBox(height: 4),
//
//       // ── Inline edit form ──
//       Obx(() {
//         final sel = c.selectedMenuItem.value;
//         if (sel == null) return const SizedBox();
//         final color = _mealColor(sel.mealType);
//         return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           _SectionHeader('Edit Menu Item',
//               subtitle: 'Updating: ${sel.foodName} (${sel.mealType.capitalizeFirst})'),
//           _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Row(children: [
//               Expanded(
//                 flex: 2,
//                 child: TextField(
//                   controller: c.menuNameCtrl,
//                   style: const TextStyle(color: _DS.textPrimary),
//                   decoration: _field('Food Name'),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: TextField(
//                   controller: c.menuPriceCtrl,
//                   style: const TextStyle(color: _DS.textPrimary),
//                   keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                   decoration: _field('Price ₹'),
//                 ),
//               ),
//             ]),
//             const SizedBox(height: 10),
//             TextField(
//               controller: c.menuDescCtrl,
//               style: const TextStyle(color: _DS.textPrimary),
//               maxLines: 2,
//               decoration: _field('Description'),
//             ),
//             const SizedBox(height: 10),
//             // Current image preview
//             if (sel.imageUrl.isNotEmpty) ...[
//               Text('Current Image', style: _DS.tsMuted),
//               const SizedBox(height: 6),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.network(
//                   sel.imageUrl,
//                   height: 90,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => const SizedBox(),
//                 ),
//               ),
//               const SizedBox(height: 8),
//             ],
//             // New image picker
//             Obx(() => c.pickedMenuImage.value != null
//                 ? Stack(children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.file(
//                   c.pickedMenuImage.value!,
//                   height: 110,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 8, right: 8,
//                 child: GestureDetector(
//                   onTap: () => c.pickedMenuImage.value = null,
//                   child: Container(
//                     decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
//                     padding: const EdgeInsets.all(4),
//                     child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
//                   ),
//                 ),
//               ),
//             ])
//                 : GestureDetector(
//               onTap: c.pickMenuImage,
//               child: Container(
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: _DS.surfaceElevated,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: _DS.border),
//                 ),
//                 child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   Icon(Icons.add_photo_alternate_outlined, color: color, size: 18),
//                   const SizedBox(width: 8),
//                   Text('Replace Photo', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
//                 ]),
//               ),
//             )),
//             const SizedBox(height: _DS.p16),
//             Row(children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: _DS.textSecondary,
//                     side: const BorderSide(color: _DS.border),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   icon: const Icon(Icons.close_rounded, size: 16),
//                   label: const Text('Cancel'),
//                   onPressed: c.clearMenuItemSelection,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 2,
//                 child: Obx(() => _PrimaryBtn(
//                   label: 'Update Item',
//                   icon: Icons.save_rounded,
//                   loading: c.isUpdatingMenuItem.value,
//                   color: color,
//                   onPressed: c.isUpdatingMenuItem.value ? null : c.updateMenuItem,
//                 )),
//               ),
//             ]),
//           ])),
//           const SizedBox(height: _DS.p8),
//         ]);
//       }),
//
//       const _SectionHeader('Menu Items', subtitle: 'Tap an item to edit it'),
//       Obx(() {
//         if (c.isLoadingMenuItems.value) {
//           return const Center(child: Padding(
//             padding: EdgeInsets.all(40),
//             child: CircularProgressIndicator(color: _DS.amber),
//           ));
//         }
//         if (c.menuItems.isEmpty) {
//           return const _EmptyState(
//             icon: Icons.menu_book_outlined,
//             message: 'No menu items found',
//             sub: 'Items for this restaurant will appear here',
//           );
//         }
//         return Column(
//           children: ['breakfast', 'lunch', 'dinner'].map((meal) {
//             final items = c.getMenuItemsByMeal(meal);
//             if (items.isEmpty) return const SizedBox();
//             return _MealSection(mealType: meal, items: items, tag: restaurantId.toString());
//           }).toList(),
//         );
//       }),
//     ]),
//   );
// }
//
// // ─── Table Card ──────────────────────────────────────────────────────────────
// class _TableCard extends StatelessWidget {
//   final RestaurantTableModel table;
//   final String tag;
//   const _TableCard({required this.table, required this.tag});
//
//   RestaurantMenuUpdateController get c =>
//       Get.find<RestaurantMenuUpdateController>(tag: tag);
//
//   @override
//   Widget build(BuildContext context) => Obx(() {
//     final isSelected = c.selectedTable.value?.id == table.id;
//     return Container(
//       margin: const EdgeInsets.only(bottom: _DS.p8),
//       decoration: BoxDecoration(
//         color: _DS.surface,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: isSelected ? _DS.amber.withOpacity(0.5) : _DS.border,
//           width: isSelected ? 1.5 : 1.0,
//         ),
//         boxShadow: [_DS.cardShadow],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: _DS.p16, vertical: _DS.p8),
//         leading: Container(
//           width: 48, height: 48,
//           decoration: BoxDecoration(
//             color: isSelected ? _DS.amberDim : _DS.surfaceElevated,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(Icons.table_restaurant, color: isSelected ? _DS.amber : _DS.textMuted, size: 22),
//         ),
//         title: Text(table.tableType, style: _DS.tsLabel),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 4),
//           child: Wrap(spacing: 6, runSpacing: 4, children: [
//             _InfoChip('${table.capacityRange} seats', Icons.people_outline),
//             _InfoChip(table.seatingType.capitalizeFirst!, Icons.chair_outlined),
//             _InfoChip(table.tableName, Icons.grid_view_rounded),
//           ]),
//         ),
//         isThreeLine: true,
//         trailing: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: isSelected ? _DS.amberDim : _DS.surfaceElevated,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             isSelected ? Icons.edit_rounded : Icons.edit_outlined,
//             color: isSelected ? _DS.amber : _DS.textMuted,
//             size: 18,
//           ),
//         ),
//         onTap: () => isSelected ? c.clearTableSelection() : c.selectTableForEdit(table),
//       ),
//     );
//   });
// }
//
// // ─── Meal Section (Menu Tab) ─────────────────────────────────────────────────
// class _MealSection extends StatelessWidget {
//   final String mealType;
//   final List<MenuItemModel> items;
//   final String tag;
//   const _MealSection({required this.mealType, required this.items, required this.tag});
//
//   RestaurantMenuUpdateController get c =>
//       Get.find<RestaurantMenuUpdateController>(tag: tag);
//
//   @override
//   Widget build(BuildContext context) {
//     final color = _mealColor(mealType);
//     final expanded = c.expandedMeals[mealType]!;
//
//     return Obx(() => Container(
//       margin: const EdgeInsets.only(bottom: _DS.p12),
//       decoration: BoxDecoration(
//         color: _DS.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: expanded.value ? color.withOpacity(0.4) : _DS.border,
//           width: expanded.value ? 1.5 : 1.0,
//         ),
//         boxShadow: [_DS.cardShadow],
//       ),
//       child: Column(children: [
//         // Header
//         InkWell(
//           onTap: () => expanded.value = !expanded.value,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(_DS.p16),
//             child: Row(children: [
//               Container(
//                 width: 44, height: 44,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft, end: Alignment.bottomRight,
//                     colors: [color, Color.lerp(color, Colors.black, 0.25)!],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(_mealIcon(mealType), color: Colors.white, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(mealType.capitalizeFirst!,
//                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
//                   Text('${items.length} item${items.length != 1 ? 's' : ''}', style: _DS.tsMuted),
//                 ]),
//               ),
//               AnimatedRotation(
//                 turns: expanded.value ? 0.5 : 0,
//                 duration: const Duration(milliseconds: 250),
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(Icons.expand_more_rounded, color: color, size: 20),
//                 ),
//               ),
//             ]),
//           ),
//         ),
//
//         // Items list
//         if (expanded.value) ...[
//           Divider(color: _DS.border, height: 1),
//           Padding(
//             padding: const EdgeInsets.all(_DS.p12),
//             child: Column(
//               children: items.map((food) => _MenuItemCard(item: food, color: color, tag: tag)).toList(),
//             ),
//           ),
//         ],
//       ]),
//     ));
//   }
// }
//
// // ─── Menu Item Card ──────────────────────────────────────────────────────────
// class _MenuItemCard extends StatelessWidget {
//   final MenuItemModel item;
//   final Color color;
//   final String tag;
//   const _MenuItemCard({required this.item, required this.color, required this.tag});
//
//   RestaurantMenuUpdateController get c =>
//       Get.find<RestaurantMenuUpdateController>(tag: tag);
//
//   @override
//   Widget build(BuildContext context) => Obx(() {
//     final isSelected = c.selectedMenuItem.value?.id == item.id;
//     return GestureDetector(
//       onTap: () => isSelected
//           ? c.clearMenuItemSelection()
//           : c.selectMenuItemForEdit(item),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: _DS.p8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? color.withOpacity(0.04) : _DS.surfaceElevated,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? color.withOpacity(0.35) : _DS.border,
//             width: isSelected ? 1.5 : 1.0,
//           ),
//         ),
//         child: Row(children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: item.imageUrl.isNotEmpty
//                 ? Image.network(item.imageUrl, width: 52, height: 52, fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => _placeholder(color))
//                 : _placeholder(color),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(item.foodName, style: _DS.tsLabel.copyWith(fontSize: 14)),
//               if (item.shortDescription.isNotEmpty)
//                 Text(item.shortDescription,
//                     maxLines: 1, overflow: TextOverflow.ellipsis, style: _DS.tsMuted),
//               const SizedBox(height: 3),
//               Text('₹ ${item.price.toStringAsFixed(2)}', style: _DS.tsPrice),
//             ]),
//           ),
//           Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: isSelected ? color.withOpacity(0.12) : _DS.surfaceElevated,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: isSelected ? color.withOpacity(0.3) : _DS.border),
//             ),
//             child: Icon(
//               isSelected ? Icons.edit_rounded : Icons.edit_outlined,
//               size: 16,
//               color: isSelected ? color : _DS.textMuted,
//             ),
//           ),
//         ]),
//       ),
//     );
//   });
//
//   Widget _placeholder(Color color) => Container(
//     width: 52, height: 52,
//     decoration: BoxDecoration(color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(10)),
//     child: Icon(Icons.fastfood_rounded, color: color, size: 22),
//   );
// }
//
// // ─── Info Chip ───────────────────────────────────────────────────────────────
// class _InfoChip extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   const _InfoChip(this.label, this.icon);
//
//   @override
//   Widget build(BuildContext context) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//     decoration: BoxDecoration(
//       color: _DS.surfaceElevated,
//       borderRadius: BorderRadius.circular(6),
//       border: Border.all(color: _DS.border),
//     ),
//     child: Row(mainAxisSize: MainAxisSize.min, children: [
//       Icon(icon, size: 11, color: _DS.textSecondary),
//       const SizedBox(width: 4),
//       Text(label, style: _DS.tsMuted.copyWith(fontSize: 11)),
//     ]),
//   );
// }
//
// // ─── Icon Button ─────────────────────────────────────────────────────────────
// class _IconBtn extends StatelessWidget {
//   final IconData icon;
//   final String tooltip;
//   final VoidCallback onTap;
//   const _IconBtn({required this.icon, required this.tooltip, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.only(right: 8),
//     child: Tooltip(
//       message: tooltip,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(color: _DS.amberDim, borderRadius: BorderRadius.circular(8)),
//           child: Icon(icon, color: _DS.amber, size: 18),
//         ),
//       ),
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/admin_restarant_menuupdatemodel.dart';
import 'controller/restaurant_menuupdatecontroller.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
class _DS {
  static const bg              = Color(0xFFF5F6FA);
  static const surface         = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFF0F1F8);
  static const border          = Color(0xFFE0E3F0);
  static const amber           = Color(0xFFE07B00);
  static const amberSoft       = Color(0xFFF5A623);
  static const amberDim        = Color(0x1AE07B00);
  static const textPrimary     = Color(0xFF1A1D2E);
  static const textSecondary   = Color(0xFF5C6080);
  static const textMuted       = Color(0xFF9BA3C2);
  static const success         = Color(0xFF1DA87A);
  static const successDim      = Color(0x1A1DA87A);
  static const danger          = Color(0xFFE05252);
  static const dangerDim       = Color(0x1AE05252);
  static const mealBreakfast   = Color(0xFFE07B00);
  static const mealLunch       = Color(0xFF0AA0A0);
  static const mealDinner      = Color(0xFF7B4FA6);

  static const p4  = 4.0;
  static const p8  = 8.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p32 = 32.0;

  static final cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.06),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );

  static const tsPageTitle = TextStyle(
    fontFamily: 'Georgia', fontSize: 19, fontWeight: FontWeight.w700,
    color: textPrimary, letterSpacing: 0.2,
  );
  static const tsSectionTitle = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w700, color: amber, letterSpacing: 2.0,
  );
  static const tsLabel = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary);
  static const tsBody  = TextStyle(fontSize: 14, color: textSecondary, height: 1.5);
  static const tsMuted = TextStyle(fontSize: 12, color: textMuted);
  static const tsPrice = TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: success, letterSpacing: 0.3);
}

// ─── Shared Helpers ──────────────────────────────────────────────────────────
InputDecoration _field(String label, {Widget? suffix, String? hint}) => InputDecoration(
  labelText: label,
  hintText: hint,
  labelStyle: const TextStyle(color: _DS.textSecondary, fontSize: 13),
  hintStyle: const TextStyle(color: _DS.textMuted, fontSize: 13),
  suffixIcon: suffix,
  filled: true,
  fillColor: _DS.surfaceElevated,
  contentPadding: const EdgeInsets.symmetric(horizontal: _DS.p16, vertical: _DS.p12),
  border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _DS.border)),
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _DS.border)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _DS.amber, width: 1.5)),
);

Color _mealColor(String m) {
  switch (m) {
    case 'breakfast': return _DS.mealBreakfast;
    case 'lunch':     return _DS.mealLunch;
    case 'dinner':    return _DS.mealDinner;
    default:          return _DS.amber;
  }
}

IconData _mealIcon(String m) {
  switch (m) {
    case 'breakfast': return Icons.free_breakfast_outlined;
    case 'lunch':     return Icons.lunch_dining_outlined;
    case 'dinner':    return Icons.dinner_dining_outlined;
    default:          return Icons.restaurant_outlined;
  }
}

// ─── Primary Button ──────────────────────────────────────────────────────────
class _PrimaryBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool loading;
  final VoidCallback? onPressed;
  final Color? color;

  const _PrimaryBtn({
    required this.label,
    required this.icon,
    required this.loading,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? _DS.amber;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: onPressed == null
                ? [_DS.textMuted, _DS.textMuted]
                : [c, Color.lerp(c, Colors.white, 0.15)!],
          ),
          boxShadow: onPressed != null
              ? [BoxShadow(color: c.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 4))]
              : [],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: loading
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : Icon(icon, size: 18),
          label: Text(loading ? 'Saving…' : label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionHeader(this.title, {this.subtitle});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: _DS.p16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title.toUpperCase(), style: _DS.tsSectionTitle),
      if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle!, style: _DS.tsBody)],
    ]),
  );
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(vertical: _DS.p8),
    padding: padding ?? const EdgeInsets.all(_DS.p20),
    decoration: BoxDecoration(
      color: _DS.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _DS.border),
      boxShadow: [_DS.cardShadow],
    ),
    child: child,
  );
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String sub;
  const _EmptyState({required this.icon, required this.message, required this.sub});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(40),
    alignment: Alignment.center,
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _DS.surfaceElevated, shape: BoxShape.circle, border: Border.all(color: _DS.border),
        ),
        child: Icon(icon, size: 32, color: _DS.textMuted),
      ),
      const SizedBox(height: 16),
      Text(message, style: _DS.tsLabel.copyWith(color: _DS.textSecondary)),
      const SizedBox(height: 4),
      Text(sub, style: _DS.tsMuted),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class MenuUpdatePage extends StatelessWidget {
  final int restaurantId;

  const MenuUpdatePage({super.key, required this.restaurantId});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: restaurantId.toString());

  @override
  Widget build(BuildContext context) {
    Get.put(
      RestaurantMenuUpdateController(restaurantId: restaurantId),
      tag: restaurantId.toString(),
    );

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: _DS.bg,
        colorScheme: const ColorScheme.light(primary: _DS.amber, surface: _DS.surface),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: _DS.bg,
          appBar: _buildAppBar(),
          body: TabBarView(
            children: [
              _buildTablesTab(context),
              _buildTimingsTab(context),
              _buildMenuTab(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    backgroundColor: _DS.surface,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    leading: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: _DS.amberDim, borderRadius: BorderRadius.circular(10)),
      child: const Icon(Icons.edit_note_rounded, color: _DS.amber, size: 20),
    ),
    title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Update Menu', style: _DS.tsPageTitle),
      Text('Restaurant #$restaurantId', style: _DS.tsMuted),
    ]),
    actions: [
      Obx(() {
        final loading = c.isLoadingTables.value || c.isLoadingTimings.value || c.isLoadingMenuItems.value;
        return loading
            ? const Padding(
          padding: EdgeInsets.all(14),
          child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _DS.amber, strokeWidth: 2)),
        )
            : _IconBtn(icon: Icons.refresh_rounded, tooltip: 'Refresh All', onTap: c.fetchAll);
      }),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: _DS.border))),
        child: const TabBar(
          labelColor: _DS.amber,
          unselectedLabelColor: _DS.textSecondary,
          indicatorColor: _DS.amber,
          indicatorWeight: 2.5,
          labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          tabs: [
            Tab(text: 'TABLES'),
            Tab(text: 'TIMINGS'),
            Tab(text: 'MENU'),
          ],
        ),
      ),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 1 — TABLES
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTablesTab(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(_DS.p20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 4),

      Obx(() {
        final sel = c.selectedTable.value;
        if (sel == null) return const SizedBox();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _SectionHeader('Edit Table', subtitle: 'Updating: ${sel.tableType}'),
          _Card(child: Column(children: [
            TextField(
              controller: c.tableTypeCtrl,
              style: const TextStyle(color: _DS.textPrimary),
              decoration: _field('Table Type / Name'),
            ),
            const SizedBox(height: _DS.p12),
            TextField(
              controller: c.capacityRangeCtrl,
              style: const TextStyle(color: _DS.textPrimary),
              decoration: _field('Capacity Range', hint: 'e.g. 2–6'),
            ),
            const SizedBox(height: _DS.p12),
            TextField(
              controller: c.tableNameCtrl,
              style: const TextStyle(color: _DS.textPrimary, letterSpacing: 1.0),
              textCapitalization: TextCapitalization.characters,
              decoration: _field('Table IDs (comma-separated)', hint: 'T1, T2, T3'),
            ),
            const SizedBox(height: _DS.p12),
            Obx(() => DropdownButtonFormField<SeatingTypeUpdate>(
              value: c.seatingTypeEdit.value,
              dropdownColor: _DS.surface,
              style: const TextStyle(color: _DS.textPrimary, fontSize: 14),
              decoration: _field('Seating Type'),
              items: SeatingTypeUpdate.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name.capitalizeFirst!)))
                  .toList(),
              onChanged: (v) => c.seatingTypeEdit.value = v!,
            )),
            const SizedBox(height: _DS.p20),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _DS.textSecondary,
                    side: const BorderSide(color: _DS.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text('Cancel'),
                  onPressed: c.clearTableSelection,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Obx(() => _PrimaryBtn(
                  label: 'Save Changes',
                  icon: Icons.save_rounded,
                  loading: c.isUpdatingTable.value,
                  onPressed: c.isUpdatingTable.value ? null : c.updateTable,
                )),
              ),
            ]),
          ])),
          const SizedBox(height: _DS.p8),
        ]);
      }),

      const _SectionHeader('Restaurant Tables', subtitle: 'Tap a table to edit its details'),
      Obx(() {
        if (c.isLoadingTables.value) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: _DS.amber),
          ));
        }
        if (c.tables.isEmpty) {
          return const _EmptyState(
            icon: Icons.table_restaurant_outlined,
            message: 'No tables found',
            sub: 'Tables for this restaurant will appear here',
          );
        }
        return Column(
          children: c.tables.map((table) => _TableCard(table: table, tag: restaurantId.toString())).toList(),
        );
      }),
    ]),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 2 — TIMINGS  ✅ FIXED: time picker now outputs "10:30 AM" format
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTimingsTab(BuildContext context) {

    // ✅ FIX: Parse existing "10:30 AM" text → TimeOfDay for picker initial value
    // Then format the picked time back to "10:30 AM" via controller helper
    Future<void> pickTime(TextEditingController ctrl) async {
      final controller = Get.find<RestaurantMenuUpdateController>(
        tag: restaurantId.toString(),
      );

      // Parse current value (could be "10:30 AM" or "10:30:00" or "10:30")
      final initial = controller.parseTimeToTimeOfDay(ctrl.text);

      final picked = await showTimePicker(
        context: context,
        initialTime: initial,
        builder: (ctx, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _DS.amber,
              onPrimary: Colors.white,
              surface: _DS.surface,
              onSurface: _DS.textPrimary,
            ),
          ),
          child: child!,
        ),
      );

      if (picked != null) {
        // ✅ FIX: Write "10:30 AM" format — NOT "10:30"
        ctrl.text = controller.formatTimeTo12h(picked);
        debugPrint('🕐 Time picked: ${ctrl.text}');
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(_DS.p20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 4),

        // Info banner
        Container(
          margin: const EdgeInsets.only(bottom: _DS.p16),
          padding: const EdgeInsets.all(_DS.p12),
          decoration: BoxDecoration(
            color: _DS.amberDim,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _DS.amber.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline_rounded, color: _DS.amber, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Times are saved in 12-hour format (e.g. 10:30 AM). '
                      'Tap the clock icon to pick a time and tap "Save All Timings" to apply.',
                  style: TextStyle(color: _DS.amber, fontSize: 12, height: 1.5),
                ),
              ),
            ],
          ),
        ),

        const _SectionHeader('Meal Timings', subtitle: 'Adjust service windows for each meal period'),

        Obx(() {
          if (c.isLoadingTimings.value) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: _DS.amber),
            ));
          }
          if (c.timings.isEmpty) {
            return const _EmptyState(
              icon: Icons.schedule_outlined,
              message: 'No timings found',
              sub: 'Add timings from the Menu Management page',
            );
          }

          return Column(
            children: [
              ...['breakfast', 'lunch', 'dinner'].map((meal) {
                final timing = c.getTimingByMeal(meal);
                if (timing == null) return const SizedBox();

                final ctrls = c.timingControllers[meal];
                if (ctrls == null) return const SizedBox();

                final color = _mealColor(meal);

                return _Card(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Meal header row
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(_mealIcon(meal), color: color, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(meal.capitalizeFirst!, style: _DS.tsLabel),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ID: ${timing.id}',
                          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),
                    const SizedBox(height: _DS.p16),

                    // ✅ Time pickers — now output "10:30 AM" format
                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: ctrls['start'],
                          readOnly: true,
                          style: const TextStyle(color: _DS.textPrimary),
                          onTap: () => pickTime(ctrls['start']!),
                          decoration: _field(
                            'Start Time',
                            suffix: Icon(Icons.schedule, size: 18, color: color),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.arrow_forward, color: _DS.textMuted, size: 18),
                      ),
                      Expanded(
                        child: TextField(
                          controller: ctrls['end'],
                          readOnly: true,
                          style: const TextStyle(color: _DS.textPrimary),
                          onTap: () => pickTime(ctrls['end']!),
                          decoration: _field(
                            'End Time',
                            suffix: Icon(Icons.schedule, size: 18, color: color),
                          ),
                        ),
                      ),
                    ]),
                  ]),
                );
              }),
              const SizedBox(height: _DS.p16),
              Obx(() => _PrimaryBtn(
                label: 'Save All Timings',
                icon: Icons.save_rounded,
                loading: c.isUpdatingTimings.value,
                onPressed: c.isUpdatingTimings.value ? null : c.updateTimings,
              )),
            ],
          );
        }),
      ]),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB 3 — MENU
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMenuTab(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(_DS.p20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 4),

      // Inline edit form
      Obx(() {
        final sel = c.selectedMenuItem.value;
        if (sel == null) return const SizedBox();
        final color = _mealColor(sel.mealType);
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _SectionHeader('Edit Menu Item',
              subtitle: 'Updating: ${sel.foodName} (${sel.mealType.capitalizeFirst})'),
          _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: c.menuNameCtrl,
                  style: const TextStyle(color: _DS.textPrimary),
                  decoration: _field('Food Name'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: c.menuPriceCtrl,
                  style: const TextStyle(color: _DS.textPrimary),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _field('Price ₹'),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            TextField(
              controller: c.menuDescCtrl,
              style: const TextStyle(color: _DS.textPrimary),
              maxLines: 2,
              decoration: _field('Description'),
            ),
            const SizedBox(height: 10),

            // Current image
            if (sel.imageUrl.isNotEmpty) ...[
              Text('Current Image', style: _DS.tsMuted),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  sel.imageUrl,
                  height: 90, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // New image picker
            Obx(() => c.pickedMenuImage.value != null
                ? Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  c.pickedMenuImage.value!,
                  height: 110, width: double.infinity, fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8, right: 8,
                child: GestureDetector(
                  onTap: () => c.pickedMenuImage.value = null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6), shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ])
                : GestureDetector(
              onTap: c.pickMenuImage,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: _DS.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _DS.border),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.add_photo_alternate_outlined, color: color, size: 18),
                  const SizedBox(width: 8),
                  Text('Replace Photo',
                      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
                ]),
              ),
            )),

            const SizedBox(height: _DS.p16),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _DS.textSecondary,
                    side: const BorderSide(color: _DS.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text('Cancel'),
                  onPressed: c.clearMenuItemSelection,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Obx(() => _PrimaryBtn(
                  label: 'Update Item',
                  icon: Icons.save_rounded,
                  loading: c.isUpdatingMenuItem.value,
                  color: color,
                  onPressed: c.isUpdatingMenuItem.value ? null : c.updateMenuItem,
                )),
              ),
            ]),
          ])),
          const SizedBox(height: _DS.p8),
        ]);
      }),

      const _SectionHeader('Menu Items', subtitle: 'Tap an item to edit it'),
      Obx(() {
        if (c.isLoadingMenuItems.value) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: _DS.amber),
          ));
        }
        if (c.menuItems.isEmpty) {
          return const _EmptyState(
            icon: Icons.menu_book_outlined,
            message: 'No menu items found',
            sub: 'Items for this restaurant will appear here',
          );
        }
        return Column(
          children: ['breakfast', 'lunch', 'dinner'].map((meal) {
            final items = c.getMenuItemsByMeal(meal);
            if (items.isEmpty) return const SizedBox();
            return _MealSection(mealType: meal, items: items, tag: restaurantId.toString());
          }).toList(),
        );
      }),
    ]),
  );
}

// ─── Table Card ──────────────────────────────────────────────────────────────
class _TableCard extends StatelessWidget {
  final RestaurantTableModel table;
  final String tag;
  const _TableCard({required this.table, required this.tag});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) => Obx(() {
    final isSelected = c.selectedTable.value?.id == table.id;
    return Container(
      margin: const EdgeInsets.only(bottom: _DS.p8),
      decoration: BoxDecoration(
        color: _DS.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? _DS.amber.withOpacity(0.5) : _DS.border,
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [_DS.cardShadow],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: _DS.p16, vertical: _DS.p8),
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: isSelected ? _DS.amberDim : _DS.surfaceElevated,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.table_restaurant,
              color: isSelected ? _DS.amber : _DS.textMuted, size: 22),
        ),
        title: Text(table.tableType, style: _DS.tsLabel),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(spacing: 6, runSpacing: 4, children: [
            _InfoChip('${table.capacityRange} seats', Icons.people_outline),
            _InfoChip(table.seatingType.capitalizeFirst!, Icons.chair_outlined),
            _InfoChip(table.tableName, Icons.grid_view_rounded),
          ]),
        ),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? _DS.amberDim : _DS.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSelected ? Icons.edit_rounded : Icons.edit_outlined,
            color: isSelected ? _DS.amber : _DS.textMuted,
            size: 18,
          ),
        ),
        onTap: () => isSelected ? c.clearTableSelection() : c.selectTableForEdit(table),
      ),
    );
  });
}

// ─── Meal Section ─────────────────────────────────────────────────────────────
class _MealSection extends StatelessWidget {
  final String mealType;
  final List<MenuItemModel> items;
  final String tag;
  const _MealSection({required this.mealType, required this.items, required this.tag});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) {
    final color    = _mealColor(mealType);
    final expanded = c.expandedMeals[mealType]!;

    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: _DS.p12),
      decoration: BoxDecoration(
        color: _DS.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: expanded.value ? color.withOpacity(0.4) : _DS.border,
          width: expanded.value ? 1.5 : 1.0,
        ),
        boxShadow: [_DS.cardShadow],
      ),
      child: Column(children: [
        InkWell(
          onTap: () => expanded.value = !expanded.value,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(_DS.p16),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [color, Color.lerp(color, Colors.black, 0.25)!],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_mealIcon(mealType), color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(mealType.capitalizeFirst!,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
                  Text('${items.length} item${items.length != 1 ? 's' : ''}', style: _DS.tsMuted),
                ]),
              ),
              AnimatedRotation(
                turns: expanded.value ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.expand_more_rounded, color: color, size: 20),
                ),
              ),
            ]),
          ),
        ),
        if (expanded.value) ...[
          Divider(color: _DS.border, height: 1),
          Padding(
            padding: const EdgeInsets.all(_DS.p12),
            child: Column(
              children: items.map((food) => _MenuItemCard(item: food, color: color, tag: tag)).toList(),
            ),
          ),
        ],
      ]),
    ));
  }
}

// ─── Menu Item Card ──────────────────────────────────────────────────────────
class _MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final Color color;
  final String tag;
  const _MenuItemCard({required this.item, required this.color, required this.tag});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) => Obx(() {
    final isSelected = c.selectedMenuItem.value?.id == item.id;
    return GestureDetector(
      onTap: () => isSelected
          ? c.clearMenuItemSelection()
          : c.selectMenuItemForEdit(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: _DS.p8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.04) : _DS.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.35) : _DS.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.imageUrl.isNotEmpty
                ? Image.network(
              item.imageUrl, width: 52, height: 52, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(color),
            )
                : _placeholder(color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.foodName, style: _DS.tsLabel.copyWith(fontSize: 14)),
              if (item.shortDescription.isNotEmpty)
                Text(item.shortDescription,
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: _DS.tsMuted),
              const SizedBox(height: 3),
              Text('₹ ${item.price.toStringAsFixed(2)}', style: _DS.tsPrice),
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.12) : _DS.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? color.withOpacity(0.3) : _DS.border),
            ),
            child: Icon(
              isSelected ? Icons.edit_rounded : Icons.edit_outlined,
              size: 16,
              color: isSelected ? color : _DS.textMuted,
            ),
          ),
        ]),
      ),
    );
  });

  Widget _placeholder(Color color) => Container(
    width: 52, height: 52,
    decoration: BoxDecoration(
      color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(Icons.fastfood_rounded, color: color, size: 22),
  );
}

// ─── Info Chip ───────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip(this.label, this.icon);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: _DS.surfaceElevated,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: _DS.border),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11, color: _DS.textSecondary),
      const SizedBox(width: 4),
      Text(label, style: _DS.tsMuted.copyWith(fontSize: 11)),
    ]),
  );
}


class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _DS.amberDim, borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _DS.amber, size: 18),
        ),
      ),
    ),
  );
}