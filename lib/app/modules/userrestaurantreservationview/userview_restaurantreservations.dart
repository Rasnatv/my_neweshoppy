
import 'package:eshoppy/app/modules/userrestaurantreservationview/resatuarntbookedorderviewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ── Design Tokens ──────────────────────────────────────────────────────────

class _T {
  static const teal       = Color(0xFF009688);
  static const tealLight  = Color(0xFFE0F2F1);
  static const tealMint   = Color(0xFF9FE1CB);
  static const tealDark   = Color(0xFF085041);
  static const tealMid    = Color(0xFF0F6E56);
  static const bg         = Color(0xFFF0F4F3);
  static const card       = Color(0xFFFFFFFF);
  static const text       = Color(0xFF1A2E2A);
  static const textSub    = Color(0xFF607D78);
  static const border     = Color(0xFFE2EEEC);
  static const sep        = Color(0xFFEBF4F2);
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
        if (ctrl.isEmpty)         return const _EmptyState();

        return RefreshIndicator(
          color: _T.teal,
          onRefresh: ctrl.fetchOrders,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _RestaurantCard(
                      restaurant: ctrl.restaurants[index],
                      isLast: index == ctrl.restaurants.length - 1,
                    ),
                    childCount: ctrl.restaurants.length,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 28)),
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
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
    // actions: [
    //   Obx(() => !ctrl.isLoading.value
    //       ? IconButton(
    //     icon: const Icon(Icons.refresh_rounded, color: Colors.white),
    //     onPressed: ctrl.fetchOrders,
    //   )
    //       : const SizedBox.shrink()),
    // ],
  );
}

// ── Restaurant Card ────────────────────────────────────────────────────────

class _RestaurantCard extends StatelessWidget {
  final BookingRestaurant restaurant;
  final bool isLast;

  const _RestaurantCard({
    required this.restaurant,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        color: _T.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _T.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A009688),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RestaurantHeader(restaurant: restaurant),
            ...restaurant.dates.asMap().entries.map((e) {
              final isFirst = e.key == 0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isFirst)
                    const Divider(
                        color: _T.sep, height: 1, indent: 14, endIndent: 14),
                  _DateSection(bookingDate: e.value),
                ],
              );
            }),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

// ── Restaurant Header ──────────────────────────────────────────────────────

class _RestaurantHeader extends StatelessWidget {
  final BookingRestaurant restaurant;
  const _RestaurantHeader({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      color: _T.tealLight,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _T.teal,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.storefront_rounded,
                color: Colors.white, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.restaurantName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _T.tealDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Dine-in reservation',
                  style: const TextStyle(
                      fontSize: 11, color: _T.tealMid),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${restaurant.restaurantTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _T.teal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${restaurant.totalOrders} item${restaurant.totalOrders > 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 10, color: _T.tealMid),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Date Section ───────────────────────────────────────────────────────────

class _DateSection extends StatelessWidget {
  final BookingDate bookingDate;
  const _DateSection({required this.bookingDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateHeader(bookingDate: bookingDate),
        ...bookingDate.timeSlots.asMap().entries.map((e) {
          final isFirst = e.key == 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isFirst)
                const Divider(
                    color: _T.sep, height: 1, indent: 14, endIndent: 14),
              _TimeSlotBlock(slot: e.value),
            ],
          );
        }),
      ],
    );
  }
}

// ── Date Header ────────────────────────────────────────────────────────────

class _DateHeader extends StatelessWidget {
  final BookingDate bookingDate;
  const _DateHeader({required this.bookingDate});

  String get _label {
    try {
      final dt        = DateTime.parse(bookingDate.bookingDate);
      final todayOnly = _dateOnly(DateTime.now());
      final dateOnly  = _dateOnly(dt);
      if (dateOnly == todayOnly)
        return 'Today, ${DateFormat('dd MMM').format(dt)}';
      if (dateOnly == todayOnly.add(const Duration(days: 1)))
        return 'Tomorrow, ${DateFormat('dd MMM').format(dt)}';
      return DateFormat('EEE, dd MMM yyyy').format(dt);
    } catch (_) {
      return bookingDate.bookingDate;
    }
  }

