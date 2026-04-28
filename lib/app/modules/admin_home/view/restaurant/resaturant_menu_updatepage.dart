
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../data/models/admin_restarant_menuupdatemodel.dart';
import 'controller/restaurant_menuupdatecontroller.dart';

class _DS {
  static const bg          = Color(0xFFF5F6FA);
  static const surface     = Colors.white;
  static const border      = Color(0xFFE8EAF0);
  static const textPrimary = Color(0xFF1A1D2E);
  static const textSub     = Color(0xFF5C6080);
  static const textMuted   = Color(0xFF9BA3C2);
  static const success     = Color(0xFF1DA87A);
  static const danger      = Color(0xFFE05252);

  static const mealBreakfast = Color(0xFFE07B00);
  static const mealLunch     = Color(0xFF0AA0A0);
  static const mealDinner    = Color(0xFF7B4FA6);
}

Color _mealColor(String m) {
  switch (m) {
    case 'breakfast': return _DS.mealBreakfast;
    case 'lunch':     return _DS.mealLunch;
    case 'dinner':    return _DS.mealDinner;
    default:          return AppColors.kPrimary;
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

// ─── Main Page ────────────────────────────────────────────────────────────────
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

    return DefaultTabController(
      length: 3,
      child: NetworkAwareWrapper(child:  Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            _buildTablesTab(context),
            _buildTimingsTab(context),
            _buildMenuTab(context),
          ],
        ),
      ),
    ));
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() => AppBar(
    automaticallyImplyLeading: true,
    backgroundColor: AppColors.kPrimary,
    elevation: 0,
    title: const Text(
      'Update Restaurant Menu',
      style: TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
    ),
    actions: [
      Obx(() {
        final loading = c.isLoadingTables.value ||
            c.isLoadingTimings.value ||
            c.isLoadingMenuItems.value;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: loading
              ? const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            ),
          )
              : IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: Colors.white),
            tooltip: 'Refresh All',
            onPressed: c.fetchAll,
          ),
        );
      }),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        color: AppColors.kPrimary,
        child: const TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8),
          unselectedLabelStyle:
          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: [
            Tab(
                icon: Icon(Icons.table_restaurant_outlined, size: 18),
                text: 'TABLES'),
            Tab(
                icon: Icon(Icons.schedule_outlined, size: 18),
                text: 'TIMINGS'),
            Tab(
                icon: Icon(Icons.menu_book_outlined, size: 18),
                text: 'MENU'),
          ],
        ),
      ),
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1 — TABLES
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildTablesTab(BuildContext context) => SingleChildScrollView(
    child: Column(children: [
      _gradientStrip(),
      Padding(
        padding: const EdgeInsets.all(20),
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Edit Form (shown when a table is selected)
          Obx(() {
            final sel = c.selectedTable.value;
            if (sel == null) return const SizedBox();
            return Column(children: [
              _buildCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        icon: Icons.edit_rounded,
                        title: 'Edit Table',
                        subtitle: 'Updating: ${sel.tableType}',
                      ),
                      const SizedBox(height: 20),
                      _modernTextField(
                        controller: c.tableTypeCtrl,
                        label: 'Table Type / Name',
                        hint: 'e.g. Round Table, VIP Booth',
                        icon: Icons.table_restaurant_outlined,
                      ),
                      const SizedBox(height: 16),
                      _modernTextField(
                        controller: c.capacityRangeCtrl,
                        label: 'Capacity Range',
                        hint: 'e.g. 2–6',
                        icon: Icons.people_outline,
                      ),
                      const SizedBox(height: 16),
                      _modernTextField(
                        controller: c.tableNameCtrl,
                        label: 'Table IDs (comma-separated)',
                        hint: 'T1, T2, T3',
                        icon: Icons.grid_view_rounded,
                      ),
                      const SizedBox(height: 16),
                      Obx(() => _modernDropdown<SeatingTypeUpdate>(
                        label: 'Seating Type',
                        icon: Icons.chair_outlined,
                        value: c.seatingTypeEdit.value,
                        items: SeatingTypeUpdate.values,
                        itemLabel: (e) => e.name.capitalizeFirst!,
                        onChanged: (v) =>
                        c.seatingTypeEdit.value = v!,
                      )),
                      const SizedBox(height: 24),
                      Row(children: [
                        Expanded(
                            child: _outlinedBtn(
                              label: 'Cancel',
                              icon: Icons.close_rounded,
                              onPressed: c.clearTableSelection,
                            )),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Obx(() => _primaryBtn(
                            label: 'Save Changes',
                            icon: Icons.save_rounded,
                            loading: c.isUpdatingTable.value,
                            onPressed: c.isUpdatingTable.value
                                ? null
                                : c.updateTable,
                          )),
                        ),
                      ]),
                    ]),
              ),
              const SizedBox(height: 20),
            ]);
          }),

          // Tables List
          _buildCard(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    icon: Icons.table_restaurant_rounded,
                    title: 'Restaurant Tables',
                    subtitle: 'Tap a table to edit its details',
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (c.isLoadingTables.value)
                      return _loadingIndicator();
                    if (c.tables.isEmpty)
                      return _emptyState(
                        icon: Icons.table_restaurant_outlined,
                        message: 'No tables found',
                      );
                    return Column(
                      children: c.tables
                          .map((t) => _TableCard(
                          table: t,
                          tag: restaurantId.toString()))
                          .toList(),
                    );
                  }),
                ]),
          ),
        ]),
      ),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 2 — TIMINGS
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildTimingsTab(BuildContext context) {
    Future<void> pickTime(TextEditingController ctrl) async {
      final initial = c.parseTimeToTimeOfDay(ctrl.text);
      final picked = await showTimePicker(
        context: context,
        initialTime: initial,
        builder: (ctx, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.kPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _DS.textPrimary,
            ),
          ),
          child: child!,
        ),
      );
      if (picked != null) ctrl.text = c.formatTimeTo12h(picked);
    }

    return SingleChildScrollView(
      child: Column(children: [
        _gradientStrip(),
        Padding(
          padding: const EdgeInsets.all(20),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Obx(() {
              if (c.isLoadingTimings.value) {
                return _buildCard(child: _loadingIndicator());
              }
              if (c.timings.isEmpty) {
                return _buildCard(
                  child: _emptyState(
                    icon: Icons.schedule_outlined,
                    message: 'No timings found',
                  ),
                );
              }
              return Column(children: [
                // One card per meal type
                ...['breakfast', 'lunch', 'dinner'].map((meal) {
                  final timing = c.getTimingByMeal(meal);
                  if (timing == null) return const SizedBox();
                  final ctrls = c.timingControllers[meal];
                  if (ctrls == null) return const SizedBox();
                  final color = _mealColor(meal);

                  return _buildCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            icon: _mealIcon(meal),
                            title: meal.capitalizeFirst!,
                            subtitle:
                            'Set service window for ${meal.capitalizeFirst}',
                            iconColor: color,
                          ),
                          const SizedBox(height: 20),

                          // Start / End time pickers
                          Row(children: [
                            Expanded(
                                child: _pickerField(
                                  label: 'Start Time',
                                  controller: ctrls['start']!,
                                  icon: Icons.access_time_outlined,
                                  onTap: () => pickTime(ctrls['start']!),
                                  accentColor: color,
                                )),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.arrow_forward_rounded,
                                  color: Colors.grey.shade400, size: 18),
                            ),
                            Expanded(
                                child: _pickerField(
                                  label: 'End Time',
                                  controller: ctrls['end']!,
                                  icon: Icons.access_time_rounded,
                                  onTap: () => pickTime(ctrls['end']!),
                                  accentColor: color,
                                )),
                          ]),

                          const SizedBox(height: 16),

                          // ── BREAK DURATION FIELD ── ADDED ──────────────────
                          _modernTextField(
                            controller: ctrls['break']!,
                            label: 'Break Duration (mins)',
                            hint: 'e.g. 20',
                            icon: Icons.coffee_outlined,
                            keyboardType: TextInputType.number,
                            accentColor: color,
                          ),
                        ]),
                  );
                }),

                const SizedBox(height: 8),

                // Save All Timings button
                Obx(() => _primaryBtn(
                  label: 'Save All Timings',
                  icon: Icons.save_rounded,
                  loading: c.isUpdatingTimings.value,
                  onPressed:
                  c.isUpdatingTimings.value ? null : c.updateTimings,
                )),
              ]);
            }),
          ]),
        ),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 3 — MENU
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildMenuTab(BuildContext context) => SingleChildScrollView(
    child: Column(children: [
      _gradientStrip(),
      Padding(
        padding: const EdgeInsets.all(20),
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Edit Form (shown when a menu item is selected)
          Obx(() {
            final sel = c.selectedMenuItem.value;
            if (sel == null) return const SizedBox();
            final color = _mealColor(sel.mealType);
            return Column(children: [
              _buildCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        icon: Icons.edit_rounded,
                        title: 'Edit Menu Item',
                        subtitle:
                        '${sel.foodName} · ${sel.mealType.capitalizeFirst}',
                        iconColor: color,
                      ),
                      const SizedBox(height: 20),
                      _modernTextField(
                        controller: c.menuNameCtrl,
                        label: 'Food Name',
                        hint: 'Enter food name',
                        icon: Icons.fastfood_outlined,
                      ),
                      const SizedBox(height: 16),
                      _modernTextField(
                        controller: c.menuPriceCtrl,
                        label: 'Price (₹)',
                        hint: 'e.g. 299.00',
                        icon: Icons.currency_rupee_outlined,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      const SizedBox(height: 16),
                      _modernTextField(
                        controller: c.menuDescCtrl,
                        label: 'Description',
                        hint: 'Short description of the dish',
                        icon: Icons.notes_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),

                      // Image section
                      _sectionHeader(
                          icon: Icons.image_rounded, title: 'Food Image'),
                      const SizedBox(height: 12),
                      if (sel.imageUrl.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            sel.imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const SizedBox(),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Obx(() => c.pickedMenuImage.value != null
                          ? Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            c.pickedMenuImage.value!,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () =>
                            c.pickedMenuImage.value = null,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.close_rounded,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ])
                          : InkWell(
                        onTap: c.pickMenuImage,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: color.withOpacity(0.3),
                                width: 1.5),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: color,
                                  size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Replace Photo',
                                style: TextStyle(
                                    color: color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      )),

                      const SizedBox(height: 24),
                      Row(children: [
                        Expanded(
                            child: _outlinedBtn(
                              label: 'Cancel',
                              icon: Icons.close_rounded,
                              onPressed: c.clearMenuItemSelection,
                            )),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Obx(() => _primaryBtn(
                            label: 'Update Item',
                            icon: Icons.save_rounded,
                            loading: c.isUpdatingMenuItem.value,
                            onPressed: c.isUpdatingMenuItem.value
                                ? null
                                : c.updateMenuItem,
                            color: color,
                          )),
                        ),
                      ]),
                    ]),
              ),
              const SizedBox(height: 20),
            ]);
          }),

          // Menu Items List
          _buildCard(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    icon: Icons.menu_book_rounded,
                    title: 'Menu Items',
                    subtitle: 'Tap an item to edit it',
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (c.isLoadingMenuItems.value)
                      return _loadingIndicator();
                    if (c.menuItems.isEmpty)
                      return _emptyState(
                        icon: Icons.menu_book_outlined,
                        message: 'No menu items found',
                      );
                    return Column(
                      children:
                      ['breakfast', 'lunch', 'dinner'].map((meal) {
                        final items = c.getMenuItemsByMeal(meal);
                        if (items.isEmpty) return const SizedBox();
                        return _MealSection(
                            mealType: meal,
                            items: items,
                            tag: restaurantId.toString());
                      }).toList(),
                    );
                  }),
                ]),
          ),
        ]),
      ),
    ]),
  );
}

