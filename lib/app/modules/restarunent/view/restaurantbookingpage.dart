
import 'package:eshoppy/app/modules/restarunent/view/restarnent_list.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../controller/restaurant_controller.dart';
import '../controller/restaurantbooking_controller.dart';
import '../controller/restaurantcartcontroller.dart';
import '../controller/restaurant_maincartcontroller.dart';

class RestaurantBookingPage extends StatelessWidget {
  RestaurantBookingPage({super.key});

  final RestaurantBookingController controller = () {
    if (Get.isRegistered<RestaurantBookingController>()) {
      Get.delete<RestaurantBookingController>(force: true);
    }
    return Get.put(RestaurantBookingController());
  }();

  Future<void> _showSuccessSheet(
      BuildContext context, int restaurantId) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingSuccessSheet(restaurantId: restaurantId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F6F3),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          title: const Text(
            'Book Your Table',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          backgroundColor: AppColors.restaurantclr,
          automaticallyImplyLeading: true,
        ),

        // ── Body ────────────────────────────────────────────────────────────
        body: Obx(() {
          // Full-page loader only on very first load (meals empty + loading)
          if (controller.isLoadingSlots.value && controller.meals.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                  color: AppColors.restaurantclr),
            );
          }

          // Always show the full page — date/guests never disappear
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Guests ────────────────────────────────────────────
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(
                        icon: Icons.people_alt_outlined,
                        title: 'Number of Guests',
                      ),
                      const SizedBox(height: 14),
                      Obx(() {
                        final atMin =
                            controller.guests.value <= 1;
                        final atMax = controller.guests.value >=
                            controller.maxGuests.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _CounterButton(
                                  icon: Icons.remove,
                                  enabled: !atMin,
                                  onTap: () {
                                    if (!atMin)
                                      controller.guests.value--;
                                  },
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 56,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.restaurantclr
                                        .withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.restaurantclr
                                          .withOpacity(0.3),
                                      width: 1.2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${controller.guests.value}',
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
                                  enabled: !atMax,
                                  onTap: () {
                                    if (!atMax)
                                      controller.guests.value++;
                                  },
                                ),
                                const SizedBox(width: 12),
                                Obx(() =>
                                controller.isLoadingTables.value
                                    ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors
                                        .restaurantclr,
                                  ),
                                )
                                    : const SizedBox.shrink()),
                                if (atMax &&
                                    controller.maxGuests.value < 99) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.orange.withOpacity(0.12),
                                      borderRadius:
                                      BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Max ${controller.maxGuests.value}',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (controller.totalSeats.value > 0) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Total seats available: ${controller.totalSeats.value}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600),
                              ),
                            ],
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── Date ──────────────────────────────────────────────
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(
                        icon: Icons.calendar_month_outlined,
                        title: 'Select Date',
                      ),
                      const SizedBox(height: 14),
                      Obx(() => GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                            controller.selectedDate.value,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365)),
                            builder: (context, child) => Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.restaurantclr,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface:
                                  const Color(0xFF2D2D2D),
                                ),
                                textButtonTheme:
                                TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                    AppColors.restaurantclr,
                                  ),
                                ),
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: child!,
                            ),
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
                              color: AppColors.restaurantclr
                                  .withOpacity(0.35),
                              width: 1.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.restaurantclr
                                    .withOpacity(0.06),
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
                                  borderRadius:
                                  BorderRadius.circular(8),
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

                // ── Meal section heading ───────────────────────────────
                Row(
                  children: [
                    Icon(Icons.restaurant_menu_outlined,
                        color: AppColors.restaurantclr, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Select Your Meals',
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
                    'Fill in the meals you want. Leave others blank to skip.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Meal cards OR unavailable banner ───────────────────
                Obx(() {
                  // Show a small inline loader while refreshing for a new date
                  if (controller.isLoadingSlots.value) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 10,
                              offset: Offset(0, 3))
                        ],
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.restaurantclr),
                      ),
                    );
                  }

                  // No meals for selected date — inline banner, page stays
                  if (controller.meals.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.35),
                          width: 1.4,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 10,
                              offset: Offset(0, 3))
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.event_busy_rounded,
                              size: 36,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No Slots Available',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            controller.errorMessage.value.isNotEmpty
                                ? controller.errorMessage.value
                                : 'No time slots are available for the selected date. Please try another date.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                height: 1.5),
                          ),
                        ],
                      ),
                    );
                  }

                  // Meals available — render cards normally
                  return Column(
                    children: List.generate(
                      controller.bookingRows.length,
                          (i) => _MealCard(
                          index: i, controller: controller),
                    ),
                  );
                }),

                const SizedBox(height: 30),
              ],
            ),
          );
        }),

  //       // ── Bottom button ────────────────────────────────────────────────────
  //       bottomNavigationBar: Obx(() => Container(
  //         padding: const EdgeInsets.fromLTRB(20, 14, 20, 55),
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color(0x14000000),
  //               blurRadius: 12,
  //               offset: Offset(0, -4),
  //             )
  //           ],
  //         ),
  //         child: SizedBox(
  //           width: double.infinity,
  //           height: 52,
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: AppColors.restaurantclr,
  //               elevation: 0,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(14)),
  //             ),
  //             onPressed: controller.isSaving.value ||
  //                 controller.meals.isEmpty
  //                 ? null
  //                 : () async {
  //               final saved = await controller.confirmAndSave();
  //               if (!saved) return;
  //
  //               // ✅ FIX: Clear cart for this restaurant after successful booking
  //               if (Get.isRegistered<Restaurantcartcontroller>()) {
  //                 await Get.find<Restaurantcartcontroller>()
  //                     .clearCartOnServer(controller.restaurantId);
  //               }
  //
  //               if (Get.isRegistered<FinalCartController>()) {
  //                 Get.delete<FinalCartController>(force: true);
  //               }
  //
  //               await _showSuccessSheet(
  //                   context, controller.restaurantId);
  //             },
  //             child: controller.isSaving.value
  //                 ? const SizedBox(
  //               height: 22,
  //               width: 22,
  //               child: CircularProgressIndicator(
  //                   color: Colors.white, strokeWidth: 2.5),
  //             )
  //                 : const Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(
  //                     Icons.shopping_cart_checkout_rounded,
  //                     color: Colors.white,
  //                     size: 20),
  //                 SizedBox(width: 10),
  //                 Text(
  //                   'Confirm Booking',
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w700,
  //                       letterSpacing: 0.3),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       )),
  //     ),
  //   );
  // }
          bottomNavigationBar: Obx(
                () => Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 55),
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
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  // ✅ UPDATED CODE
                  onPressed: controller.isSaving.value ||
                      controller.meals.isEmpty
                      ? null
                      : () async {
                    final saved =
                    await controller.confirmAndSave();

                    if (!saved) return;

                    // ✅ Clear restaurant cart instantly
                    if (Get.isRegistered<
                        Restaurantcartcontroller>()) {
                      final cartCtrl =
                      Get.find<Restaurantcartcontroller>();

                      // ✅ Step 1: Clear local + server cart
                      await cartCtrl.clearCartForRestaurant(
                        controller.restaurantId,
                      );

                      // ✅ Step 2: Refresh latest cart
                      await cartCtrl.fetchCart();
                    }

                    // ✅ Remove final cart controller
                    if (Get.isRegistered<
                        FinalCartController>()) {
                      Get.delete<FinalCartController>(
                        force: true,
                      );
                    }

                    // ✅ Show success sheet
                    await _showSuccessSheet(
                      context,
                      controller.restaurantId,
                    );
                  },

                  child: controller.isSaving.value
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_checkout_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Confirm Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )));}

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _BookingSuccessSheet extends StatelessWidget {
  final int restaurantId;
  const _BookingSuccessSheet({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 55),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.22),
                    blurRadius: 22,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 52),
            ),
            const SizedBox(height: 16),
            const Text(
              'Table Reserved! 🎉',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your table is reserved.\nGo to cart → complete payment to confirm your booking.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey, height: 1.6),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.restaurantclr,
                  side: BorderSide(
                      color: AppColors.restaurantclr.withOpacity(0.5),
                      width: 1.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.offAll(() => RestaurantListPage());
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Get.isRegistered<RestaurantController>()) {
                      Get.find<RestaurantController>().fetchRestaurants();
                    }
                  });
                },
                child: const Text(
                  'Continue Browsing or Go to Cart',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared section widgets
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
              offset: Offset(0, 3))
        ],
      ),
      child: child,
    );
  }
}

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

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _CounterButton(
      {required this.icon, required this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color:
          enabled ? AppColors.restaurantclr : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
          boxShadow: enabled
              ? [
            BoxShadow(
              color: AppColors.restaurantclr.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ]
              : [],
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.grey.shade500,
          size: 18,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Meal card  (seating type → table → time slot)
// ─────────────────────────────────────────────────────────────────────────────

class _MealCard extends StatelessWidget {
  final int index;
  final RestaurantBookingController controller;
  const _MealCard({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final row      = controller.bookingRows[index];
      final mealType = row['mealType']?.toString() ?? '';
      final label    = mealType.isNotEmpty
          ? mealType[0].toUpperCase() + mealType.substring(1)
          : '';

      final isComplete =
          (row['seatingType'] ?? '').toString().isNotEmpty &&
              (row['timeSlot']    ?? '').toString().isNotEmpty &&
              (row['tableName']   ?? '').toString().isNotEmpty;

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
                offset: Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card header ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: isComplete
                    ? Colors.teal.withOpacity(0.07)
                    : AppColors.restaurantclr.withOpacity(0.06),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
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
                      color: isComplete
                          ? Colors.teal
                          : AppColors.restaurantclr,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isComplete
                          ? Colors.teal
                          : AppColors.restaurantclr,
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
                          Text('Done',
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

            // ── Card body ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1) Seating type ─────────────────────────────────
                  _FieldLabel('Seating Type'),
                  const SizedBox(height: 8),
                  controller.seatingGroups.isEmpty
                      ? _infoChip(
                    controller.isLoadingTables.value
                        ? 'Loading tables…'
                        : 'No tables available for this guest count',
                    isWarning:
                    !controller.isLoadingTables.value,
                  )
                      : Row(
                    children: controller.availableSeatingTypes
                        .map((type) {
                      final sel =
                          row['seatingType'] == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              controller.setSeating(
                                  index, type),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4),
                            padding:
                            const EdgeInsets.symmetric(
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

                  // 2) Time slot ─────────────────────────────────────
                  _FieldLabel('Time Slot'),
                  const SizedBox(height: 8),
                  _TimeSlotsWidget(
                      index: index, controller: controller),

                  const SizedBox(height: 16),

                  // 3) Table ─────────────────────────────────────────
                  _FieldLabel('Table'),
                  const SizedBox(height: 8),
                  _TablesWidget(
                      index: index, controller: controller),
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
      case 'breakfast':
        return Icons.free_breakfast_outlined;
      case 'lunch':
        return Icons.lunch_dining_outlined;
      case 'dinner':
        return Icons.dinner_dining_outlined;
      default:
        return Icons.restaurant_outlined;
    }
  }

  Widget _infoChip(String msg, {bool isWarning = false}) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (isWarning ? Colors.orange : Colors.grey)
            .withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: (isWarning ? Colors.orange : Colors.grey)
                .withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
              isWarning
                  ? Icons.warning_amber_rounded
                  : Icons.info_outline,
              color: isWarning ? Colors.orange : Colors.grey,
              size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(msg,
                style: TextStyle(
                    fontSize: 12,
                    color:
                    isWarning ? Colors.orange : Colors.grey,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
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
// Time-slot picker
// ─────────────────────────────────────────────────────────────────────────────

class _TimeSlotsWidget extends StatelessWidget {
  final int index;
  final RestaurantBookingController controller;
  const _TimeSlotsWidget(
      {required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final slots    = controller.timeSlotsForRow(index);
      final selected =
          controller.bookingRows[index]['timeSlot']?.toString() ?? '';

      if (slots.isEmpty) {
        return const Text('No slots available',
            style: TextStyle(color: Colors.grey, fontSize: 13));
      }

      final allDisabled = slots.every((s) => !s.isSelectable);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (allDisabled)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.orange.withOpacity(0.3), width: 1),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.orange, size: 14),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'All slots for this meal have passed.',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((slot) {
              final isDisabled = !slot.isSelectable;
              final isSel      = selected == slot.time;

              return GestureDetector(
                onTap: isDisabled
                    ? null
                    : () => controller.setTimeSlot(index, slot.time),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? const Color(0xFFEEEEEE)
                        : isSel
                        ? AppColors.restaurantclr
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDisabled
                          ? Colors.transparent
                          : isSel
                          ? AppColors.restaurantclr
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isDisabled) ...[
                        const Icon(Icons.lock_clock,
                            size: 11, color: Colors.grey),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        slot.time,
                        style: TextStyle(
                          color: isDisabled
                              ? Colors.grey.shade400
                              : isSel
                              ? Colors.white
                              : const Color(0xFF555555),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          decoration: isDisabled
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Table picker
// ─────────────────────────────────────────────────────────────────────────────

class _TablesWidget extends StatelessWidget {
  final int index;
  final RestaurantBookingController controller;
  const _TablesWidget(
      {required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seatingChosen =
          (controller.bookingRows[index]['seatingType'] ?? '')
              .toString()
              .isNotEmpty;

      if (!seatingChosen) {
        return Container(
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey, size: 14),
              SizedBox(width: 6),
              Text('Select seating type first',
                  style:
                  TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        );
      }

      final tables   = controller.tablesForRow(index);
      final selected =
          controller.bookingRows[index]['tableName']?.toString() ??
              '';

      if (tables.isEmpty) {
        return const Text(
          'No tables for selected seating',
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
                padding:
                const EdgeInsets.symmetric(horizontal: 14),
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
                    color: isSel
                        ? Colors.white
                        : const Color(0xFF444444),
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