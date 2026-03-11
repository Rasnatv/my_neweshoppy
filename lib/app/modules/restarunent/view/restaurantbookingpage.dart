//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../common/style/app_text_style.dart';
// import '../controller/restaurantbooking_controller.dart';
// import 'Restaurant_mainCart.dart';
//
// class RestaurantBookingPage extends StatelessWidget {
//   RestaurantBookingPage({super.key});
//
//   final RestaurantBookingController controller = () {
//     // Delete any old instance so a fresh one always reads
//     // the correct restaurant_id from Get.arguments
//     if (Get.isRegistered<RestaurantBookingController>()) {
//       Get.delete<RestaurantBookingController>(force: true);
//     }
//     return Get.put(RestaurantBookingController());
//   }();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Book Your Table",
//             style: AppTextStyle.rTextNunitoWhite17w700),
//         backgroundColor: AppColors.restaurantclr,
//       ),
//       body: Obx(() {
//         if (controller.isLoadingSlots.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (controller.meals.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.info_outline, size: 48, color: Colors.grey),
//                 const SizedBox(height: 12),
//                 Text(
//                   controller.errorMessage.value.isNotEmpty
//                       ? controller.errorMessage.value
//                       : "No time slots available.",
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           );
//         }
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               // ── GUESTS ──────────────────────────────────────────────
//               _title("Number of Guests"),
//               const SizedBox(height: 8),
//               Obx(() => Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       if (controller.guests.value > 1) {
//                         controller.guests.value--;
//                       }
//                     },
//                     icon: const Icon(Icons.remove_circle_outline),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: AppColors.restaurantclr.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       "${controller.guests.value}",
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => controller.guests.value++,
//                     icon: const Icon(Icons.add_circle_outline),
//                   ),
//                   Obx(() => controller.isLoadingTables.value
//                       ? const Padding(
//                     padding: EdgeInsets.only(left: 8),
//                     child: SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                             strokeWidth: 2)),
//                   )
//                       : const SizedBox.shrink()),
//                 ],
//               )),
//               const SizedBox(height: 16),
//
//               // ── DATE ────────────────────────────────────────────────
//               _title("Select Date"),
//               const SizedBox(height: 8),
//               Obx(() => GestureDetector(
//                 onTap: () async {
//                   final picked = await showDatePicker(
//                     context: context,
//                     initialDate: controller.selectedDate.value,
//                     firstDate: DateTime.now(),
//                     lastDate:
//                     DateTime.now().add(const Duration(days: 365)),
//                   );
//                   if (picked != null) {
//                     controller.selectedDate.value = picked;
//                   }
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 12, horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         controller.selectedDate.value
//                             .toLocal()
//                             .toString()
//                             .split(' ')[0],
//                         style: const TextStyle(fontSize: 15),
//                       ),
//                       const Icon(Icons.calendar_today, size: 18),
//                     ],
//                   ),
//                 ),
//               )),
//               const SizedBox(height: 20),
//
//               // ── MEAL CARDS ───────────────────────────────────────────
//               _title("Select Your Meals"),
//               const SizedBox(height: 4),
//               const Text(
//                 "Fill in the meals you want. Leave others blank to skip.",
//                 style: TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               const SizedBox(height: 12),
//
//               Obx(() => Column(
//                 children: List.generate(
//                   controller.bookingRows.length,
//                       (i) => _MealCard(index: i, controller: controller),
//                 ),
//               )),
//
//               const SizedBox(height: 24),
//             ],
//           ),
//         );
//       }),
//
//       // ── ADD TO CART → save to DB immediately then go to cart ────────
//       bottomNavigationBar: Obx(() => Padding(
//         padding: const EdgeInsets.all(20),
//         child: SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.restaurantclr,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//             ),
//             onPressed: controller.isSaving.value
//                 ? null
//                 : () async {
//               // 1. Validate — build summary from completed rows
//               final summary = controller.buildSummary();
//               if (summary == null) {
//                 Get.snackbar(
//                   "Incomplete",
//                   "Please complete at least one meal "
//                       "(seating type, time slot and table).",
//                   backgroundColor: Colors.red,
//                   colorText: Colors.white,
//                 );
//                 return;
//               }
//
//               // 2. Save to DB immediately
//               final saved = await controller.confirmAndSave();
//               if (!saved) {
//                 Get.snackbar(
//                   "Booking Failed",
//                   controller.errorMessage.value.isNotEmpty
//                       ? controller.errorMessage.value
//                       : "Could not save booking. Try again.",
//                   backgroundColor: Colors.red,
//                   colorText: Colors.white,
//                 );
//                 return;
//               }
//
//               // 3. Success → go to cart screen
//               Get.snackbar(
//                 "Added to Cart!",
//                 "Your booking has been saved successfully.",
//                 backgroundColor: Colors.green,
//                 colorText: Colors.white,
//                 duration: const Duration(seconds: 2),
//               );
//               Get.offAll(()=>RestaurantMainCart());
//             },
//             child: controller.isSaving.value
//                 ? const SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(
//                   color: Colors.white, strokeWidth: 2),
//             )
//                 : const Text("Add to Cart",
//                 style: TextStyle(color: Colors.white, fontSize: 16)),
//           ),
//         ),
//       )),
//     );
//   }
//
//   Widget _title(String t) => Text(t,
//       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// class _MealCard extends StatelessWidget {
//   final int index;
//   final RestaurantBookingController controller;
//   const _MealCard({required this.index, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final row       = controller.bookingRows[index];
//       final mealType  = row["mealType"] ?? "";
//       final mealLabel = mealType.isNotEmpty
//           ? mealType[0].toUpperCase() + mealType.substring(1)
//           : "";
//       final isComplete =
//           (row["seatingType"] ?? "").isNotEmpty &&
//               (row["timeSlot"]    ?? "").isNotEmpty &&
//               (row["tableName"]   ?? "").isNotEmpty;
//
//       return Card(
//         margin: const EdgeInsets.only(bottom: 16),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14)),
//         elevation: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // header
//             Container(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: isComplete
//                     ? Colors.teal.shade50
//                     : AppColors.restaurantclr.withOpacity(0.07),
//                 borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(14)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(_mealIcon(mealType),
//                       color:
//                       isComplete ? Colors.teal : AppColors.kPrimary,
//                       size: 22),
//                   const SizedBox(width: 8),
//                   Text(mealLabel,
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: isComplete
//                               ? Colors.teal
//                               : AppColors.kPrimary)),
//                   const Spacer(),
//                   if (isComplete)
//                     const Icon(Icons.check_circle,
//                         color: Colors.teal, size: 20),
//                 ],
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   // ── SEATING ──────────────────────────────────────
//                   _label("Seating Type"),
//                   const SizedBox(height: 6),
//                   controller.seatingGroups.isEmpty
//                       ? const Text("Loading…",
//                       style: TextStyle(
//                           color: Colors.grey, fontSize: 13))
//                       : Row(
//                     children: controller.availableSeatingTypes
//                         .map((type) {
//                       final sel = row["seatingType"] == type;
//                       return Expanded(
//                         child: GestureDetector(
//                           onTap: () =>
//                               controller.setSeating(index, type),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 4),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 10),
//                             decoration: BoxDecoration(
//                               color: sel
//                                   ? AppColors.restaurantclr
//                                   : Colors.grey.shade200,
//                               borderRadius:
//                               BorderRadius.circular(10),
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               type[0].toUpperCase() +
//                                   type.substring(1),
//                               style: TextStyle(
//                                 color: sel
//                                     ? Colors.white
//                                     : Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 14),
//
//                   // ── TIME SLOT ─────────────────────────────────────
//                   _label("Time Slot"),
//                   const SizedBox(height: 6),
//                   _TimeSlotsWidget(
//                       index: index, controller: controller),
//                   const SizedBox(height: 14),
//
//                   // ── TABLE ─────────────────────────────────────────
//                   _label("Table"),
//                   const SizedBox(height: 6),
//                   _TablesWidget(
//                       index: index, controller: controller),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   IconData _mealIcon(String t) {
//     switch (t) {
//       case "breakfast": return Icons.free_breakfast_outlined;
//       case "lunch":     return Icons.lunch_dining_outlined;
//       case "dinner":    return Icons.dinner_dining_outlined;
//       default:          return Icons.restaurant_outlined;
//     }
//   }
//
//   Widget _label(String t) => Text(t,
//       style: const TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: Colors.black54));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// class _TimeSlotsWidget extends StatelessWidget {
//   final int index;
//   final RestaurantBookingController controller;
//   const _TimeSlotsWidget({required this.index, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final slots    = controller.timeSlotsForRow(index);
//       final selected = controller.bookingRows[index]["timeSlot"] ?? "";
//       if (slots.isEmpty) {
//         return const Text("No slots available",
//             style: TextStyle(color: Colors.grey, fontSize: 13));
//       }
//       return Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: slots.map((slot) {
//           final isSel = selected == slot;
//           return GestureDetector(
//             onTap: () => controller.setTimeSlot(index, slot),
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                   vertical: 8, horizontal: 10),
//               decoration: BoxDecoration(
//                 color: isSel ? AppColors.restaurantclr: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(slot,
//                   style: TextStyle(
//                       color: isSel ? Colors.white : Colors.black,
//                       fontSize: 12)),
//             ),
//           );
//         }).toList(),
//       );
//     });
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// class _TablesWidget extends StatelessWidget {
//   final int index;
//   final RestaurantBookingController controller;
//   const _TablesWidget({required this.index, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final seatingChosen =
//           (controller.bookingRows[index]["seatingType"] ?? "").isNotEmpty;
//       if (!seatingChosen) {
//         return const Text("Select seating type first",
//             style: TextStyle(color: Colors.grey, fontSize: 13));
//       }
//       final tables   = controller.tablesForRow(index);
//       final selected = controller.bookingRows[index]["tableName"] ?? "";
//       if (tables.isEmpty) {
//         return const Text("No tables for selected seating",
//             style: TextStyle(color: Colors.grey, fontSize: 13));
//       }
//       return Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: tables.map((table) {
//           final isSel = selected == table;
//           return GestureDetector(
//             onTap: () => controller.setTable(index, table),
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                   vertical: 10, horizontal: 14),
//               decoration: BoxDecoration(
//                 color: isSel ? AppColors.restaurantclr: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(10),
//
//               ),
//               alignment: Alignment.center,
//               child: Text(table,
//                   style: TextStyle(
//                       color: isSel ? Colors.white : Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14)),
//             ),
//           );
//         }).toList(),
//       );
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/restaurantbooking_controller.dart';
import 'Restaurant_mainCart.dart';

