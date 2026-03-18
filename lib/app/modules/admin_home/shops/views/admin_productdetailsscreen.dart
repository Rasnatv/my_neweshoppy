import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/models/admin_shopproductdetailsmodel.dart';
import '../controller/admin_productdetailcontroller.dart';




class AdminProductDetailScreen extends StatelessWidget {
  const AdminProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(mAdminProductDetailController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(controller),
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
        if (controller.product == null) {
          return const _EmptyView();
        }
        return _ProductDetailBody(controller: controller);
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(mAdminProductDetailController controller) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: const Text(
        'Product Details',
        style: TextStyle(
          color: Color(0xFF1A1A2E),
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1A1A2E), size: 20),
        onPressed: () => Get.back(),
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: const Color(0xFFE8E8F0), height: 1),
      ),
    );
  }
}

// ─── Auth Token Badge ─────────────────────────────────────────────────────────

class _AuthTokenBadge extends StatelessWidget {
  final String token;
  const _AuthTokenBadge({required this.token});

  String get _masked => token.length > 10
      ? '${token.substring(0, 6)}...${token.substring(token.length - 4)}'
      : token;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: token));
        Get.snackbar(
          'Copied',
          'Auth token copied to clipboard',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.key_rounded, size: 13, color: Color(0xFF6366F1)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                _masked,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
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
          // Variant Image Carousel
          _VariantImageCard(controller: controller),
          const SizedBox(height: 16),

          // Product Info Card
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
            ),
          ),
          const SizedBox(height: 12),

          // Common Attributes
          _SectionHeader(title: 'Common Attributes'),
          const SizedBox(height: 8),
          _InfoCard(
            child: Row(
              children: [
                _AttributeTile(
                  icon: Icons.checkroom_rounded,
                  label: 'Material',
                  value: product.commonAttributes.material,
                ),
                const _VerticalDivider(),
                _AttributeTile(
                  icon: Icons.branding_watermark_rounded,
                  label: 'Brand',
                  value: product.commonAttributes.brand,
                ),
                const _VerticalDivider(),
                _AttributeTile(
                  icon: Icons.person_rounded,
                  label: 'Type',
                  value: product.commonAttributes.type,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Variants Section
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
              child: variant != null
                  ? Image.network(
                variant.image,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                loadingBuilder: (_, child, progress) => progress == null
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
    final isLowStock = stockInt <= 3;

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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  variant.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xFFF5F6FA),
                    child: const Icon(Icons.image_rounded,
                        color: Color(0xFFD1D5DB)),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _MiniChip(
                          label: variant.attributes.colour,
                          icon: Icons.circle,
                          color: _colorFromName(variant.attributes.colour),
                        ),
                        const SizedBox(width: 6),
                        _MiniChip(
                          label: variant.attributes.size.toUpperCase(),
                          icon: Icons.straighten_rounded,
                          color: const Color(0xFF6B7280),
                        ),
                        const Spacer(),
                        _StockBadge(
                          stock: variant.stock,
                          isLow: isLowStock,
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

  Color _colorFromName(String name) {
    switch (name.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black87;
      case 'white':
        return Colors.grey;
      case 'yellow':
        return Colors.amber;
      default:
        return const Color(0xFF6B7280);
    }
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

class _MiniChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _MiniChip(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StockBadge extends StatelessWidget {
  final String stock;
  final bool isLow;
  const _StockBadge({required this.stock, required this.isLow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isLow ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Stock: $stock',
        style: TextStyle(
          fontSize: 11,
          color: isLow ? const Color(0xFFD97706) : const Color(0xFF059669),
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

class _AttributeTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _AttributeTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF6366F1)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      color: const Color(0xFFE8E8F0),
      margin: const EdgeInsets.symmetric(horizontal: 8),
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_rounded, size: 56, color: Color(0xFFD1D5DB)),
          SizedBox(height: 16),
          Text(
            'No product found',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
          ),
        ],
      ),
    );
  }
}