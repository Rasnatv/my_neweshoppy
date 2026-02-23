
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/adminretaurant_menumodel.dart';
import 'controller/restaurant_menuaddingcontroller.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
class _DS {
  // Palette — Light Theme
  static const bg = Color(0xFFF5F6FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFF0F1F8);
  static const border = Color(0xFFE0E3F0);
  static const amber = Color(0xFFE07B00);
  static const amberSoft = Color(0xFFF5A623);
  static const amberDim = Color(0x1AE07B00);
  static const textPrimary = Color(0xFF1A1D2E);
  static const textSecondary = Color(0xFF5C6080);
  static const textMuted = Color(0xFF9BA3C2);
  static const success = Color(0xFF1DA87A);
  static const successDim = Color(0x1A1DA87A);
  static const danger = Color(0xFFE05252);
  static const dangerDim = Color(0x1AE05252);
  static const mealBreakfast = Color(0xFFE07B00);
  static const mealLunch = Color(0xFF0AA0A0);
  static const mealDinner = Color(0xFF7B4FA6);

  // Spacing
  static const p4 = 4.0;
  static const p8 = 8.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p32 = 32.0;

  // Radius
  static const r8 = BorderRadius.all(Radius.circular(8));
  static const r12 = BorderRadius.all(Radius.circular(12));
  static const r16 = BorderRadius.all(Radius.circular(16));

  // Shadows
  static final cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.06),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );
  static final amberGlow = BoxShadow(
    color: amber.withOpacity(0.12),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );

  // Text Styles
  static const tsPageTitle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: 0.2,
  );
  static const tsSectionTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: amber,
    letterSpacing: 2.0,
  );
  static const tsLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  static const tsBody = TextStyle(
    fontSize: 14,
    color: textSecondary,
    height: 1.5,
  );
  static const tsMuted = TextStyle(fontSize: 12, color: textMuted);
  static const tsPrice = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: success,
    letterSpacing: 0.3,
  );
  static const tsChip = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: amber,
    letterSpacing: 0.5,
  );
}

// ─── Input Decoration Helper ──────────────────────────────────────────────────
InputDecoration _field(String label, {Widget? suffix, String? hint}) =>
    InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: _DS.textSecondary, fontSize: 13),
      hintStyle: const TextStyle(color: _DS.textMuted, fontSize: 13),
      suffixIcon: suffix,
      filled: true,
      fillColor: _DS.surfaceElevated,
      contentPadding: const EdgeInsets.symmetric(horizontal: _DS.p16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _DS.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _DS.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _DS.amber, width: 1.5),
      ),
    );

// ─── Primary Button ───────────────────────────────────────────────────────────
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
              ? [
            BoxShadow(
                color: c.withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 4))
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
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2.5),
          )
              : Icon(icon, size: 18),
          label: Text(
            loading ? 'Saving…' : label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader(this.title, {this.subtitle});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: _DS.p16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: _DS.tsSectionTitle),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: _DS.tsBody),
        ],
      ],
    ),
  );
}

// ─── Card ─────────────────────────────────────────────────────────────────────
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

// ─── Main Page ────────────────────────────────────────────────────────────────
class MenuManagementPage extends StatelessWidget {
  const MenuManagementPage({super.key});

