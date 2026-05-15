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
  static const white = Color(0xFFFFFFFF);
  static const bg = Color(0xFFF4F7F6);
  static const card = Color(0xFFFFFFFF);
  static const text = Color(0xFF1A2E2A);
  static const textSub = Color(0xFF607D78);
  static const textMuted = Color(0xFF9EB3AF);
  static const divider = Color(0xFFECF0EF);
  static const success = Color(0xFF26A69A);
  static const gold = Color(0xFFFFB300);
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
        if (ctrl.bookings.isEmpty) return _EmptyState();

        return RefreshIndicator(
          color: _T.teal,
          onRefresh: ctrl.fetchOrders,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [


              // Booking groups
              Builder(builder: (_) {
                final groups = ctrl.groupedByRestaurant;
                final restaurantIds = groups.keys.toList();
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final rid = restaurantIds[index];
                      final items = groups[rid]!;
                      return _RestaurantGroup(
                        restaurantId: rid,
                        restaurantName: items.first.restaurantName,
                        items: items,
                        isLast: index == restaurantIds.length - 1,
                      );
                    },
                    childCount: restaurantIds.length,
                  ),
                );
              }),

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
      iconTheme: IconThemeData(color: Colors.white),
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

class _RestaurantGroup extends StatelessWidget {
  final int restaurantId;
  final String restaurantName;
  final List<BookingItem> items;
  final bool isLast;

  const _RestaurantGroup({
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.isLast,
  });

  /// Sub-group items by timeSlot so each slot gets its own strip
  Map<String, List<BookingItem>> get _groupedBySlot {
    final map = <String, List<BookingItem>>{};
    for (final item in items) {
      map.putIfAbsent(item.timeSlot, () => []).add(item);
    }
    return map;
  }

  double get _groupTotal =>
      items.fold(0.0, (s, i) => s + i.price * i.guests);

  @override
  Widget build(BuildContext context) {
    final slotGroups = _groupedBySlot;
    final slotKeys = slotGroups.keys.toList();

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
         SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: _T.tealLight,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(18)),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _T.tealDark,
                          letterSpacing: 0.1,
                        ),
                      ),
                      Text(
                        'Restaurant #$restaurantId',
                        style: const TextStyle(
                            fontSize: 11, color: _T.textSub),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${_groupTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _T.teal,
                      ),
                    ),
                    Text(
                      '${items.length} item${items.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                          fontSize: 11, color: _T.textSub),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Slot Sections ──────────────────────────────────────────────
          ...slotKeys.asMap().entries.map((entry) {
            final idx = entry.key;
            final slotKey = entry.value;
            final slotItems = slotGroups[slotKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (idx > 0)
                  const Divider(
                      color: _T.divider, height: 1, indent: 16, endIndent: 16),

                // Slot strip
                _SlotStrip(item: slotItems.first),

                // Items within this slot
                ...slotItems.asMap().entries.map((e) {
                  final i = e.key;
                  final item = e.value;
                  return Column(
                    children: [
                      if (i > 0)
                        const Divider(
                            color: _T.divider,
                            height: 1,
                            indent: 78,
                            endIndent: 16),
                      _BookingCard(item: item),
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

// ── Slot Strip ─────────────────────────────────────────────────────────────

class _SlotStrip extends StatelessWidget {
  final BookingItem item;
  const _SlotStrip({required this.item});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = _fmtDate(item.bookingDate);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _T.tealLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _T.tealMid.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1 — Date · Time
          Row(
            children: [
              _SlotPill(
                  icon: Icons.calendar_today_rounded, text: dateFormatted),
              const SizedBox(width: 12),
              Expanded(
                child: _SlotPill(
                    icon: Icons.access_time_rounded, text: item.timeSlot),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Row 2 — Table · Meal badge
          Row(
            children: [
              _SlotPill(
                  icon: Icons.table_restaurant_rounded, text: item.tableNo),
              const Spacer(),
              _MealBadge(mealType: item.mealType),
            ],
          ),
        ],
      ),
    );
  }

  String _fmtDate(String raw) {
    try {
      return DateFormat('dd MMM yy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }
}

class _SlotPill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SlotPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: _T.tealDark),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: _T.tealDark,
            fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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

// ── Individual Booking Card ─────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final BookingItem item;
  const _BookingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final total = item.price * item.guests;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.image,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _T.text,
                        ),
                      ),
                    ),
                    Text(
                      '₹${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _T.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _InfoPill(
                      label: '₹${item.price.toStringAsFixed(0)} each',
                      icon: Icons.currency_rupee_rounded,
                    ),
                    const SizedBox(width: 6),
                    _InfoPill(
                      label:
                      '${item.guests} guest${item.guests > 1 ? 's' : ''}',
                      icon: Icons.person_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Booking #${item.bookingId}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: _T.textMuted,
                    letterSpacing: 0.2,
                  ),
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
            decoration: BoxDecoration(
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