// ─── Shared UI Helpers ────────────────────────────────────────────────────────

Widget _gradientStrip() => Container(
  height: 8,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.kPrimary, AppColors.kPrimary.withOpacity(0.6)],
    ),
  ),
);

Widget _buildCard({required Widget child}) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  margin: const EdgeInsets.only(bottom: 20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: child,
);

Widget _sectionHeader({
  required IconData icon,
  required String title,
  String? subtitle,
  Color? iconColor,
}) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.kPrimary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
          Icon(icon, color: iconColor ?? AppColors.kPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
      ]),
      if (subtitle != null) ...[
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 44),
          child: Text(subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        ),
      ],
    ]);

// ← UPDATED: added optional accentColor so the break duration field can
//   use the meal colour (orange/teal/purple) for focused border.
Widget _modernTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  int maxLines = 1,
  Color? accentColor,
}) =>
    TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: accentColor ?? AppColors.kPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );

Widget _modernDropdown<T>({
  required String label,
  required IconData icon,
  required T value,
  required List<T> items,
  required String Function(T) itemLabel,
  required ValueChanged<T?> onChanged,
}) =>
    DropdownButtonFormField<T>(
      value: value,
      dropdownColor: Colors.white,
      style: const TextStyle(color: _DS.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 22),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.kPrimary, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(itemLabel(e))))
          .toList(),
      onChanged: onChanged,
    );

