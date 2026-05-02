
import 'dart:io';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/merchant_offerproductviewmodel.dart';
import '../../../widgets/delete_widget.dart';
import '../controller/merchant_offerproduct_view_controller.dart';
import 'merchant_offerproductupdatepage.dart';

class OfferProductScreen extends StatelessWidget {
  final int offerId;

  late final MerchantOfferProductController controller;

  OfferProductScreen({super.key, required this.offerId}) {
    controller = Get.put(
      MerchantOfferProductController(offerId: offerId),
      tag: offerId.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F3F7),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.kPrimary,
          title: const Text(
            "Offer Products",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            Obx(
                  () => controller.isRefreshing.value
                  ? const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
                  : IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: controller.fetchOfferProduct,
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return _gridView(context, controller.offerProducts);
        }),
      ),
    );
  }

  // ═══════════════════════════ GRID ═══════════════════════════

  Widget _gridView(
      BuildContext context, List<NMerchantOfferProductModels> products) {
    // ✅ Calculate mainAxisExtent dynamically based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenWidth >= 430
        ? 310.0 // Large phones (iPhone Pro Max, Samsung Ultra)
        : screenWidth >= 390
        ? 295.0 // Medium-large phones
        : 280.0; // Normal phones

    return RefreshIndicator(
      onRefresh: controller.fetchOfferProduct,
      child: GridView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: cardHeight, // ✅ Fixed height — no ratio math needed
        ),
        itemBuilder: (context, index) {
          return _productCard(context, products[index]);
        },
      ),
    );
  }

  // ═══════════════════════ PRODUCT CARD ═══════════════════════

  Widget _productCard(
      BuildContext context, NMerchantOfferProductModels product) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── IMAGE ──────────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: _buildProductImage(product.productImage),
                ),
                // DISCOUNT BADGE
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${product.discountPercentage.toStringAsFixed(0)}% OFF",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── DETAILS ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Original price & savings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${product.realPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        "Save ₹${product.savedAmount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Offer price
                  Text(
                    "₹${product.offerPrice.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kPrimary,
                    ),
                  ),

                  const SizedBox(height: 10), // ✅ Replaced Spacer() with fixed gap

                  // ── EDIT & DELETE BUTTONS ──────────────────────
                  Row(
                    children: [
                      // EDIT
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Get.to(
                                  () => const UpdateOfferProductPage(),
                              arguments: {
                                'offer_product_id': product.productId,
                                'offer_id': offerId,
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.kPrimary.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit_outlined,
                                    color: AppColors.kPrimary, size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: AppColors.kPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // DELETE
                      Expanded(
                        child: GestureDetector(
                          onTap: () => DeleteConfirmDialog.show(
                            context: Get.context!,
                            title: 'Delete Product',
                            message:
                            '"${product.productName}" will be permanently removed.',
                            onConfirm: () => controller
                                .deleteOfferProduct(product.productId),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline,
                                    color: Colors.red.shade600, size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Handles network URL, local file path, and empty/null image
  Widget _buildProductImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        height: 130,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
        key: ValueKey(imagePath),
        errorBuilder: (_, __, ___) => Container(
          height: 130,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    }

    // ✅ Local file path — used right after image update before silentRefresh
    return Image.file(
      File(imagePath),
      height: 130,
      width: double.infinity,
      fit: BoxFit.cover,
      key: ValueKey(imagePath),
      errorBuilder: (_, __, ___) => Container(
        height: 130,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }

// ═══════════════════════════ EMPTY ═══════════════════════════
}