  RestaurantmenuController get c => Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(RestaurantmenuController());

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: _DS.bg,
        colorScheme: const ColorScheme.light(
          primary: _DS.amber,
          surface: _DS.surface,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: _DS.textPrimary,
          displayColor: _DS.textPrimary,
        ),
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
              _buildMenuAndPreviewTab(),
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
      decoration: BoxDecoration(
        color: _DS.amberDim,
        borderRadius: BorderRadius.circular(10),
      ),
      child:
      const Icon(Icons.restaurant_menu, color: _DS.amber, size: 20),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Menu Management', style: _DS.tsPageTitle),
        Text('Restaurant Administration', style: _DS.tsMuted),
      ],
    ),
    actions: [
      Obx(() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: c.isLoadingPreview.value
            ? const Padding(
          padding: EdgeInsets.all(14),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: _DS.amber,
              strokeWidth: 2,
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _IconBtn(
            icon: Icons.refresh_rounded,
            tooltip: 'Refresh',
            onTap: c.fetchSetupPreview,
          ),
        ),
      )),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: _DS.border)),
        ),
        child: const TabBar(
          labelColor: _DS.amber,
          unselectedLabelColor: _DS.textSecondary,
          indicatorColor: _DS.amber,
          indicatorWeight: 2.5,
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            Tab(text: 'TABLES'),
            Tab(text: 'TIMINGS'),
            Tab(text: 'MENU'),
          ],
        ),
      ),
    ),
  );

  // ══════════════════════════════════════════════════════════════════
  // TAB 1 — TABLES
  // ══════════════════════════════════════════════════════════════════
  Widget _buildTablesTab(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(_DS.p20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        const _SectionHeader(
          'Add Table Type',
          subtitle: 'Configure seating groups for your restaurant floor',
        ),
        _Card(
          child: Column(
            children: [
              TextField(
                controller: c.tableTypeCtrl,
                style: const TextStyle(color: _DS.textPrimary),
                decoration: _field('Table Name',
                    hint: 'e.g. VIP Booth, Family Table'),
              ),
              const SizedBox(height: _DS.p12),
              TextField(
                controller: c.capacityRangeCtrl,
                style: const TextStyle(color: _DS.textPrimary),
                decoration:
                _field('Capacity Range', hint: 'e.g. 2–6 or 4'),
              ),
              const SizedBox(height: _DS.p12),
              TextField(
                controller: c.tableIdsCtrl,
                style: const TextStyle(
                    color: _DS.textPrimary, letterSpacing: 1.0),
                textCapitalization: TextCapitalization.characters,
                decoration:
                _field('Table IDs', hint: 'e.g. T1, T2, T3'),
              ),
              const SizedBox(height: _DS.p12),
              Obx(() => DropdownButtonFormField<SeatingType>(
                value: c.seatingType.value,
                dropdownColor: _DS.surface,
                style: const TextStyle(
                    color: _DS.textPrimary, fontSize: 14),
                decoration: _field('Seating Arrangement'),
                items: SeatingType.values
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name.capitalizeFirst!),
                ))
                    .toList(),
                onChanged: (v) => c.seatingType.value = v!,
              )),
              const SizedBox(height: _DS.p20),
              Obx(() => _PrimaryBtn(
                label: 'Add Table Type',
                icon: Icons.add_rounded,
                loading: c.isAddingTable.value,
                onPressed:
                c.isAddingTable.value ? null : c.submitTableForm,
              )),
            ],
          ),
        ),
        const SizedBox(height: _DS.p24),
        const _SectionHeader(
          'Your Tables',
          subtitle: 'Manage existing seating configurations',
        ),
        Obx(() => c.tableTypes.isEmpty
            ? _EmptyState(
          icon: Icons.table_restaurant_outlined,
          message: 'No tables configured yet',
          sub: 'Add your first table type above',
        )
            : Column(
          children: c.tableTypes
              .map((table) => _Card(
            padding: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: _DS.p16,
                vertical: _DS.p8,
              ),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _DS.amberDim,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.table_restaurant,
                    color: _DS.amber, size: 22),
              ),
              title: Text(table.name,
                  style: _DS.tsLabel
                      .copyWith(color: _DS.textPrimary)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _InfoChip('${table.capacityRange} seats',
                        Icons.people_outline),
                    _InfoChip(
                        table.seatingType.name
                            .capitalizeFirst!,
                        Icons.chair_outlined),
                    _InfoChip(
                        table.availableTables.join(', '),
                        Icons.grid_view_rounded),
                  ],
                ),
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: _DS.danger, size: 20),
                onPressed: () =>
                    c.removeTableTypeLocally(table),
              ),
            ),
          ))
              .toList(),
        )),
      ],
    ),
  );

  // ══════════════════════════════════════════════════════════════════
  // TAB 2 — TIMINGS
  // ══════════════════════════════════════════════════════════════════
  Widget _buildTimingsTab(BuildContext context) {
    // ✅ FIX: Time picker formats to 12h AM/PM to match API expectation
    Future<void> pickTime(TextEditingController ctrl) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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
        // ✅ FIX: Use controller's formatTimeTo12h for correct API format
        ctrl.text = Get.find<RestaurantmenuController>().formatTimeTo12h(picked);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(_DS.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),

          // ✅ NEW: Info banner explaining the meal type restriction
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
                Icon(Icons.info_outline_rounded,
                    color: _DS.amber, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Each meal period (Breakfast, Lunch, Dinner) can only have one time slot. '
                        'To change a saved slot, delete it first using the × button below.',
                    style: TextStyle(
                        color: _DS.amber, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),

          const _SectionHeader(
            'Schedule Meal Slots',
            subtitle: 'Define service windows for each meal period',
          ),
          _Card(
            child: Column(
              children: [
                Obx(() => DropdownButtonFormField<MealType>(
                  value: c.selectedMealType.value,
                  dropdownColor: _DS.surface,
                  style: const TextStyle(
                      color: _DS.textPrimary, fontSize: 14),
                  decoration: _field('Meal Period'),
                  items: MealType.values
                      .map((m) => DropdownMenuItem(
                    value: m,
                    child: Row(
                      children: [
                        Icon(_mealIcon(m),
                            size: 16, color: _mealColor(m)),
                        const SizedBox(width: 8),
                        Text(m.name.capitalizeFirst!),
                        // ✅ NEW: Show "saved" badge if slot exists
                        Obx(() {
                          final hasSaved = c.timeSlots
                              .any((s) => s.mealType == m);
                          final hasQueued = c.pendingSlots
                              .containsKey(m) &&
                              c.pendingSlots[m]!.isNotEmpty;
                          if (hasSaved) {
                            return Container(
                              margin:
                              const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius:
                                BorderRadius.circular(4),
                              ),
                              child: Text('Saved',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color:
                                      Colors.green.shade700,
                                      fontWeight:
                                      FontWeight.w700)),
                            );
                          } else if (hasQueued) {
                            return Container(
                              margin:
                              const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius:
                                BorderRadius.circular(4),
                              ),
                              child: Text('Queued',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color:
                                      Colors.orange.shade700,
                                      fontWeight:
                                      FontWeight.w700)),
                            );
                          }
                          return const SizedBox();
                        }),
                      ],
                    ),
                  ))
                      .toList(),
                  onChanged: (v) => c.selectedMealType.value = v!,
                )),
                const SizedBox(height: _DS.p12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: c.startCtrl,
                        readOnly: true,
                        style: const TextStyle(color: _DS.textPrimary),
                        onTap: () => pickTime(c.startCtrl),
                        decoration: _field('Start Time',
                            suffix: const Icon(Icons.schedule,
                                size: 18, color: _DS.textSecondary)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.arrow_forward,
                          color: _DS.textMuted, size: 18),
                    ),
                    Expanded(
                      child: TextField(
                        controller: c.endCtrl,
                        readOnly: true,
                        style: const TextStyle(color: _DS.textPrimary),
                        onTap: () => pickTime(c.endCtrl),
                        decoration: _field('End Time',
                            suffix: const Icon(Icons.schedule,
                                size: 18, color: _DS.textSecondary)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _DS.p12),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _DS.amber,
                      side:
                      const BorderSide(color: _DS.amber, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                    margin: const EdgeInsets.only(top: _DS.p12),
                    padding: const EdgeInsets.all(_DS.p12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8EC),
                      border: Border.all(
                          color: _DS.amber.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.pending_actions,
                                color: _DS.amberSoft, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text('$total slot(s) queued',
                                  style: const TextStyle(
                                      color: _DS.amber, fontSize: 13)),
                            ),
                            GestureDetector(
                              onTap: () => c.pendingSlots.clear(),
                              child: const Text('Clear',
                                  style: TextStyle(
                                      color: _DS.danger,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // ✅ NEW: Show queued slots detail
                        ...c.pendingSlots.entries.map((entry) {
                          return Column(
                            children: entry.value.map((slot) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Icon(_mealIcon(entry.key),
                                        size: 14,
                                        color: _mealColor(entry.key)),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${entry.key.name.capitalizeFirst}: ${slot.startTime} → ${slot.endTime}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: _DS.textSecondary),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: _DS.p16),
                Obx(() => _PrimaryBtn(
                  label: 'Save Timings',
                  icon: Icons.save_rounded,
                  loading: c.isAddingTimings.value,
                  onPressed: c.isAddingTimings.value ||
                      c.pendingSlots.isEmpty
                      ? null
                      : () async {
                    await c.addMealTimings(c.pendingSlots);
                    c.pendingSlots.clear();
                  },
                )),
              ],
            ),
          ),

          const SizedBox(height: _DS.p24),
          const _SectionHeader(
            'Saved Timings',
            subtitle: 'Current service schedule — tap × to delete a slot',
          ),
          Obx(() => Column(
            children: MealType.values.map((meal) {
              final slots = c.getSlotsByMeal(meal);
              return _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                            _mealColor(meal).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(_mealIcon(meal),
                              color: _mealColor(meal), size: 18),
                        ),
                        const SizedBox(width: 10),
                        Text(meal.name.capitalizeFirst!,
                            style: _DS.tsLabel),
                        const Spacer(),
                        // ✅ NEW: Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: slots.isNotEmpty
                                ? Colors.green.shade50
                                : _DS.surfaceElevated,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: slots.isNotEmpty
                                  ? Colors.green.shade200
                                  : _DS.border,
                            ),
                          ),
                          child: Text(
                            slots.isNotEmpty
                                ? '✓ Configured'
                                : 'Not set',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: slots.isNotEmpty
                                  ? Colors.green.shade700
                                  : _DS.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (slots.isNotEmpty) ...[
                      const SizedBox(height: _DS.p12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: slots
                            .map((s) => _TimeChip(
                          label: s.displayTime,
                          color: _mealColor(meal),
                          // ✅ FIX: onDelete now calls API delete
                          onDelete: () =>
                              c.removeTimeSlot(s),
                        ))
                            .toList(),
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      const Text('No slots added',
                          style: _DS.tsMuted),
                    ],
                  ],
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB 3 — MENU & PREVIEW
  // ══════════════════════════════════════════════════════════════════
  Widget _buildMenuAndPreviewTab() => SingleChildScrollView(
    padding: const EdgeInsets.all(_DS.p20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        const _SectionHeader(
          'Menu Builder',
          subtitle: 'Add food items by meal period',
        ),
        ...MealType.values.map((m) => _MealTypeCard(mealType: m)),
        const SizedBox(height: _DS.p32),
        _buildDivider('Setup Preview'),
        const SizedBox(height: _DS.p16),
        _buildPreviewSection(),
      ],
    ),
  );

  Widget _buildDivider(String label) => Row(
    children: [
      const Expanded(child: Divider(color: _DS.border)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(label.toUpperCase(),
            style: _DS.tsSectionTitle.copyWith(fontSize: 11)),
      ),
      const Expanded(child: Divider(color: _DS.border)),
    ],
  );

  Widget _buildPreviewSection() {
    return Column(
      children: [
        // Tables
        _PreviewCard(
          icon: Icons.table_restaurant_outlined,
          title: 'Tables & Seating',
          child: Obx(() => c.tableTypes.isEmpty
              ? const Text('No tables configured', style: _DS.tsMuted)
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: c.tableTypes
                .map((t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.fiber_manual_record,
                      size: 6, color: _DS.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${t.name}  ·  ${t.capacityRange} seats  ·  ${t.availableTables.join(', ')}',
                      style:
                      _DS.tsBody.copyWith(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ))
                .toList(),
          )),
        ),
        // Timings
        _PreviewCard(
          icon: Icons.schedule_outlined,
          title: 'Meal Timings',
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: MealType.values.map((meal) {
              final slots = c.getSlotsByMeal(meal);
              if (slots.isEmpty) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.name.capitalizeFirst!,
                        style: _DS.tsLabel.copyWith(
                            color: _mealColor(meal), fontSize: 13)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: slots
                          .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _mealColor(meal)
                              .withOpacity(0.10),
                          borderRadius:
                          BorderRadius.circular(6),
                        ),
                        child: Text(s.displayTime,
                            style: TextStyle(
                                fontSize: 11,
                                color: _mealColor(meal),
                                fontWeight: FontWeight.w600)),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),
        ),
        // Menu
        _PreviewCard(
          icon: Icons.menu_book_outlined,
          title: 'Menu Items',
          child: Obx(() {
            final hasItems =
            c.mealMenus.any((m) => m.foodItems.isNotEmpty);
            if (!hasItems) {
              return const Text('No menu items added',
                  style: _DS.tsMuted);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: c.mealMenus.map((menu) {
                if (menu.foodItems.isEmpty) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(menu.mealType.name.capitalizeFirst!,
                          style: _DS.tsLabel.copyWith(
                              color: _mealColor(menu.mealType),
                              fontSize: 13)),
                      const SizedBox(height: 6),
                      ...menu.foodItems.map((food) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.fiber_manual_record,
                                size: 6, color: _DS.textMuted),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(food.name,
                                    style: _DS.tsBody)),
                            Text(
                                '₹${food.price.toStringAsFixed(0)}',
                                style: _DS.tsPrice),
                          ],
                        ),
                      )),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ),
        const SizedBox(height: _DS.p12),
        _PrimaryBtn(
          label: 'Refresh Preview',
          icon: Icons.refresh_rounded,
          loading: false,
          onPressed: c.fetchSetupPreview,
        ),
        const SizedBox(height: _DS.p24),
      ],
    );
  }

  // Meal helpers
  IconData _mealIcon(MealType m) {
    switch (m) {
      case MealType.breakfast:
        return Icons.free_breakfast_outlined;
      case MealType.lunch:
        return Icons.lunch_dining_outlined;
      case MealType.dinner:
        return Icons.dinner_dining_outlined;
    }
  }

  Color _mealColor(MealType m) {
    switch (m) {
      case MealType.breakfast:
        return _DS.mealBreakfast;
      case MealType.lunch:
        return _DS.mealLunch;
      case MealType.dinner:
        return _DS.mealDinner;
    }
  }
}

// ─── Preview Card ─────────────────────────────────────────────────────────────
class _PreviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _PreviewCard(
      {required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: _DS.p12),
    decoration: BoxDecoration(
      color: _DS.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _DS.border),
      boxShadow: [_DS.cardShadow],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: _DS.p16, vertical: _DS.p12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: _DS.border)),
          ),
          child: Row(
            children: [
              Icon(icon, color: _DS.amber, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: _DS.tsLabel
                      .copyWith(fontSize: 15, letterSpacing: 0.2)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(_DS.p16),
          child: child,
        ),
      ],
    ),
  );
}

// ─── Time Chip ────────────────────────────────────────────────────────────────
class _TimeChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onDelete;

  const _TimeChip(
      {required this.label, required this.color, required this.onDelete});

  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.only(left: 10, right: 6, top: 5, bottom: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.10),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onDelete,
          child: Icon(Icons.close_rounded, size: 14, color: color),
        ),
      ],
    ),
  );
}

