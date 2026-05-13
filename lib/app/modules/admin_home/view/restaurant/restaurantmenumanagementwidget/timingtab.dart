import 'package:eshoppy/app/modules/admin_home/view/restaurant/restaurantmenumanagementwidget/shared_uihelpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../common/style/app_colors.dart';
import '../../../../../data/models/adminretaurant_menumodel.dart';
import '../controller/restaurant_menuaddingcontroller.dart';
import 'mealclricons.dart';


class TimingsTabzz extends StatelessWidget {
  const TimingsTabzz({super.key});

  RestaurantmenuController get c => Get.find();

  Future<void> _pickTime(
      BuildContext context, TextEditingController ctrl) async {
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasTable = c.tableTypes.isNotEmpty;

      if (!hasTable) {
        return lockedTabzz(
          icon: Icons.table_restaurant_outlined,
          title: 'Tables Required',
          subtitle:
          'Please add at least one table type\nbefore setting up meal timings.',
          actionLabel: 'Go to Tables',
          onAction: () =>
              DefaultTabController.of(context)?.animateTo(0),
        );
      }

      return SingleChildScrollView(
        child: Column(children: [
          gradientStripzz(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // ── Add Timing Form ──────────────────────────────────────
                  buildCardzz(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeaderzz(
                            icon: Icons.alarm_add_outlined,
                            title: 'Schedule Meal Slots',
                            subtitle:
                            'Define service windows for each meal period',
                          ),
                          const SizedBox(height: 20),

                          // Meal Period dropdown
                          Obx(() => modernDropdownzz<MealType>(
                            label: 'Meal Period',
                            icon: Icons.restaurant_outlined,
                            value: c.selectedMealType.value,
                            items: MealType.values,
                            itemLabel: (m) => m.name.capitalizeFirst!,
                            onChanged: (v) =>
                            c.selectedMealType.value = v!,
                          )),
                          const SizedBox(height: 16),

                          // Start / End time pickers
                          Row(children: [
                            Expanded(
                                child: pickerTextFieldzz(
                                  controller: c.startCtrl,
                                  label: 'Start Time',
                                  icon: Icons.access_time_outlined,
                                  onTap: () =>
                                      _pickTime(context, c.startCtrl),
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: Icon(Icons.arrow_forward_rounded,
                                  color: Colors.grey.shade400, size: 18),
                            ),
                            Expanded(
                                child: pickerTextFieldzz(
                                  controller: c.endCtrl,
                                  label: 'End Time',
                                  icon: Icons.access_time_rounded,
                                  onTap: () =>
                                      _pickTime(context, c.endCtrl),
                                )),
                          ]),
                          const SizedBox(height: 16),

                          // Break duration
                          modernTextFieldzz(
                            controller: c.breakDurationCtrl,
                            label: 'Break Duration (mins)',
                            hint: 'e.g. 20',
                            icon: Icons.coffee_outlined,
                            type: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // ── Available Days Calendar ──────────────────────
                          Obx(() {
                            final mealType =
                                c.selectedMealType.value;
                            final color = mealColorszz(mealType);
                            final now = DateTime.now();
                            final firstDay =
                            DateTime(now.year, now.month, 1);
                            final daysInMonth =
                                DateTime(now.year, now.month + 1, 0)
                                    .day;
                            final startWeekday =
                                firstDay.weekday % 7; // 0 = Sun
                            final monthLabel =
                                '${monthNamezz(now.month)} ${now.year}';

                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: color.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Row(children: [
                                    Icon(
                                        Icons.calendar_month_outlined,
                                        color: color,
                                        size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Available Days',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      monthLabel,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: color.withOpacity(0.6),
                                      ),
                                    ),
                                    const Spacer(),
                                    Obx(() {
                                      final count = c
                                          .selectedDates[mealType]!
                                          .length;
                                      return count == 0
                                          ? Text('None selected',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors
                                                  .grey.shade400))
                                          : Container(
                                        padding:
                                        const EdgeInsets
                                            .symmetric(
                                            horizontal: 8,
                                            vertical: 2),
                                        decoration: BoxDecoration(
                                          color: color
                                              .withOpacity(0.12),
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                        ),
                                        child: Text(
                                          '$count day${count > 1 ? 's' : ''}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: color),
                                        ),
                                      );
                                    }),
                                  ]),
                                  const SizedBox(height: 12),

                                  // Day-of-week headers
                                  Row(
                                    children: ['Su', 'Mo', 'Tu', 'We',
                                      'Th', 'Fr', 'Sa']
                                        .map((d) => Expanded(
                                      child: Center(
                                        child: Text(
                                          d,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Colors
                                                  .grey.shade400),
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 6),

                                  // Calendar grid
                                  Obx(() {
                                    final cells = <Widget>[];
                                    for (int i = 0;
                                    i < startWeekday;
                                    i++) {
                                      cells.add(const SizedBox());
                                    }
                                    for (int day = 1;
                                    day <= daysInMonth;
                                    day++) {
                                      final date = DateTime(
                                          now.year, now.month, day);
                                      final isPast = date.isBefore(
                                          DateTime(now.year, now.month,
                                              now.day));
                                      final isToday =
                                          date.year == now.year &&
                                              date.month ==
                                                  now.month &&
                                              date.day == now.day;
                                      final isSelected =
                                      c.isDateSelected(
                                          mealType, date);

                                      cells.add(GestureDetector(
                                        onTap: isPast
                                            ? null
                                            : () => c.toggleDate(
                                            mealType, date),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                              milliseconds: 150),
                                          margin:
                                          const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? color
                                                : isPast
                                                ? Colors.transparent
                                                : isToday
                                                ? color
                                                .withOpacity(
                                                0.15)
                                                : color
                                                .withOpacity(
                                                0.06),
                                            borderRadius:
                                            BorderRadius.circular(
                                                8),
                                            border: Border.all(
                                              color: isSelected
                                                  ? color
                                                  : isToday
                                                  ? color
                                                  : isPast
                                                  ? Colors.grey
                                                  .shade200
                                                  : color
                                                  .withOpacity(
                                                  0.15),
                                              width: isSelected ||
                                                  isToday
                                                  ? 1.5
                                                  : 1.0,
                                            ),
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Center(
                                              child: Text(
                                                '$day',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w700
                                                      : isToday
                                                      ? FontWeight
                                                      .w700
                                                      : FontWeight
                                                      .w400,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : isPast
                                                      ? Colors.grey
                                                      .shade300
                                                      : isToday
                                                      ? color
                                                      : Colors
                                                      .grey
                                                      .shade700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));
                                    }
                                    return GridView.count(
                                      crossAxisCount: 7,
                                      shrinkWrap: true,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      childAspectRatio: 1,
                                      children: cells,
                                    );
                                  }),
                                  const SizedBox(height: 10),

                                  // Quick-select chips
                                  Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: [
                                        quickSelectChipzz(
                                          label: 'Next 7 days',
                                          color: color,
                                          onTap: () {
                                            for (int i = 0;
                                            i < 7;
                                            i++) {
                                              final d = now.add(
                                                  Duration(days: i));
                                              if (!c.isDateSelected(
                                                  mealType, d)) {
                                                c.toggleDate(
                                                    mealType, d);
                                              }
                                            }
                                          },
                                        ),
                                        quickSelectChipzz(
                                          label: 'This month',
                                          color: color,
                                          onTap: () {
                                            for (int i = 0;
                                            i < daysInMonth;
                                            i++) {
                                              final d = DateTime(
                                                  now.year,
                                                  now.month,
                                                  i + 1);
                                              if (!d.isBefore(DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day)) &&
                                                  !c.isDateSelected(
                                                      mealType, d)) {
                                                c.toggleDate(
                                                    mealType, d);
                                              }
                                            }
                                          },
                                        ),
                                        quickSelectChipzz(
                                          label: 'Clear all',
                                          color: Colors.red.shade400,
                                          onTap: () => c
                                              .selectedDates[mealType]!
                                              .clear(),
                                        ),
                                      ]),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 16),

                          // Queue button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.kPrimary,
                                side: BorderSide(
                                    color: AppColors.kPrimary,
                                    width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12)),
                              ),
                              icon: const Icon(
                                  Icons.add_alarm_rounded,
                                  size: 18),
                              label: const Text('Queue Slot',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5)),
                              onPressed: c.addToPendingSlots,
                            ),
                          ),

                          // Pending queue preview
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Icon(Icons.pending_actions,
                                        color: Colors.orange.shade700,
                                        size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                          '$total slot(s) queued',
                                          style: TextStyle(
                                              color:
                                              Colors.orange.shade800,
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight.w600)),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          c.pendingSlots.clear(),
                                      child: Text('Clear all',
                                          style: TextStyle(
                                              color: Colors.red.shade400,
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w600)),
                                    ),
                                  ]),
                                  const SizedBox(height: 8),
                                  ...c.pendingSlots.entries.map(
                                        (entry) => Column(
                                      children: entry.value
                                          .map((slot) => Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(top: 4),
                                        child: Row(children: [
                                          Icon(
                                              mealIconszz(
                                                  entry.key),
                                              size: 14,
                                              color:
                                              mealColorszz(
                                                  entry
                                                      .key)),
                                          const SizedBox(
                                              width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  '${entry.key.name.capitalizeFirst}: '
                                                      '${slot.startTime} → ${slot.endTime}'
                                                      '${slot.breakDuration > 0 ? '  (${slot.breakDuration} min break)' : ''}',
                                                  style: const TextStyle(
                                                      fontSize:
                                                      12,
                                                      color: Color(
                                                          0xFF5C6080)),
                                                ),
                                                if (slot.availableDays
                                                    .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        top:
                                                        3),
                                                    child: Wrap(
                                                      spacing: 4,
                                                      runSpacing:
                                                      4,
                                                      children: slot
                                                          .availableDays
                                                          .map((d) =>
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal:
                                                                6,
                                                                vertical:
                                                                2),
                                                            decoration:
                                                            BoxDecoration(
                                                              color: mealColorszz(entry.key).withOpacity(0.12),
                                                              borderRadius:
                                                              BorderRadius.circular(4),
                                                            ),
                                                            child:
                                                            Text(
                                                              d,
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: mealColorszz(entry.key)),
                                                            ),
                                                          ))
                                                          .toList(),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 20),
                          Obx(() => primaryBtnzz(
                            label: 'Save Timings',
                            icon: Icons.save_rounded,
                            loading: c.isAddingTimings.value,
                            onPressed: c.isAddingTimings.value ||
                                c.pendingSlots.isEmpty
                                ? null
                                : () async {
                              await c.addMealTimings(
                                  c.pendingSlots);
                              c.pendingSlots.clear();
                            },
                          )),
                        ]),
                  ),