class RestaurantBookingPage extends StatelessWidget {
  RestaurantBookingPage({super.key});

  final RestaurantBookingController controller = () {
    if (Get.isRegistered<RestaurantBookingController>()) {
      Get.delete<RestaurantBookingController>(force: true);
    }
    return Get.put(RestaurantBookingController());
  }();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Book Your Table",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.restaurantclr,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingSlots.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.restaurantclr,
            ),
          );
        }
        if (controller.meals.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.restaurantclr.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.restaurant_outlined,
                      size: 44, color: AppColors.restaurantclr),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : "No time slots available.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── GUESTS ──────────────────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      icon: Icons.people_alt_outlined,
                      title: "Number of Guests",
                    ),
                    const SizedBox(height: 14),
                    Obx(() => Row(
                      children: [
                        _CounterButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (controller.guests.value > 1) {
                              controller.guests.value--;
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 56,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.restaurantclr.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                              AppColors.restaurantclr.withOpacity(0.3),
                              width: 1.2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${controller.guests.value}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.restaurantclr,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _CounterButton(
                          icon: Icons.add,
                          onTap: () => controller.guests.value++,
                        ),
                        Obx(() => controller.isLoadingTables.value
                            ? Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.restaurantclr,
                            ),
                          ),
                        )
                            : const SizedBox.shrink()),
                      ],
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── DATE ────────────────────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      icon: Icons.calendar_month_outlined,
                      title: "Select Date",
                    ),
                    const SizedBox(height: 14),
                    Obx(() => GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value,
                          firstDate: DateTime.now(),
                          lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.restaurantclr,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: const Color(0xFF2D2D2D),
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                    AppColors.restaurantclr,
                                  ),
                                ),
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          controller.selectedDate.value = picked;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.restaurantclr.withOpacity(0.35),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.restaurantclr.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.restaurantclr
                                    .withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: AppColors.restaurantclr,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _formatDate(
                                  controller.selectedDate.value),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.restaurantclr,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── MEAL CARDS ───────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.restaurant_menu_outlined,
                      color: AppColors.restaurantclr, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "Select Your Meals",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(left: 28),
                child: Text(
                  "Fill in the meals you want. Leave others blank to skip.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 14),

              Obx(() => Column(
                children: List.generate(
                  controller.bookingRows.length,
                      (i) => _MealCard(
                      index: i, controller: controller),
                ),
              )),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),

      // ── BOTTOM BUTTON ───────────────────────────────────────────────
      bottomNavigationBar: Obx(() => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -4),
            )
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.restaurantclr,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: controller.isSaving.value
                ? null
                : () async {
              final summary = controller.buildSummary();
              if (summary == null) {
                Get.snackbar(
                  "Incomplete",
                  "Please complete at least one meal "
                      "(seating type, time slot and table).",
                  backgroundColor: Colors.red.shade400,
                  colorText: Colors.white,
                  borderRadius: 12,
                  margin: const EdgeInsets.all(12),
                );
                return;
              }
              final saved = await controller.confirmAndSave();
              if (!saved) {
                Get.snackbar(
                  "Booking Failed",
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : "Could not save booking. Try again.",
                  backgroundColor: Colors.red.shade400,
                  colorText: Colors.white,
                  borderRadius: 12,
                  margin: const EdgeInsets.all(12),
                );
                return;
              }
              Get.snackbar(
                "Added to Cart!",
                "Your booking has been saved successfully.",
                backgroundColor: Colors.green.shade500,
                colorText: Colors.white,
                borderRadius: 12,
                margin: const EdgeInsets.all(12),
                duration: const Duration(seconds: 2),
              );
              Get.offAll(() => RestaurantMainCart());
            },
            child: controller.isSaving.value
                ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5),
            )
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_checkout_rounded,
                    color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  "Add to Cart",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    final weekday = days[d.weekday - 1];
    return "$weekday, ${d.day} ${months[d.month - 1]} ${d.year}";
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION CARD WRAPPER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.restaurantclr, size: 19),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COUNTER BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.restaurantclr,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.restaurantclr.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MEAL CARD
// ─────────────────────────────────────────────────────────────────────────────
class _MealCard extends StatelessWidget {
  final int index;
  final RestaurantBookingController controller;
  const _MealCard({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final row = controller.bookingRows[index];
      final mealType = row["mealType"] ?? "";
      final mealLabel = mealType.isNotEmpty
          ? mealType[0].toUpperCase() + mealType.substring(1)
          : "";
      final isComplete =
          (row["seatingType"] ?? "").isNotEmpty &&
              (row["timeSlot"] ?? "").isNotEmpty &&
              (row["tableName"] ?? "").isNotEmpty;

      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isComplete
                ? Colors.teal.withOpacity(0.4)
                : const Color(0xFFEEEEEE),
            width: 1.4,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ──────────────────────────────────────────────
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: isComplete
                    ? Colors.teal.withOpacity(0.07)
                    : AppColors.restaurantclr.withOpacity(0.06),
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: isComplete
                          ? Colors.teal.withOpacity(0.15)
                          : AppColors.restaurantclr.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _mealIcon(mealType),
                      color: isComplete ? Colors.teal : AppColors.restaurantclr,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    mealLabel,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isComplete ? Colors.teal : AppColors.restaurantclr,
                    ),
                  ),
                  const Spacer(),
                  if (isComplete)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.teal, size: 14),
                          SizedBox(width: 4),
                          Text("Done",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── SEATING ─────────────────────────────────────
                  _FieldLabel("Seating Type"),
                  const SizedBox(height: 8),
                  controller.seatingGroups.isEmpty
                      ? const Text("Loading…",
                      style:
                      TextStyle(color: Colors.grey, fontSize: 13))
                      : Row(
                    children: controller.availableSeatingTypes
                        .map((type) {
                      final sel = row["seatingType"] == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              controller.setSeating(index, type),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.restaurantclr
                                  : const Color(0xFFF5F5F5),
                              borderRadius:
                              BorderRadius.circular(10),
                              border: Border.all(
                                color: sel
                                    ? AppColors.restaurantclr
                                    : Colors.transparent,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              type[0].toUpperCase() +
                                  type.substring(1),
                              style: TextStyle(
                                color: sel
                                    ? Colors.white
                                    : const Color(0xFF555555),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // ── TIME SLOT ───────────────────────────────────
                  _FieldLabel("Time Slot"),
                  const SizedBox(height: 8),
                  _TimeSlotsWidget(
                      index: index, controller: controller),

                  const SizedBox(height: 16),

                  // ── TABLE ───────────────────────────────────────
                  _FieldLabel("Table"),
                  const SizedBox(height: 8),
                  _TablesWidget(index: index, controller: controller),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  IconData _mealIcon(String t) {
    switch (t) {
      case "breakfast":
        return Icons.free_breakfast_outlined;
      case "lunch":
        return Icons.lunch_dining_outlined;
      case "dinner":
        return Icons.dinner_dining_outlined;
      default:
        return Icons.restaurant_outlined;
    }
  }
}

Widget _FieldLabel(String t) => Text(
  t,
  style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color(0xFF888888),
      letterSpacing: 0.4),
);

// ─────────────────────────────────────────────────────────────────────────────
// TIME SLOTS
// ─────────────────────────────────────────────────────────────────────────────
class _TimeSlotsWidget extends StatelessWidget {
  final int index;
  final RestaurantBookingController controller;
  const _TimeSlotsWidget(
      {required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final slots = controller.timeSlotsForRow(index);
      final selected = controller.bookingRows[index]["timeSlot"] ?? "";
      if (slots.isEmpty) {
        return const Text("No slots available",
            style: TextStyle(color: Colors.grey, fontSize: 13));
      }
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: slots.map((slot) {
          final isSel = selected == slot;
          return GestureDetector(
            onTap: () => controller.setTimeSlot(index, slot),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color:
                isSel ? AppColors.restaurantclr : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSel
                      ? AppColors.restaurantclr
                      : Colors.transparent,
                ),
              ),
              child: Text(
                slot,
                style: TextStyle(
                  color:
                  isSel ? Colors.white : const Color(0xFF555555),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TABLES — horizontal scrollable row with compact chips
// ─────────────────────────────────────────────────────────────────────────────
class _TablesWidget extends StatelessWidget {
  final int index;
  final RestaurantBookingController controller;
  const _TablesWidget({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seatingChosen =
          (controller.bookingRows[index]["seatingType"] ?? "").isNotEmpty;

      if (!seatingChosen) {
        return Container(
          padding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey, size: 14),
              SizedBox(width: 6),
              Text(
                "Select seating type first",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
      }

      final tables = controller.tablesForRow(index);
      final selected = controller.bookingRows[index]["tableName"] ?? "";

      if (tables.isEmpty) {
        return const Text(
          "No tables for selected seating",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        );
      }

      return SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tables.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final table = tables[i];
            final isSel = selected == table;
            return GestureDetector(
              onTap: () => controller.setTable(index, table),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 0),
                decoration: BoxDecoration(
                  color: isSel
                      ? AppColors.restaurantclr
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSel
                        ? AppColors.restaurantclr
                        : const Color(0xFFDDDDDD),
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  table,
                  style: TextStyle(
                    color: isSel ? Colors.white : const Color(0xFF444444),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}