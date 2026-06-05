
import 'package:eshoppy/app/data/models/user_myordersmodel.dart';
import 'package:eshoppy/app/modules/myoders/controller/my_orderscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../widgets/networkconnection_checkpage.dart';
import '../../product/view/prodductdetailscreen.dart';
import '../../userhome/view/user_offerproductdetail.dart';

class MyOrdersView extends StatelessWidget {
  MyOrdersView({super.key});

  static Color get primary => AppColors.kPrimary;

  // ── Design Tokens ────────────────────────────────────────────────────────────
  static const Color _bg = Color(0xFFF7F8FC);
  static const Color _surface = Colors.white;
  static const Color _textPrimary = Color(0xFF0D1117);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _textMuted = Color(0xFFADB5BD);
  static const Color _divider = Color(0xFFEEF0F4);
  static const Color _successGreen = Color(0xFF10B981);
  static const Color _cardShadowColor = Color(0x0F000000);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyOrdersController());

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(),
        body: Obx(() {
          if (controller.isLoading.value) return _buildLoadingState();
          if (controller.hasError.value) return _buildErrorState(controller);
          if (controller.orders.isEmpty) return _buildEmptyState();
          return RefreshIndicator(
            color: primary,
            displacement: 20,
            strokeWidth: 2,
            onRefresh: controller.fetchMyOrders,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(
                  controller.orders[index],
                  controller,
                  index,
                );
              },
            ),
          );
        }),
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor:AppColors.kPrimary,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: _textPrimary),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _divider),
      ),
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Orders',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),)
        ],
      ),

    );
  }

  // ── Loading State ────────────────────────────────────────────────────────────
  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      itemCount: 4,
      itemBuilder: (_, i) => _buildSkeletonCard(i),
    );
  }

  Widget _buildSkeletonCard(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _cardShadowColor,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _shimmer(38, 38, radius: 10),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmer(120, 13),
                  const SizedBox(height: 6),
                  _shimmer(80, 10),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _shimmer(56, 56, radius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmer(double.infinity, 13),
                    const SizedBox(height: 6),
                    _shimmer(100, 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shimmer(double w, double h, {double radius = 8}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF0F4),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  // ── Order Card ───────────────────────────────────────────────────────────────
  Widget _buildOrderCard(
      MyOrdersModel order, MyOrdersController controller, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _cardShadowColor,
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                // Order icon badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary.withOpacity(0.15),
                        primary.withOpacity(0.06),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: primary,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderId,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: _textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            controller.formatDate(order.orderDate),
                            style: const TextStyle(
                              fontSize: 11,
                              color: _textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Item count pill
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _divider),
                  ),
                  child: Text(
                    '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: _textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Thin separator ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Container(height: 1, color: _divider),
          ),

          // ── Items List ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Column(
              children: order.items
                  .map((item) => _buildItemRow(item, controller))
                  .toList(),
            ),
          ),

          // ── Footer ────────────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primary.withOpacity(0.04),
                  primary.withOpacity(0.08),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payments_rounded,
                      size: 16,
                      color: primary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Total ',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${controller.formatPrice(order.totalAmount)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: primary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Item Row ─────────────────────────────────────────────────────────────────
  Widget _buildItemRow(OrderProduct item, MyOrdersController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            if (item.type == 1) {
              Get.to(() => UserOfferProductDetailScreen(
                offerProductId: item.productId,
                preSelectedVariantId: item.variant?.variantId,
              ));
            } else {
              Get.to(() => ProductDetailPage(
                productId: item.productId,
                preSelectedVariantId: item.variant?.variantId,
              ));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _divider, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Product Image ──────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.displayImage,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 58,
                      height: 58,
                      color: _divider,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: _textMuted,
                        size: 22,
                      ),
                    ),
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : Container(
                      width: 58,
                      height: 58,
                      color: _divider,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: primary,
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // ── Product Details ────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                          height: 1.3,
                        ),
                      ),

                      // Variant chips
                      if (item.variant != null &&
                          item.variant!.attributes.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Wrap(
                          spacing: 5,
                          runSpacing: 4,
                          children:
                          item.variant!.attributes.entries.map((e) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: _surface,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: _divider),
                              ),
                              child: Text(
                                '${_cap(e.key)}: ${_cap(e.value)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 5),

                      // Price row
                      Row(
                        children: [
                          if (item.variant != null &&
                              item.variant!.finalPrice <
                                  item.variant!.price) ...[
                            Text(
                              '₹${controller.formatPrice(item.variant!.price)}',
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: _textMuted,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: _textMuted,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                          Text(
                            '₹${controller.formatPrice(item.price)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: _textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: _textMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            'Qty ${item.quantity}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: _textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // ── Item Total ─────────────────────────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${controller.formatPrice(item.total)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: primary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: _textMuted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  // ── Empty State ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container with layered rings
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.04),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.07),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 28,
                    color: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              'No Orders Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "You haven't placed any orders yet.\nStart shopping to see your orders here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: _textSecondary,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }

  // ── Error State ──────────────────────────────────────────────────────────────
  Widget _buildErrorState(MyOrdersController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 32,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: _textSecondary,
                height: 1.6,
              ),
            )),
            const SizedBox(height: 28),
            SizedBox(
              height: 46,
              child: OutlinedButton.icon(
                onPressed: controller.fetchMyOrders,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  'Try Again',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: BorderSide(color: primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}