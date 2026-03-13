
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/offer_productdetailmodel.dart';
import '../controller/merchant_offerproduct_detailcontroller.dart';

class MerchnantOfferProductDetailScreen extends StatelessWidget {
  final int productId;

  const MerchnantOfferProductDetailScreen(
      {super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MerchantOfferProductDetailController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProductDetail(productId);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        title: const Text(
          "Product Details",
          style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child:
              CircularProgressIndicator(color: AppColors.kPrimary));
        }
        final product = controller.productDetail.value;
        if (product == null) {
          return const Center(child: Text("No details available."));
        }
        return _buildBody(product, controller);
      }),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────
  Widget _buildBody(
      MerchantOfferProductDetailModel product,
      MerchantOfferProductDetailController controller) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageSection(product, controller),
          _detailsCard(product, controller),
          if (product.productAttributes.commonAttributes.isNotEmpty)
            _attributesCard(product),
          if (product.productAttributes.variants.isNotEmpty)
            _variantsCard(product, controller),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Image Section ─────────────────────────────────────────────────────────
  // Images are sourced from each variant's "image" field.
  Widget _imageSection(
      MerchantOfferProductDetailModel product,
      MerchantOfferProductDetailController controller) {
    // One image per variant
    final images = product.productImages;

    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          color: Colors.white,
          child: images.isEmpty
              ? const Center(
              child: Icon(Icons.image_not_supported_outlined,
                  size: 60, color: Colors.grey))
              : PageView.builder(
            controller: controller.pageController,
            itemCount: images.length,
            onPageChanged: controller.onImagePageChanged,
            itemBuilder: (context, index) => Image.network(
              images[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(
                    child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image_outlined,
                      size: 48, color: Colors.grey)),
            ),
          ),
        ),

        // Discount badge — from selected variant
        Obx(() {
          final variants = product.productAttributes.variants;
          if (variants.isEmpty) return const SizedBox.shrink();
          final idx = controller.selectedVariantIndex.value
              .clamp(0, variants.length - 1);
          final discount = variants[idx].discountPercentage;
          return Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${discount.toStringAsFixed(0)}% OFF",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12),
              ),
            ),
          );
        }),

        // Stock badge — from selected variant
        Obx(() {
          final variants = product.productAttributes.variants;
          if (variants.isEmpty) return const SizedBox.shrink();
          final idx = controller.selectedVariantIndex.value
              .clamp(0, variants.length - 1);
          final stock = variants[idx].stock;
          return Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: stock > 0
                    ? Colors.green.shade600
                    : Colors.red.shade500,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                stock > 0 ? "In Stock ($stock)" : "Out of Stock",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11),
              ),
            ),
          );
        }),

        // Dot indicators
        if (images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final isActive =
                    controller.currentImageIndex.value == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.kPrimary
                        : Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            )),
          ),
      ],
    );
  }

  // ── Details Card ──────────────────────────────────────────────────────────
  // Price info is taken from the currently selected variant.
  Widget _detailsCard(
      MerchantOfferProductDetailModel product,
      MerchantOfferProductDetailController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.productName,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 12),

          // Price row — reactive to selected variant
          Obx(() {
            final variants = product.productAttributes.variants;
            if (variants.isEmpty) return const SizedBox.shrink();
            final idx = controller.selectedVariantIndex.value
                .clamp(0, variants.length - 1);
            final variant = variants[idx];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${variant.finalPrice.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.kPrimary),
                ),
                const SizedBox(width: 10),
                Text(
                  "₹${variant.price.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade400,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.grey.shade400,
                      decorationThickness: 1.8),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    "Save ₹${variant.savedAmount.toStringAsFixed(0)}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade700),
                  ),
                ),
              ],
            );
          }),

          if (product.description.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            const Text("Description",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF555555))),
            const SizedBox(height: 6),
            Text(
              product.description,
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF777777),
                  height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  // ── Common Attributes Card ────────────────────────────────────────────────
  Widget _attributesCard(MerchantOfferProductDetailModel product) {
    final attrs = product.productAttributes.commonAttributes;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Specifications",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1E))),
          const SizedBox(height: 12),
          ...attrs.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    _capitalize(e.key),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF555555)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    e.value,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF333333)),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Variants Card ─────────────────────────────────────────────────────────
  Widget _variantsCard(
      MerchantOfferProductDetailModel product,
      MerchantOfferProductDetailController controller) {
    final variants = product.productAttributes.variants;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Available Variants",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1E))),
          const SizedBox(height: 12),

          // ── Variant chips ──────────────────────────────────────
          Obx(() => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(variants.length, (index) {
              final variant    = variants[index];
              final isSelected =
                  controller.selectedVariantIndex.value == index;
              final label =
              variant.attributes.values.join(' / ');

              return GestureDetector(
                onTap: () => controller.selectVariant(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.kPrimary
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.kPrimary
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade700),
                  ),
                ),
              );
            }),
          )),

          const SizedBox(height: 14),

          // ── Selected variant detail box ────────────────────────
          Obx(() {
            final idx = controller.selectedVariantIndex.value
                .clamp(0, variants.length - 1);
            final selected = variants[idx];

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(idx),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Variant image thumbnail
                    if (selected.image.isNotEmpty &&
                        selected.image.startsWith('http'))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          selected.image,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 64,
                            height: 64,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.grey, size: 24),
                          ),
                        ),
                      ),

                    if (selected.image.isNotEmpty &&
                        selected.image.startsWith('http'))
                      const SizedBox(width: 12),

                    // Attributes
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selected.attributes.entries
                            .map((e) => Text(
                          "${_capitalize(e.key)}: ${e.value}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF444444)),
                        ))
                            .toList(),
                      ),
                    ),

                    // Pricing & stock
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹${selected.finalPrice.toStringAsFixed(0)}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.kPrimary),
                        ),
                        Text(
                          "MRP ₹${selected.price.toStringAsFixed(0)}",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.red.shade400,
                              decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: selected.stock > 0
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: selected.stock > 0
                                    ? Colors.green.shade200
                                    : Colors.red.shade200),
                          ),
                          child: Text(
                            selected.stock > 0
                                ? "Stock: ${selected.stock}"
                                : "Out of Stock",
                            style: TextStyle(
                                fontSize: 11,
                                color: selected.stock > 0
                                    ? Colors.green.shade700
                                    : Colors.red.shade600,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty
      ? s
      : s[0].toUpperCase() + s.substring(1).replaceAll('_', ' ');
}
