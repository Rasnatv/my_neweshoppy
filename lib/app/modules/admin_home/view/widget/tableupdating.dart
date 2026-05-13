// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../common/style/app_colors.dart';
// import '../../../../data/models/admin_restarant_menuupdatemodel.dart';
// import '../../../../widgets/delete_widget.dart';
// import '../restaurant/controller/restaurant_menuupdatecontroller.dart';
//
// import 'menuuihelper.dart';
//
// // ─── Tables Tab ───────────────────────────────────────────────────────────────
// class TablesTab extends StatelessWidget {
//   final String tag;
//   const TablesTab({super.key, required this.tag});
//
//   RestaurantMenuUpdateController get c =>
//       Get.find<RestaurantMenuUpdateController>(tag: tag);
//
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//     child: Column(children: [
//       gradientStrip(),
//       Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Mode Toggle
//             Obx(() => modeToggle(
//               leftLabel: 'Existing Tables',
//               rightLabel: 'Add New Table',
//               leftIcon: Icons.table_restaurant_outlined,
//               rightIcon: Icons.add_circle_outline_rounded,
//               isAddMode: c.tableTabMode.value == TabMode.addNew,
//               onToggle: (addMode) => c.tableTabMode.value =
//               addMode ? TabMode.addNew : TabMode.existing,
//             )),
//             const SizedBox(height: 20),
//
//             // Add New Form
//             Obx(() {
//               if (c.tableTabMode.value != TabMode.addNew)
//                 return const SizedBox();
//               return _AddTableForm(tag: tag);
//             }),
//
//             // Existing Tables
//             Obx(() {
//               if (c.tableTabMode.value != TabMode.existing)
//                 return const SizedBox();
//               return _ExistingTables(tag: tag, context: context);
//             }),
//           ],
//         ),
//       ),
//     ]),
//   );
// }
//
// // ─── Add Table Form ───────────────────────────────────────────────────────────
// class _AddTableForm extends StatelessWidget {
//   final String tag;
//   const _AddTableForm({required this.tag});
//
//   RestaurantMenuUpdateController get c =>
//       Get.find<RestaurantMenuUpdateController>(tag: tag);
//
//   @override
//   Widget build(BuildContext context) => buildCard(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         sectionHeader(
//           icon: Icons.add_circle_outline_rounded,
//           title: 'Add Table Type',
//           subtitle: 'Configure new seating for your restaurant',
//         ),
//         const SizedBox(height: 20),
//         modernTextField(
//           controller: c.addTableTypeCtrl,
//           label: 'Table Name',
//           hint: 'e.g. 6 Seater, VIP Booth',
//           icon: Icons.table_restaurant_outlined,
//         ),
//         const SizedBox(height: 16),
//         modernTextField(
//           controller: c.addCapacityRangeCtrl,
//           label: 'Capacity Range',
//           hint: 'e.g. 2–6 or 4',
//           icon: Icons.people_outline,
//         ),
//         const SizedBox(height: 16),
//         modernTextField(
//           controller: c.addTableIdsCtrl,
//           label: 'Table IDs (comma-separated)',
//           hint: 'T1, T2, T3',
//           icon: Icons.grid_view_rounded,
//         ),
//         const SizedBox(height: 16),
//         Obx(() => modernDropdown<SeatingTypeUpdate>(
//           label: 'Seating Arrangement',
//           icon: Icons.chair_outlined,
//           value: c.addSeatingType.value,
//           items: SeatingTypeUpdate.values,
//           itemLabel: (e) => e.name.capitalizeFirst!,
//           onChanged: (v) => c.addSeatingType.value = v!,
//         )),
//         const SizedBox(height: 24),
//         Obx(() => primaryBtn(
//           label: 'Add Table Type',
//           icon: Icons.add_rounded,
//           loading: c.isAddingTable.value,
//           onPressed: c.isAddingTable.value ? null : c.submitAddTable,
//         )),
//       ],
//     ),
//   );
// }
//
// // ─── Existing Tables ──────────────────────────────────────────────────────────
// class _ExistingTables extends StatelessWidget {
//   final String tag;
//   final BuildContext context;
//   const _ExistingTables({required this.tag, required this.context});
//
//   RestaurantMenuUpdateController get c =>
//       Get.find<RestaurantMenuUpdateController>(tag: tag);
//
//   @override
//   Widget build(BuildContext ctx) => Column(children: [
//     // Edit form when table selected
//     Obx(() {
//       final sel = c.selectedTable.value;
//       if (sel == null) return const SizedBox();
//       return Column(children: [
//         _TableEditForm(tag: tag, table: sel),
//         const SizedBox(height: 20),
//       ]);
//     }),
//
//     // Tables list
//     buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           sectionHeader(
//             icon: Icons.table_restaurant_rounded,
//             title: 'Restaurant Tables',
//             subtitle: 'Tap a table to edit its details',
//           ),
//           const SizedBox(height: 16),
//           Obx(() {
//             if (c.isLoadingTables.value) return loadingIndicator();
//             if (c.tables.isEmpty)
//               return emptyState(
//                 icon: Icons.table_restaurant_outlined,
//                 message: 'No tables found',
//                 sub: 'Switch to "Add New Table" to create one',
//               );
//             return Column(
//               children: c.tables
//                   .map((t) => TableCard(
//                   table: t, tag: tag, context: context))
//                   .toList(),
//             );
//           }),
//         ],
//       ),
//     ),
//   ]);
// }
//
// // ─── Table Edit Form ──────────────────────────────────────────────────────────
// class _TableEditForm extends StatelessWidget {
//   final String tag;
//   final RestaurantTableModel table;
//   const _TableEditForm({required this.tag, required this.table});
//
//   RestaurantMenuUpdateController get c =>
//       Get.find<RestaurantMenuUpdateController>(tag: tag);
//
//   @override
//   Widget build(BuildContext context) => buildCard(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         sectionHeader(
//           icon: Icons.edit_rounded,
//           title: 'Edit Table',
//           subtitle: 'Updating: ${table.tableType}',
//         ),
//         const SizedBox(height: 20),
//         modernTextField(
//           controller: c.tableTypeCtrl,
//           label: 'Table Type / Name',
//           hint: 'e.g. Round Table, VIP Booth',
//           icon: Icons.table_restaurant_outlined,
//         ),
//         const SizedBox(height: 16),
//         modernTextField(
//           controller: c.capacityRangeCtrl,
//           label: 'Capacity Range',
//           hint: 'e.g. 2–6',
//           icon: Icons.people_outline,
//         ),
//         const SizedBox(height: 16),
//         modernTextField(
//           controller: c.tableNameCtrl,
//           label: 'Table IDs (comma-separated)',
//           hint: 'T1, T2, T3',
//           icon: Icons.grid_view_rounded,
//         ),
//         const SizedBox(height: 16),
//         Obx(() => modernDropdown<SeatingTypeUpdate>(
//           label: 'Seating Type',
//           icon: Icons.chair_outlined,
//           value: c.seatingTypeEdit.value,
//           items: SeatingTypeUpdate.values,
//           itemLabel: (e) => e.name.capitalizeFirst!,
//           onChanged: (v) => c.seatingTypeEdit.value = v!,
//         )),
//         const SizedBox(height: 24),
//         Row(children: [
//           Expanded(
//               child: outlinedBtn(
//                 label: 'Cancel',
//                 icon: Icons.close_rounded,
//                 onPressed: c.clearTableSelection,
//               )),
//           const SizedBox(width: 12),
//           Expanded(
//             flex: 2,
//             child: Obx(() => primaryBtn(
//               label: 'Save Changes',
//               icon: Icons.save_rounded,
//               loading: c.isUpdatingTable.value,
//               onPressed:
//               c.isUpdatingTable.value ? null : c.updateTable,
//             )),
//           ),
//         ]),
//       ],
//     ),
//   );
// }
//
// // ─── Table Card ───────────────────────────────────────────────────────────────
// class TableCard extends StatelessWidget {
//   final RestaurantTableModel table;
//   final String tag;
//   final BuildContext context;
//   const TableCard(
//       {super.key,
//         required this.table,
//         required this.tag,
//         required this.context});
//
//   RestaurantMenuUpdateController get c =>
//       Get.find<RestaurantMenuUpdateController>(tag: tag);
//
//   @override
//   Widget build(BuildContext ctx) => Obx(() {
//     final isSelected = c.selectedTable.value?.id == table.id;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: isSelected
//             ? AppColors.kPrimary.withOpacity(0.04)
//             : Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: isSelected
//               ? AppColors.kPrimary.withOpacity(0.4)
//               : Colors.grey.shade200,
//           width: isSelected ? 1.5 : 1.0,
//         ),
//       ),
//       child: ListTile(
//         contentPadding:
//         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Container(
//           width: 48,
//           height: 48,
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? AppColors.kPrimary.withOpacity(0.12)
//                 : Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(Icons.table_restaurant,
//               color: isSelected
//                   ? AppColors.kPrimary
//                   : Colors.grey.shade400,
//               size: 22),
//         ),
//         title: Text(table.tableType,
//             style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 color: DS.textPrimary)),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 6),
//           child: Wrap(spacing: 6, runSpacing: 4, children: [
//             _chip('${table.capacityRange} seats', Icons.people_outline),
//             _chip(table.seatingType.capitalizeFirst!, Icons.chair_outlined),
//             _chip(table.tableName, Icons.grid_view_rounded),
//           ]),
//         ),
//         isThreeLine: true,
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Edit button
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? AppColors.kPrimary.withOpacity(0.12)
//                     : Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 isSelected ? Icons.edit_rounded : Icons.edit_outlined,
//                 color: isSelected
//                     ? AppColors.kPrimary
//                     : Colors.grey.shade400,
//                 size: 18,
//               ),
//             ),
//             const SizedBox(width: 8),
//             // Delete button
//             Obx(() => c.isDeletingTable.value
//                 ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child:
//                 CircularProgressIndicator(strokeWidth: 2))
//                 : GestureDetector(
//               onTap: () => DeleteConfirmDialog.show(
//                 context: context,
//                 title: 'Delete Table',
//                 message:
//                 'Delete "${table.tableType}"? This cannot be undone.',
//                 onConfirm: () => c.deleteTable(table),
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(Icons.delete_outline_rounded,
//                     color: Colors.red.shade400, size: 18),
//               ),
//             )),
//           ],
//         ),
//         onTap: () => isSelected
//             ? c.clearTableSelection()
//             : c.selectTableForEdit(table),
//       ),
//     );
//   });
//
//   Widget _chip(String label, IconData icon) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//     decoration: BoxDecoration(
//       color: Colors.grey.shade100,
//       borderRadius: BorderRadius.circular(6),
//       border: Border.all(color: Colors.grey.shade200),
//     ),
//     child: Row(mainAxisSize: MainAxisSize.min, children: [
//       Icon(icon, size: 11, color: Colors.grey.shade500),
//       const SizedBox(width: 4),
//       Text(label,
//           style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//     ]),
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../data/models/admin_restarant_menuupdatemodel.dart';
import '../../../../widgets/delete_widget.dart';
import '../restaurant/controller/restaurant_menuupdatecontroller.dart';

import 'menuuihelper.dart';

// ─── Tables Tab ───────────────────────────────────────────────────────────────
class TablesTab extends StatelessWidget {
  final String tag;
  const TablesTab({super.key, required this.tag});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(children: [
      gradientStrip(),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode Toggle
            Obx(() => modeToggle(
              leftLabel: 'Existing Tables',
              rightLabel: 'Add New Table',
              leftIcon: Icons.table_restaurant_outlined,
              rightIcon: Icons.add_circle_outline_rounded,
              isAddMode: c.tableTabMode.value == TabMode.addNew,
              onToggle: (addMode) => c.tableTabMode.value =
              addMode ? TabMode.addNew : TabMode.existing,
            )),
            const SizedBox(height: 20),

            // Add New Form
            Obx(() {
              if (c.tableTabMode.value != TabMode.addNew)
                return const SizedBox();
              return _AddTableForm(tag: tag);
            }),

            // Existing Tables
            Obx(() {
              if (c.tableTabMode.value != TabMode.existing)
                return const SizedBox();
              return _ExistingTables(tag: tag, context: context);
            }),
          ],
        ),
      ),
    ]),
  );
}

