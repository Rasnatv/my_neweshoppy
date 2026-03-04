import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/admin_productdetailmodel.dart';
import '../controller/admin_viewproductdetailcontrller.dart';

class AdminSingleOfferProductScreen extends StatelessWidget {
  const AdminSingleOfferProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminSingleOfferProductController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Obx(() {
        if (controller.isLoading.value) return const _LoadingView();
        if (controller.hasError.value) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.refreshProduct,
          );
        }
        if (controller.product.value == null) return const _LoadingView();
        return _DetailContent(controller: controller);
      }),
    );
  }
}

// ─────────────────────────────────────────────
// Main Detail Content
// ─────────────────────────────────────────────

class _DetailContent extends StatelessWidget {
  final AdminSingleOfferProductController controller;
  const _DetailContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF6366F1),
      onRefresh: controller.refreshProduct,
      child: CustomScrollView(
        slivers: [
          _ImageGalleryAppBar(controller: controller),
          SliverToBoxAdapter(
            child: Obx(() {
              final p = controller.product.value!;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderSection(product: p),
                    const SizedBox(height: 16),
                    _PriceSection(product: p),
                    const SizedBox(height: 16),
                    _InfoGrid(product: p),
                    if (p.description.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'Description',
                        icon: Icons.description_outlined,
                        child: Text(
                          p.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4B5563),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                    if (p.productAttributes != null) ...[
                      const SizedBox(height: 16),
                      _AttributesSection(attributes: p.productAttributes!),
                    ],
                    if (p.productAttributes != null &&
                        p.productAttributes!.variants.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _VariantsSection(
                          variants: p.productAttributes!.variants),
                    ],
                    const SizedBox(height: 16),
                    _MetaSection(product: p),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}


class _ImageGalleryAppBar extends StatelessWidget {
  final AdminSingleOfferProductController controller;
  const _ImageGalleryAppBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final images = controller.product.value?.productImages ?? [];
      final discount =
          controller.product.value?.discountPercentage ?? '0';
      final pct = double.tryParse(discount) ?? 0;
      final discountColor = pct >= 25
          ? const Color(0xFF10B981)
          : pct >= 10
          ? const Color(0xFFF59E0B)
          : const Color(0xFF6366F1);

      return SliverAppBar(
        expandedHeight: 320,
        pinned: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1D26),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Color(0xFF1A1D26)),
          ),
        ),
        actions: [
          Obx(() => IconButton(
            icon: controller.isLoading.value
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF6366F1),
              ),
            )
                : const Icon(Icons.refresh_rounded),
            onPressed: controller.isLoading.value
                ? null
                : controller.refreshProduct,
          )),
          const SizedBox(width: 4),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              // ── Page View ──────────────────────
              images.isEmpty
                  ? Container(
                color: const Color(0xFFEEF0F5),
                child: const Center(
                  child: Icon(Icons.image_not_supported_outlined,
                      size: 64, color: Color(0xFFD1D5DB)),
                ),
              )
                  : PageView.builder(
                itemCount: images.length,
                onPageChanged: (i) =>
                controller.currentImageIndex.value = i,
                itemBuilder: (_, i) => Image.network(
                  images[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFEEF0F5),
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          size: 48, color: Color(0xFFD1D5DB)),
                    ),
                  ),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
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

              // ── Gradient overlay ───────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                ),
              ),

              // ── Discount badge ─────────────────
              Positioned(
                top: 60,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: discountColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: discountColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${pct.toStringAsFixed(0)}% OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // ── Image dots indicator ───────────
              if (images.length > 1)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                          (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: controller.currentImageIndex.value == i
                            ? 18
                            : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: controller.currentImageIndex.value == i
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  )),
                ),
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
// Header — product name + merchant + offer tag
// ─────────────────────────────────────────────

