
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../common/style/app_colors.dart';
import '../../../data/models/cartmodel.dart';
import '../../../data/models/user_offerdetailmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../../product/controller/cartcontroller.dart';
import '../controller/user_offerproductdetail_controller.dart';
class UserOfferProductDetailScreen extends StatefulWidget {
  final int offerProductId;
  final int? preSelectedVariantId; // ✅ ADD

  const UserOfferProductDetailScreen({
    required this.offerProductId,
    this.preSelectedVariantId, // ✅ ADD
    super.key,
  });

  @override
  State<UserOfferProductDetailScreen> createState() =>
      _UserOfferProductDetailScreenState();
}

class _UserOfferProductDetailScreenState
    extends State<UserOfferProductDetailScreen> {
  late final UserOfferProductDetailController controller;
  late final CartController cartController;

  final CarouselSliderController _carouselController =
  CarouselSliderController();

  final String _token = GetStorage().read('auth_token') ?? '';

  // ── Design Tokens (matches ProductDetailPage) ───────────────
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
  void initState() {
    super.initState();
    controller = Get.put(
      UserOfferProductDetailController(),
      tag: widget.offerProductId.toString(),
    );
    cartController = Get.find<CartController>();

    // if (controller.productData.value == null && !controller.isLoading.value) {
    //   controller.fetchProductDetails(widget.offerProductId);
    // }
    if (controller.productData.value == null && !controller.isLoading.value) {
      controller.fetchProductDetails(widget.offerProductId).then((_) {
        // ✅ Pre-select the variant that was in cart
        if (widget.preSelectedVariantId != null) {
          controller.selectVariantById(widget.preSelectedVariantId!);
        }
      });
    }

    ever(controller.currentImageIndex, (index) {
      _carouselController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Product Details',
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
            child: CircularProgressIndicator(
                color: _primary, strokeWidth: 2.5),
          );
        }

        if (controller.productData.value == null) {
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
                  'Failed to load product',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () =>
                      controller.fetchProductDetails(widget.offerProductId),
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

        final product = controller.productData.value!;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  _buildImageCarousel(product),
                  const SizedBox(height: 8),
                  _buildProductInfo(product),
                  const SizedBox(height: 8),
                  _buildPriceSection(product),
                  const SizedBox(height: 8),
                  _buildVariantSelector(product),
                  const SizedBox(height: 8),
                  _buildCommonAttributes(product),
                  const SizedBox(height: 8),
                  _buildDescription(product),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            _buildBottomBar(product),
          ],
        );
      }),
    ));
  }

  // ── Image Carousel ──────────────────────────────────────────
  Widget _buildImageCarousel(UserOfferProductDetail product) {
    return Container(
      color: _surface,
      child: Column(
        children: [
          // Offer Badge Strip
          if (product.discountPercentage > 0)
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: _primaryLight.withOpacity(0.6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _accentLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _accent.withOpacity(0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_offer_rounded,
                            size: 11, color: _accent),
                        SizedBox(width: 4),
                        Text(
                          'Special Offer',
                          style: TextStyle(
                            color: _accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Carousel / Placeholder
          if (product.productImages.isEmpty)
            Container(
              height: 350,
              color: _bg,
              child: Center(
                child: Icon(Icons.image_not_supported_outlined,
                    size: 90, color: Colors.grey[300]),
              ),
            )
          else
            SizedBox(
              height: 350,
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 350,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  initialPage: controller.currentImageIndex.value,
                  onPageChanged: (index, _) {
                    controller.currentImageIndex.value = index;
                  },
                ),
                items: product.productImages.map((imageUrl) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    headers: {'Authorization': 'Bearer $_token'},
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
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.image_not_supported_outlined,
                      size: 90,
                      color: Colors.grey[300],
                    ),
                  );
                }).toList(),
              ),
            ),

          // Dot Indicators
          if (product.productImages.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Obx(() => AnimatedSmoothIndicator(
                activeIndex: controller.currentImageIndex.value,
                count: product.productImages.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 7,
                  dotWidth: 7,
                  activeDotColor: _primary,
                  dotColor: Color(0xFFB0B8CC),
                  expansionFactor: 3,
                ),
              )),
            ),
        ],
      ),
    );
  }

  // ── Product Info ────────────────────────────────────────────
  Widget _buildProductInfo(UserOfferProductDetail product) {
    return Container(
      padding: const EdgeInsets.all(18),
      color: _surface,
      child: Row(
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
          Obx(() {
            final qty        = controller.selectedVariant.value?.stock ?? 0;
            final isLow      = qty > 0 && qty <= 5;
            final isOut      = qty <= 0;
            final color      = isOut ? _red : isLow ? _amber : _green;
            final label      = isOut
                ? 'Out of Stock'
                : isLow
                ? 'Only $qty left'
                : '$qty In Stock';

            return Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.09),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.35)),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Price Section ───────────────────────────────────────────
  Widget _buildPriceSection(UserOfferProductDetail product) {
    return Obx(() {
      final variant      = controller.selectedVariant.value;
      final variantPrice = variant?.price ?? product.price;
      final offerPrice   = variant?.offerPrice ?? product.offerPrice;
      final saved        = variantPrice - offerPrice;
      final discountPct  = variantPrice > 0
          ? (saved / variantPrice) * 100
          : product.discountPercentage;

      return Container(
        padding: const EdgeInsets.all(18),
        color: _surface,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OFFER PRICE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _textLight,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${offerPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.green,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '₹${variantPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _textLight,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: _accentLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _accent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'YOU SAVE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: _accent,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${saved.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: _accent,
                    ),
                  ),
                  Text(
                    '${discountPct.toStringAsFixed(0)}% off',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _accent.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Variant Selector ────────────────────────────────────────
  Widget _buildVariantSelector(UserOfferProductDetail product) {
    if (product.variants.isEmpty) return const SizedBox.shrink();

    final attributeNames =
    product.variants.first.attributes.keys.toList();

    return Container(
      color: _surface,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Select Variant', Icons.tune_rounded),
          const SizedBox(height: 16),
          ...attributeNames.map((attr) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.getAttributeDisplayName(attr),
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
                  controller.selectedAttributes[attr];
                  final values =
                  controller.getAvailableValuesForAttribute(attr);

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: values.map((value) {
                      final isSelected = selected == value;
                      return GestureDetector(
                        onTap: () =>
                            controller.selectAttribute(attr, value),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.kPrimary
                                : _surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.kPrimary
                                  : _divider,
                              width: isSelected ? 2 : 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color:
                                _primary.withOpacity(0.25),
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
                              color: isSelected
                                  ? Colors.white
                                  : _textDark,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          )),

          // Low-stock warning
          Obx(() {
            final stock =
                controller.selectedVariant.value?.stock ?? 0;
            if (stock <= 0 || stock > 5) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _amber.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 14, color: _amber),
                  const SizedBox(width: 6),
                  Text(
                    'Only $stock left in stock!',
                    style: const TextStyle(
                      fontSize: 12,
                      color: _amber,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Common Attributes ───────────────────────────────────────
  Widget _buildCommonAttributes(UserOfferProductDetail product) {
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
                      entry.value,
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
          }),
        ],
      ),
    );
  }

  // ── Description ─────────────────────────────────────────────
  Widget _buildDescription(UserOfferProductDetail product) {
    if (product.description.trim().isEmpty) return const SizedBox.shrink();

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


  Widget _buildBottomBar(UserOfferProductDetail product) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Obx(() {
        final variant      = controller.selectedVariant.value;
        final isOutOfStock = variant == null || variant.stock <= 0;

        // ✅ FIX: match by productId AND variantId
        final cartItem = variant == null
            ? null
            : cartController.cartItems.firstWhereOrNull(
              (item) =>
          item.productId == product.productId.toString() &&
              item.variantId == variant.variantId,
        );
        final isInCart = cartItem != null;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: _surface,
            border: Border(
              top: BorderSide(color: _divider, width: 0.5),
            ),
          ),
          child: SafeArea(
            top: false,
            child: isInCart && !isOutOfStock
                ? _buildCartStepper(cartItem!, product)
                : _buildAddToCartButton(isOutOfStock, product),
          ),
        );
      }),
    );
  }

  Widget _buildAddToCartButton(
      bool isOutOfStock, UserOfferProductDetail product) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: GestureDetector(
        onTap: isOutOfStock
            ? null
            : () async {
          final variantId = controller.selectedVariant.value?.variantId;
          if (variantId == null) {
            AppSnackbar.warning("Please select a variant");
            return;
          }
          await cartController.addToCart(
            productId: product.productId,
            variantId: variantId,
            type: product.type,
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
  Widget _buildCartStepper(CartItem cartItem, UserOfferProductDetail product) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                  onTap: () => cartController.updateQuantity(
                    product.productId,
                    "decrement",
                    variantId: cartItem.variantId, // ✅ fix
                  ),
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
                  onTap: () => cartController.updateQuantity(
                    product.productId,
                    "increment",
                    variantId: cartItem.variantId, // ✅ fix
                  ),
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