// ─── Add Table Form ───────────────────────────────────────────────────────────
class _AddTableForm extends StatelessWidget {
  final String tag;
  const _AddTableForm({required this.tag});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) => buildCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          icon: Icons.add_circle_outline_rounded,
          title: 'Add Table Type',
          subtitle: 'Configure new seating for your restaurant',
        ),
        const SizedBox(height: 20),
        modernTextField(
          controller: c.addTableTypeCtrl,
          label: 'Table Name',
          hint: 'e.g. 6 Seater, VIP Booth',
          icon: Icons.table_restaurant_outlined,
        ),
        const SizedBox(height: 16),

        // ✅ Fixed "1-" prefix + editable number field
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                '1-',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: modernTextField(
                controller: c.addCapacityNumberCtrl,
                label: 'Max Seats',
                hint: 'e.g. 7',
                icon: Icons.people_outline,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        modernTextField(
          controller: c.addTableIdsCtrl,
          label: 'Table IDs (comma-separated)',
          hint: 'T1, T2, T3',
          icon: Icons.grid_view_rounded,
        ),
        const SizedBox(height: 16),
        Obx(() => modernDropdown<SeatingTypeUpdate>(
          label: 'Seating Arrangement',
          icon: Icons.chair_outlined,
          value: c.addSeatingType.value,
          items: SeatingTypeUpdate.values,
          itemLabel: (e) => e.name.capitalizeFirst!,
          onChanged: (v) => c.addSeatingType.value = v!,
        )),
        const SizedBox(height: 24),
        Obx(() => primaryBtn(
          label: 'Add Table Type',
          icon: Icons.add_rounded,
          loading: c.isAddingTable.value,
          onPressed: c.isAddingTable.value ? null : c.submitAddTable,
        )),
      ],
    ),
  );
}

