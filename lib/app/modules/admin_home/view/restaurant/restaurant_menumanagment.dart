
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../data/models/adminretaurant_menumodel.dart';
import '../admin_home.dart';
import 'controller/restaurant_menuaddingcontroller.dart';

// ─── Meal Helpers ─────────────────────────────────────────────────────────────
Color _mealColor(MealType m) {
  switch (m) {
    case MealType.breakfast: return const Color(0xFFE07B00);
    case MealType.lunch:     return const Color(0xFF0AA0A0);
    case MealType.dinner:    return const Color(0xFF7B4FA6);
  }
}

IconData _mealIcon(MealType m) {
  switch (m) {
    case MealType.breakfast: return Icons.free_breakfast_outlined;
    case MealType.lunch:     return Icons.lunch_dining_outlined;
    case MealType.dinner:    return Icons.dinner_dining_outlined;
  }
}

// ─── Main Page ────────────────────────────────────────────────────────────────
class MenuManagementPage extends StatelessWidget {
  const MenuManagementPage({super.key});

  RestaurantmenuController get c => Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(RestaurantmenuController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() => AppBar(
    automaticallyImplyLeading: true,
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: AppColors.kPrimary,
    elevation: 0,
    title: const Text(
      'Menu Management',
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    ),
    actions: [
      Obx(() {
        final loading = c.isLoadingPreview.value;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: loading
              ? const Center(
            child: SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            ),
          )
              : IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Refresh',
            onPressed: c.fetchSetupPreview,
          ),
        );
      }),
      IconButton(onPressed: ()=>Get.offAll(()=> AdminDashboard()), icon:Icon(Icons.home)
      )],
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
              fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          unselectedLabelStyle:
          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: [
            Tab(icon: Icon(Icons.table_restaurant_outlined, size: 18), text: 'TABLES'),
            Tab(icon: Icon(Icons.schedule_outlined, size: 18), text: 'TIMINGS'),
            Tab(icon: Icon(Icons.menu_book_outlined, size: 18), text: 'MENU'),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Add Table Form
          _buildCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionHeader(
                icon: Icons.add_circle_outline_rounded,
                title: 'Add Table Type',
                subtitle: 'Configure seating groups for your restaurant floor',
              ),
              const SizedBox(height: 20),
              _modernTextField(
                controller: c.tableTypeCtrl,
                label: 'Table Name',
                hint: 'e.g. 6 seater, 4 seater',
                icon: Icons.table_restaurant_outlined,
              ),
              const SizedBox(height: 16),
              _modernTextField(
                controller: c.capacityRangeCtrl,
                label: 'Capacity Range',
                hint: 'e.g. 2–6 or 4',
                icon: Icons.people_outline,
              ),
              const SizedBox(height: 16),
              _modernTextField(
                controller: c.tableIdsCtrl,
                label: 'Table IDs',
                hint: 'e.g. T1, T2, T3',
                icon: Icons.grid_view_rounded,
              ),
              const SizedBox(height: 16),
              Obx(() => _modernDropdown<SeatingType>(
                label: 'Seating Arrangement',
                icon: Icons.chair_outlined,
                value: c.seatingType.value,
                items: SeatingType.values,
                itemLabel: (e) => e.name.capitalizeFirst!,
                onChanged: (v) => c.seatingType.value = v!,
              )),
              const SizedBox(height: 24),
              Obx(() => _primaryBtn(
                label: 'Add Table Type',
                icon: Icons.add_rounded,
                loading: c.isAddingTable.value,
                onPressed: c.isAddingTable.value ? null : c.submitTableForm,
              )),
            ]),
          ),

          // Tables List
          _buildCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionHeader(
                icon: Icons.table_restaurant_rounded,
                title: 'Your Tables',
                subtitle: 'Manage existing seating configurations',
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (c.tableTypes.isEmpty) {
                  return _emptyState(
                    icon: Icons.table_restaurant_outlined,
                    message: 'No tables configured yet',
                    sub: 'Add your first table type above',
                  );
                }
                return Column(
                  children: c.tableTypes.map((table) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.table_restaurant,
                            color: AppColors.kPrimary, size: 22),
                      ),
                      title: Text(table.name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1D2E))),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Wrap(spacing: 6, runSpacing: 4, children: [
                          _chip('${table.capacityRange} seats',
                              Icons.people_outline),
                          _chip(table.seatingType.name.capitalizeFirst!,
                              Icons.chair_outlined),
                          _chip(table.availableTables.join(', '),
                              Icons.grid_view_rounded),
                        ]),
                      ),
                      isThreeLine: true,
                      trailing: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.delete_outline,
                            color: Colors.red.shade400, size: 18),
                      ),
                      onTap: () => c.removeTableTypeLocally(table),
                    ),
                  )).toList(),
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
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (ctx, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.kPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF1A1D2E),
            ),
          ),
          child: child!,
        ),
      );
      if (picked != null) {
        ctrl.text =
            Get.find<RestaurantmenuController>().formatTimeTo12h(picked);
      }
    }

    return SingleChildScrollView(
      child: Column(children: [
        _gradientStrip(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // Info banner
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.kPrimary.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: AppColors.kPrimary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Each meal period can only have one time slot. '
                          'To change a saved slot, delete it first using the × button.',
                      style: TextStyle(
                          color: AppColors.kPrimary,
                          fontSize: 12,
                          height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            // Add Timing Form
            _buildCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionHeader(
                  icon: Icons.alarm_add_outlined,
                  title: 'Schedule Meal Slots',
                  subtitle: 'Define service windows for each meal period',
                ),
                const SizedBox(height: 20),
                Obx(() => _modernDropdown<MealType>(
                  label: 'Meal Period',
                  icon: Icons.restaurant_outlined,
                  value: c.selectedMealType.value,
                  items: MealType.values,
                  itemLabel: (m) => m.name.capitalizeFirst!,
                  onChanged: (v) => c.selectedMealType.value = v!,
                )),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: _pickerTextField(
                    controller: c.startCtrl,
                    label: 'Start Time',
                    icon: Icons.access_time_outlined,
                    onTap: () => pickTime(c.startCtrl),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_forward_rounded,
                        color: Colors.grey.shade400, size: 18),
                  ),
                  Expanded(child: _pickerTextField(
                    controller: c.endCtrl,
                    label: 'End Time',
                    icon: Icons.access_time_rounded,
                    onTap: () => pickTime(c.endCtrl),
                  )),
                ]),
                const SizedBox(height: 16),

                // ── BREAK DURATION FIELD (editable number input) ──
                _modernTextField(
                  controller: c.breakDurationCtrl,
                  label: 'Break Duration (mins)',
                  hint: 'e.g. 20',
                  icon: Icons.coffee_outlined,
                  type: TextInputType.number,
                ),

                const SizedBox(height: 16),

                // Queue button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.kPrimary,
                      side: BorderSide(
                          color: AppColors.kPrimary, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_alarm_rounded, size: 18),
                    label: const Text('Queue Slot',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5)),
                    onPressed: c.addToPendingSlots,
                  ),
                ),

                // Pending queue
                Obx(() {
                  final total = c.pendingSlots.values
                      .fold(0, (s, e) => s + e.length);
                  if (total == 0) return const SizedBox();
                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.pending_actions,
                              color: Colors.orange.shade700, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('$total slot(s) queued',
                                style: TextStyle(
                                    color: Colors.orange.shade800,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ),
                          GestureDetector(
                            onTap: () => c.pendingSlots.clear(),
                            child: Text('Clear all',
                                style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        ...c.pendingSlots.entries.map((entry) =>
                            Column(children: entry.value.map((slot) =>
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(children: [
                                    Icon(_mealIcon(entry.key),
                                        size: 14,
                                        color: _mealColor(entry.key)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${entry.key.name.capitalizeFirst}: '
                                            '${slot.startTime} → ${slot.endTime}'
                                            '${slot.breakDuration > 0 ? '  (${slot.breakDuration} min break)' : ''}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF5C6080)),
                                      ),
                                    ),
                                  ]),
                                )).toList())),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 20),
                Obx(() => _primaryBtn(
                  label: 'Save Timings',
                  icon: Icons.save_rounded,
                  loading: c.isAddingTimings.value,
                  onPressed: c.isAddingTimings.value || c.pendingSlots.isEmpty
                      ? null
                      : () async {
                    await c.addMealTimings(c.pendingSlots);
                    c.pendingSlots.clear();
                  },
                )),
              ]),
            ),

            // Saved Timings
            _buildCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionHeader(
                  icon: Icons.event_available_outlined,
                  title: 'Saved Timings',
                  subtitle: 'Current service schedule — tap × to delete',
                ),
                const SizedBox(height: 16),
                Obx(() => Column(
                  children: MealType.values.map((meal) {
                    final slots = c.getSlotsByMeal(meal);
                    final color = _mealColor(meal);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: slots.isNotEmpty
                            ? color.withOpacity(0.04)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: slots.isNotEmpty
                              ? color.withOpacity(0.25)
                              : Colors.grey.shade200,
                          width: slots.isNotEmpty ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(_mealIcon(meal),
                                  color: color, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Text(meal.name.capitalizeFirst!,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1D2E))),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: slots.isNotEmpty
                                    ? Colors.green.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: slots.isNotEmpty
                                      ? Colors.green.shade200
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                slots.isNotEmpty ? '✓ Configured' : 'Not set',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: slots.isNotEmpty
                                      ? Colors.green.shade700
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ]),
                          if (slots.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: slots.map((s) => Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 6, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: color.withOpacity(0.3)),
                                ),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(s.displayTime,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: color,
                                              fontWeight: FontWeight.w600)),
                                      if (s.breakDuration > 0)
                                        Text(
                                          '${s.breakDuration} min break',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: color.withOpacity(0.7)),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => c.removeTimeSlot(s),
                                    child: Icon(Icons.close_rounded,
                                        size: 14, color: color),
                                  ),
                                ]),
                              )).toList(),
                            ),
                          ] else ...[
                            const SizedBox(height: 6),
                            Text('No slots added',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400)),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                )),
              ]),
            ),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Meal type cards
          _buildCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionHeader(
                icon: Icons.restaurant_menu_rounded,
                title: 'Menu Builder',
                subtitle: 'Add food items by meal period',
              ),
              const SizedBox(height: 16),
              ...MealType.values.map((m) => _MealTypeCard(mealType: m)),
            ]),
          ),

          // Setup Preview
          _buildCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionHeader(
                icon: Icons.preview_outlined,
                title: 'Setup Preview',
              ),
              const SizedBox(height: 16),

              // Tables preview
              _previewSection(
                icon: Icons.table_restaurant_outlined,
                title: 'Tables & Seating',
                child: Obx(() => c.tableTypes.isEmpty
                    ? Text('No tables configured',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade400))
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: c.tableTypes.map((t) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [
                      Icon(Icons.fiber_manual_record,
                          size: 6, color: AppColors.kPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${t.name}  ·  ${t.capacityRange} seats  ·  ${t.availableTables.join(', ')}',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5C6080),
                              height: 1.5),
                        ),
                      ),
                    ]),
                  )).toList(),
                )),
              ),

              const SizedBox(height: 12),

              // Timings preview
              _previewSection(
                icon: Icons.schedule_outlined,
                title: 'Meal Timings',
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: MealType.values.map((meal) {
                    final slots = c.getSlotsByMeal(meal);
                    if (slots.isEmpty) return const SizedBox();
                    final color = _mealColor(meal);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meal.name.capitalizeFirst!,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: color)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: slots.map((s) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(s.displayTime,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: color,
                                          fontWeight: FontWeight.w600)),
                                  if (s.breakDuration > 0)
                                    Text(
                                      '${s.breakDuration} min break',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: color.withOpacity(0.7)),
                                    ),
                                ],
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )),
              ),

              const SizedBox(height: 12),

              // Menu preview
              _previewSection(
                icon: Icons.menu_book_outlined,
                title: 'Menu Items',
                child: Obx(() {
                  final hasItems =
                  c.mealMenus.any((m) => m.foodItems.isNotEmpty);
                  if (!hasItems) {
                    return Text('No menu items added',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: c.mealMenus.map((menu) {
                      if (menu.foodItems.isEmpty) return const SizedBox();
                      final color = _mealColor(menu.mealType);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(menu.mealType.name.capitalizeFirst!,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: color)),
                            const SizedBox(height: 6),
                            ...menu.foodItems.map((food) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(children: [
                                Icon(Icons.fiber_manual_record,
                                    size: 6,
                                    color: Colors.grey.shade400),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(food.name,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF5C6080))),
                                ),
                                Text(
                                  '₹${food.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1DA87A),
                                  ),
                                ),
                              ]),
                            )),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),

              const SizedBox(height: 20),
              _primaryBtn(
                label: 'Refresh Preview',
                icon: Icons.refresh_rounded,
                loading: false,
                onPressed: c.fetchSetupPreview,
              ),
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
          child: Icon(icon, color: iconColor ?? AppColors.kPrimary, size: 20),
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

