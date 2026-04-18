import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../data/models/adminofferproductmodel.dart';
import '../controller/admin_viewofferproductcontroller.dart';




class AdminOfferProductScreen extends StatelessWidget {
  const AdminOfferProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final  AdminOfferProductController controller =
    Get.put( AdminOfferProductController ());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _LoadingView();
        }
        if (controller.hasError.value) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.refreshProducts,
          );
        }
        if (controller.products.isEmpty) {
          return const _EmptyView();
        }
        return _ProductsContent(controller: controller);
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(AdminOfferProductController controller) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.kPrimary,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: true,
      iconTheme:IconThemeData(color:Colors.white),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Offer Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          // offerId is a plain int — no Obx needed
          Text(
            'Offer ID: #${controller.offerId}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        // Only wraps the icon that actually changes reactively
        Obx(() => IconButton(
          icon: controller.isLoading.value
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF6366F1),
            ),
          )
              : const Icon(Icons.refresh_rounded),
          onPressed: controller.isLoading.value
              ? null
              : controller.refreshProducts,
          tooltip: 'Refresh',
        )),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _ProductsContent extends StatelessWidget {
  final AdminOfferProductController controller;
  const _ProductsContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF6366F1),
      onRefresh: controller.refreshProducts,
      child: CustomScrollView(
        slivers: [
          Obx(() => SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = controller.products[index]; // ✅ define product
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      '/offer-product-detail',
                      arguments: product.id, // ✅ now accessible
                    ),
                    child: _ProductCard(product: product),
                  );
                },
                childCount: controller.products.length,
              ),
            ),
          )),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final AdminOfferProductModel product;
  const _ProductCard({required this.product});

  Color get _discountColor {
    final pct = double.tryParse(product.discountPercentage) ?? 0;
    if (pct >= 25) return const Color(0xFF10B981);
    if (pct >= 10) return const Color(0xFFF59E0B);
    return const Color(0xFF6366F1);
  }

  @override
  Widget build(BuildContext context) {
    final originalPrice =
        double.tryParse(product.originalPrice)?.toStringAsFixed(2) ??
            product.originalPrice;
    final offerPrice = product.offerPrice.toStringAsFixed(2);
    final stock = int.tryParse(product.stockQty) ?? 0;
    final isLowStock = stock <= 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Image ──────────────────
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: SizedBox(
              width: 110,
              height: 120,
              child: Image.network(
                product.productImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFEEF0F5),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Color(0xFFD1D5DB),
                      size: 32,
                    ),
                  ),
                ),
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: const Color(0xFFEEF0F5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Product Details ────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.productName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1D26),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: _discountColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _discountColor.withOpacity(0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${double.tryParse(product.discountPercentage)?.toStringAsFixed(0)}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'ID: #${product.id}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        '₹$offerPrice',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _discountColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '₹$originalPrice',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// State Views
// ─────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF6366F1)),
          SizedBox(height: 16),
          Text(
            'Loading products...',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFEF4444),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load products',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D26),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Color(0xFFD1D5DB)),
          SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'No products are linked to this offer.',
            style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}