
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/modules/product/view/prodductdetailscreen.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_text_style.dart';
import '../../userhome/view/user_offerproductdetail.dart';
import '../controller/cartcontroller.dart';
import '../../../data/models/cartmodel.dart';
import 'addresslistpage.dart';
import '../controller/userproductdetail_controller.dart';
import '../../../data/models/user_productdetailmodel.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  final int? preSelectedVariantId;

  const ProductDetailPage({
    super.key,
    required this.productId,
    this.preSelectedVariantId,
  });

  static const _tealDark    = Color(0xFF0A7D65);
  static const _tealDeep    = Color(0xFF085041);
  static const _tealLight   = Color(0xFFE0F5F0);
  static const _tealSurface = Color(0xFFF2FBFA);
  static const _surface     = Color(0xFFFFFFFF);
  static const _textDark    = Color(0xFF0D1F1B);
  static const _textMid     = Color(0xFF4A6560);
  static const _textLight   = Color(0xFF9BB5B0);
  static const _divider     = Color(0xFFE8F0EE);
  static const _red         = Color(0xFFD03A3A);
  static const _amber       = Color(0xFFE09020);

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: always delete stale controller so preSelectedVariantId
    // from the new navigation is never ignored
    if (Get.isRegistered<ProductDetailController>(tag: productId.toString())) {
      Get.delete<ProductDetailController>(
          tag: productId.toString(), force: true);
    }

    final controller = Get.put(
      ProductDetailController(
        productId: productId,
        preSelectedVariantId: preSelectedVariantId,
      ),
      tag: productId.toString(),
    );

    final cartController = Get.find<CartController>();

    // ... rest of build unchanged

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F3),
        appBar: AppBar(
          backgroundColor: Colors.teal,
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
                  color: Colors.teal, strokeWidth: 2.5),
            );
          }
          final product = controller.product.value;
          final variant = controller.selectedVariant.value;
          if (product == null || variant == null)
            return _buildError(controller);

          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImagePanel(controller, product),
                    _buildInfoBlock(product, variant),
                    _buildVariantSection(controller, product),
                    _buildSpecifications(product),
                    _buildDescription(product),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
              _buildBottomBar(controller, cartController, product, variant),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildError(ProductDetailController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration:
              const BoxDecoration(color: _tealLight, shape: BoxShape.circle),
              child: const Icon(Icons.error_outline_rounded,
                  size: 30, color: Colors.teal),
            ),
            const SizedBox(height: 14),
            const Text('Product not found',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _textDark)),
            const SizedBox(height: 6),
            const Text(
              'Something went wrong. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: _textMid, height: 1.5),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () => controller.fetchProduct(productId),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
                    SizedBox(width: 7),
                    Text('Retry',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePanel(
      ProductDetailController controller, ProductDetailModel product) {
    final variants = product.variants;
    final count = variants.length;

    return Stack(
      children: [
        SizedBox(
          height: 380,
          // ✅ Removed Obx wrapper — PageController is not observable
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: count,
            onPageChanged: (index) {
              controller.currentImageIndex.value = index;
              controller.selectVariant(variants[index]);
            },
            itemBuilder: (context, index) {
              final v = variants[index];
              return Container(
                color: _surface,
                child: Image.network(
                  v.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported_outlined,
                          size: 56, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Text('No image available',
                          style:
                          TextStyle(fontSize: 12, color: Colors.grey[400])),
                    ],
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                        strokeWidth: 2.5,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),

        // Gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFFF0F4F3).withOpacity(0.9),
                ],
              ),
            ),
          ),
        ),

        // Dot indicators — keep their own Obx, they DO read currentImageIndex
        if (count > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Obx(() {
              final current = controller.currentImageIndex.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(count, (i) {
                  final isActive = i == current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.teal : _tealLight,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildInfoBlock(
      ProductDetailModel product, ProductVariantModel variant) {
    final stock = variant.stock;
    final isOut = stock <= 0;
    final isLow = stock > 0 && stock <= 5;
    final stockColor = isOut ? _red : (isLow ? _amber : Colors.teal);
    final stockLabel = isOut
        ? 'Out of Stock'
        : isLow
        ? 'Only $stock left'
        : '$stock In Stock';

    return Container(
      width: double.infinity,
      color: _surface,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                    color: _textDark,
                    height: 1.3,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: stockColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: stockColor.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                          color: stockColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      stockLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: stockColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '₹${variant.price}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.teal,
                  letterSpacing: -0.7,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSection(
      ProductDetailController controller, ProductDetailModel product) {
    final attributeMap = controller.getVariantAttributes();
    if (attributeMap.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 5),
      color: _surface,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Select Variant', Icons.tune_rounded),
          const SizedBox(height: 17),
          ...attributeMap.entries.map((entry) {
            final attribute = entry.key;
            final values = entry.value.toList();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attribute[0].toUpperCase() + attribute.substring(1),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _textLight,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Obx(() {
                    final selected = controller
                        .selectedVariant.value?.attributes[attribute];
                    return Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: values.map((value) {
                        final isSelected = selected == value;
                        ProductVariantModel? matched;
                        try {
                          matched = product.variants.firstWhere(
                                  (v) => v.attributes[attribute] == value);
                        } catch (_) {}
                        return GestureDetector(
                          onTap: matched != null
                              ? () => controller.selectVariant(matched!)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 17, vertical: 13),
                            decoration: BoxDecoration(
                              color:
                              isSelected ? Colors.teal : _tealSurface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                isSelected ? Colors.teal : _divider,
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : _textMid,
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

  Widget _buildSpecifications(ProductDetailModel product) {
    if (product.commonAttributes.isEmpty) return const SizedBox.shrink();
    final entries = product.commonAttributes.entries.toList();

    return Container(
      margin: const EdgeInsets.only(top: 5),
      color: _surface,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Specifications', Icons.inventory_2_outlined),
          const SizedBox(height: 8),
          ...entries.asMap().entries.map((e) {
            final isLast = e.key == entries.length - 1;
            final entry = e.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          entry.key[0].toUpperCase() +
                              entry.key.substring(1),
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          entry.value.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(color: _divider, height: 1, thickness: 1),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDescription(ProductDetailModel product) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      color: _surface,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Description', Icons.description_outlined),
          const SizedBox(height: 10),
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.65,
              color: _textMid,
              letterSpacing: 0.1,
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
      ProductVariantModel variant,
      ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Obx(() {
        final current = controller.selectedVariant.value ?? variant;
        final isOut = current.stock <= 0;

        // ✅ Check cart by both productId AND variantId
        final cartItem = cartController.cartItems.firstWhereOrNull(
              (i) =>
          i.productId == productId.toString() &&
              i.variantId == current.variantId,
        );
        final isInCart = cartItem != null;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
          decoration: BoxDecoration(
            color: _surface,
            boxShadow: [
              BoxShadow(
                color: _tealDeep.withOpacity(0.1),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: isInCart && !isOut
                ? _buildCartStepper(cartItem!, cartController)
                : _buildAddBtn(isOut, cartController, current.variantId),
          ),
        );
      }),
    );
  }

  Widget _buildAddBtn(
      bool isOut, CartController cartController, int variantId) {
    return GestureDetector(
      onTap: isOut
          ? null
          : () async => await cartController.addToCart(
        productId: productId,
        variantId: variantId,
        type: 0,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          color: isOut ? _divider : Colors.teal,
          borderRadius: BorderRadius.circular(13),
          boxShadow: isOut
              ? []
              : [
            BoxShadow(
              color: Colors.teal.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOut
                  ? Icons.remove_shopping_cart_outlined
                  : Icons.shopping_bag_outlined,
              size: 18,
              color: isOut ? _textLight : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              isOut ? 'Out of Stock' : 'Add to Cart',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isOut ? _textLight : Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartStepper(CartItem cartItem, CartController cartController) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Get.toNamed('/cart'),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: _tealLight,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 16, color: _tealDark),
                  SizedBox(width: 6),
                  Text(
                    'Go to Cart',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _tealDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.35),
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
                  productId,
                  "decrement",
                  variantId: cartItem.variantId,
                ),
                child: Container(
                  width: 46,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(13),
                      bottomLeft: Radius.circular(13),
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
                  width: 36,
                  child: Center(
                    child: Text(
                      '${cartItem.quantity}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => cartController.updateQuantity(
                  productId,
                  "increment",
                  variantId: cartItem.variantId,
                ),
                child: Container(
                  width: 46,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(13),
                      bottomRight: Radius.circular(13),
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
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _tealLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: Colors.teal),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: _textDark,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}