class _HeaderSection extends StatelessWidget {
  final AdminSingleOfferProductModel product;
  const _HeaderSection({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.productName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1D26),
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Stock badge
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: int.parse(product.stockQty) > 5
                    ? const Color(0xFFD1FAE5)
                    : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    int.parse(product.stockQty) > 5
                        ? Icons.check_circle_outline_rounded
                        : Icons.warning_amber_rounded,
                    size: 12,
                    color: int.parse(product.stockQty) > 5
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Qty: ${product.stockQty}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: int.parse(product.stockQty) > 5
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Offer name chip
        Row(
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_offer_rounded,
                      size: 12, color: Color(0xFF6366F1)),
                  const SizedBox(width: 4),
                  Text(
                    product.offerName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Merchant chip
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF10B981).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.storefront_rounded,
                      size: 12, color: Color(0xFF10B981)),
                  const SizedBox(width: 4),
                  Text(
                    product.merchantName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Price Section
// ─────────────────────────────────────────────

class _PriceSection extends StatelessWidget {
  final AdminSingleOfferProductModel product;
  const _PriceSection({required this.product});

  Color get _discountColor {
    final pct = double.tryParse(product.discountPercentage) ?? 0;
    if (pct >= 25) return const Color(0xFF10B981);
    if (pct >= 10) return const Color(0xFFF59E0B);
    return const Color(0xFF6366F1);
  }

  @override
  Widget build(BuildContext context) {
    final original = double.tryParse(product.originalPrice) ?? 0;
    final offer = product.offerPrice;
    final saved = original - offer;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Offer Price',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${offer.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: _discountColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹${original.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _discountColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border:
              Border.all(color: _discountColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'You Save',
                  style: TextStyle(
                    fontSize: 11,
                    color: _discountColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${saved.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _discountColor,
                  ),
                ),
                Text(
                  '${double.tryParse(product.discountPercentage)?.toStringAsFixed(0)}% off',
                  style: TextStyle(
                    fontSize: 11,
                    color: _discountColor,
                    fontWeight: FontWeight.w600,
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

// ─────────────────────────────────────────────
// Info Grid
// ─────────────────────────────────────────────

class _InfoGrid extends StatelessWidget {
  final AdminSingleOfferProductModel product;
  const _InfoGrid({required this.product});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.8,
      children: [
        _InfoTile(
          label: 'Product ID',
          value: '#${product.id}',
          icon: Icons.tag_rounded,
          color: const Color(0xFF6366F1),
        ),
        _InfoTile(
          label: 'Offer ID',
          value: '#${product.offerId}',
          icon: Icons.local_offer_rounded,
          color: const Color(0xFF8B5CF6),
        ),
        _InfoTile(
          label: 'Category',
          value: 'ID: ${product.categoryId}',
          icon: Icons.category_rounded,
          color: const Color(0xFFF59E0B),
        ),
        _InfoTile(
          label: 'Stock',
          value: product.stockQty,
          icon: Icons.warehouse_rounded,
          color: const Color(0xFF10B981),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1D26),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Attributes Section
// ─────────────────────────────────────────────

class _AttributesSection extends StatelessWidget {
  final ProductAttributes attributes;
  const _AttributesSection({required this.attributes});

  @override
  Widget build(BuildContext context) {
    if (attributes.commonAttributes.isEmpty) return const SizedBox.shrink();

    return _SectionCard(
      title: 'Common Attributes',
      icon: Icons.tune_rounded,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: attributes.commonAttributes.entries.map((entry) {
          return Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${_capitalize(entry.key)}: ',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: entry.value.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1A1D26),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ─────────────────────────────────────────────
// Variants Section
// ─────────────────────────────────────────────

class _VariantsSection extends StatelessWidget {
  final List<ProductVariant> variants;
  const _VariantsSection({required this.variants});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Variants',
      icon: Icons.style_rounded,
      child: Column(
        children: variants.asMap().entries.map((entry) {
          final i = entry.key;
          final v = entry.value;
          final isLow = v.stock <= 5;

          return Container(
            margin: EdgeInsets.only(bottom: i < variants.length - 1 ? 10 : 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: v.attributes.entries.map((e) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_capitalize(e.key)}: ${e.value}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6366F1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${v.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1D26),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isLow
                            ? const Color(0xFFFEE2E2)
                            : const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isLow ? 'Low: ${v.stock}' : 'Stock: ${v.stock}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isLow
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ─────────────────────────────────────────────
// Meta Section (timestamps)
// ─────────────────────────────────────────────

class _MetaSection extends StatelessWidget {
  final AdminSingleOfferProductModel product;
  const _MetaSection({required this.product});

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Details',
      icon: Icons.info_outline_rounded,
      child: Column(
        children: [
          _MetaRow(
              label: 'Created',
              value: _formatDate(product.createdAt)),
          const Divider(height: 16, color: Color(0xFFF3F4F6)),
          _MetaRow(
              label: 'Updated',
              value: _formatDate(product.updatedAt)),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF9CA3AF))),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D26))),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Reusable Section Card
// ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF6366F1)),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1D26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
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
    return const Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF6366F1)),
            SizedBox(height: 16),
            Text('Loading product...',
                style: TextStyle(
                    color: Color(0xFF9CA3AF), fontSize: 14)),
          ],
        ),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
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
                child: const Icon(Icons.error_outline_rounded,
                    color: Color(0xFFEF4444), size: 40),
              ),
              const SizedBox(height: 16),
              const Text('Failed to load product',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D26))),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF9CA3AF))),
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
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}