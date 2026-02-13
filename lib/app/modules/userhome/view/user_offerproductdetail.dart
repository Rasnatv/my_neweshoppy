import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../common/style/app_text_style.dart';
import '../../../data/models/user_offerdetailmodel.dart';
import  'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controller/user_offerproductdetail_controller.dart';


class UserOfferProductDetailScreen extends StatelessWidget {
  final int offerProductId;

  UserOfferProductDetailScreen({required this.offerProductId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserOfferProductDetailController());

    // Fetch data when screen loads
    controller.fetchProductDetails(offerProductId);

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.productData.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text("Failed to load product details"),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchProductDetails(offerProductId),
                  child: Text("Retry"),
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
                  _buildStockInfo(controller),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomBar(controller),
    );
  }

  Widget _buildAppBar(BuildContext context, UserOfferProductDetail product) {
    return SliverAppBar(
      expandedHeight: 60,
      floating: true,
      pinned: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor:AppColors.kPrimary,
      elevation: 0,
      title: Text(
        "Product Details",style:AppTextStyle.rTextNunitoWhite17w700
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {
            // TODO: Implement share
          },
        ),
        IconButton(
          icon: Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {
            // TODO: Implement wishlist
          },
        ),
      ],
    );
  }

  Widget _buildImageCarousel(
      UserOfferProductDetailController controller, UserOfferProductDetail product) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Offer Badge
          if (product.discountPercentage > 0)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${product.discountPercentage}% OFF",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Image Carousel
          CarouselSlider(
            options: CarouselOptions(
              height: 320,
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
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Color(0xFFF3F4F6),
                          child: Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.grey,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
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

          // Indicator
          if (product.productImages.length > 1)
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Obx(() => AnimatedSmoothIndicator(
                activeIndex: controller.currentImageIndex.value,
                count: product.productImages.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Color(0xFF3B82F6),
                  dotColor: Color(0xFFE5E7EB),
                ),
              )),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(UserOfferProductDetail product) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.productName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              height: 1.3,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.local_offer, size: 16, color: Color(0xFF10B981)),
              SizedBox(width: 6),
              Text(
                product.offerName,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(
      UserOfferProductDetailController controller, UserOfferProductDetail product) {
    return Obx(() {
      final variant = controller.selectedVariant.value;
      final variantPrice = variant?.price ?? product.price;
      final offerPrice = product.offerPrice;

      return Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${offerPrice.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10B981),
                  ),
                ),
                SizedBox(width: 12),
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Text(
                    "₹${variantPrice.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "You save ₹${(variantPrice - offerPrice).toStringAsFixed(0)} (${product.discountPercentage}%)",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF59E0B),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildVariantSelector(
      UserOfferProductDetailController controller, UserOfferProductDetail product) {
    if (product.variants.isEmpty) return SizedBox.shrink();

    // Get all unique attribute names
    final attributeNames =
    product.variants.first.attributes.keys.toList();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Variant",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 16),
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
      List<String> values,
      ) {
    return Obx(() {
      final selectedValue = controller.selectedAttributes[attributeName];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.getAttributeDisplayName(attributeName),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: values.map((value) {
              final isSelected = selectedValue == value;
              return GestureDetector(
                onTap: () => controller.selectAttribute(attributeName, value),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF3B82F6) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Color(0xFF3B82F6)
                          : Color(0xFFE5E7EB),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _buildCommonAttributes(UserOfferProductDetail product) {
    if (product.commonAttributes.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 16),
          ...product.commonAttributes.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key[0].toUpperCase() + entry.key.substring(1),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
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

  Widget _buildStockInfo(UserOfferProductDetailController controller) {
    return Obx(() {
      final variant = controller.selectedVariant.value;
      if (variant == null) return SizedBox.shrink();

      return Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          children: [
            Icon(
              variant.stock > 0
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              color: variant.stock > 0 ? Color(0xFF10B981) : Color(0xFFEF4444),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              variant.stock > 0
                  ? "In Stock (${variant.stock} available)"
                  : "Out of Stock",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: variant.stock > 0
                    ? Color(0xFF10B981)
                    : Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomBar(UserOfferProductDetailController controller) {
    return Obx(() {
      final variant = controller.selectedVariant.value;
      final isOutOfStock = variant == null || variant.stock <= 0;

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity selector
              if (!isOutOfStock)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, size: 20),
                        onPressed: controller.decreaseQuantity,
                        color: Color(0xFF6B7280),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "${controller.quantity.value}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, size: 20),
                        onPressed: controller.increaseQuantity,
                        color: Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ),

              if (!isOutOfStock) SizedBox(width: 12),

              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: isOutOfStock ? null : controller.addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isOutOfStock ? Color(0xFFE5E7EB) : Color(0xFF3B82F6),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isOutOfStock
                            ? Icons.block
                            : Icons.shopping_cart_outlined,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        isOutOfStock ? "Out of Stock" : "Add to Cart",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}