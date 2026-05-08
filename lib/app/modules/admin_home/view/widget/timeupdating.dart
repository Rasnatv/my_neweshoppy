import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../data/models/admin_restarant_menuupdatemodel.dart';
import '../../../../widgets/delete_widget.dart';
import '../restaurant/controller/restaurant_menuupdatecontroller.dart';
import 'menuuihelper.dart';

// ─── Timings Tab ──────────────────────────────────────────────────────────────
class TimingsTab extends StatelessWidget {
  final String tag;
  const TimingsTab({super.key, required this.tag});

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
              leftLabel: 'Edit Timings',
              rightLabel: 'Add New Slot',
              leftIcon: Icons.edit_calendar_outlined,
              rightIcon: Icons.alarm_add_outlined,
              isAddMode: c.timingTabMode.value == TabMode.addNew,
              onToggle: (addMode) => c.timingTabMode.value =
              addMode ? TabMode.addNew : TabMode.existing,
            )),
            const SizedBox(height: 20),

            // Add New
            Obx(() {
              if (c.timingTabMode.value != TabMode.addNew)
                return const SizedBox();
              return _AddTimingForm(tag: tag, context: context);
            }),

            // Edit Existing
            Obx(() {
              if (c.timingTabMode.value != TabMode.existing)
                return const SizedBox();
              return _ExistingTimings(tag: tag, context: context);
            }),
          ],
        ),
      ),
    ]),
  );
}

// ─── Add Timing Form ──────────────────────────────────────────────────────────
class _AddTimingForm extends StatelessWidget {
  final String tag;
  final BuildContext context;
  const _AddTimingForm({required this.tag, required this.context});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  Future<void> _pickTime(TextEditingController ctrl) async {
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
            onSurface: DS.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) ctrl.text = c.formatTimeTo12h(picked);
  }

  @override
  Widget build(BuildContext ctx) => buildCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          icon: Icons.alarm_add_outlined,
          title: 'Add New Meal Slot',
          subtitle: 'Define service windows for each meal period',
        ),
        const SizedBox(height: 16),

        // Info banner
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border:
            Border.all(color: AppColors.kPrimary.withOpacity(0.2)),
          ),
          child: Row(children: [
            Icon(Icons.info_outline_rounded,
                color: AppColors.kPrimary, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Each meal period can have only one slot. '
                    'Delete the existing slot first to change it.',
                style: TextStyle(
                    color: AppColors.kPrimary, fontSize: 12, height: 1.5),
              ),
            ),
          ]),
        ),

        // Meal selector
        Obx(() => modernDropdown<String>(
          label: 'Meal Period',
          icon: Icons.restaurant_outlined,
          value: c.addSelectedMeal.value,
          items: ['breakfast', 'lunch', 'dinner'],
          itemLabel: (m) => m.capitalizeFirst!,
          onChanged: (v) => c.addSelectedMeal.value = v!,
        )),
        const SizedBox(height: 16),

        // Time pickers
        Row(children: [
          Expanded(
              child: pickerField(
                label: 'Start Time',
                controller: c.addStartCtrl,
                icon: Icons.access_time_outlined,
                onTap: () => _pickTime(c.addStartCtrl),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.arrow_forward_rounded,
                color: Colors.grey.shade400, size: 18),
          ),
          Expanded(
              child: pickerField(
                label: 'End Time',
                controller: c.addEndCtrl,
                icon: Icons.access_time_rounded,
                onTap: () => _pickTime(c.addEndCtrl),
              )),
        ]),
        const SizedBox(height: 16),

        modernTextField(
          controller: c.addBreakCtrl,
          label: 'Break Duration (mins)',
          hint: 'e.g. 20',
          icon: Icons.coffee_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        // Queue button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.kPrimary,
              side: BorderSide(color: AppColors.kPrimary, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add_alarm_rounded, size: 18),
            label: const Text('Queue Slot',
                style: TextStyle(
                    fontWeight: FontWeight.w700, letterSpacing: 0.5)),
            onPressed: c.addToPendingSlots,
          ),
        ),

        // Pending queue display
        Obx(() {
          final total = c.pendingSlots.values.fold(0, (s, e) => s + e.length);
          if (total == 0) return const SizedBox();
          return _PendingSlotsDisplay(tag: tag);
        }),

        const SizedBox(height: 20),
        Obx(() => primaryBtn(
          label: 'Save Timings',
          icon: Icons.save_rounded,
          loading: c.isAddingTimings.value,
          onPressed: c.isAddingTimings.value || c.pendingSlots.isEmpty
              ? null
              : c.submitAddTimings,
        )),
      ],
    ),
  );
}

