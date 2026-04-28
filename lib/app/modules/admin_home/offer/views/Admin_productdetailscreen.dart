import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/models/admin_productdetailmodel.dart';
import '../controller/admin_viewproductdetailcontrller.dart';

class AdminSingleOfferProductScreen extends StatelessWidget {
  const AdminSingleOfferProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminSingleOfferProductController());
    return NetworkAwareWrapper(child: Scaffold(
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
    ));
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
                    _HeaderSection(product: p, controller: controller),
                    const SizedBox(height: 16),
                    _PriceSection(controller: controller),
                    const SizedBox(height: 16),
                    _InfoGrid(product: p, controller: controller),
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
                    if (p.productAttributes != null &&
                        p.productAttributes!.commonAttributes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _AttributesSection(attributes: p.productAttributes!),
                    ],
                    if (p.productAttributes != null &&
                        p.productAttributes!.variants.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _VariantsSection(
                        variants: p.productAttributes!.variants,
                        controller: controller,
                      ),
                    ],
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

// ─────────────────────────────────────────────
// Image Gallery AppBar  ← NOW StatefulWidget
// ─────────────────────────────────────────────
class _ImageGalleryAppBar extends StatefulWidget {
  final AdminSingleOfferProductController controller;
  const _ImageGalleryAppBar({required this.controller});

  @override
  State<_ImageGalleryAppBar> createState() => _ImageGalleryAppBarState();
}

class _ImageGalleryAppBarState extends State<_ImageGalleryAppBar> {
  late final PageController _pageController;
  final String _token = GetStorage().read('auth_token') ?? '';

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: widget.controller.selectedVariantIndex.value,
    );

    // ── React to variant taps → scroll gallery to matching image ──
    ever(widget.controller.selectedVariantIndex, (int idx) {
      if (!_pageController.hasClients) return;
      if ((_pageController.page?.round() ?? -1) == idx) return;
      _pageController.animateToPage(
        idx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Obx(() {
      final images = controller.product.value?.productImages ?? [];
      final pct =
          double.tryParse(controller.product.value?.discountPercentage ?? '0') ?? 0;
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
            child: const Icon(
              Icons.arrow_back,
              size: 18,
              color: Color(0xFF1A1D26),
            ),
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
            onPressed:
            controller.isLoading.value ? null : controller.refreshProduct,
          )),
          const SizedBox(width: 4),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              // ── Image PageView ──────────────────────────────────
              images.isEmpty
                  ? Container(
                color: const Color(0xFFEEF0F5),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 64,
                    color: Color(0xFFD1D5DB),
                  ),
                ),
              )
                  : PageView.builder(
                controller: _pageController, // ← KEY: attach the controller
                itemCount: images.length,
                onPageChanged: (i) {
                  // Swipe also updates both observables
                  controller.currentImageIndex.value = i;
                  controller.selectedVariantIndex.value = i;
                },
                itemBuilder: (_, i) => Image.network(
                  images[i],
                  fit: BoxFit.cover,
                  headers: {'Authorization': 'Bearer $_token'},
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFEEF0F5),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: Color(0xFFD1D5DB),
                      ),
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

              // ── Gradient overlay ────────────────────────────────
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

              // ── Discount badge ──────────────────────────────────
              if (pct > 0)
                Positioned(
                  top: 60,
                  right: 16,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

              // ── Dot indicators ──────────────────────────────────
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
                        width: controller.currentImageIndex.value == i ? 18 : 6,
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
// Header
// ─────────────────────────────────────────────
class _HeaderSection extends StatelessWidget {
  final AdminSingleOfferProductModel product;
  final AdminSingleOfferProductController controller;
  const _HeaderSection({required this.product, required this.controller});

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
            Obx(() {
              final qty = controller.selectedVariant?.stock ?? 0;
              final isLow = qty > 0 && qty <= 5;
              final outOfStock = qty <= 0;
              final color = outOfStock
                  ? const Color(0xFFEF4444)
                  : isLow
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF10B981);
              final bgColor = outOfStock
                  ? const Color(0xFFFEE2E2)
                  : isLow
                  ? const Color(0xFFFEF3C7)
                  : const Color(0xFFD1FAE5);

              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      outOfStock
                          ? Icons.cancel_rounded
                          : isLow
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 12,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      outOfStock ? 'Out of Stock' : '$qty in stock',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 8),
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
  final AdminSingleOfferProductController controller;
  const _PriceSection({required this.controller});

  Color _discountColor(double pct) {
    if (pct >= 25) return const Color(0xFF10B981);
    if (pct >= 10) return const Color(0xFFF59E0B);
    return const Color(0xFF6366F1);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final variant = controller.selectedVariant;
      final original = variant?.price ?? 0.0;
      final offer = variant?.finalPrice ?? 0.0;
      final saved = original - offer;
      final pct =
          double.tryParse(controller.product.value?.discountPercentage ?? '0') ?? 0;
      final color = _discountColor(pct);

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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${offer.round()}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${original.round()}',
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
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'You Save',
                    style: TextStyle(
                        fontSize: 11, color: color, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${saved.round()}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color),
                  ),
                  Text(
                    '${pct.toStringAsFixed(0)}% off',
                    style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
// Info Grid
// ─────────────────────────────────────────────
class _InfoGrid extends StatelessWidget {
  final AdminSingleOfferProductModel product;
  final AdminSingleOfferProductController controller;
  const _InfoGrid({required this.product, required this.controller});

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

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

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
}

// ─────────────────────────────────────────────
// Variants Section
// ─────────────────────────────────────────────
class _VariantsSection extends StatelessWidget {
  final List<ProductVariant> variants;
  final AdminSingleOfferProductController controller;
  const _VariantsSection({required this.variants, required this.controller});

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Variants',
      icon: Icons.style_rounded,
      child: Obx(() {
        return Column(
          children: variants.asMap().entries.map((entry) {
            final i = entry.key;
            final v = entry.value;
            final isSelected = controller.selectedVariantIndex.value == i;
            final isLow = v.stock > 0 && v.stock <= 5;
            final outOfStock = v.stock <= 0;

            return GestureDetector(
              onTap: () => controller.selectVariant(i), // ← triggers gallery scroll
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin:
                EdgeInsets.only(bottom: i < variants.length - 1 ? 10 : 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6366F1).withOpacity(0.06)
                      : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFE5E7EB),
                    width: isSelected ? 1.5 : 1,
                  ),
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
                              color:
                              const Color(0xFF6366F1).withOpacity(0.1),
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
                          '₹${v.finalPrice.round()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                        Text(
                          '₹${v.price.round()}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: outOfStock
                                ? const Color(0xFFFEE2E2)
                                : isLow
                                ? const Color(0xFFFEF3C7)
                                : const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            outOfStock
                                ? 'Out of Stock'
                                : '${v.stock} in stock',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: outOfStock
                                  ? const Color(0xFFEF4444)
                                  : isLow
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }),
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
// Loading View
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
            Text(
              'Loading product...',
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Error View
// ─────────────────────────────────────────────
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
        backgroundColor: AppColors.kPrimary,
        leading: IconButton(
          icon:
          const Icon(Icons.arrow_back, size: 20),
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
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load product',
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
      ),
    );
  }
}