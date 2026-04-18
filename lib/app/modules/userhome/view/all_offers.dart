// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../controller/user_offer_controller.dart';
// import '../view/user_offerproductlistpage.dart';
//
// class AllOffersPage extends StatelessWidget {
//   AllOffersPage({super.key});
//
//   final UserOfferController controller =
//   Get.put(UserOfferController(), permanent: true);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("All Offers"),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         // 🔄 Loading
//         if (controller.isLoading.value) {
//           return GridView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: 6,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 16,
//               crossAxisSpacing: 16,
//               childAspectRatio: 0.75,
//             ),
//             itemBuilder: (_, __) => Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           );
//         }
//
//         // ❌ Empty
//         if (controller.offerList.isEmpty) {
//           return Center(
//             child: Text(
//               "No offers available",
//               style: TextStyle(color: Colors.grey.shade500),
//             ),
//           );
//         }
//
//         // ✅ Grid
//         return GridView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: controller.offerList.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisSpacing: 16,
//             crossAxisSpacing: 16,
//             childAspectRatio: 0.72,
//           ),
//           itemBuilder: (context, index) {
//             final offer = controller.offerList[index];
//
//             return GestureDetector(
//               onTap: () {
//                 Get.to(
//                       () => UserOfferProductPage(
//                       offer_id: offer.offerId.toString()),
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.kPrimary.withOpacity(0.1),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Stack(
//                     children: [
//                       // 🔳 Image
//                       Positioned.fill(
//                         child: Image.network(
//                           offer.image,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => Container(
//                             color: Colors.grey.shade200,
//                             child: const Icon(Icons.store),
//                           ),
//                         ),
//                       ),
//
//                       // 🌑 Gradient
//                       Positioned.fill(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.transparent,
//                                 Colors.black.withOpacity(0.7),
//                               ],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // 🔥 Discount
//                       Positioned(
//                         top: 10,
//                         left: 10,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.orange,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             "${double.parse(offer.discountPercentage.toString()).toInt()}% OFF",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // 📄 Bottom Content
//                       Positioned(
//                         left: 10,
//                         right: 10,
//                         bottom: 10,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               offer.shopName!,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 6),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Text(
//                                 "Shop Now",
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../controller/user_offer_controller.dart';
import '../view/user_offerproductlistpage.dart';

class AllOffersPage extends StatelessWidget {
  AllOffersPage({super.key});

  final UserOfferController controller =
  Get.put(UserOfferController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("All Offers",style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),),
      ),
      body: Obx(() {
        // 🔄 Loading
        if (controller.isLoading.value) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, __) => _ShimmerCard(),
          );
        }

        if (controller.offerList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_offer_outlined,
                    size: 52, color: Colors.grey[350]),
                const SizedBox(height: 12),
                Text(
                  "No offers available",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        // ✅ List
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.offerList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final offer = controller.offerList[index];
            return _OfferCard(offer: offer);
          },
        );
      }),
    );
  }
}

// ── Offer Card ────────────────────────────────────────────────────────────────

class _OfferCard extends StatelessWidget {
  final dynamic offer;

  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() =>
            UserOfferProductPage(offer_id: offer.offerId.toString()));
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimary.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // ── Full background image ──────────────────────────────
              Positioned.fill(
                child: Image.network(
                  offer.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(Icons.store_rounded,
                          size: 40, color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),

              // ── Dark gradient overlay ──────────────────────────────
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.72),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // ── Discount badge (top-left) ──────────────────────────
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${double.parse(offer.discountPercentage.toString()).toInt()}% OFF",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // ── Bottom content ─────────────────────────────────────
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Shop name + subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.shopName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Tap to explore offer products",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Shop Now button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Shop Now",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shimmer placeholder card ──────────────────────────────────────────────────

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}