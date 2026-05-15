
import 'package:eshoppy/app/modules/userrestaurantreservationview/resatuarntbookedorderviewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ── Teal Theme Tokens ──────────────────────────────────────────────────────

class _T {
  static const teal = Color(0xFF009688);
  static const tealLight = Color(0xFFE0F2F1);
  static const tealMid = Color(0xFF4DB6AC);
  static const tealDark = Color(0xFF00796B);
  static const bg = Color(0xFFF4F7F6);
  static const card = Color(0xFFFFFFFF);
  static const text = Color(0xFF1A2E2A);
  static const textSub = Color(0xFF607D78);
  static const divider = Color(0xFFECF0EF);
  static const shadow = Color(0x0F009688);
}

// ── Entry Point ────────────────────────────────────────────────────────────

class BookedOrdersPage extends StatelessWidget {
  const BookedOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BookingController>()) {
      Get.put(BookingController());
    }
    final ctrl = Get.find<BookingController>();

    return Scaffold(
      backgroundColor: _T.bg,
      appBar: _buildAppBar(ctrl),
      body: Obx(() {
        if (ctrl.isLoading.value) return _LoadingState();
        if (ctrl.isEmpty) return _EmptyState();

        return RefreshIndicator(
          color: _T.teal,
          onRefresh: ctrl.fetchOrders,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final restaurant = ctrl.restaurants[index];
                    return _RestaurantSection(
                      restaurant: restaurant,
                      isLast: index == ctrl.restaurants.length - 1,
                    );
                  },
                  childCount: ctrl.restaurants.length,
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BookingController ctrl) {
    return AppBar(
      backgroundColor: _T.teal,
      elevation: 0,
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        'My Reservations',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      actions: [
        Obx(() => !ctrl.isLoading.value
            ? IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: ctrl.fetchOrders,
        )
            : const SizedBox.shrink()),
      ],
    );
  }
}

// ── Level 1: Restaurant Section ────────────────────────────────────────────

class _RestaurantSection extends StatelessWidget {
  final BookingRestaurant restaurant;
  final bool isLast;

  const _RestaurantSection({
    required this.restaurant,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, isLast ? 8 : 0),
      decoration: BoxDecoration(
        color: _T.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _T.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Restaurant Header ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(
              color: _T.tealLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _T.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.storefront_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    restaurant.restaurantName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _T.tealDark,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${restaurant.restaurantTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _T.teal,
                      ),
                    ),
                    Text(
                      '${restaurant.totalOrders} item${restaurant.totalOrders > 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 11, color: _T.textSub),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Level 2: Dates ─────────────────────────────────────────────
          ...restaurant.dates.asMap().entries.map((dateEntry) {
            final dateIdx = dateEntry.key;
            final bookingDate = dateEntry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dateIdx > 0)
                  const Divider(
                      color: _T.divider, height: 1, indent: 16, endIndent: 16),

                _DateHeader(bookingDate: bookingDate),

                // ── Level 3: Time Slots ────────────────────────────────
                ...bookingDate.timeSlots.asMap().entries.map((slotEntry) {
                  final slotIdx = slotEntry.key;
                  final slot = slotEntry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (slotIdx > 0)
                        const Divider(
                            color: _T.divider,
                            height: 1,
                            indent: 16,
                            endIndent: 16),

                      _TimeSlotStrip(slot: slot),

                      // ── Level 4: Orders ──────────────────────────────
                      ...slot.orders.asMap().entries.map((orderEntry) {
                        final orderIdx = orderEntry.key;
                        final order = orderEntry.value;
                        return Column(
                          children: [
                            if (orderIdx > 0)
                              const Divider(
                                  color: _T.divider,
                                  height: 1,
                                  indent: 78,
                                  endIndent: 16),
                            _OrderCard(order: order),
                          ],
                        );
                      }),
                    ],
                  );
                }),
              ],
            );
          }),

          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

// ── Level 2: Date Header ───────────────────────────────────────────────────

