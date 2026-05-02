
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../data/models/admin_userpurchasedproductsmodel.dart';
import '../controller/admin_purchasedproductcontroller.dart';

class PurchasedProductsScreen extends StatelessWidget {
  const PurchasedProductsScreen({super.key});

  static const _primary  = Color(0xFF6366F1);
  static const _green    = Color(0xFF10B981);
  static const _bg       = Color(0xFFF5F6FA);
  static const _textDark = Color(0xFF1A1A2E);
  static const _textMid  = Color(0xFF6B7280);
  static const _border   = Color(0xFFE8E8F0);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchasedProductController());

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.kPrimary,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            'Purchased Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          automaticallyImplyLeading: true,
          actions: [
            Obx(() => !controller.isLoading.value
                ? IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              onPressed: () => controller
                  .fetchPurchasedProducts(controller.currentUserId.value),
              tooltip: 'Refresh',
            )
                : const SizedBox.shrink()),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: _border, height: 1),
          ),
        ),
        body: Obx(() {
          // ── Loading ──
          if (controller.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: _primary, strokeWidth: 2.5),
                  SizedBox(height: 14),
                  Text('Loading purchases...',
                      style: TextStyle(color: _textMid, fontSize: 14)),
                ],
              ),
            );
          }

          // ── Error ──
          if (controller.errorMessage.isNotEmpty && controller.orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 52, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _textMid, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => controller.fetchPurchasedProducts(
                          controller.currentUserId.value),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── Empty ──
          if (controller.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        size: 52, color: _primary),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No purchases yet',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'This user has no purchased products',
                    style: TextStyle(fontSize: 13, color: _textMid),
                  ),
                ],
              ),
            );
          }

          // ── Content ──
          return Column(
            children: [
              _buildSummaryBanner(controller),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => controller
                      .fetchPurchasedProducts(controller.currentUserId.value),
                  color: _primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      return _OrderCard(order: controller.orders[index]);
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSummaryBanner(PurchasedProductController controller) {
    return Obx(() => Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF004D40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00695C).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Orders',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.orders.length}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white24,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Spent',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${controller.totalSpend.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

// ─── Order Card ───────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final OrderItem order;

  const _OrderCard({required this.order});

  static const _primary  = Color(0xFF6366F1);
  static const _green    = Color(0xFF10B981);
  static const _textDark = Color(0xFF1A1A2E);
  static const _textMid  = Color(0xFF6B7280);
  static const _border   = Color(0xFFE8E8F0);

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Order Header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.05),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined,
                    size: 16, color: _primary),
                const SizedBox(width: 8),
                Text(
                  order.orderId,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₹${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Date ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: _textMid),
                const SizedBox(width: 6),
                Text(
                  _formatDate(order.orderDate),
                  style: const TextStyle(fontSize: 12, color: _textMid),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // ── Items ──
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: order.items.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 16, color: Color(0xFFE8E8F0)),
            itemBuilder: (_, i) => _ProductRow(product: order.items[i]),
          ),
        ],
      ),
    );
  }
}

// ─── Product Row ──────────────────────────────────────────────────────────────

class _ProductRow extends StatelessWidget {
  final PurchasedProduct product;

  const _ProductRow({required this.product});

  static const _primary  = Color(0xFF6366F1);
  static const _amber    = Color(0xFFF59E0B);
  static const _green    = Color(0xFF10B981);
  static const _textDark = Color(0xFF1A1A2E);
  static const _textMid  = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Product Image ──
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: product.productImage,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 60,
              height: 60,
              color: const Color(0xFFF0F0F5),
              child: const Icon(Icons.image_outlined,
                  size: 24, color: Color(0xFFB0B0C0)),
            ),
            errorWidget: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: const Color(0xFFF0F0F5),
              child: const Icon(Icons.broken_image_outlined,
                  size: 24, color: Color(0xFFB0B0C0)),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ── Product Details ──
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.productName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _InfoPill(
                    icon: Icons.currency_rupee_rounded,
                    label: '₹${product.price.toStringAsFixed(2)}',
                    color: _primary,
                  ),
                  const SizedBox(width: 6),
                  _InfoPill(
                    icon: Icons.layers_outlined,
                    label: 'Qty: ${product.quantity}',
                    color: _amber,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // ── Total ──
        Text(
          '₹${product.total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: _green,
          ),
        ),
      ],
    );
  }
}

// ─── Info Pill ────────────────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}