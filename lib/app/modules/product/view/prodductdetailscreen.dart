

import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/cartmodel.dart';
import '../controller/cartcontroller.dart';
import '../controller/userproductdetail_controller.dart';
import '../../../data/models/user_productdetailmodel.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  static const _primary      = Color(0xFF3D5A99);
  static const _primaryLight = Color(0xFFEEF1F9);
  static const _accent       = Color(0xFFE8A020);
  static const _accentLight  = Color(0xFFFFF8EC);
  static const _bg           = Color(0xFFF5F6FA);
  static const _surface      = Color(0xFFFFFFFF);
  static const _textDark     = Color(0xFF1C2340);
  static const _textMid      = Color(0xFF5A6480);
  static const _textLight    = Color(0xFFB0B8CC);
  static const _divider      = Color(0xFFEBEDF5);
  static const _red          = Color(0xFFD93025);
  static const _amber        = Color(0xFFF59E0B);
  static const _green        = Color(0xFF1A8A5A);

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

    final cartController = Get.find<CartController>();

    return NetworkAwareWrapper(child:Scaffold(
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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _primary, strokeWidth: 2.5),
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
                  SizedBox(height: 5,),
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
            _buildBottomBar(controller, cartController, product, variant),
          ],
        );
      }),
    ));
  }

  // ── Image Gallery ───────────────────────────────────────────
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

  // ── Product Info ────────────────────────────────────────────
  Widget _buildProductInfo(
      ProductDetailModel product, ProductVariantModel variant) {
    final stockCount = variant.stock;
    final isLow      = stockCount > 0 && stockCount <= 5;
    final isOut      = stockCount <= 0;
    final color      = isOut ? _red : (isLow ? _amber : _green);
    // In _buildProductInfo, change label to show count when in stock:
    final label = isOut
        ? 'Out of Stock'
        : isLow
        ? 'Only $stockCount left'
        : '$stockCount In Stock';   // ← shows actual count

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
                padding:
                const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(icon, size: 11, color: color),
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
          Text(
            "₹${variant.price}",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.green,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  // ── Variant Section ─────────────────────────────────────────
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
                                color:
                                isSelected ? AppColors.kPrimary : _divider,
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
                                color:
                                isSelected ? Colors.white : _textDark,
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

  // ── Common Attributes ───────────────────────────────────────
  Widget _buildCommonAttributes(ProductDetailModel product) {
    if (product.commonAttributes.isEmpty) return const SizedBox.shrink();

    final entries = product.commonAttributes.entries.toList();

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
                color: isEven
                    ? _primaryLight.withOpacity(0.55)
                    : _surface,
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

  // ── Description ─────────────────────────────────────────────
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

  Widget _buildBottomBar(
      ProductDetailController controller,
      CartController cartController,
      ProductDetailModel product,
      ProductVariantModel variant) {
    return Positioned(
      left: 0, right: 0, bottom: 0,
      child: Obx(() {
        final currentVariant = controller.selectedVariant.value ?? variant;
        final isOutOfStock = currentVariant.stock <= 0;

        final cartItem = cartController.cartItems.firstWhereOrNull(
              (item) => item.productId == productId.toString(),
        );
        final isInCart = cartItem != null;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: _surface,
            border: const Border(top: BorderSide(color: _divider, width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: isInCart && !isOutOfStock
                ? _buildCartStepper(cartItem!, cartController)
                : _buildAddToCartButton(
              isOutOfStock,
              cartController,
              currentVariant.variantId,  // ✅ pass variantId
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAddToCartButton(
      bool isOutOfStock,
      CartController cartController,
      int variantId,  // ✅ added
      ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: GestureDetector(
        onTap: isOutOfStock
            ? null
            : () async {
          await cartController.addToCart(
            productId: productId,
            variantId: variantId,  // ✅ pass it
            type: 0,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isOutOfStock ? _divider : AppColors.kPrimary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isOutOfStock
                    ? Icons.remove_shopping_cart_outlined
                    : Icons.shopping_bag_outlined,
                size: 19,
                color: isOutOfStock ? _textLight : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                isOutOfStock ? 'Out of Stock' : 'Add to Cart',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isOutOfStock ? _textLight : Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Cart Stepper ────────────────────────────────────────────
  Widget _buildCartStepper(CartItem cartItem, CartController cartController) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal:8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Get.toNamed('/cart'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _accentLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _accent.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_rounded, size: 17, color: _accent),
                    const SizedBox(width: 6),
                    Text(
                      'Go to Cart',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.kPrimary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.32),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () =>
                      cartController.updateQuantity(productId, "decrement"),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                      ),
                    ),
                    child: const Icon(Icons.remove_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: SizedBox(
                    key: ValueKey(cartItem.quantity),
                    width: 40,
                    child: Center(
                      child: Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      cartController.updateQuantity(productId, "increment"),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Title Helper ────────────────────────────────────
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