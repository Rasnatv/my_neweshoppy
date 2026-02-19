import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/offer_productdetailmodel.dart';
import '../controller/merchant_offerproduct_detailcontroller.dart';


class MerchnantOfferProductDetailScreen extends StatelessWidget {
  final int offerId;

  MerchnantOfferProductDetailScreen({super.key, required this.offerId});

  late final MerchantOfferProductDetailController controller =
  Get.put(MerchantOfferProductDetailController());

  @override
  Widget build(BuildContext context) {
    controller.fetchProductDetail(offerId);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        title: const Text(
          "Product Details",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(color: AppColors.kPrimary));
        }
        final product = controller.productDetail.value;
        if (product == null) {
          return const Center(child: Text("No details available."));
        }
        return _buildBody(product);
      }),
    );
  }

  Widget _buildBody(MerchantOfferProductDetailModel product) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageSection(product),
          _detailsCard(product),
          if (product.productAttributes.commonAttributes.isNotEmpty)
            _attributesCard(product),
          if (product.productAttributes.variants.isNotEmpty)
            _variantsCard(product),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Image Section ──────────────────────────────────────────────────────────
  Widget _imageSection(MerchantOfferProductDetailModel product) {
    final images = product.productImages
        .where((img) => img.isNotEmpty && img.startsWith('http'))
        .toList();

    return Stack(
      children: [
        Container(
          height: 280,
          width: double.infinity,
          color: Colors.white,
          child: images.isEmpty
              ? const Center(
              child: Icon(Icons.image_not_supported_outlined,
                  size: 60, color: Colors.grey))
              : PageView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) => Image.network(
              images[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image_outlined,
                      size: 48, color: Colors.grey)),
            ),
          ),
        ),
        // Discount badge
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${product.discountPercentage.toStringAsFixed(0)}% OFF",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12),
            ),
          ),
        ),
        // Stock badge
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: product.stockQty > 0
                  ? Colors.green.shade600
                  : Colors.red.shade500,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              product.stockQty > 0
                  ? "In Stock (${product.stockQty})"
                  : "Out of Stock",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }

  // ── Details Card ───────────────────────────────────────────────────────────
  Widget _detailsCard(MerchantOfferProductDetailModel product) {
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
          // Product Name
          Text(
            product.productName,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 12),

          // Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${product.offerPrice.toStringAsFixed(0)}",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.kPrimary),
              ),
              const SizedBox(width: 10),
              Text(
                "₹${product.price.toStringAsFixed(0)}",
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
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  "Save ₹${product.savedAmount.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700),
                ),
              ),
            ],
          ),

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

  // ── Common Attributes Card ─────────────────────────────────────────────────
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
                        fontSize: 13, color: Color(0xFF333333)),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Variants Card ──────────────────────────────────────────────────────────
  Widget _variantsCard(MerchantOfferProductDetailModel product) {
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
          Obx(() => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(variants.length, (index) {
              final variant = variants[index];
              final isSelected =
                  controller.selectedVariantIndex.value == index;
              final label = variant.attributes.values.join(' / ');
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
                        color:
                        isSelected ? Colors.white : Colors.grey.shade700),
                  ),
                ),
              );
            }),
          )),
          const SizedBox(height: 14),
          Obx(() {
            final selected =
            variants[controller.selectedVariantIndex.value];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${selected.price.toStringAsFixed(0)}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.kPrimary),
                      ),
                      Text(
                        "Stock: ${selected.stock}",
                        style: TextStyle(
                            fontSize: 12,
                            color: selected.stock > 0
                                ? Colors.green.shade600
                                : Colors.red.shade500,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).replaceAll('_', ' ');
}