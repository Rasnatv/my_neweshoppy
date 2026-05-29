
import 'package:entenaadu/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/models/admin_productdetailmodel.dart';
import '../controller/admin_viewproductdetailcontrller.dart';
import '../widget/admin_productdetail errorview.dart';
import '../widget/loadingview.dart';
import '../widget/section_cart.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
class _C {
  static const bg         = Color(0xFFF0F1F8);
  static const card       = Color(0xFFFFFFFF);
  static const indigo     = Color(0xFF5B5EF4);
  static const indigoSoft = Color(0xFFEEEEFF);
  static const indigoMid  = Color(0xFFC7C9FD);
  static const purple     = Color(0xFF8B5CF6);
  static const purpleSoft = Color(0xFFF3EEFF);
  static const green      = Color(0xFF0DBF82);
  static const greenSoft  = Color(0xFFDFFAF0);
  static const greenBdr   = Color(0xFFA7F0D2);
  static const amber      = Color(0xFFF59E0B);
  static const amberSoft  = Color(0xFFFEF3C7);
  static const red        = Color(0xFFEF4444);
  static const redSoft    = Color(0xFFFEE2E2);
  static const border     = Color(0xFFE8EAF0);
  static const textPrimary   = Color(0xFF13152B);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted     = Color(0xFF9CA3AF);
}

BoxDecoration _cardDecoration({double radius = 14}) => BoxDecoration(
  color: _C.card,
  borderRadius: BorderRadius.circular(radius),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF14163C).withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 1),
    ),
  ],
);

// ─── Screen ───────────────────────────────────────────────────────────────────
class AdminSingleOfferProductScreen extends StatelessWidget {
  const AdminSingleOfferProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminSingleOfferProductController());
    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: _C.bg,
        body: Obx(() {
          if (controller.isLoading.value) return const LoadingView();
          if (controller.hasError.value) {
            return ErrorView(
              message: controller.errorMessage.value,
              onRetry: controller.refreshProduct,
            );
          }
          if (controller.product.value == null) return const LoadingView();
          return _DetailContent(controller: controller);
        }),
      ),
    );
  }
}

