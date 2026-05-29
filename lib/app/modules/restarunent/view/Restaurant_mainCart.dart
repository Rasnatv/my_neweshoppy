
import 'package:entenaadu/app/modules/restarunent/view/restarnent_list.dart';
import 'package:entenaadu/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/restaurantmaincartmodel.dart';
import '../../../widgets/delete_widget.dart';
import '../controller/restaurant_maincartcontroller.dart';

// ── Helper: always returns a live FinalCartController ─────────────────────────
FinalCartController _getController() {
  if (Get.isRegistered<FinalCartController>()) {
    return Get.find<FinalCartController>();
  }
  return Get.put(FinalCartController());
}

// ── Binding ───────────────────────────────────────────────────────────────────
class FinalCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinalCartController>(() => FinalCartController());
  }
}

// ── Main Page ─────────────────────────────────────────────────────────────────
class RestaurantFinalCart extends StatelessWidget {
  RestaurantFinalCart({super.key});

  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    // ✅ Single controller instance — resolved once in build, passed to ALL children
    final controller = _getController();

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F3),
        appBar: _buildAppBar(controller),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(color: _primary));
          }

          if (controller.isEmpty) {
            return const _EmptyCartView();
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 130),
            itemCount: controller.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = controller.restaurants[index];
              return _RestaurantCard(
                // ✅ Pass controller + id — no snapshot models
                controller: controller,
                restaurantId: restaurant.restaurantId,
                onRemoveRestaurant: () =>
                    _confirmRemoveRestaurant(context, restaurant, controller),
              );
            },
          );
        }),

        // ✅ bottomNavigationBar — pass controller, reads reactively inside
        bottomNavigationBar: Obx(() {
          if (controller.isLoading.value || controller.isEmpty) {
            return const SizedBox(height: 0);
          }
          if (controller.restaurants.length != 1) {
            return const SizedBox(height: 0);
          }
          return _PlaceOrderBar(controller: controller);
        }),
      ),
    );
  }

  AppBar _buildAppBar(FinalCartController controller) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.offAll(() => RestaurantListPage()),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'My Cart',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      actions: [
        Obx(() {
          final count = controller.restaurants.length;
          if (count == 0) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count ${count == 1 ? 'restaurant' : 'restaurants'}',
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          );
        }),
      ],
    );
  }

  void _confirmRemoveRestaurant(
      BuildContext context,
      FinalCartRestaurantModel restaurant,
      FinalCartController controller) {
    DeleteConfirmDialog.show(
      context: context,
      title: 'Remove Restaurant?',
      message: 'All bookings from "${restaurant.restaurantName}" will be removed.',
      onConfirm: () => controller.removeRestaurant(restaurant.restaurantId),
    );
  }
}

// ── RESTAURANT CARD ───────────────────────────────────────────────────────────
class _RestaurantCard extends StatelessWidget {
  final FinalCartController controller; // ✅ passed in, not looked up
  final int restaurantId;
  final VoidCallback onRemoveRestaurant;

  const _RestaurantCard({
    required this.controller,
    required this.restaurantId,
    required this.onRemoveRestaurant,
  });

  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ Fresh lookup by ID from the passed-in controller
      final freshRestaurant = controller.restaurants
          .firstWhereOrNull((r) => r.restaurantId == restaurantId);

      if (freshRestaurant == null) return const SizedBox.shrink();

      final isDeleting = controller.isDeletingRestaurant(restaurantId);
      final showCardButton = controller.restaurants.length > 1;

      return AnimatedOpacity(
        opacity: isDeleting ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RestaurantHeader(
                restaurant: freshRestaurant,
                onRemove: onRemoveRestaurant,
                isDeleting: isDeleting,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                itemCount: freshRestaurant.bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _BookingCard(
                    controller: controller, // ✅ same instance passed down
                    bookingId: freshRestaurant.bookings[index].bookingId,
                    restaurantId: restaurantId,
                  );
                },
              ),