Widget _modernTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  TextInputType type = TextInputType.text,
  int maxLines = 1,
}) =>
    TextField(
      controller: controller,
      keyboardType: type,
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
          borderSide: BorderSide(color: AppColors.kPrimary, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );

Widget _pickerTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required VoidCallback? onTap,
  bool showDropdownArrow = false,
}) =>
    TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 22, color: AppColors.kPrimary),
        suffixIcon: showDropdownArrow
            ? Icon(Icons.arrow_drop_down, color: AppColors.kPrimary, size: 28)
            : null,
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
      style: const TextStyle(color: Color(0xFF1A1D2E), fontSize: 15),
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
      label: Text(loading ? 'Saving…' : label,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5)),
      onPressed: onPressed,
    ),
  );
}

Widget _emptyState({
  required IconData icon,
  required String message,
  String? sub,
}) =>
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
          if (sub != null) ...[
            const SizedBox(height: 4),
            Text(sub,
                style:
                TextStyle(fontSize: 12, color: Colors.grey.shade400)),
          ],
        ]),
      ),
    );

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
        style:
        TextStyle(fontSize: 11, color: Colors.grey.shade600)),
  ]),
);

Widget _previewSection({
  required IconData icon,
  required String title,
  required Widget child,
}) =>
    Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border:
            Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(children: [
            Icon(icon, color: AppColors.kPrimary, size: 18),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ]),
    );

