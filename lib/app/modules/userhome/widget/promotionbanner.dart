import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/promotionbanner_controller.dart';

// class HomeCarouselSlider extends StatelessWidget {
//   HomeCarouselSlider({super.key});
//
//   final promoController = Get.put(PromotionController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (!promoController.hasBanners) {
//         return const SizedBox.shrink(); // HIDE IF NO BANNERS
//       }
//
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: CarouselSlider(
//           items: promoController.bannerImages.map((image) {
//             return ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.network(
//                 image,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             );
//           }).toList(),
//           options: CarouselOptions(
//             height: 180,
//             autoPlay: true,
//             enlargeCenterPage: true,
//             viewportFraction: 0.9,
//             autoPlayInterval: const Duration(seconds: 3),
//             autoPlayAnimationDuration: const Duration(milliseconds: 800),
//           ),
//         ),
//       );
//     });
//   }
// }
class HomeCarouselSlider extends StatelessWidget {
  HomeCarouselSlider({super.key});

  final promoController = Get.put(PromotionController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!promoController.hasBanners) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CarouselSlider(
          items: promoController.bannerImages.map((image) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
          ),
        ),
      );
    });
  }
}