              // ── Restaurant total + optional button ─────────────────
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${freshRestaurant.bookings.length} '
                                '${freshRestaurant.bookings.length == 1 ? 'booking' : 'bookings'}'
                                ' · ${freshRestaurant.totalItemCount} items',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700),
                          ),
                          Text(
                            '₹${FinalCartController.formatPrice(freshRestaurant.restaurantTotal)}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _primary),
                          ),
                        ],
                      ),
                    ),
                    if (showCardButton) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.toNamed('/payment',
                                arguments: [restaurantId.toString()]);
                          },
                          icon: const Icon(
                              Icons.check_circle_outline_rounded, size: 18),
                          label: const Text('Confirm Booking',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            padding:
                            const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ── RESTAURANT HEADER ─────────────────────────────────────────────────────────
class _RestaurantHeader extends StatelessWidget {
  final FinalCartRestaurantModel restaurant;
  final VoidCallback onRemove;
  final bool isDeleting;

  const _RestaurantHeader({
    required this.restaurant,
    required this.onRemove,
    required this.isDeleting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F5151), Color(0xFF1B7A6D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.restaurant_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(restaurant.restaurantName,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 11, color: Colors.white60),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(restaurant.restaurantLocation,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white60),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: isDeleting ? null : onRemove,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isDeleting
                  ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.delete_outline_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ── BOOKING CARD ──────────────────────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final FinalCartController controller; // ✅ passed in
  final int? bookingId;
  final int restaurantId;

  const _BookingCard({
    required this.controller,
    required this.bookingId,
    required this.restaurantId,
  });

  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ Fresh lookup every rebuild
      final freshRestaurant = controller.restaurants
          .firstWhereOrNull((r) => r.restaurantId == restaurantId);
      if (freshRestaurant == null) return const SizedBox.shrink();

      final freshBooking = freshRestaurant.bookings
          .firstWhereOrNull((b) => b.bookingId == bookingId);
      if (freshBooking == null) return const SizedBox.shrink();

      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0EEEE), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Booking Meta ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.05),
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MetaRow(
                            icon: Icons.calendar_today_rounded,
                            text: _formatDate(freshBooking.bookingDate)),
                        const SizedBox(height: 2),
                        _MetaRow(
                            icon: Icons.access_time_rounded,
                            text: freshBooking.timeSlot),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: _primary.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.table_restaurant_rounded,
                            size: 11, color: _primary),
                        const SizedBox(width: 4),
                        Text(freshBooking.tableNo,
                            style: const TextStyle(
                                fontSize: 11,
                                color: _primary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Items ────────────────────────────────────────────────
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: freshBooking.items.length,
              separatorBuilder: (_, __) => const Divider(
                  height: 16, thickness: 1, color: Color(0xFFEEF0F0)),
              itemBuilder: (context, index) {
                final item = freshBooking.items[index];
                return _ItemRow(
                  controller: controller, // ✅ same instance passed down
                  cartId: item.cartId,
                  restaurantId: restaurantId,
                  bookingId: freshBooking.bookingId,
                  itemName: item.itemName,
                );
              },
            ),

            // ── Booking Total — fresh from freshBooking inside Obx ───
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Booking total: ',
                      style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  Text(
                    '₹${FinalCartController.formatPrice(freshBooking.bookingTotal)}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, dd MMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

// ── ITEM ROW ──────────────────────────────────────────────────────────────────
class _ItemRow extends StatelessWidget {
  final FinalCartController controller; // ✅ passed in
  final String cartId;
  final int restaurantId;
  final int? bookingId;
  final String itemName;

  const _ItemRow({
    required this.controller,
    required this.cartId,
    required this.restaurantId,
    required this.bookingId,
    required this.itemName,
  });

  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ Fresh lookup every rebuild using the passed-in controller
      final restaurant = controller.restaurants
          .firstWhereOrNull((r) => r.restaurantId == restaurantId);
      if (restaurant == null) return const SizedBox.shrink();

      final freshBooking = restaurant.bookings
          .firstWhereOrNull((b) => b.bookingId == bookingId);
      if (freshBooking == null) return const SizedBox.shrink();

      final freshItem =
      freshBooking.items.firstWhereOrNull((i) => i.cartId == cartId);
      if (freshItem == null) return const SizedBox.shrink();

      final isItemDeleting = controller.isDeletingItem(freshItem.cartId);
      final isQtyUpdating =
      controller.isAnyQuantityUpdating(freshItem.cartId);
      final isDecreasing =
      controller.isUpdatingQuantity(freshItem.cartId, 'decrease');
      final isIncreasing =
      controller.isUpdatingQuantity(freshItem.cartId, 'increase');
      final isBusy = isItemDeleting || isQtyUpdating;

      return AnimatedOpacity(
        opacity: isItemDeleting ? 0.4 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row ─────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    freshItem.itemImage,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: _primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fastfood_rounded,
                          size: 24, color: _primary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        freshItem.itemName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${FinalCartController.formatPrice(freshItem.price)} / item',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: isBusy
                      ? null
                      : () => _confirmRemoveItem(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.red.withOpacity(0.18), width: 1),
                    ),
                    alignment: Alignment.center,
                    child: isItemDeleting
                        ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.red))
                        : Icon(Icons.delete_outline_rounded,
                        size: 17,
                        color: isBusy
                            ? Colors.red.withOpacity(0.3)
                            : Colors.red),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Bottom Row ───────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Stepper
                Container(
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _primary.withOpacity(0.2), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StepperButton(
                        icon: Icons.remove_rounded,
                        iconColor: _primary,
                        isLoading: isDecreasing,
                        onTap: isBusy || freshItem.quantity <= 1
                            ? null
                            : () => controller.updateQuantity(
                          restaurantId: restaurantId,
                          bookingId: bookingId,
                          cartId: freshItem.cartId,
                          action: 'decrease',
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 36),
                        alignment: Alignment.center,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 2),
                        child: isQtyUpdating
                            ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _primary))
                            : Text(
                          '${freshItem.quantity}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _primary),
                        ),
                      ),
                      _StepperButton(
                        icon: Icons.add_rounded,
                        iconColor: _primary,
                        isLoading: isIncreasing,
                        onTap: isBusy
                            ? null
                            : () => controller.updateQuantity(
                          restaurantId: restaurantId,
                          bookingId: bookingId,
                          cartId: freshItem.cartId,
                          action: 'increase',
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ Total price — always fresh from freshItem inside Obx
                Text(
                  '₹${FinalCartController.formatPrice(freshItem.totalPrice)}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _primary),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _confirmRemoveItem(BuildContext context) {
    DeleteConfirmDialog.show(
      context: context,
      title: 'Remove Item?',
      message: '"$itemName" will be removed from your cart.',
      onConfirm: () => controller.removeCartItem(
        restaurantId: restaurantId,
        bookingId: bookingId,
        cartId: cartId,
      ),
    );
  }
}

// ── STEPPER BUTTON ────────────────────────────────────────────────────────────
class _StepperButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool isLoading;
  final VoidCallback? onTap;

  const _StepperButton({
    required this.icon,
    required this.iconColor,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
            width: 13,
            height: 13,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: iconColor))
            : Icon(icon,
            size: 16,
            color: onTap == null ? Colors.grey : iconColor),
      ),
    );
  }
}

