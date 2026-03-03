
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../data/models/merchant_offerproductviewmodel.dart';
import '../controller/merchant_offerproduct_view_controller.dart';
import 'merchant_offerproduct_detailsscreen.dart';

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

  // ================= GRID =================

  Widget _gridView(List<MerchantOfferProductModels> products) {
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
          return _productCard(products[index]);
        },
      ),
    );
  }

  // ================= PRODUCT CARD =================

  Widget _productCard(MerchantOfferProductModels product) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MerchnantOfferProductDetailScreen(
          productId: product.productId,
        ));
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
            // IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    product.productImage,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// DISCOUNT BADGE
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

            /// DETAILS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${product.realPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "Save ₹${product.savedAmount.toStringAsFixed(0)}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "₹${product.offerPrice.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ================= EMPTY =================

  Widget _emptyView() {
    return const Center(
      child: Text(
        "No Product Found",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}