                  // ── Saved Timings ────────────────────────────────────────
                  buildCardzz(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeaderzz(
                            icon: Icons.event_available_outlined,
                            title: 'Saved Timings',
                            subtitle:
                            'Current service schedule — tap × to delete',
                          ),
                          const SizedBox(height: 16),
                          Obx(() => Column(
                            children: MealType.values.map((meal) {
                              final slots = c.getSlotsByMeal(meal);
                              final color = mealColorszz(meal);
                              return Container(
                                margin:
                                const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: slots.isNotEmpty
                                      ? color.withOpacity(0.04)
                                      : Colors.grey.shade50,
                                  borderRadius:
                                  BorderRadius.circular(14),
                                  border: Border.all(
                                    color: slots.isNotEmpty
                                        ? color.withOpacity(0.25)
                                        : Colors.grey.shade200,
                                    width:
                                    slots.isNotEmpty ? 1.5 : 1.0,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Container(
                                        padding:
                                        const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                          color.withOpacity(0.12),
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                            mealIconszz(meal),
                                            color: color,
                                            size: 18),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(meal.name.capitalizeFirst!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w700,
                                              color:
                                              Color(0xFF1A1D2E))),
                                      const Spacer(),
                                      Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3),
                                        decoration: BoxDecoration(
                                          color: slots.isNotEmpty
                                              ? Colors.green.shade50
                                              : Colors.grey.shade100,
                                          borderRadius:
                                          BorderRadius.circular(6),
                                          border: Border.all(
                                            color: slots.isNotEmpty
                                                ? Colors.green.shade200
                                                : Colors.grey.shade300,
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
                                        children: slots
                                            .map((s) => Container(
                                          padding: const EdgeInsets
                                              .only(
                                              left: 10,
                                              right: 6,
                                              top: 5,
                                              bottom: 5),
                                          decoration:
                                          BoxDecoration(
                                            color: color
                                                .withOpacity(
                                                0.10),
                                            borderRadius:
                                            BorderRadius
                                                .circular(8),
                                            border: Border.all(
                                                color: color
                                                    .withOpacity(
                                                    0.3)),
                                          ),
                                          child: Row(
                                              mainAxisSize:
                                              MainAxisSize
                                                  .min,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  mainAxisSize:
                                                  MainAxisSize
                                                      .min,
                                                  children: [
                                                    Text(
                                                        s.displayTime,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: color,
                                                            fontWeight: FontWeight.w600)),
                                                    if (s.breakDuration >
                                                        0)
                                                      Text(
                                                        '${s.breakDuration} min break',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: color.withOpacity(0.7)),
                                                      ),
                                                    if (s.availableDays
                                                        .isNotEmpty)
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            top:
                                                            3),
                                                        child:
                                                        Text(
                                                          '${s.availableDays.length} day${s.availableDays.length > 1 ? 's' : ''}',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: color.withOpacity(0.7),
                                                              fontWeight: FontWeight.w500),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                    width: 6),
                                                GestureDetector(
                                                  onTap: () =>
                                                      c.removeTimeSlot(
                                                          s),
                                                  child: Icon(
                                                      Icons
                                                          .close_rounded,
                                                      size: 14,
                                                      color:
                                                      color),
                                                ),
                                              ]),
                                        ))
                                            .toList(),
                                      ),
                                    ] else ...[
                                      const SizedBox(height: 6),
                                      Text('No slots added',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                              Colors.grey.shade400)),
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
    });
  }
}