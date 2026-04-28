
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/admin_shopproductdetailsmodel.dart';
import '../controller/admin_productdetailcontroller.dart';

class AdminProductDetailScreen extends StatelessWidget {
  const AdminProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(mAdminProductDetailController());

    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _LoadingView();
        }
        if (controller.errorMessage.isNotEmpty && controller.product == null) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: () {
              final args = Get.arguments;
              if (args != null && args['product_id'] != null) {
                controller.fetchProductDetail(productId: args['product_id']);
              }
            },
          );
        }
        return _ProductDetailBody(controller: controller);
      }),
    ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.kPrimary,
      elevation: 0,
     automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: Colors.white),
      title: const Text(
        'Product Details',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: const Color(0xFFE8E8F0), height: 1),
      ),
    );
  }
}

// ─── Main Body ────────────────────────────────────────────────────────────────

class _ProductDetailBody extends StatelessWidget {
  final mAdminProductDetailController controller;
  const _ProductDetailBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    final product = controller.product!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Variant Image Carousel ──
          _VariantImageCard(controller: controller),
          const SizedBox(height: 16),

          // ── Product Info ──
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _Chip(
                            label: product.category,
                            color: const Color(0xFF6366F1),
                          ),
                        ],
                      ),
                    ),
                    _ProductIdBadge(id: product.productId),
                  ],
                ),
                if (product.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Common Attributes (hidden when empty) ──
          if (product.commonAttributes.isNotEmpty) ...[
            _SectionHeader(title: 'Specifications'),
            const SizedBox(height: 8),
            _InfoCard(
              child: Column(
                children: product.commonAttributes.entries
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  final isEven = entry.key.isEven;
                  final e = entry.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: isEven
                          ? const Color(0xFFF5F6FA)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.label_outline_rounded,
                            size: 14, color: Color(0xFF6366F1)),
                        const SizedBox(width: 8),
                        Text(
                          e.key[0].toUpperCase() + e.key.substring(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          e.value,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ── Variants ──
          _SectionHeader(
            title: 'Variants',
            trailing: _Chip(
              label: '${product.variants.length} options',
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 8),
          ...product.variants.asMap().entries.map(
                (e) => Obx(() => _VariantCard(
              variant: e.value,
              index: e.key,
              isSelected:
              controller.selectedVariantIndex.value == e.key,
              onTap: () => controller.selectVariant(e.key),
            )),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Variant Image Card ───────────────────────────────────────────────────────

class _VariantImageCard extends StatelessWidget {
  final mAdminProductDetailController controller;
  const _VariantImageCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final variant = controller.selectedVariant;
      final variants = controller.product?.variants ?? [];

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: variant != null && variant.image.isNotEmpty
                  ? Image.network(
                variant.image,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                loadingBuilder: (_, child, progress) =>
                progress == null
                    ? child
                    : Container(
                  height: 280,
                  color: const Color(0xFFF5F6FA),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6366F1),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              )
                  : const _ImagePlaceholder(),
            ),
            if (variants.length > 1)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: variants.asMap().entries.map((e) {
                    final isSelected =
                        controller.selectedVariantIndex.value == e.key;
                    return GestureDetector(
                      onTap: () => controller.selectVariant(e.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 10 : 7,
                        height: isSelected ? 10 : 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF6366F1)
                              : const Color(0xFFD1D5DB),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      color: const Color(0xFFF5F6FA),
      child: const Center(
        child: Icon(Icons.image_not_supported_rounded,
            size: 48, color: Color(0xFFD1D5DB)),
      ),
    );
  }
}

// ─── Variant Card ─────────────────────────────────────────────────────────────

class _VariantCard extends StatelessWidget {
  final mProductVariant variant;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _VariantCard({
    required this.variant,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final stockInt = int.tryParse(variant.stock) ?? 0;
    final isOutOfStock = stockInt <= 0;
    final isLowStock = stockInt > 0 && stockInt <= 3;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6366F1)
                : const Color(0xFFE8E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // ── Thumbnail ──
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: variant.image.isNotEmpty
                    ? Image.network(
                  variant.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback(),
                )
                    : _imageFallback(),
              ),
              const SizedBox(width: 14),

              // ── Details ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Variant ID + Price
                    Row(
                      children: [
                        Text(
                          'Variant #${variant.variantId}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${variant.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6366F1),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Dynamic attributes + stock badge
                    Row(
                      children: [
                        // Show all variant attributes dynamically
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: variant.attributes.entries.map((e) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${e.key[0].toUpperCase()}${e.key.substring(1)}: ${e.value}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Stock badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isOutOfStock
                                ? const Color(0xFFFFEBEE)
                                : isLowStock
                                ? const Color(0xFFFEF3C7)
                                : const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isOutOfStock ? 'Out of Stock' : 'Stock: $stockInt',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isOutOfStock
                                  ? const Color(0xFFE53935)
                                  : isLowStock
                                  ? const Color(0xFFD97706)
                                  : const Color(0xFF059669),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      width: 60,
      height: 60,
      color: const Color(0xFFF5F6FA),
      child: const Icon(Icons.image_rounded, color: Color(0xFFD1D5DB)),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProductIdBadge extends StatelessWidget {
  final int id;
  const _ProductIdBadge({required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '#$id',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ─── State Views ──────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF6366F1),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading product...',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
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
}