// ─── Detail content ───────────────────────────────────────────────────────────
class _DetailContent extends StatelessWidget {
  final AdminSingleOfferProductController controller;
  const _DetailContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: _C.indigo,
      onRefresh: controller.refreshProduct,
      child: CustomScrollView(
        slivers: [
          _ImageGalleryAppBar(controller: controller),
          SliverToBoxAdapter(
            child: Obx(() {
              final p = controller.product.value!;
              return Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _HeaderCard(product: p, controller: controller),
                    const SizedBox(height: 12),
                    // Price
                    _PriceCard(controller: controller),
                    const SizedBox(height: 12),
                    // IDs grid
                    _InfoGrid(product: p),
                    // Description
                    if (p.description.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _DescriptionCard(description: p.description),
                    ],
                    // Common attributes
                    if (p.productAttributes != null &&
                        p.productAttributes!.commonAttributes.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _AttributesCard(
                          attributes: p.productAttributes!),
                    ],
                    // Variants
                    if (p.productAttributes != null &&
                        p.productAttributes!.variants.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _VariantsCard(
                        variants: p.productAttributes!.variants,
                        controller: controller,
                      ),
                    ],
                    const SizedBox(height:50 ),
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

// ─── Image gallery app bar ────────────────────────────────────────────────────
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
    final c = widget.controller;
    return Obx(() {
      final images = c.product.value?.productImages ?? [];
      final pct =
          double.tryParse(c.product.value?.discountPercentage ?? '0') ?? 0;
      final discountColor = pct >= 25
          ? _C.green
          : pct >= 10
          ? _C.amber
          : _C.indigo;

      return SliverAppBar(
        expandedHeight: 300,
        pinned: true,
        backgroundColor: _C.card,
        foregroundColor: _C.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: Get.back,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: _C.textPrimary),
          ),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              // ── PageView ──────────────────────────────────────
              images.isEmpty
                  ? _emptyImage()
                  : PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (i) {
                  c.currentImageIndex.value = i;
                  c.selectedVariantIndex.value = i;
                },
                itemBuilder: (_, i) => Image.network(
                  images[i],
                  fit: BoxFit.cover,
                  headers: {'Authorization': 'Bearer $_token'},
                  errorBuilder: (_, __, ___) => _emptyImage(),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFFEEF0F5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _C.indigo,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Bottom gradient ────────────────────────────────
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 90,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xCC13152B), Colors.transparent],
                    ),
                  ),
                ),
              ),

              // ── Discount badge ─────────────────────────────────
              if (pct > 0)
                Positioned(
                  top: 56, right: 14,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: discountColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: discountColor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '${pct.toStringAsFixed(0)}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),

              // ── Dot indicators ─────────────────────────────────
              if (images.length > 1)
                Positioned(
                  bottom: 10, left: 0, right: 0,
                  child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                          (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: c.currentImageIndex.value == i ? 16 : 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: c.currentImageIndex.value == i
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

  Widget _emptyImage() => Container(
    color: const Color(0xFFDDE0F0),
    child: const Center(
      child: Icon(Icons.image_not_supported_outlined,
          size: 56, color: Color(0xFF9DA3C8)),
    ),
  );
}

// ─── Header card ──────────────────────────────────────────────────────────────
class _HeaderCard extends StatelessWidget {
  final AdminSingleOfferProductModel product;
  final AdminSingleOfferProductController controller;
  const _HeaderCard({required this.product, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _C.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(() {
                final qty = controller.selectedVariant?.stock ?? 0;
                final isLow = qty > 0 && qty <= 5;
                final outOfStock = qty <= 0;
                return _StockBadge(qty: qty, isLow: isLow, outOfStock: outOfStock);
              }),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _TagChip(
                label: product.offerName,
                icon: Icons.local_offer_rounded,
                color: _C.indigo,
                bg: _C.indigoSoft,
                border: _C.indigoMid,
              ),
              _TagChip(
                label: product.merchantName,
                icon: Icons.storefront_rounded,
                color: _C.green,
                bg: _C.greenSoft,
                border: _C.greenBdr,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final int qty;
  final bool isLow;
  final bool outOfStock;
  const _StockBadge({required this.qty, required this.isLow, required this.outOfStock});

  @override
  Widget build(BuildContext context) {
    final color = outOfStock ? _C.red : isLow ? _C.amber : _C.green;
    final bg    = outOfStock ? _C.redSoft : isLow ? _C.amberSoft : _C.greenSoft;
    final icon  = outOfStock
        ? Icons.cancel_rounded
        : isLow
        ? Icons.warning_amber_rounded
        : Icons.check_circle_outline_rounded;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            outOfStock ? 'Out of Stock' : '$qty in stock',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color, bg, border;
  const _TagChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.bg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

// ─── Price card ───────────────────────────────────────────────────────────────
class _PriceCard extends StatelessWidget {
  final AdminSingleOfferProductController controller;
  const _PriceCard({required this.controller});

  Color _discountColor(double pct) =>
      pct >= 25 ? _C.green : pct >= 10 ? _C.amber : _C.indigo;
  Color _discountBg(double pct) =>
      pct >= 25 ? _C.greenSoft : pct >= 10 ? _C.amberSoft : _C.indigoSoft;
  Color _discountBorder(double pct) =>
      pct >= 25 ? _C.greenBdr : pct >= 10 ? const Color(0xFFFDE68A) : _C.indigoMid;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final variant  = controller.selectedVariant;
      final original = variant?.price ?? 0.0;
      final offer    = variant?.finalPrice ?? 0.0;
      final saved    = original - offer;
      final pct      =
          double.tryParse(controller.product.value?.discountPercentage ?? '0') ?? 0;
      final color    = _discountColor(pct);
      final bg       = _discountBg(pct);
      final border   = _discountBorder(pct);

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: prices
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offer Price',
                    style: const TextStyle(
                        fontSize: 11, color: _C.textMuted, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '₹${offer.round()}',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 1.1),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${original.round()}',
                    style: const TextStyle(
                        fontSize: 13,
                        color: _C.textMuted,
                        decoration: TextDecoration.lineThrough,
                        fontFeatures: [FontFeature.tabularFigures()]),
                  ),
                ],
              ),
            ),
            // Right: savings box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Text('You Save',
                      style: TextStyle(
                          fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(
                    '₹${saved.round()}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: color,
                        fontFeatures: const [FontFeature.tabularFigures()]),
                  ),
                  Text(
                    '${pct.toStringAsFixed(0)}% off',
                    style: TextStyle(
                        fontSize: 10, color: color, fontWeight: FontWeight.w700),
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

// ─── Info grid ────────────────────────────────────────────────────────────────
class _InfoGrid extends StatelessWidget {
  final AdminSingleOfferProductModel product;
  const _InfoGrid({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            label: 'Product ID',
            value: '#${product.id}',
            icon: Icons.numbers_rounded,
            iconColor: _C.indigo,
            iconBg: _C.indigoSoft,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _InfoTile(
            label: 'Offer ID',
            value: '#${product.offerId}',
            icon: Icons.local_offer_rounded,
            iconColor: _C.purple,
            iconBg: _C.purpleSoft,
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconColor, iconBg;
  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: _cardDecoration(radius: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        color: _C.textMuted,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _C.textPrimary,
                      fontFeatures: [FontFeature.tabularFigures()]),
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

// ─── Description card ─────────────────────────────────────────────────────────
class _DescriptionCard extends StatelessWidget {
  final String description;
  const _DescriptionCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Description', icon: Icons.description_outlined),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: _C.textSecondary,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Attributes card ──────────────────────────────────────────────────────────
class _AttributesCard extends StatelessWidget {
  final ProductAttributes attributes;
  const _AttributesCard({required this.attributes});

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    if (attributes.commonAttributes.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Common Attributes', icon: Icons.tune_rounded),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: attributes.commonAttributes.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _C.border),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${_capitalize(e.key)}: ',
                        style: const TextStyle(
                            fontSize: 12,
                            color: _C.textMuted,
                            fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: e.value.toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: _C.textPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Variants card ────────────────────────────────────────────────────────────
class _VariantsCard extends StatelessWidget {
  final List<ProductVariant> variants;
  final AdminSingleOfferProductController controller;
  const _VariantsCard({required this.variants, required this.controller});

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Variants', icon: Icons.style_rounded),
          const SizedBox(height: 10),
          Obx(() => Column(
            children: variants.asMap().entries.map((entry) {
              final i = entry.key;
              final v = entry.value;
              final isSelected = controller.selectedVariantIndex.value == i;
              final isLow      = v.stock > 0 && v.stock <= 5;
              final outOfStock = v.stock <= 0;
              final stockColor = outOfStock ? _C.red : isLow ? _C.amber : _C.green;
              final stockBg    = outOfStock ? _C.redSoft : isLow ? _C.amberSoft : _C.greenSoft;

              return GestureDetector(
                onTap: () => controller.selectVariant(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                      bottom: i < variants.length - 1 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 11),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _C.indigoSoft
                        : const Color(0xFFFAFBFD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? _C.indigo : _C.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Attribute chips
                      Expanded(
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: v.attributes.entries.map((e) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 3),
                              decoration: BoxDecoration(
                                color: _C.indigo.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_capitalize(e.key)}: ${e.value}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: _C.indigo,
                                    fontWeight: FontWeight.w700),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Price + stock
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${v.finalPrice.round()}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: _C.indigo,
                                fontFeatures: [FontFeature.tabularFigures()]),
                          ),
                          Text(
                            '₹${v.price.round()}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: _C.textMuted,
                                decoration: TextDecoration.lineThrough,
                                fontFeatures: [FontFeature.tabularFigures()]),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: stockBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              outOfStock
                                  ? 'Out of Stock'
                                  : '${v.stock} in stock',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: stockColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }
}

// ─── Shared: Section header ───────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
              color: _C.indigoSoft, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 13, color: _C.indigo),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: _C.textPrimary,
              letterSpacing: 0.1),
        ),
      ],
    );
  }
}