// ─── Info Chip ────────────────────────────────────────────────────────────────
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
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: _DS.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: _DS.tsMuted.copyWith(fontSize: 11)),
      ],
    ),
  );
}

// ─── Icon Button ──────────────────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _IconBtn(
      {required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _DS.amberDim,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: _DS.amber, size: 18),
      ),
    ),
  );
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String sub;

  const _EmptyState(
      {required this.icon, required this.message, required this.sub});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(40),
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _DS.surfaceElevated,
            shape: BoxShape.circle,
            border: Border.all(color: _DS.border),
          ),
          child: Icon(icon, size: 32, color: _DS.textMuted),
        ),
        const SizedBox(height: 16),
        Text(message,
            style: _DS.tsLabel.copyWith(color: _DS.textSecondary)),
        const SizedBox(height: 4),
        Text(sub, style: _DS.tsMuted),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════
// MEAL TYPE CARD
// ═══════════════════════════════════════════════════════════════════
class _MealTypeCard extends StatelessWidget {
  final MealType mealType;

  const _MealTypeCard({required this.mealType});

  RestaurantmenuController get c => Get.find();

  IconData get _icon {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.free_breakfast_outlined;
      case MealType.lunch:
        return Icons.lunch_dining_outlined;
      case MealType.dinner:
        return Icons.dinner_dining_outlined;
    }
  }

  Color get _color {
    switch (mealType) {
      case MealType.breakfast:
        return _DS.mealBreakfast;
      case MealType.lunch:
        return _DS.mealLunch;
      case MealType.dinner:
        return _DS.mealDinner;
    }
  }

  @override
  Widget build(BuildContext context) {
    final menu = c.getMealMenu(mealType);
    final isExpanded = c.expandedCards[mealType]!;
    final pickedImage = c.pickedImages[mealType]!;

    return Obx(() {
      final expanded = isExpanded.value;
      return Container(
        margin: const EdgeInsets.only(bottom: _DS.p12),
        decoration: BoxDecoration(
          color: _DS.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: expanded ? _color.withOpacity(0.4) : _DS.border,
            width: expanded ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (expanded)
              BoxShadow(
                  color: _color.withOpacity(0.06), blurRadius: 16),
            _DS.cardShadow,
          ],
        ),
        child: Column(
          children: [
            // ── Header ──
            InkWell(
              onTap: () => c.toggleCard(mealType),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(_DS.p16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _color,
                            Color.lerp(_color, Colors.black, 0.25)!,
                          ],
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
                          Text(
                            mealType.name.capitalizeFirst!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _color,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Obx(() => Text(
                            '${menu.foodItems.length} item${menu.foodItems.length != 1 ? 's' : ''} on menu',
                            style: _DS.tsMuted,
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
                  ],
                ),
              ),
            ),

            // ── Expanded Content ──
            if (expanded) ...[
              Divider(color: _DS.border, height: 1),
              Padding(
                padding: const EdgeInsets.all(_DS.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Item',
                      style:
                      _DS.tsSectionTitle.copyWith(color: _color),
                    ),
                    const SizedBox(height: _DS.p12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: c.foodNameCtrls[mealType],
                            style: const TextStyle(
                                color: _DS.textPrimary),
                            decoration: _field('Food Name'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: c.foodPriceCtrls[mealType],
                            style: const TextStyle(
                                color: _DS.textPrimary),
                            keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: _field('Price ₹'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: c.descriptionCtrls[mealType],
                      style:
                      const TextStyle(color: _DS.textPrimary),
                      maxLines: 2,
                      decoration:
                      _field('Description (optional)'),
                    ),
                    const SizedBox(height: 10),
                    // Image picker
                    Obx(() => pickedImage.value != null
                        ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(12),
                          child: Image.file(
                            pickedImage.value!,
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () =>
                            pickedImage.value = null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black
                                    .withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              padding:
                              const EdgeInsets.all(4),
                              child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                        : GestureDetector(
                      onTap: () =>
                          c.pickFoodImage(mealType),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: _DS.surfaceElevated,
                          borderRadius:
                          BorderRadius.circular(12),
                          border:
                          Border.all(color: _DS.border),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                                Icons
                                    .add_photo_alternate_outlined,
                                color: _color,
                                size: 20),
                            const SizedBox(width: 8),
                            Text('Add Photo',
                                style: TextStyle(
                                    color: _color,
                                    fontWeight:
                                    FontWeight.w600,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: _DS.p12),
                    Obx(() => _PrimaryBtn(
                      label: 'Add to Menu',
                      icon: Icons.add_rounded,
                      loading: c.isAddingMenuItem.value,
                      color: _color,
                      onPressed: c.isAddingMenuItem.value
                          ? null
                          : () => c.submitFoodItem(mealType),
                    )),

                    // ── Food List ──
                    Obx(() {
                      if (menu.foodItems.isEmpty)
                        return const SizedBox();
                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: _DS.p20),
                          Divider(color: _DS.border),
                          const SizedBox(height: _DS.p12),
                          Text('On the Menu',
                              style: _DS.tsSectionTitle
                                  .copyWith(color: _color)),
                          const SizedBox(height: _DS.p12),
                          ...List.generate(
                              menu.foodItems.length, (i) {
                            final food = menu.foodItems[i];
                            return Container(
                              margin: const EdgeInsets.only(
                                  bottom: 8),
                              padding:
                              const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _DS.surfaceElevated,
                                borderRadius:
                                BorderRadius.circular(12),
                                border: Border.all(
                                    color: _DS.border),
                              ),
                              child: Row(
                                children: [
                                  _buildFoodImage(food),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(food.name,
                                            style: _DS.tsLabel
                                                .copyWith(
                                                fontSize:
                                                14)),
                                        if (food.description
                                            .isNotEmpty)
                                          Text(
                                            food.description,
                                            maxLines: 1,
                                            overflow: TextOverflow
                                                .ellipsis,
                                            style: _DS.tsMuted,
                                          ),
                                        const SizedBox(height: 3),
                                        Text(
                                            '₹ ${food.price.toStringAsFixed(2)}',
                                            style: _DS.tsPrice),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.delete_outline,
                                        color: _DS.danger,
                                        size: 18),
                                    onPressed: () =>
                                        c.removeFoodItemLocally(
                                            mealType, food),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildFoodImage(FoodItem food) {
    final placeholder = Container(
      width: 52,
      height: 52,
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
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      );
    }
    return placeholder;
  }
}