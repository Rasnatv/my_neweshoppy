import 'package:entenaadu/app/modules/admin_home/view/restaurant/restaurantmenumanagementwidget/shared_uihelpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/style/app_colors.dart';
import '../../../../../data/models/adminretaurant_menumodel.dart';
import '../controller/restaurant_menuaddingcontroller.dart';
import 'meal_typecard.dart';
import 'mealclricons.dart';


class MenuTabzz extends StatelessWidget {
  const MenuTabzz({super.key});

  RestaurantmenuController get c => Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasTable = c.tableTypes.isNotEmpty;
      final hasTiming = c.timeSlots.isNotEmpty;

      if (!hasTable) {
        return lockedTabzz(
          icon: Icons.table_restaurant_outlined,
          title: 'Tables Required',
          subtitle:
          'Please add at least one table type\nbefore building the menu.',
          actionLabel: 'Go to Tables',
          onAction: () =>
              DefaultTabController.of(context)?.animateTo(0),
        );
      }

      if (!hasTiming) {
        return lockedTabzz(
          icon: Icons.schedule_outlined,
          title: 'Meal Timings Required',
          subtitle:
          'Please set up meal timings\nbefore adding menu items.',
          actionLabel: 'Go to Timings',
          onAction: () =>
              DefaultTabController.of(context)?.animateTo(1),
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
                  // ── Menu Builder ─────────────────────────────────────────
                  buildCardzz(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeaderzz(
                            icon: Icons.restaurant_menu_rounded,
                            title: 'Menu Builder',
                            subtitle: 'Add food items by meal period',
                          ),
                          const SizedBox(height: 16),
                          ...MealType.values
                              .map((m) => MealTypeCardzz(mealType: m)),
                        ]),
                  ),

                  // ── Setup Preview ────────────────────────────────────────
                  buildCardzz(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeaderzz(
                            icon: Icons.preview_outlined,
                            title: 'Setup Preview',
                          ),
                          const SizedBox(height: 16),

                          // Tables preview
                          previewSectionzz(
                            icon: Icons.table_restaurant_outlined,
                            title: 'Tables & Seating',
                            child: Obx(() => c.tableTypes.isEmpty
                                ? Text('No tables configured',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade400))
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: c.tableTypes
                                  .map((t) => Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                    vertical: 3),
                                child: Row(children: [
                                  Icon(
                                      Icons
                                          .fiber_manual_record,
                                      size: 6,
                                      color:
                                      AppColors.kPrimary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${t.name}  ·  ${t.capacityRange} seats  ·  ${t.availableTables.join(', ')}',
                                      style:
                                      const TextStyle(
                                          fontSize: 13,
                                          color: Color(
                                              0xFF5C6080),
                                          height: 1.5),
                                    ),
                                  ),
                                ]),
                              ))
                                  .toList(),
                            )),
                          ),
                          const SizedBox(height: 12),

                          // Timings preview
                          previewSectionzz(
                            icon: Icons.schedule_outlined,
                            title: 'Meal Timings',
                            child: Obx(() => Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: MealType.values.map((meal) {
                                final slots = c.getSlotsByMeal(meal);
                                if (slots.isEmpty) {
                                  return const SizedBox();
                                }
                                final color = mealColorszz(meal);
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(meal.name.capitalizeFirst!,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: color)),
                                      const SizedBox(height: 4),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: slots
                                            .map((s) => Container(
                                          margin:
                                          const EdgeInsets.only(
                                              bottom: 6),
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                              horizontal: 8,
                                              vertical: 4),
                                          decoration: BoxDecoration(
                                            color: color
                                                .withOpacity(0.10),
                                            borderRadius:
                                            BorderRadius.circular(
                                                6),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: [
                                              Text(s.displayTime,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: color,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600)),
                                              if (s.breakDuration > 0)
                                                Text(
                                                  '${s.breakDuration} min break',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: color
                                                          .withOpacity(
                                                          0.7)),
                                                ),
                                              if (s.availableDays
                                                  .isNotEmpty)
                                                Text(
                                                  '${s.availableDays.length} day${s.availableDays.length > 1 ? 's' : ''} scheduled',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: color
                                                          .withOpacity(
                                                          0.7)),
                                                ),
                                            ],
                                          ),
                                        ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )),
                          ),
                          const SizedBox(height: 12),

                          // Menu Items preview
                          previewSectionzz(
                            icon: Icons.menu_book_outlined,
                            title: 'Menu Items',
                            child: Obx(() {
                              final hasItems = c.mealMenus
                                  .any((m) => m.foodItems.isNotEmpty);
                              if (!hasItems) {
                                return Text('No menu items added',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade400));
                              }
                              return Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: c.mealMenus.map((menu) {
                                  if (menu.foodItems.isEmpty) {
                                    return const SizedBox();
                                  }
                                  final color =
                                  mealColorszz(menu.mealType);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            menu.mealType.name
                                                .capitalizeFirst!,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w600,
                                                color: color)),
                                        const SizedBox(height: 6),
                                        ...menu.foodItems
                                            .map((food) => Padding(
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              bottom: 8),
                                          child:
                                          Row(children: [
                                            Builder(
                                                builder: (_) {
                                                  final placeholder =
                                                  Container(
                                                    width: 44,
                                                    height: 44,
                                                    decoration:
                                                    BoxDecoration(
                                                      color: color
                                                          .withOpacity(
                                                          0.10),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          8),
                                                    ),
                                                    child: Icon(
                                                        Icons
                                                            .fastfood_rounded,
                                                        color:
                                                        color,
                                                        size: 20),
                                                  );
                                                  if (food.imageFile !=
                                                      null) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          8),
                                                      child: Image.file(
                                                          food.imageFile!,
                                                          width: 44,
                                                          height:
                                                          44,
                                                          fit: BoxFit
                                                              .cover),
                                                    );
                                                  }
                                                  if (food.imageUrl !=
                                                      null &&
                                                      food.imageUrl!
                                                          .isNotEmpty) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          8),
                                                      child: Image.network(
                                                        food.imageUrl!,
                                                        width: 44,
                                                        height: 44,
                                                        fit: BoxFit
                                                            .cover,
                                                        errorBuilder:
                                                            (_,
                                                            __,
                                                            ___) =>
                                                        placeholder,
                                                      ),
                                                    );
                                                  }
                                                  return placeholder;
                                                }),
                                            const SizedBox(
                                                width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                      food.name,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          13,
                                                          color: Color(
                                                              0xFF5C6080))),
                                                  if (food.description
                                                      .isNotEmpty)
                                                    Text(
                                                        food.description,
                                                        maxLines:
                                                        1,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize:
                                                            11,
                                                            color: Colors
                                                                .grey
                                                                .shade400)),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '₹${food.price.toStringAsFixed(0)}',
                                              style:
                                              const TextStyle(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                color: Color(
                                                    0xFF1DA87A),
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
                          primaryBtnzz(
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
    });
  }
}