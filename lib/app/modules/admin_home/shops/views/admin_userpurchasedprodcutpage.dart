import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
        if (controller.errorMessage.isNotEmpty &&
            controller.purchasedProducts.isEmpty) {
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
        if (controller.purchasedProducts.isEmpty) {
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
                  itemCount: controller.purchasedProducts.length,
                  itemBuilder: (context, index) {
                    return _PurchasedProductCard(
                      product: controller.purchasedProducts[index],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryBanner(PurchasedProductController controller) {
    return Obx(() => Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF00695C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Orders count
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
                  '${controller.purchasedProducts.length}',
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
          // Total spend
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

// ─── Product Card ─────────────────────────────────────────────────────────────

class _PurchasedProductCard extends StatelessWidget {
  final PurchasedProduct product;

  const _PurchasedProductCard({required this.product});

  static const _primary  = Color(0xFF6366F1);
  static const _green    = Color(0xFF10B981);
  static const _textDark = Color(0xFF1A1A2E);
  static const _textMid  = Color(0xFF6B7280);
  static const _border   = Color(0xFFE8E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined,
                      size: 22, color: _primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.receipt_long_outlined,
                              size: 12, color: _textMid),
                          const SizedBox(width: 4),
                          Text(
                            'Order #${product.orderId}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: _textMid,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₹${product.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _green,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Container(height: 1, color: _border),
            const SizedBox(height: 12),

            // ── Bottom row ──
            Row(
              children: [
                _InfoPill(
                  icon: Icons.currency_rupee_rounded,
                  label: 'Unit Price',
                  value: '₹${product.price.toStringAsFixed(2)}',
                  color: _primary,
                ),
                const SizedBox(width: 10),
                _InfoPill(
                  icon: Icons.layers_outlined,
                  label: 'Quantity',
                  value: '${product.quantity}',
                  color: const Color(0xFFF59E0B),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Info Pill ────────────────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: color,
                    fontWeight: FontWeight.w700,
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