Widget _pickerField({
  required String label,
  required TextEditingController controller,
  required IconData icon,
  required VoidCallback onTap,
  Color? accentColor,
}) =>
    ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, value, __) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon,
                size: 22, color: accentColor ?? AppColors.kPrimary),
            suffixIcon: Icon(Icons.arrow_drop_down,
                size: 28, color: accentColor ?? AppColors.kPrimary),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: accentColor ?? AppColors.kPrimary, width: 2),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          child: Text(
            value.text.isEmpty ? 'Select $label' : value.text,
            style: TextStyle(
              fontSize: 15,
              color: value.text.isEmpty
                  ? Colors.grey.shade500
                  : Colors.black87,
              fontWeight:
              value.text.isEmpty ? FontWeight.w400 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );

Widget _primaryBtn({
  required String label,
  required IconData icon,
  required bool loading,
  VoidCallback? onPressed,
  Color? color,
}) {
  final c = color ?? AppColors.kPrimary;
  return Container(
    width: double.infinity,
    height: 54,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        colors: onPressed == null
            ? [Colors.grey.shade400, Colors.grey.shade300]
            : [c, c.withOpacity(0.8)],
      ),
      boxShadow: onPressed != null
          ? [
        BoxShadow(
            color: c.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6))
      ]
          : [],
    ),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: loading
          ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              color: Colors.white, strokeWidth: 2.5))
          : Icon(icon, size: 20),
      label: Text(
        loading ? 'Saving…' : label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
      onPressed: onPressed,
    ),
  );
}

