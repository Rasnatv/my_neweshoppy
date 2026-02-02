import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/gallery_controller.dart';
class GalleryTabPage extends StatelessWidget {
  final String restaurantId;

  const GalleryTabPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final GalleryController controller =
    Get.put(GalleryController(restaurantId: restaurantId));

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        );
      }

      if (controller.additionalImages.isEmpty) {
        return const Center(
          child: Text(
            "No gallery images available",
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.additionalImages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              controller.additionalImages[index],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, size: 40),
              ),
            ),
          );
        },
      );
    });
  }
}
