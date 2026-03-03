import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/common/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/merchant_gallerymode.dart';
import '../controller/userview_galleryimagecontroller.dart';


class UserMerchantGalleryViewPage extends StatelessWidget {
  final int merchantId;

  const UserMerchantGalleryViewPage({super.key, required this.merchantId});

  @override
  Widget build(BuildContext context) {
    final MerchantGalleryViewController controller = Get.put(
      MerchantGalleryViewController(merchantId: merchantId),
      tag: merchantId.toString(),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        // ========== LOADING ==========
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ========== EMPTY ==========
        if (controller.images.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library_outlined,
                    size: 72, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No Images Found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "This merchant hasn't uploaded any images yet.",
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        // ========== GRID ==========
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, i) {
            final MerchantImage image = controller.images[i];

            return GestureDetector(
              onTap: () => _openFullscreen(context, controller.images, i),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.red),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ========== FULLSCREEN VIEWER ==========
  void _openFullscreen(
      BuildContext context, List<MerchantImage> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenGallery(
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

// ========== FULLSCREEN GALLERY WIDGET ==========
class _FullscreenGallery extends StatefulWidget {
  final List<MerchantImage> images;
  final int initialIndex;

  const _FullscreenGallery(
      {required this.images, required this.initialIndex});

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "${_currentIndex + 1} / ${widget.images.length}",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemBuilder: (_, i) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                widget.images[i].imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  color: Colors.red,
                  size: 60,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}