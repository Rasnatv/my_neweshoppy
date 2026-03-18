
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/restaurantmaincartmodel.dart';
import '../controller/restaurant_maincartcontroller.dart';

// ── BINDINGS ──────────────────────────────────────────────────────────────────
class FinalCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinalCartController>(() => FinalCartController());
  }
}

// ── MAIN PAGE ─────────────────────────────────────────────────────────────────
class RestaurantFinalCart extends StatelessWidget {
  RestaurantFinalCart({super.key});

  final FinalCartController controller = Get.put(FinalCartController());
  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F3),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: _primary));
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.restaurants.isEmpty) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchFinalCart,
          );
        }

        if (controller.isEmpty) return const _EmptyCartView();

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 130),
          itemCount: controller.restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = controller.restaurants[index];
            return _RestaurantCard(
              restaurant: restaurant,
              onRemoveRestaurant: () =>
                  _confirmRemoveRestaurant(context, restaurant),
            );
          },
        );
      }),

      // ── BOTTOM BAR ─────────────────────────────────────────────────────────
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.isEmpty) {
          return const SizedBox(height: 0);
        }
        return _PlaceOrderBar(
          grandTotal: controller.grandTotal,
          restaurantCount: controller.restaurants.length,
          totalBookings: controller.totalBookingCount,
          totalItems: controller.totalItemCount,
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text('My Cart',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      actions: [
        Obx(() {
          final count = controller.restaurants.length;
          if (count == 0) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(right: 16),
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
      BuildContext context, FinalCartRestaurantModel restaurant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  shape: BoxShape.circle),
              child: const Icon(Icons.delete_sweep_rounded,
                  color: Colors.red, size: 34),
            ),
            const SizedBox(height: 16),
            const Text('Remove Restaurant?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              'All bookings from "${restaurant.restaurantName}" will be removed.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final isDeleting =
                    controller.isDeletingRestaurant(restaurant.restaurantId);
                    return ElevatedButton(
                      onPressed: isDeleting
                          ? null
                          : () {
                        Get.back();
                        controller
                            .removeRestaurant(restaurant.restaurantId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        disabledBackgroundColor:
                        Colors.red.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: isDeleting
                          ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                          : const Text('Remove',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── RESTAURANT CARD ───────────────────────────────────────────────────────────
class _RestaurantCard extends StatelessWidget {
  final FinalCartRestaurantModel restaurant;
  final VoidCallback onRemoveRestaurant;

  const _RestaurantCard({
    required this.restaurant,
    required this.onRemoveRestaurant,
  });

  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinalCartController>();

    return Obx(() {
      final isDeleting =
      controller.isDeletingRestaurant(restaurant.restaurantId);

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
                restaurant: restaurant,
                onRemove: onRemoveRestaurant,
                isDeleting: isDeleting,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                itemCount: restaurant.bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _BookingCard(
                    booking: restaurant.bookings[index],
                    restaurantId: restaurant.restaurantId,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Container(
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
                        '${restaurant.bookings.length} ${restaurant.bookings.length == 1 ? 'booking' : 'bookings'} · ${restaurant.totalItemCount} items',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700),
                      ),
                      Text(
                        '₹${FinalCartController.formatPrice(restaurant.restaurantTotal)}',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _primary),
                      ),
                    ],
                  ),
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
          // Delete restaurant button
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
  final FinalCartBookingModel booking;
  final int restaurantId;

  const _BookingCard({required this.booking, required this.restaurantId});

  FinalCartController get _controller => Get.find<FinalCartController>();
  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0EEEE), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Booking Meta ─────────────────────────────────────────────
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
                          text: _formatDate(booking.bookingDate)),
                      const SizedBox(height: 2),
                      _MetaRow(
                          icon: Icons.access_time_rounded,
                          text: booking.timeSlot),
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
                      Text(booking.tableNo,
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

          // ── Items ────────────────────────────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: booking.items.length,
            separatorBuilder: (_, __) => const Divider(
                height: 16, thickness: 1, color: Color(0xFFEEF0F0)),
            itemBuilder: (context, index) {
              final item = booking.items[index];
              return _ItemRow(
                item: item,
                restaurantId: restaurantId,
                bookingId: booking.bookingId,
              );
            },
          ),

          // ── Booking Total ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Booking total: ',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500)),
                Text(
                  '₹${FinalCartController.formatPrice(booking.bookingTotal)}',
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
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, dd MMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  void _confirmRemoveBooking(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  shape: BoxShape.circle),
              child: const Icon(Icons.event_busy_rounded,
                  color: Colors.orange, size: 34),
            ),
            const SizedBox(height: 16),
            const Text('Remove Booking?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              'Booking #${booking.bookingId} (${booking.tableNo} · ${booking.timeSlot}) will be removed.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _controller.removeBooking(
                          restaurantId, booking.bookingId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Remove',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── ITEM ROW ──────────────────────────────────────────────────────────────────
class _ItemRow extends StatelessWidget {
  final FinalCartItemModel item;
  final int restaurantId;
  final int bookingId;

  const _ItemRow({
    required this.item,
    required this.restaurantId,
    required this.bookingId,
  });

  FinalCartController get _controller => Get.find<FinalCartController>();
  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isItemDeleting = _controller.isDeletingItem(item.cartId);
      final isQtyUpdating = _controller.isAnyQuantityUpdating(item.cartId);
      final isDecreasing = _controller.isUpdatingQuantity(item.cartId, 'decrease');
      final isIncreasing = _controller.isUpdatingQuantity(item.cartId, 'increase');
      final isBusy = isItemDeleting || isQtyUpdating;

      return AnimatedOpacity(
        opacity: isItemDeleting ? 0.4 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row: Image  +  Name / Unit price  +  Delete ───────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.itemImage,
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

                // Name + unit price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${FinalCartController.formatPrice(item.price)} / item',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ── Delete button (standalone, top-right) ─────────────
                GestureDetector(
                  onTap: isBusy ? null : () => _confirmRemoveItem(context),
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
                          strokeWidth: 2, color: Colors.red),
                    )
                        : Icon(
                      Icons.delete_outline_rounded,
                      size: 17,
                      color: isBusy
                          ? Colors.red.withOpacity(0.3)
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Bottom Row: Stepper (left)  +  Total price (right) ────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ── Quantity stepper ───────────────────────────────────
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
                      // Decrease button
                      _StepperButton(
                        icon: Icons.remove_rounded,
                        iconColor: _primary,
                        isLoading: isDecreasing,
                        onTap: isBusy || item.quantity <= 1
                            ? null
                            : () => _controller.updateQuantity(
                          restaurantId: restaurantId,
                          bookingId: bookingId,
                          cartId: item.cartId,
                          action: 'decrease',
                        ),
                      ),

                      // Quantity display
                      Container(
                        constraints: const BoxConstraints(minWidth: 36),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: isQtyUpdating
                            ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: _primary),
                        )
                            : Text(
                          '${item.quantity}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _primary),
                        ),
                      ),

                      // Increase button
                      _StepperButton(
                        icon: Icons.add_rounded,
                        iconColor: _primary,
                        isLoading: isIncreasing,
                        onTap: isBusy
                            ? null
                            : () => _controller.updateQuantity(
                          restaurantId: restaurantId,
                          bookingId: bookingId,
                          cartId: item.cartId,
                          action: 'increase',
                        ),
                      ),
                    ],
                  ),
                ),

                // Total price for this item
                Text(
                  '₹${FinalCartController.formatPrice(item.totalPrice)}',
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  shape: BoxShape.circle),
              child:
              const Icon(Icons.fastfood_rounded, color: Colors.red, size: 34),
            ),
            const SizedBox(height: 16),
            const Text('Remove Item?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              '"${item.itemName}" will be removed from your cart.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _controller.removeCartItem(
                        restaurantId: restaurantId,
                        bookingId: bookingId,
                        cartId: item.cartId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Remove',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
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
            strokeWidth: 2,
            color: iconColor,
          ),
        )
            : Icon(icon, size: 16, color: onTap == null ? Colors.grey : iconColor),
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
class _PlaceOrderBar extends StatelessWidget {
  final double grandTotal;
  final int restaurantCount;
  final int totalBookings;
  final int totalItems;

  const _PlaceOrderBar({
    required this.grandTotal,
    required this.restaurantCount,
    required this.totalBookings,
    required this.totalItems,
  });

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
        child: Column(
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
                      '$restaurantCount ${restaurantCount == 1 ? 'restaurant' : 'restaurants'} · $totalBookings ${totalBookings == 1 ? 'booking' : 'bookings'}',
                      style:
                      TextStyle(fontSize: 11, color: Colors.grey.shade500),
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
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to checkout / confirm booking
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 20),
                    SizedBox(width: 10),
                    Text('Confirm Bookings',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3)),
                  ],
                ),
              ),
            ),
          ],
        ),
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
            onPressed: () => Get.back(),
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

// ── ERROR VIEW ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});
  static const _primary = Color(0xFF0F5151);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  shape: BoxShape.circle),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.red),
            ),
            const SizedBox(height: 20),
            const Text('Something went wrong',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: 14, color: Colors.grey.shade500)),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}