// ─── Pending Slots Display ────────────────────────────────────────────────────
class _PendingSlotsDisplay extends StatelessWidget {
  final String tag;
  const _PendingSlotsDisplay({required this.tag});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext context) => Obx(() {
    final total =
    c.pendingSlots.values.fold(0, (s, e) => s + e.length);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
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
          ...c.pendingSlots.entries.map((entry) => Column(
            children: entry.value
                .map((slot) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(children: [
                Icon(mealIcon(entry.key),
                    size: 14,
                    color: mealColor(entry.key)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${entry.key.capitalizeFirst}: ${slot.display}',
                    style: const TextStyle(
                        fontSize: 12, color: DS.textSub),
                  ),
                ),
              ]),
            ))
                .toList(),
          )),
        ],
      ),
    );
  });
}

// ─── Existing Timings ─────────────────────────────────────────────────────────
class _ExistingTimings extends StatelessWidget {
  final String tag;
  final BuildContext context;
  const _ExistingTimings({required this.tag, required this.context});

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  @override
  Widget build(BuildContext ctx) => Obx(() {
    if (c.isLoadingTimings.value)
      return buildCard(child: loadingIndicator());
    if (c.timings.isEmpty)
      return buildCard(
        child: emptyState(
          icon: Icons.schedule_outlined,
          message: 'No timings found',
          sub: 'Switch to "Add New Slot" to create one',
        ),
      );
    return Column(children: [
      ...['breakfast', 'lunch', 'dinner'].map((meal) {
        final timing = c.getTimingByMeal(meal);
        if (timing == null) return const SizedBox();
        return MealTimingCard(
          tag: tag,
          meal: meal,
          timing: timing,
          context: context,
        );
      }),
      const SizedBox(height: 8),
      Obx(() => primaryBtn(
        label: 'Save All Timings',
        icon: Icons.save_rounded,
        loading: c.isUpdatingTimings.value,
        onPressed:
        c.isUpdatingTimings.value ? null : c.updateTimings,
      )),
    ]);
  });
}

// ─── Meal Timing Card ─────────────────────────────────────────────────────────
class MealTimingCard extends StatelessWidget {
  final String tag;
  final String meal;
  final MealTimingModel timing;
  final BuildContext context;
  const MealTimingCard({
    super.key,
    required this.tag,
    required this.meal,
    required this.timing,
    required this.context,
  });

  RestaurantMenuUpdateController get c =>
      Get.find<RestaurantMenuUpdateController>(tag: tag);

  Future<void> _pickTime(TextEditingController ctrl) async {
    final initial = c.parseTimeToTimeOfDay(ctrl.text);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) ctrl.text = c.formatTimeTo12h(picked);
  }

  @override
  Widget build(BuildContext ctx) {
    final color = mealColor(meal);
    final ctrls = c.timingControllers[meal];
    if (ctrls == null) return const SizedBox();

    return buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: sectionHeader(
                icon: mealIcon(meal),
                title: meal.capitalizeFirst!,
                subtitle: 'Edit service window for ${meal.capitalizeFirst}',
                iconColor: color,
              ),
            ),
            // Delete button
            Obx(() => c.isDeletingTiming.value
                ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2))
                : IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  color: Colors.red.shade400, size: 22),
              tooltip: 'Delete this timing',
              onPressed: () => DeleteConfirmDialog.show(
                context: context,
                title: 'Delete Timing',
                message:
                'Delete ${meal.capitalizeFirst} timing? This cannot be undone.',
                onConfirm: () => c.deleteTimingSlot(timing),
              ),
            )),
          ]),
          const SizedBox(height: 20),

          Row(children: [
            Expanded(
                child: pickerField(
                  label: 'Start Time',
                  controller: ctrls['start']!,
                  icon: Icons.access_time_outlined,
                  onTap: () => _pickTime(ctrls['start']!),
                  accentColor: color,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.arrow_forward_rounded,
                  color: Colors.grey.shade400, size: 18),
            ),
            Expanded(
                child: pickerField(
                  label: 'End Time',
                  controller: ctrls['end']!,
                  icon: Icons.access_time_rounded,
                  onTap: () => _pickTime(ctrls['end']!),
                  accentColor: color,
                )),
          ]),
          const SizedBox(height: 16),

          modernTextField(
            controller: ctrls['break']!,
            label: 'Break Duration (mins)',
            hint: 'e.g. 20',
            icon: Icons.coffee_outlined,
            keyboardType: TextInputType.number,
            accentColor: color,
          ),
        ],
      ),
    );
  }
}