// ─── Meal Type Card ───────────────────────────────────────────────────────────
class _MealTypeCard extends StatelessWidget {
  final MealType mealType;
  const _MealTypeCard({required this.mealType});

  RestaurantmenuController get c => Get.find();
  Color get _color => _mealColor(mealType);
  IconData get _icon => _mealIcon(mealType);

  @override
  Widget build(BuildContext context) {
    final menu         = c.getMealMenu(mealType);
    final isExpanded   = c.expandedCards[mealType]!;
    final pickedImage  = c.pickedImages[mealType]!;

    return Obx(() {
      final expanded = isExpanded.value;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: expanded ? _color.withOpacity(0.4) : Colors.grey.shade200,
            width: expanded ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: expanded
                  ? _color.withOpacity(0.06)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: [
          // Header
          InkWell(
            onTap: () => c.toggleCard(mealType),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_color, Color.lerp(_color, Colors.black, 0.25)!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: _color.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Icon(_icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mealType.name.capitalizeFirst!,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _color)),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                        '${menu.foodItems.length} item${menu.foodItems.length != 1 ? 's' : ''} on menu',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      )),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.expand_more_rounded,
                        color: _color, size: 20),
                  ),
                ),
              ]),
            ),
          ),

          // Expanded content
          if (expanded) ...[
            Divider(height: 1, color: _color.withOpacity(0.2)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // New item form
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(_icon, color: _color, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Text('New Item',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _color,
                            letterSpacing: 0.5)),
                  ]),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: _modernTextField(
                        controller: c.foodNameCtrls[mealType]!,
                        label: 'Food Name',
                        hint: 'e.g. Masala Dosa',
                        icon: Icons.fastfood_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _modernTextField(
                        controller: c.foodPriceCtrls[mealType]!,
                        label: 'Price ₹',
                        hint: '0.00',
                        icon: Icons.currency_rupee_outlined,
                        type: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _modernTextField(
                    controller: c.descriptionCtrls[mealType]!,
                    label: 'Description (optional)',
                    hint: 'Short description of the dish',
                    icon: Icons.notes_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),

                  // Image picker
                  Obx(() => pickedImage.value != null
                      ? Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        pickedImage.value!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8, right: 8,
                      child: GestureDetector(
                        onTap: () => pickedImage.value = null,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.close_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ])
                      : InkWell(
                    onTap: () => c.pickFoodImage(mealType),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                        color: _color.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _color.withOpacity(0.25),
                            width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              color: _color, size: 20),
                          const SizedBox(width: 10),
                          Text('Add Photo',
                              style: TextStyle(
                                  color: _color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  )),

                  const SizedBox(height: 16),
                  Obx(() => _primaryBtn(
                    label: 'Add to Menu',
                    icon: Icons.add_rounded,
                    loading: c.isAddingMenuItem.value,
                    color: _color,
                    onPressed: c.isAddingMenuItem.value
                        ? null
                        : () => c.submitFoodItem(mealType),
                  )),

                  // Food list
                  Obx(() {
                    if (menu.foodItems.isEmpty) return const SizedBox();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 12),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.list_alt_outlined,
                                color: _color, size: 14),
                          ),
                          const SizedBox(width: 8),
                          Text('On the Menu',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _color,
                                  letterSpacing: 0.5)),
                        ]),
                        const SizedBox(height: 12),
                        ...List.generate(menu.foodItems.length, (i) {
                          final food = menu.foodItems[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade200),
                            ),
                            child: Row(children: [
                              _buildFoodImage(food),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(food.name,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1D2E))),
                                    if (food.description.isNotEmpty)
                                      Text(food.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500)),
                                    const SizedBox(height: 3),
                                    Text(
                                        '₹ ${food.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1DA87A))),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: GestureDetector(
                                  onTap: () => c.removeFoodItemLocally(
                                      mealType, food),
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.red.shade400,
                                      size: 18),
                                ),
                              ),
                            ]),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ]),
      );
    });
  }

  Widget _buildFoodImage(FoodItem food) {
    final placeholder = Container(
      width: 52, height: 52,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.fastfood_rounded, color: _color, size: 22),
    );
    if (food.imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(food.imageFile!,
            width: 52, height: 52, fit: BoxFit.cover),
      );
    }
    if (food.imageUrl != null && food.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          food.imageUrl!,
          width: 52, height: 52, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      );
    }
    return placeholder;
  }
}