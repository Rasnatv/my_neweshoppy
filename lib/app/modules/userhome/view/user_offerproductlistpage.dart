//
// import 'package:eshoppy/app/modules/userhome/view/user_offerproductdetail.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// import '../../../common/style/app_colors.dart';
// import '../../../common/style/app_text_style.dart';
// import '../controller/userofferproduct_controller.dart';
//
// class UserOfferProductPage extends StatelessWidget {
//   final String offer_id;
//
//   const UserOfferProductPage({super.key, required this.offer_id});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       UserOfferProductController(offer_id),
//       tag: offer_id.toString(),
//     );
//
//     final token = GetStorage().read('auth_token') ?? '';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Offer Products',
//           style: AppTextStyle.rTextNunitoWhite17w700,
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: AppColors.kPrimary,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                 const SizedBox(height: 12),
//                 Text(controller.errorMessage.value),
//                 const SizedBox(height: 12),
//                 ElevatedButton(
//                   onPressed: controller.fetchOfferProducts,
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (controller.productList.isEmpty) {
//           return const Center(child: Text('No offer products found'));
//         }
//
//         return GridView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: controller.productList.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 0.65,
//             crossAxisSpacing: 14,
//             mainAxisSpacing: 14,
//           ),
//           itemBuilder: (context, index) {
//             final product = controller.productList[index];
//
//             return GestureDetector(
//               onTap: () {
//                 Get.to(() => UserOfferProductDetailScreen(
//                   offerProductId: product.id,
//                 ));
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 8,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Stack(
//                         children: [
//                           // Product Image
//                           ClipRRect(
//                             borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(16),
//                             ),
//                             child: Image.network(
//                               product.productImage,
//                               width: double.infinity,
//                               height: double.infinity,
//                               fit: BoxFit.cover,
//                               headers: {
//                                 'Authorization': 'Bearer $token',
//                               },
//                               loadingBuilder: (context, child, progress) {
//                                 if (progress == null) return child;
//                                 return const SizedBox(
//                                   child: Center(
//                                     child: CircularProgressIndicator(),
//                                   ),
//                                 );
//                               },
//                               errorBuilder: (_, __, ___) => const SizedBox(
//                                 child: Center(
//                                   child: Icon(Icons.broken_image, size: 50),
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           // ✅ Wishlist Heart Button — type: 1 for offer product
//                           Positioned(
//                             top: 8,
//                             right: 8,
//                             child: Obx(() {
//                               final isFav = controller.wishlistController
//                                   .isInWishlist(product.id);
//                               return GestureDetector(
//                                 onTap: () =>
//                                     controller.wishlistController.toggleWishlist(
//                                       product.id,
//                                       type: product.type, // ✅ use type from model (should be 1 for offer)
//                                     ),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.1),
//                                         blurRadius: 8,
//                                         offset: const Offset(0, 2),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Icon(
//                                     isFav
//                                         ? Icons.favorite
//                                         : Icons.favorite_border,
//                                     color:
//                                     isFav ? Colors.red : Colors.grey[600],
//                                     size: 20,
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Product Details
//                     Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             product.productName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//
//                           Row(
//                             children: [
//                               Text(
//                                 '₹${double.tryParse(product.originalPrice)?.round() ?? 0}',
//                                 style: const TextStyle(
//                                   color: Colors.grey,
//                                   decoration: TextDecoration.lineThrough,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 '₹${double.tryParse(product.offerPrice)?.round() ?? 0}',
//                                 style: TextStyle(
//                                   color: AppColors.kPrimary,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(height: 6),
//
//                           _buildDiscountBadge(
//                             product.originalPrice,
//                             product.offerPrice,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
//
//   Widget _buildDiscountBadge(String original, String offer) {
//     final orig = double.tryParse(original);
//     final off = double.tryParse(offer);
//     if (orig == null || off == null || orig <= 0) return const SizedBox();
//     final discount = (((orig - off) / orig) * 100).round();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: Colors.green.shade100,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         '$discount% OFF',
//         style: const TextStyle(
//           color: Colors.green,
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
import 'package:eshoppy/app/modules/userhome/view/user_offerproductdetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/userofferproduct_controller.dart';

class UserOfferProductPage extends StatelessWidget {
  final String offer_id;

  const UserOfferProductPage({super.key, required this.offer_id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      UserOfferProductController(offer_id),
      tag: offer_id.toString(),
    );

    final token = GetStorage().read('auth_token') ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offer Products',
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.kPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(controller.errorMessage.value),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.fetchOfferProducts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.productList.isEmpty) {
          return const Center(child: Text('No offer products found'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.productList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final product = controller.productList[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => UserOfferProductDetailScreen(
                  offerProductId: product.id,
                ));
              },
              child: Container(
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
                    Expanded(
                      child: Stack(
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              product.productImage,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              headers: {
                                'Authorization': 'Bearer $token',
                              },
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const SizedBox(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => const SizedBox(
                                child: Center(
                                  child: Icon(Icons.broken_image, size: 50),
                                ),
                              ),
                            ),
                          ),

                          // ✅ Discount Badge — top LEFT of image
                          Positioned(
                            top: 8,
                            left: 8,
                            child: _buildDiscountBadgeOverlay(
                              product.originalPrice,
                              product.offerPrice,
                            ),
                          ),

                          // Wishlist Heart Button — top RIGHT
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Obx(() {
                              final isFav = controller.wishlistController
                                  .isInWishlist(product.id);
                              return GestureDetector(
                                onTap: () => controller.wishlistController
                                    .toggleWishlist(
                                  product.id,
                                  type: product.type,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                    isFav ? Colors.red : Colors.grey[600],
                                    size: 20,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    // Product Details
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
                                '₹${double.tryParse(product.originalPrice)?.round() ?? 0}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹${double.tryParse(product.offerPrice)?.round() ?? 0}',
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
              ),
            );
          },
        );
      }),
    );
  }

  /// ✅ Overlay badge shown on top-left of product image
  Widget _buildDiscountBadgeOverlay(String original, String offer) {
    final orig = double.tryParse(original);
    final off = double.tryParse(offer);
    if (orig == null || off == null || orig <= 0 || off >= orig) {
      return const SizedBox.shrink();
    }
    final discount = (((orig - off) / orig) * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$discount% OFF',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}