// ─── Existing Tables ──────────────────────────────────────────────────────────
class _ExistingTables extends StatelessWidget {
  final String tag;
  final BuildContext context;
  const _ExistingTables({required this.tag, required this.context});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext ctx) => Column(children: [
    // Edit form when table selected
    Obx(() {
      final sel = c.selectedTable.value;
      if (sel == null) return const SizedBox();
      return Column(children: [
        _TableEditForm(tag: tag, table: sel),
        const SizedBox(height: 20),
      ]);
    }),

    // Tables list
    buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader(
            icon: Icons.table_restaurant_rounded,
            title: 'Restaurant Tables',
            subtitle: 'Tap a table to edit its details',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (c.isLoadingTables.value) return loadingIndicator();
            if (c.tables.isEmpty)
              return emptyState(
                icon: Icons.table_restaurant_outlined,
                message: 'No tables found',
                sub: 'Switch to "Add New Table" to create one',
              );
            return Column(
              children: c.tables
                  .map((t) => TableCard(
                  table: t, tag: tag, context: context))
                  .toList(),
            );
          }),
        ],
      ),
    ),
  ]);
}

// ─── Table Edit Form ──────────────────────────────────────────────────────────
class _TableEditForm extends StatelessWidget {
  final String tag;
  final RestaurantTableModel table;
  const _TableEditForm({required this.tag, required this.table});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) => buildCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          icon: Icons.edit_rounded,
          title: 'Edit Table',
          subtitle: 'Updating: ${table.tableType}',
        ),
        const SizedBox(height: 20),
        modernTextField(
          controller: c.tableTypeCtrl,
          label: 'Table Type / Name',
          hint: 'e.g. Round Table, VIP Booth',
          icon: Icons.table_restaurant_outlined,
        ),
        const SizedBox(height: 16),

        // ✅ Fixed "1-" prefix + editable number field for edit too
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                '1-',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: modernTextField(
                controller: c.capacityNumberCtrl,
                label: 'Max Seats',
                hint: 'e.g. 7',
                icon: Icons.people_outline,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        modernTextField(
          controller: c.tableNameCtrl,
          label: 'Table IDs (comma-separated)',
          hint: 'T1, T2, T3',
          icon: Icons.grid_view_rounded,
        ),
        const SizedBox(height: 16),
        Obx(() => modernDropdown<SeatingTypeUpdate>(
          label: 'Seating Type',
          icon: Icons.chair_outlined,
          value: c.seatingTypeEdit.value,
          items: SeatingTypeUpdate.values,
          itemLabel: (e) => e.name.capitalizeFirst!,
          onChanged: (v) => c.seatingTypeEdit.value = v!,
        )),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(
              child: outlinedBtn(
                label: 'Cancel',
                icon: Icons.close_rounded,
                onPressed: c.clearTableSelection,
              )),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Obx(() => primaryBtn(
              label: 'Save Changes',
              icon: Icons.save_rounded,
              loading: c.isUpdatingTable.value,
              onPressed:
              c.isUpdatingTable.value ? null : c.updateTable,
            )),
          ),
        ]),
      ],
    ),
  );
}

