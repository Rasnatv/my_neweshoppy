
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homedatacontroller.dart';

class HomeCarouselSlider extends StatelessWidget {
  HomeCarouselSlider({super.key});

  final HomeDataController controller = Get.find<HomeDataController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.advertisements.isEmpty) {
        return _buildLoader(context);
      }
      if (controller.advertisements.isEmpty) {
        return _buildEmpty();
      }
      return CarouselSlider.builder(
        itemCount: controller.advertisements.length,
        itemBuilder: (context, index, realIndex) {
          final ad = controller.advertisements[index];
          return _AdBannerCard(ad: ad);
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

  Widget _buildLoader(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20),
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

  Widget _buildEmpty() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 38, color: Colors.grey[350]),
            const SizedBox(height: 8),
            Text(
              "Select a location to see offers",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tap the location bar above to get started",
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdBannerCard extends StatelessWidget {
  final HomeAdModel ad;

  const _AdBannerCard({required this.ad});

  @override
  Widget build(BuildContext context) {
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
            Image.network(
              ad.bannerImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.image_not_supported_rounded,
                      size: 48, color: Colors.grey[400]),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}