  static DateTime _dateOnly(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              size: 13, color: _T.tealMid),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              _label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _T.tealDark,
              ),
            ),
          ),
          Text(
            '₹${bookingDate.dateTotal.toStringAsFixed(0)}',
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500, color: _T.tealMid),
          ),
        ],
      ),
    );
  }
}

// ── Time Slot Block ────────────────────────────────────────────────────────

class _TimeSlotBlock extends StatelessWidget {
  final BookingTimeSlot slot;
  const _TimeSlotBlock({required this.slot});

  @override
  Widget build(BuildContext context) {
    final mealType =
    slot.orders.isNotEmpty ? slot.orders.first.mealType : '';
    final tableNo =
    slot.orders.isNotEmpty ? slot.orders.first.tableNo : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Time slot strip ──────────────────────────────────────────────
        Container(
          margin: const EdgeInsets.fromLTRB(10, 4, 10, 8),
          decoration: BoxDecoration(
            color: _T.tealLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _T.tealMint),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 13, color: _T.tealDark),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        slot.timeSlot,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _T.tealDark,
                        ),
                      ),
                    ),
                    if (mealType.isNotEmpty) _MealBadge(mealType: mealType),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Row(
                  children: [
                    if (tableNo.isNotEmpty) ...[
                      _SlotChip(
                          icon: Icons.chair_alt_rounded, label: tableNo),
                      const SizedBox(width: 10),
                    ],
                    _SlotChip(
                      icon: Icons.group_outlined,
                      label:
                      '${slot.guests} guest${slot.guests > 1 ? 's' : ''}',
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _T.teal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹${slot.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Orders ───────────────────────────────────────────────────────
        ...slot.orders.asMap().entries.map((e) {
          return Column(
            children: [
              if (e.key > 0)
                const Divider(
                    color: _T.sep,
                    height: 1,
                    indent: 84,
                    endIndent: 14),
              _OrderRow(order: e.value),
            ],
          );
        }),
      ],
    );
  }
}

class _SlotChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SlotChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: _T.tealMid),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(
              fontSize: 11,
              color: _T.tealDark,
              fontWeight: FontWeight.w500)),
    ],
  );
}

class _MealBadge extends StatelessWidget {
  final String mealType;
  const _MealBadge({required this.mealType});

  @override
  Widget build(BuildContext context) {
    final display =
        '${mealType[0].toUpperCase()}${mealType.substring(1).toLowerCase()}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _T.teal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        display,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Order Row ──────────────────────────────────────────────────────────────

class _OrderRow extends StatelessWidget {
  final BookingOrder order;
  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Food image ─────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.network(
              order.image,
              width: 58,
              height: 58,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _FoodPlaceholder(),
              loadingBuilder: (_, child, progress) =>
              progress == null ? child : _FoodPlaceholder(loading: true),
            ),
          ),
          const SizedBox(width: 12),

          // ── Details ────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        order.foodName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _T.text,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
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
                const SizedBox(height: 6),
                Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: [
                    _InfoPill(
                      icon: Icons.currency_rupee_rounded,
                      label: '₹${order.price.toStringAsFixed(0)} each',
                    ),
                    _InfoPill(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Qty ${order.quantity}',
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

class _FoodPlaceholder extends StatelessWidget {
  final bool loading;
  const _FoodPlaceholder({this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: _T.tealLight,
        borderRadius: BorderRadius.circular(13),
      ),
      child: loading
          ? const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: _T.teal),
        ),
      )
          : const Icon(Icons.fastfood_rounded, color: _T.tealMint, size: 24),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: _T.tealLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _T.tealMint),
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
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            color: _T.tealLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.restaurant_menu_rounded,
              color: _T.tealMint, size: 40),
        ),
        const SizedBox(height: 20),
        const Text(
          'No reservations yet',
          style: TextStyle(
              color: _T.text,
              fontSize: 18,
              fontWeight: FontWeight.w600),
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