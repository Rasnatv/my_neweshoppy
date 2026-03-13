
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../data/models/merchant_offerproductviewmodel.dart';
import '../controller/merchant_offerproduct_view_controller.dart';
import 'merchant_offerproduct_detailsscreen.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.kPrimary,
        title: Text(
          "Offer Products",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchOfferProduct,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.offerProducts.isEmpty) {
          return _emptyView();
        }
        return _gridView(controller.offerProducts);
      }),
    );
  }

  // ═══════════════════════════ GRID ═══════════════════════════

  Widget _gridView(List<NMerchantOfferProductModels> products) {
    return RefreshIndicator(
      onRefresh: controller.fetchOfferProduct,
      child: GridView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.70,
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
      onTap: () {
        Get.to(
              () => MerchnantOfferProductDetailScreen (
            productId: product.productId,
          ),
        );
      },
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
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  child: Image.network(
                    product.productImage,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 130,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                  ),
                ),
                // DISCOUNT BADGE  — uses discount_percentage from API
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // product_name
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

                    // original_price (struck through) + saved amount
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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

                    // discount_price (offer price)
                    Text(
                      "₹${product.offerPrice.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPrimary,
                      ),
                    ),

                    const Spacer(),

                    // ── EDIT & DELETE BUTTONS ──────────────────────
                    Row(
                      children: [
                        // EDIT
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => EditOfferProductPage(
                                productId: product.productId,
                                offerId: offerId,
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.kPrimary
                                    .withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.kPrimary
                                        .withOpacity(0.4)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit_outlined,
                                      color: AppColors.kPrimary,
                                      size: 13),
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
                            onTap: () {
                              Get.defaultDialog(
                                title: "Delete",
                                titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                middleText:
                                "Are you sure you want to delete this product?",
                                middleTextStyle:
                                const TextStyle(fontSize: 13),
                                textConfirm: "Delete",
                                textCancel: "Cancel",
                                confirmTextColor: Colors.white,
                                buttonColor: Colors.red,
                                cancelTextColor: Colors.grey.shade700,
                                onConfirm: () {
                                  Get.back();
                                  controller.deleteOfferProduct(
                                      product.productId);
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius:
                                BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.red.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete_outline,
                                      color: Colors.red.shade600,
                                      size: 13),
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
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════ EMPTY ═══════════════════════════

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            "No Product Found",
            style:
            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Pull down to refresh",
            style:
            TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}