//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controller/promotionbanner_controller.dart';
//
// class HomeCarouselSlider extends StatelessWidget {
//   HomeCarouselSlider({super.key});
//
//   final PromotionController promoController =
//   Get.find<PromotionController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (promoController.bannerImages.isEmpty) {
//         return const SizedBox(
//           height: 190,
//           child: Center(child: CircularProgressIndicator()),
//         );
//       }
//
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: CarouselSlider.builder(
//           itemCount: promoController.bannerImages.length,
//           itemBuilder: (context, index, realIndex) {
//             final imageUrl = promoController.bannerImages[index];
//
//             return Container(
//               margin: const EdgeInsets.symmetric(horizontal: 6),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(18),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return const Center(
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//           options: CarouselOptions(
//             height: 190,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 3),
//             autoPlayAnimationDuration: const Duration(milliseconds: 800),
//             viewportFraction: 0.88, // 👈 KEY FIX (space on sides)
//             enlargeCenterPage: true,
//             enlargeFactor: 0.15,
//             enableInfiniteScroll: true,
//           ),
//         ),
//       );
//     });
//   }
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/promotionbanner_controller.dart';

class HomeCarouselSlider extends StatelessWidget {
  HomeCarouselSlider({super.key});

  final PromotionController promoController = Get.find<PromotionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (promoController.bannerImages.isEmpty) {
        return Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      }

      return CarouselSlider.builder(
        itemCount: promoController.bannerImages.length,
        itemBuilder: (context, index, realIndex) {
          final imageUrl = promoController.bannerImages[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Image
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[100],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),

                  // Subtle gradient overlay for better readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 180,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.easeInOutCubic,
          viewportFraction: 0.90,
          enlargeCenterPage: true,
          enlargeFactor: 0.12,
          enableInfiniteScroll: true,
          pauseAutoPlayOnTouch: true,
        ),
      );
    });
  }
}