// ── META ROW ──────────────────────────────────────────────────────────────────
class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 11, color: const Color(0xFF0F5151)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF0F5151),
                  fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

// ── PLACE ORDER BAR ───────────────────────────────────────────────────────────
// ✅ Receives controller, reads ALL values inside its own Obx — fully reactive
class _PlaceOrderBar extends StatelessWidget {
  final FinalCartController controller;

  const _PlaceOrderBar({required this.controller});

  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        // ✅ Obx is HERE inside the widget — reads live values every time
        child: Obx(() {
          final grandTotal = controller.grandTotal;
          final restaurantCount = controller.restaurants.length;
          final totalBookings = controller.totalBookingCount;
          final totalItems = controller.totalItemCount;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grand Total',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(
                        '₹${FinalCartController.formatPrice(grandTotal)}',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _primary),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$restaurantCount '
                            '${restaurantCount == 1 ? 'restaurant' : 'restaurants'}'
                            ' · $totalBookings '
                            '${totalBookings == 1 ? 'booking' : 'bookings'}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 2),
                      Text('$totalItems items • incl. GST',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _primary)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final List<String> restaurantIds = controller.restaurants
                        .map((r) => r.restaurantId.toString())
                        .toList();
                    Get.toNamed('/payment', arguments: restaurantIds);
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded,
                      size: 20),
                  label: const Text('Confirm Booking',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── EMPTY CART ────────────────────────────────────────────────────────────────
class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();
  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
                color: _primary.withOpacity(0.08), shape: BoxShape.circle),
            child: const Icon(Icons.shopping_cart_outlined,
                size: 60, color: _primary),
          ),
          const SizedBox(height: 24),
          const Text('No bookings in cart',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          Text('Book a table at a restaurant to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Get.offAll(RestaurantListPage()),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Browse Restaurants',
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}