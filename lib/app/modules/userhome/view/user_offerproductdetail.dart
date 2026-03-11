


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../data/models/user_offerdetailmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controller/user_offerproductdetail_controller.dart';

class UserOfferProductDetailScreen extends StatefulWidget {
  final int offerProductId;
  const UserOfferProductDetailScreen({required this.offerProductId});

  @override
  State<UserOfferProductDetailScreen> createState() =>
      _UserOfferProductDetailScreenState();
}

class _UserOfferProductDetailScreenState
    extends State<UserOfferProductDetailScreen> {
  late final UserOfferProductDetailController controller;

  // ── Teal palette ───────────────────────────────────────────
  static const _teal      = Color(0xFF009688);
  static const _tealDark  = Color(0xFF00796B);
  static const _tealLight = Color(0xFFE0F2F1);
  static const _teal2     = Color(0xFF4DB6AC);
  static const _bg        = Color(0xFFF4F7F6);
  static const _textDark  = Color(0xFF1A2E2C);
  static const _textMid   = Color(0xFF546E6B);
  static const _textLight = Color(0xFF90AFAC);
  static const _divider   = Color(0xFFECF2F1);
  static const _red       = Color(0xFFE53935);
  static const _amber     = Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    // Tag by product ID so each product gets its own controller instance.
    controller = Get.put(
      UserOfferProductDetailController(),
      tag: widget.offerProductId.toString(),
    );
    if (controller.productData.value == null && !controller.isLoading.value) {
      controller.fetchProductDetails(widget.offerProductId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _teal, strokeWidth: 2.5),
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
                    color: _tealLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.error_outline_rounded,
                      size: 44, color: _teal),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load product',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _textDark),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () =>
                      controller.fetchProductDetails(widget.offerProductId),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
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
        return CustomScrollView(
          slivers: [
            _buildAppBar(context, product),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(controller, product),
                  _buildProductInfo(product),
                  _buildPriceSection(controller, product),
                  _buildVariantSelector(controller, product),
                  _buildCommonAttributes(product),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomBar(controller),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context, UserOfferProductDetail product) {
    return SliverAppBar(
      expandedHeight: 60,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: _teal,
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
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // ── Image Carousel ─────────────────────────────────────────
  Widget _buildImageCarousel(
      UserOfferProductDetailController controller,
      UserOfferProductDetail product) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (product.discountPercentage > 0)
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: _tealLight.withOpacity(0.5),
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
                      color: _tealLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _teal2),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_offer_rounded,
                            size: 11, color: _tealDark),
                        SizedBox(width: 4),
                        Text(
                          'Special Offer',
                          style: TextStyle(
                            color: _tealDark,
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
          CarouselSlider(
            options: CarouselOptions(
              height: 300,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                controller.currentImageIndex.value = index;
              },
            ),
            items: product.productImages.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xFFF9FAFB),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              size: 56, color: Color(0xFFCFD8DC)),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: _teal,
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
          ),
          if (product.productImages.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Obx(() => AnimatedSmoothIndicator(
                activeIndex: controller.currentImageIndex.value,
                count: product.productImages.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 7,
                  dotWidth: 7,
                  activeDotColor: _teal,
                  dotColor: Color(0xFFB2DFDB),
                  expansionFactor: 3,
                ),
              )),
            ),
        ],
      ),
    );
  }

  // ── Product Info ───────────────────────────────────────────
  Widget _buildProductInfo(UserOfferProductDetail product) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(18),
      color: Colors.white,
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
              Builder(builder: (_) {
                final stock      = product.stockQty;
                final qty        = int.tryParse(stock.toString()) ?? 0;
                final isLow      = qty > 0 && qty <= 5;
                final outOfStock = qty <= 0;
                final color =
                outOfStock ? _red : (isLow ? _amber : _teal);
                final label = outOfStock
                    ? 'Out of Stock'
                    : isLow
                    ? 'Only $qty left'
                    : 'In Stock';
                final icon = outOfStock
                    ? Icons.cancel_rounded
                    : Icons.check_circle_rounded;

                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
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
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _tealLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _teal2.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_offer_rounded,
                    size: 12, color: _teal),
                const SizedBox(width: 4),
                Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _tealDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Price Section ──────────────────────────────────────────
  Widget _buildPriceSection(
      UserOfferProductDetailController controller,
      UserOfferProductDetail product) {
    return Obx(() {
      final variant      = controller.selectedVariant.value;
      final variantPrice = variant?.price ?? product.price;
      final offerPrice   = product.offerPrice;
      final saved        = variantPrice - offerPrice;

      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(18),
        color: Colors.white,
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
                      color: _teal,
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: _tealLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _teal.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Text(
                    'YOU SAVE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: _tealDark,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${saved.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: _tealDark,
                    ),
                  ),
                  Text(
                    '${product.discountPercentage.toStringAsFixed(0)}% off',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _teal,
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

  // ── Variant Selector ───────────────────────────────────────
  Widget _buildVariantSelector(
      UserOfferProductDetailController controller,
      UserOfferProductDetail product) {
    if (product.variants.isEmpty) return const SizedBox.shrink();

    final attributeNames =
    product.variants.first.attributes.keys.toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(18),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Select Variant', Icons.tune_rounded),
          const SizedBox(height: 16),
          ...attributeNames.map((attributeName) {
            return _buildAttributeSelector(
              controller,
              attributeName,
              controller.getAvailableValuesForAttribute(attributeName),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAttributeSelector(
      UserOfferProductDetailController controller,
      String attributeName,
      List<String> values) {
    return Obx(() {
      final selectedValue = controller.selectedAttributes[attributeName];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.getAttributeDisplayName(attributeName),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _textMid,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.map((value) {
              final isSelected = selectedValue == value;
              return GestureDetector(
                onTap: () =>
                    controller.selectAttribute(attributeName, value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? _teal : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? _teal : _divider,
                      width: isSelected ? 2 : 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: _teal.withOpacity(0.28),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
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
          ),
          const SizedBox(height: 18),
        ],
      );
    });
  }

  // ── Common Attributes ──────────────────────────────────────
  Widget _buildCommonAttributes(UserOfferProductDetail product) {
    if (product.commonAttributes.isEmpty) return const SizedBox.shrink();

    final entries = product.commonAttributes.entries.toList();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(18),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Product Details', Icons.inventory_2_outlined),
          const SizedBox(height: 14),
          ...entries.asMap().entries.map((e) {
            final isEven = e.key.isEven;
            final entry  = e.value;
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isEven
                    ? _tealLight.withOpacity(0.45)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key[0].toUpperCase() +
                          entry.key.substring(1),
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
          }).toList(),
        ],
      ),
    );
  }

  // ── Bottom Bar ─────────────────────────────────────────────
  //
  // States:
  //   Out of stock  → [Out of Stock]  [Unavailable]  (both disabled)
  //   In stock, not in cart → [Add to Cart]  [Buy Now]
  //   In stock, in cart     → [Go to Cart]   [Buy Now]
  //   Remove from cart screen → auto-reverts to [Add to Cart] via ever()
  Widget _buildBottomBar(UserOfferProductDetailController controller) {
    return Obx(() {
      if (controller.isLoading.value ||
          controller.productData.value == null) {
        return const SizedBox.shrink();
      }

      final variant       = controller.selectedVariant.value;
      final isOutOfStock  = variant == null || variant.stock <= 0;
      final isAddedToCart = controller.isAddedToCart.value;

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
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

                  // ── LEFT: Add to Cart  ←→  Go to Cart ──────
                  Expanded(
                    child: GestureDetector(
                      onTap: isOutOfStock
                          ? null
                          : isAddedToCart
                          ? controller.goToCart     // in cart → navigate
                          : controller.addToCart,   // not in cart → add
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          // Filled teal when already in cart, outlined otherwise
                          color: isOutOfStock
                              ? Colors.white
                              : isAddedToCart
                              ? _teal
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isOutOfStock ? _divider : _teal,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                  ? Colors.white
                                  : _teal,
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
                                    ? Colors.white
                                    : _teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // ── RIGHT: Buy Now — always visible ─────────
                  // Adds to cart (if not already) then goes to cart
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
                            colors: [_teal, _tealDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          color: isOutOfStock ? _divider : null,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: isOutOfStock
                              ? []
                              : [
                            BoxShadow(
                              color: _teal.withOpacity(0.35),
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
                              color:
                              isOutOfStock ? _textLight : Colors.white,
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
    });
  }

  // ── Helpers ────────────────────────────────────────────────
  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _tealLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: _teal),
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