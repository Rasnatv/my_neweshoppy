
import 'package:entenaadu/app/modules/userrestaurantreservationview/resatuarntbookedorderviewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ── Design Tokens ──────────────────────────────────────────────────────────

class _T {
  static const teal       = Color(0xFF009688);
  static const tealLight  = Color(0xFFE1F5EE);
  static const tealMint   = Color(0xFF9FE1CB);
  static const tealDark   = Color(0xFF085041);
  static const tealMid    = Color(0xFF0F6E56);
  static const bg         = Color(0xFFF4F6F5);
  static const card       = Color(0xFFFFFFFF);
  static const text       = Color(0xFF1A2E2A);
  static const textSub    = Color(0xFF607D78);
  static const border     = Color(0xFFE8EFED);
  static const sep        = Color(0xFFF0F4F2);
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
        if (ctrl.isLoading.value) return const _LoadingState();
        if (ctrl.isEmpty) return const _EmptyState();

        // Group restaurants by date
        final grouped = <String, List<BookingRestaurant>>{};
        for (final r in ctrl.restaurants) {
          for (final d in r.dates) {
            grouped.putIfAbsent(d.bookingDate, () => []);
            if (!grouped[d.bookingDate]!.any((x) => x.restaurantName == r.restaurantName)) {
              grouped[d.bookingDate]!.add(r);
            }
          }
        }
        final sortedDates = grouped.keys.toList()..sort();

        return RefreshIndicator(
          color: _T.teal,
          onRefresh: ctrl.fetchOrders,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 32),
            physics: const BouncingScrollPhysics(),
            children: [
              for (final date in sortedDates) ...[
                _DateSectionLabel(dateStr: date),
                const SizedBox(height: 8),
                for (final restaurant in ctrl.restaurants)
                  for (final bookingDate in restaurant.dates)
                    if (bookingDate.bookingDate == date)
                      _ReservationCard(
                        restaurant: restaurant,
                        bookingDate: bookingDate,
                      ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BookingController ctrl) => AppBar(
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

  );
}

// ── Upcoming Badge ─────────────────────────────────────────────────────────

class _UpcomingBadge extends StatelessWidget {
  final int count;
  const _UpcomingBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _T.tealLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$count upcoming',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _T.tealDark,
          ),
        ),
      ),
    );
  }
}

// ── Date Section Label ─────────────────────────────────────────────────────

class _DateSectionLabel extends StatelessWidget {
  final String dateStr;
  const _DateSectionLabel({required this.dateStr});

  String get _label {
    try {
      final dt        = DateTime.parse(dateStr);
      final todayOnly = _dateOnly(DateTime.now());
      final dateOnly  = _dateOnly(dt);
      if (dateOnly == todayOnly)
        return 'Today — ${DateFormat('dd MMM').format(dt)}';
      if (dateOnly == todayOnly.add(const Duration(days: 1)))
        return 'Tomorrow — ${DateFormat('dd MMM').format(dt)}';
      return DateFormat('EEE — dd MMM yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    return Text(
      _label.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: _T.textSub,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Reservation Card ───────────────────────────────────────────────────────

class _ReservationCard extends StatelessWidget {
  final BookingRestaurant restaurant;
  final BookingDate bookingDate;

  const _ReservationCard({
    required this.restaurant,
    required this.bookingDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _T.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _T.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(restaurant: restaurant),
          const Divider(height: 1, color: _T.sep),
          for (final slot in bookingDate.timeSlots)
            _TimelineSlot(slot: slot),
          _CardFooter(dateTotal: bookingDate.dateTotal),
        ],
      ),
    );
  }
}

// ── Card Header ────────────────────────────────────────────────────────────

class _CardHeader extends StatelessWidget {
  final BookingRestaurant restaurant;
  const _CardHeader({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _T.tealLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.storefront_rounded,
                color: _T.tealMid, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.restaurantName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _T.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Dine-in · ${restaurant.totalOrders} item${restaurant.totalOrders > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 12, color: _T.textSub),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _T.tealLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '₹${restaurant.restaurantTotal.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _T.tealDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Timeline Slot ──────────────────────────────────────────────────────────

class _TimelineSlot extends StatelessWidget {
  final BookingTimeSlot slot;
  const _TimelineSlot({required this.slot});

  @override
  Widget build(BuildContext context) {
    final mealType = slot.orders.isNotEmpty ? slot.orders.first.mealType : '';
    final tableNo  = slot.orders.isNotEmpty ? slot.orders.first.tableNo  : '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline column ──────────────────────────────────────────
          SizedBox(
            width: 46,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: _T.teal,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 1.5,
                  height: 28,
                  color: _T.tealMint,
                ),
                Text(
                  slot.timeSlot.replaceAll(' ', '\n'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: _T.textSub,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),

          // ── Slot body ────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chips row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (mealType.isNotEmpty)
                      _Chip(
                        icon: mealType.toLowerCase() == 'dinner'
                            ? Icons.nights_stay_outlined
                            : Icons.wb_sunny_outlined,
                        label: '${mealType[0].toUpperCase()}${mealType.substring(1).toLowerCase()}',
                        highlighted: true,
                      ),
                    if (tableNo.isNotEmpty)
                      _Chip(
                          icon: Icons.chair_alt_rounded, label: tableNo),
                    _Chip(
                      icon: Icons.group_outlined,
                      label: '${slot.guests} guest${slot.guests > 1 ? 's' : ''}',
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Food items
                ...slot.orders.asMap().entries.map((e) {
                  return Column(
                    children: [
                      if (e.key > 0)
                        const Divider(
                            height: 1, color: _T.sep,
                            indent: 50, endIndent: 0),
                      _OrderItem(order: e.value),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  const _Chip({required this.icon, required this.label, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlighted ? _T.tealLight : const Color(0xFFF4F6F5),
        border: Border.all(
          color: highlighted ? _T.tealMint : _T.border,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 11,
              color: highlighted ? _T.tealMid : _T.textSub),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: highlighted ? _T.tealDark : _T.text,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order Item ─────────────────────────────────────────────────────────────

class _OrderItem extends StatelessWidget {
  final BookingOrder order;
  const _OrderItem({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              order.image,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _Thumb(),
              loadingBuilder: (_, child, progress) =>
              progress == null ? child : _Thumb(loading: true),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.foodName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _T.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '₹${order.price.toStringAsFixed(0)} each · Qty ${order.quantity}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: _T.textSub,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '₹${order.totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _T.teal,
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final bool loading;
  const _Thumb({this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _T.tealLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: loading
          ? const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: _T.teal),
        ),
      )
          : const Icon(Icons.fastfood_rounded, color: _T.tealMint, size: 20),
    );
  }
}

// ── Card Footer ────────────────────────────────────────────────────────────

class _CardFooter extends StatelessWidget {
  final double dateTotal;
  const _CardFooter({required this.dateTotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _T.sep)),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined,
              size: 14, color: _T.textSub),
          const SizedBox(width: 6),
          const Text(
            'Booking total',
            style: TextStyle(fontSize: 12, color: _T.textSub),
          ),
          const Spacer(),
          Text(
            '₹${dateTotal.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _T.text,
            ),
          ),
        ],
      ),
    );
  }
}

// ── States ─────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) => const Center(
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: _T.tealLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.restaurant_menu_rounded,
              color: _T.tealMint, size: 36),
        ),
        const SizedBox(height: 20),
        const Text(
          'No reservations yet',
          style: TextStyle(
            color: _T.text,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
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