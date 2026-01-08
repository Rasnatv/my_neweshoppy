// import 'package:flutter/material.dart';
//
// import '../../../../common/constants/app_images.dart';
// import '../../../../common/style/app_colors.dart';
// import '../../../../common/style/app_text_style.dart';
// class Offerss {
//   final String offerName;
//   final String offerType;
//   final String image;
//   final List<OfferProductss> products;
//
//   Offerss({
//     required this.offerName,
//     required this.offerType,
//     required this.image,
//     required this.products,
//   });
// }
//
// class OfferProductss {
//   final String name;
//   final double price;
//   final String image;
//
//   OfferProductss({
//     required this.name,
//     required this.price,
//     required this.image,
//   });
// }
//
//
// class AdminMerchantofferspage extends StatelessWidget {
//   const AdminMerchantofferspage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     /// Dummy Offer Data
//     final List<Offerss> offers = [
//       Offerss(
//         offerName: "New Year Offer",
//         offerType: "Flat 20% OFF",
//         image: AppImages.banner1,
//         products: [
//           OfferProductss(
//               name: "Burger", price: 150, image: AppImages.prduct2),
//           OfferProductss(
//               name: "Pizza", price: 250, image: AppImages.prduct2),
//         ],
//       ),
//       Offerss(
//         offerName: "Festival Combo",
//         offerType: "Buy 1 Get 1",
//         image: AppImages.banner1,
//         products: [
//           OfferProductss(
//               name: "Coffee", price: 50, image: AppImages.prduct2),
//           OfferProductss(name: "Tea", price: 30, image: AppImages.prduct2),
//         ],
//       ),
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Merchant Offers",
//           style: AppTextStyle.rTextNunitoWhite17w700,
//         ),
//         backgroundColor: AppColors.kPrimary,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: offers.length,
//         itemBuilder: (context, index) {
//           final offer = offers[index];
//
//           return Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// OFFER IMAGE
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.asset(
//                       offer.image,
//                       height: 150,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   /// OFFER NAME
//                   Text(
//                     offer.offerName,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   /// OFFER TYPE
//                   Text(
//                     offer.offerType,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: AppColors.kPrimary,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//
//                   const Divider(height: 24),
//
//                   /// PRODUCTS UNDER OFFER
//                   Text(
//                     "Products in this offer",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   ListView.builder(
//                     itemCount: offer.products.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, pIndex) {
//                       final product = offer.products[pIndex];
//
//                       return ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         leading: Image.asset(
//                           product.image,
//                           width: 40,
//                         ),
//                         title: Text(product.name),
//                         subtitle: Text("₹ ${product.price}"),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/constants/app_images.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';

/// ---------------- MODELS ----------------
class Offer {
  final String offerName;
  final String offerType;
  final String image;
  final List<OfferProduct> products;

  Offer({
    required this.offerName,
    required this.offerType,
    required this.image,
    required this.products,
  });
}

class OfferProduct {
  final String name;
  final double price;
  final String image;

  OfferProduct({
    required this.name,
    required this.price,
    required this.image,
  });
}

/// ---------------- CONTROLLER ----------------
class AdminOfferController extends GetxController {
  final offers = <Offer>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyOffers();
  }

  void loadDummyOffers() {
    offers.assignAll([
      Offer(
        offerName: "New Year Offer",
        offerType: "Flat Discount offer",
        image: AppImages.banner1,
        products: [
          OfferProduct(
              name: "Burger", price: 150, image: AppImages.prduct2),
          OfferProduct(
              name: "Pizza", price: 250, image: AppImages.prduct2),
        ],
      ),
      Offer(
        offerName: "Festival Combo",
        offerType: "Buy 1 Get 1",
        image: AppImages.banner1,
        products: [
          OfferProduct(
              name: "Coffee", price: 50, image: AppImages.prduct2),
          OfferProduct(name: "Tea", price: 30, image: AppImages.prduct2),
        ],
      ),
    ]);
  }

  void deleteOffer(int index) {
    offers.removeAt(index);
  }
}

/// ---------------- PAGE ----------------
class AdminMerchantofferspage extends StatelessWidget {
  AdminMerchantofferspage({super.key});

  final AdminOfferController controller =
  Get.put(AdminOfferController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Merchant Offers",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
      ),
      body: Obx(() {
        if (controller.offers.isEmpty) {
          return const Center(child: Text("No offers available"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.offers.length,
          itemBuilder: (context, index) {
            final offer = controller.offers[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// OFFER IMAGE + DELETE ICON
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            offer.image,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.white),
                              onPressed: () {
                                _showDeleteDialog(context, index);
                              },
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// OFFER NAME
                    Text(
                      offer.offerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// OFFER TYPE
                    Text(
                      offer.offerType,
                      style: TextStyle(
                        color: AppColors.kPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Divider(height: 24),

                    /// PRODUCTS
                    Text(
                      "Products in this offer",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    ListView.builder(
                      itemCount: offer.products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, pIndex) {
                        final product = offer.products[pIndex];

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(product.image, width: 40),
                          title: Text(product.name),
                          subtitle: Text("₹ ${product.price}"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// ---------------- DELETE CONFIRMATION ----------------
  void _showDeleteDialog(BuildContext context, int index) {
    Get.defaultDialog(
      title: "Delete Offer",
      middleText: "Are you sure you want to delete this offer?",
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.kPrimary,
      onConfirm: () {
        controller.deleteOffer(index);
        Get.back();
      },
    );
  }
}