class _DateHeader extends StatelessWidget {
  final BookingDate bookingDate;
  const _DateHeader({required this.bookingDate});

  String get _label {
    try {
      final dt = DateTime.parse(bookingDate.bookingDate);
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      final tomorrowOnly = todayOnly.add(const Duration(days: 1));
      final dateOnly = DateTime(dt.year, dt.month, dt.day);

      if (dateOnly == todayOnly) return 'Today';
      if (dateOnly == tomorrowOnly) return 'Tomorrow';
      return DateFormat('EEE, dd MMM yyyy').format(dt);
    } catch (_) {
      return bookingDate.bookingDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded,
              size: 13, color: _T.tealDark),
          const SizedBox(width: 6),
          Text(
            _label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _T.tealDark,
            ),
          ),
          const Spacer(),
          Text(
            '₹${bookingDate.dateTotal.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _T.textSub,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Level 3: Time Slot Strip ───────────────────────────────────────────────

class _TimeSlotStrip extends StatelessWidget {
  final BookingTimeSlot slot;
  const _TimeSlotStrip({required this.slot});

  @override
  Widget build(BuildContext context) {
    final mealType =
    slot.orders.isNotEmpty ? slot.orders.first.mealType : '';
    final tableNo =
    slot.orders.isNotEmpty ? slot.orders.first.tableNo : '';

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: _T.tealLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _T.tealMid.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Time · Meal badge ───────────────────────────────────
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 13, color: _T.tealDark),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  slot.timeSlot,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _T.tealDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (mealType.isNotEmpty) _MealBadge(mealType: mealType),
            ],
          ),

          const SizedBox(height: 8),

          // ── Row 2: Table · Guests · Total ─────────────────────────────
          Row(
            children: [
              if (tableNo.isNotEmpty) ...[
                _SlotChip(
                  icon: Icons.table_restaurant_rounded,
                  label: tableNo,
                ),
                const SizedBox(width: 10),
              ],
              _SlotChip(
                icon: Icons.people_rounded,
                label: '${slot.guests} guest${slot.guests > 1 ? 's' : ''}',
              ),
              const Spacer(),
              // Total price — prominently on its own at the end
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _T.teal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '₹${slot.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SlotChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: _T.tealDark),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: _T.tealDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _MealBadge extends StatelessWidget {
  final String mealType;
  const _MealBadge({required this.mealType});

  @override
  Widget build(BuildContext context) {
    final lower = mealType.toLowerCase();
    final emoji =
    lower == 'breakfast' ? '🌅' : lower == 'lunch' ? '☀️' : '🌙';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _T.teal,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$emoji ${mealType[0].toUpperCase()}${mealType.substring(1)}',
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Level 4: Order Card ────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final BookingOrder order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              order.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _T.tealLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fastfood_rounded,
                    color: _T.tealMid, size: 26),
              ),
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _T.tealLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _T.teal),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + total
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.foodName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _T.text,
                        ),
                      ),
                    ),
                    Text(
                      '₹${order.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _T.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Pills — no booking ID shown to user
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _InfoPill(
                      label: '₹${order.price.toStringAsFixed(0)} each',
                      icon: Icons.currency_rupee_rounded,
                    ),
                    _InfoPill(
                      label: 'Qty: ${order.quantity}',
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _T.tealLight,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _T.tealMid.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: _T.tealDark),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: _T.tealDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── States ─────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: _T.teal, strokeWidth: 2.5),
          SizedBox(height: 16),
          Text(
            'Fetching your reservations…',
            style: TextStyle(color: _T.textSub, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: _T.tealLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.restaurant_menu_rounded,
                color: _T.tealMid, size: 42),
          ),
          const SizedBox(height: 20),
          const Text(
            'No reservations yet',
            style: TextStyle(
                color: _T.text, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your restaurant bookings will appear here',
            style: TextStyle(color: _T.textSub, fontSize: 13),
          ),
        ],
      ),
    );
  }
}