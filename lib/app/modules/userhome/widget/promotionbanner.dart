
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/promotionbanner_controller.dart';

class HomeCarouselSlider extends StatelessWidget {
  HomeCarouselSlider({super.key});

  final PromotionController promoController =
  Get.find<PromotionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (promoController.bannerImages.isEmpty) {
        return const SizedBox(
          height: 190,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: CarouselSlider.builder(
          itemCount: promoController.bannerImages.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = promoController.bannerImages[index];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 190,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.88, // 👈 KEY FIX (space on sides)
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            enableInfiniteScroll: true,
          ),
        ),
      );
    });
  }
}