Widget _outlinedBtn({
  required String label,
  required IconData icon,
  required VoidCallback onPressed,
}) =>
    OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey.shade600,
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label,
          style:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      onPressed: onPressed,
    );

Widget _loadingIndicator() => const Center(
  child: Padding(
    padding: EdgeInsets.all(32),
    child: CircularProgressIndicator(color: AppColors.kPrimary),
  ),
);

Widget _emptyState({required IconData icon, required String message}) =>
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500)),
        ]),
      ),
    );

// ─── Table Card ───────────────────────────────────────────────────────────────
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
                color: _DS.textPrimary)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(spacing: 6, runSpacing: 4, children: [
            _chip('${table.capacityRange} seats', Icons.people_outline),
            _chip(table.seatingType.capitalizeFirst!, Icons.chair_outlined),
            _chip(table.tableName, Icons.grid_view_rounded),
          ]),
        ),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.kPrimary.withOpacity(0.12)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSelected ? Icons.edit_rounded : Icons.edit_outlined,
            color: isSelected ? AppColors.kPrimary : Colors.grey.shade400,
            size: 18,
          ),
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

// ─── Meal Section ─────────────────────────────────────────────────────────────
class _MealSection extends StatelessWidget {
  final String mealType;
  final List<MenuItemModel> items;
  final String tag;
  const _MealSection(
      {required this.mealType, required this.items, required this.tag});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) {
    final color    = _mealColor(mealType);
    final expanded = c.expandedMeals[mealType]!;

    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: expanded.value
            ? color.withOpacity(0.02)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: expanded.value
              ? color.withOpacity(0.3)
              : Colors.grey.shade200,
          width: expanded.value ? 1.5 : 1.0,
        ),
      ),
      child: Column(children: [
        InkWell(
          onTap: () => expanded.value = !expanded.value,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      Color.lerp(color, Colors.black, 0.25)!
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                Icon(_mealIcon(mealType), color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mealType.capitalizeFirst!,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: color)),
                      Text(
                        '${items.length} item${items.length != 1 ? 's' : ''}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ]),
              ),
              AnimatedRotation(
                turns: expanded.value ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.expand_more_rounded,
                      color: color, size: 20),
                ),
              ),
            ]),
          ),
        ),
        if (expanded.value) ...[
          Divider(height: 1, color: color.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: items
                  .map((f) =>
                  _MenuItemCard(item: f, color: color, tag: tag))
                  .toList(),
            ),
          ),
        ],
      ]),
    ));
  }
}

// ─── Menu Item Card ───────────────────────────────────────────────────────────
class _MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final Color color;
  final String tag;
  const _MenuItemCard(
      {required this.item, required this.color, required this.tag});

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
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.04)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.35)
                : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.imageUrl.isNotEmpty
                ? Image.network(item.imageUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder())
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.foodName,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _DS.textPrimary)),
                  if (item.shortDescription.isNotEmpty)
                    Text(item.shortDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 4),
                  Text(
                    '₹ ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _DS.success,
                      letterSpacing: 0.3,
                    ),
                  ),
                ]),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withOpacity(0.12)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? color.withOpacity(0.3)
                    : Colors.grey.shade200,
              ),
            ),
            child: Icon(
              isSelected ? Icons.edit_rounded : Icons.edit_outlined,
              size: 16,
              color: isSelected ? color : Colors.grey.shade400,
            ),
          ),
        ]),
      ),
    );
  });

  Widget _placeholder() => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      color: color.withOpacity(0.10),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(Icons.fastfood_rounded, color: color, size: 22),
  );
}