// ─── Table Card ───────────────────────────────────────────────────────────────
class TableCard extends StatelessWidget {
  final RestaurantTableModel table;
  final String tag;
  final BuildContext context;
  const TableCard(
      {super.key,
        required this.table,
        required this.tag,
        required this.context});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext ctx) => Obx(() {
    final isSelected = c.selectedTable.value?.id == table.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.kPrimary.withOpacity(0.04)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppColors.kPrimary.withOpacity(0.4)
              : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.kPrimary.withOpacity(0.12)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.table_restaurant,
              color: isSelected
                  ? AppColors.kPrimary
                  : Colors.grey.shade400,
              size: 22),
        ),
        title: Text(table.tableType,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: DS.textPrimary)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(spacing: 6, runSpacing: 4, children: [
            _chip('${table.capacityRange} seats', Icons.people_outline),
            _chip(table.seatingType.capitalizeFirst!, Icons.chair_outlined),
            _chip(table.tableName, Icons.grid_view_rounded),
          ]),
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.kPrimary.withOpacity(0.12)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isSelected ? Icons.edit_rounded : Icons.edit_outlined,
                color: isSelected
                    ? AppColors.kPrimary
                    : Colors.grey.shade400,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => c.isDeletingTable.value
                ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2))
                : GestureDetector(
              onTap: () => DeleteConfirmDialog.show(
                context: context,
                title: 'Delete Table',
                message:
                'Delete "${table.tableType}"? This cannot be undone.',
                onConfirm: () => c.deleteTable(table),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.delete_outline_rounded,
                    color: Colors.red.shade400, size: 18),
              ),
            )),
          ],
        ),
        onTap: () => isSelected
            ? c.clearTableSelection()
            : c.selectTableForEdit(table),
      ),
    );
  });

  Widget _chip(String label, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11, color: Colors.grey.shade500),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
    ]),
  );
}