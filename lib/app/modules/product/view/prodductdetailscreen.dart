
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../controller/userproductdetail_controller.dart';
import '../../../data/models/user_productdetailmodel.dart';


class ProductDetailPage extends StatelessWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  // ── Professional Indigo + Gold Color Palette ───────────────
  static const _primary      = Color(0xFF3D5A99);   // Deep Indigo Blue
  static const _primaryDark  = Color(0xFF2C4178);   // Darker Indigo
  static const _primaryLight = Color(0xFFEEF1F9);   // Soft Indigo tint
  static const _accent       = Color(0xFFE8A020);   // Warm Gold accent
  static const _accentLight  = Color(0xFFFFF8EC);   // Gold tint bg
  static const _bg           = Color(0xFFF5F6FA);   // Cool off-white bg
  static const _surface      = Color(0xFFFFFFFF);   // Card white
  static const _textDark     = Color(0xFF1C2340);   // Near-black navy
  static const _textMid      = Color(0xFF5A6480);   // Muted slate
  static const _textLight    = Color(0xFFB0B8CC);   // Disabled / placeholder
  static const _divider      = Color(0xFFEBEDF5);   // Subtle border
  static const _red          = Color(0xFFD93025);   // Error red
  static const _amber        = Color(0xFFF59E0B);   // Warning amber
  static const _green        = Color(0xFF1A8A5A);   // Success green

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<ProductDetailController>(
        tag: productId.toString())) {
      Get.delete<ProductDetailController>(
          tag: productId.toString(), force: true);
    }

    final controller = Get.put(
      ProductDetailController(productId: productId),
      tag: productId.toString(),
    );

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Product Details",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded,
                color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
                color: _primary, strokeWidth: 2.5),
          );
        }

        final product = controller.product.value;
        final variant = controller.selectedVariant.value;

        if (product == null || variant == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: _primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.error_outline_rounded,
                      size: 44, color: _primary),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Product not found',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchProduct(productId),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageGallery(variant),
                  const SizedBox(height: 8),
                  _buildProductInfo(product, variant),
                  const SizedBox(height: 8),
                  _buildVariantSection(controller, product),
                  const SizedBox(height: 8),
                  _buildCommonAttributes(product),
                  const SizedBox(height: 8),
                  _buildDescription(product),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            _buildBottomBar(controller, product, variant),
          ],
        );
      }),
    );
  }

  // ── Image Gallery ──────────────────────────────────────────
  Widget _buildImageGallery(ProductVariantModel variant) {
    return Container(
      height: 350,
      color: _surface,
      child: Center(
        child: Image.network(
          variant.image,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.image_not_supported_outlined,
            size: 90,
            color: Colors.grey[300],
          ),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                color: _primary,
                strokeWidth: 2,
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                    progress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Product Info ───────────────────────────────────────────
  Widget _buildProductInfo(
      ProductDetailModel product, ProductVariantModel variant) {
    final stockCount = int.tryParse(variant.stock) ?? 0;
    final isLow      = stockCount > 0 && stockCount <= 5;
    final isOut      = stockCount <= 0;
    final color      = isOut ? _red : (isLow ? _amber : _green);
    final label      = isOut
        ? 'Out of Stock'
        : isLow
        ? 'Only $stockCount left'
        : 'In Stock';
    final icon = isOut ? Icons.cancel_rounded : Icons.check_circle_rounded;

    return Container(
      padding: const EdgeInsets.all(18),
      color: _surface,
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
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                    height: 1.35,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 11, color: color),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Price row with accent gold
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${variant.price}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color:Colors.green,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 10),

            ],
          ),
        ],
      ),
    );
  }

  // ── Variant Section ────────────────────────────────────────
  Widget _buildVariantSection(
      ProductDetailController controller, ProductDetailModel product) {
    final attributeMap = controller.getVariantAttributes();
    if (attributeMap.isEmpty) return const SizedBox.shrink();

    return Container(
      color: _surface,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Select Variant', Icons.tune_rounded),
          const SizedBox(height: 16),
          ...attributeMap.entries.map((entry) {
            final attribute = entry.key;
            final values    = entry.value.toList();

            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attribute[0].toUpperCase() + attribute.substring(1),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _textMid,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    final selected =
                    controller.selectedVariant.value?.attributes[attribute];

                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: values.map((value) {
                        final isSelected = selected == value;

                        ProductVariantModel? matchedVariant;
                        try {
                          matchedVariant = product.variants.firstWhere(
                                  (v) => v.attributes[attribute] == value);
                        } catch (_) {
                          matchedVariant = null;
                        }

                        final isAvailable = matchedVariant != null;

                        return GestureDetector(
                          onTap: isAvailable
                              ? () => controller.selectVariant(matchedVariant!)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.kPrimary : _surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColors.kPrimary : _divider,
                                width: isSelected ? 2 : 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                BoxShadow(
                                  color: _primary.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                                  : [],
                            ),
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : _textDark,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ── Common Attributes ──────────────────────────────────────
  Widget _buildCommonAttributes(ProductDetailModel product) {
    if (product.commonAttributes == null ||
        product.commonAttributes!.isEmpty) {
      return const SizedBox.shrink();
    }

    final entries = product.commonAttributes!.entries.toList();

    return Container(
      color: _surface,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Specifications', Icons.inventory_2_outlined),
          const SizedBox(height: 14),
          ...entries.asMap().entries.map((e) {
            final isEven = e.key.isEven;
            final entry  = e.value;
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isEven ? _primaryLight.withOpacity(0.55) : _surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key[0].toUpperCase() + entry.key.substring(1),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _textMid,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ── Description ────────────────────────────────────────────
  Widget _buildDescription(ProductDetailModel product) {
    return Container(
      color: _surface,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Description', Icons.description_outlined),
          const SizedBox(height: 14),
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: _textMid,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Bar ─────────────────────────────────────────────
  Widget _buildBottomBar(
      ProductDetailController controller,
      ProductDetailModel product,
      ProductVariantModel variant,
      ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Obx(() {
        final currentVariant =
            controller.selectedVariant.value ?? variant;
        final stockCount    = int.tryParse(currentVariant.stock) ?? 0;
        final isOutOfStock  = stockCount <= 0;
        final isAddedToCart = controller.isAddedToCart.value;
        final isCartLoading = controller.isLoading.value;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          decoration: BoxDecoration(
            color: _surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // ── LEFT: Add to Cart  ←→  Go to Cart ────
                    Expanded(
                      child: GestureDetector(
                        onTap: isOutOfStock || isCartLoading
                            ? null
                            : isAddedToCart
                            ? controller.goToCart
                            : controller.addToCart,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            // "Go to Cart" → filled accent gold
                            // "Add to Cart" → outlined indigo
                            // "Out of Stock" → muted
                            color: isOutOfStock
                                ? _surface
                                : isAddedToCart
                                ? _accent          // ← Gold fill for "Go to Cart"
                                : _surface,        // ← White for "Add to Cart"
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isOutOfStock
                                  ? _divider
                                  : isAddedToCart
                                  ? _accent        // ← Gold border
                                  : AppColors.kPrimary,      // ← Indigo border
                              width: 2,
                            ),
                            boxShadow: isAddedToCart && !isOutOfStock
                                ? [
                              BoxShadow(
                                color: _accent.withOpacity(0.28),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                                : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isCartLoading && !isAddedToCart)
                                const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: _primary,
                                  ),
                                )
                              else
                                Icon(
                                  isOutOfStock
                                      ? Icons.block_rounded
                                      : isAddedToCart
                                      ? Icons.shopping_cart_rounded
                                      : Icons.shopping_cart_outlined,
                                  size: 18,
                                  color: isOutOfStock
                                      ? _textLight
                                      : isAddedToCart
                                      ? Colors.white   // ← White icon on gold
                                      : AppColors.kPrimary      // ← Indigo icon on white
                                ),
                              const SizedBox(width: 6),
                              Text(
                                isOutOfStock
                                    ? 'Out of Stock'
                                    : isAddedToCart
                                    ? 'Go to Cart'
                                    : 'Add to Cart',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isOutOfStock
                                      ? _textLight
                                      : isAddedToCart
                                      ? Colors.white   // ← White text on gold
                                      : AppColors.kPrimary,      // ← Indigo text on white
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // ── RIGHT: Buy Now ──────────────────────
                    Expanded(
                      child: GestureDetector(
                        onTap: isOutOfStock
                            ? null
                            : () async {
                          if (!controller.isAddedToCart.value) {
                            await controller.addToCart();
                          }
                          controller.goToCart();
                        },
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: isOutOfStock
                                ? null
                                : const LinearGradient(
                              colors: [AppColors.kPrimary, AppColors.kPrimary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            color: isOutOfStock ? _divider : null,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: isOutOfStock
                                ? []
                                : [
                              BoxShadow(
                                color: _primary.withOpacity(0.32),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isOutOfStock
                                    ? Icons.remove_shopping_cart_outlined
                                    : Icons.bolt_rounded,
                                size: 18,
                                color: isOutOfStock
                                    ? _textLight
                                    : Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isOutOfStock ? 'Unavailable' : 'Buy Now',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isOutOfStock
                                      ? _textLight
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Helpers ────────────────────────────────────────────────
  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: _primary),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _textDark,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
