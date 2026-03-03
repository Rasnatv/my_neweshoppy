
import 'package:eshoppy/app/modules/userhome/view/user_offerproductdetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/userofferproduct_controller.dart';

class UserOfferProductPage extends StatelessWidget {
  final String offer_id;

  const UserOfferProductPage({super.key, required this.offer_id});

  @override
  Widget build(BuildContext context) {
    // Use Get.put with a unique tag to avoid conflicts
    final controller = Get.put(
      UserOfferProductController(offer_id),
      tag:offer_id.toString(), // ← Unique tag for each merchant
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Offer Products',style:AppTextStyle.rTextNunitoWhite17w700),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.kPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.productList.isEmpty) {
          return const Center(child: Text('No offer products found'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.productList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final product = controller.productList[index];

            return GestureDetector(onTap:(){

              Get.to(()=>UserOfferProductDetailScreen(offerProductId:product.id));
            },child:
              Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product.productImage,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '₹${product.originalPrice}',
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '₹${product.offerPrice}',
                              style: TextStyle(
                                color: AppColors.kPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ));
          },
        );
      }),
    );
  }
}