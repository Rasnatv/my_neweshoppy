
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_text_style.dart';
import '../../../data/models/merchant_gallerymode.dart';

import '../../../widgets/delete_widget.dart';
import '../../../widgets/networkconnection_checkpage.dart';
import 'merchant_gallerycontroller.dart';

class MerchantGalleryPage extends StatelessWidget {
  MerchantGalleryPage({super.key});

  final MerchantGalleryController controller =
  Get.put(MerchantGalleryController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: AppColors.kPrimary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Merchant Gallery",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          elevation: 0,
        ),
        body: Obx(() {
          return Column(
            children: [
              /// ================= UPLOAD CARD =================
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upload Images",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),

                    /// SELECTED IMAGE PREVIEW
                    if (controller.selectedImages.isNotEmpty)
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.selectedImages.length,
                          itemBuilder: (_, i) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      controller.selectedImages[i],
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => controller.removeSelectedImage(i),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black54,
                                      child: Icon(Icons.close,
                                          size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.photo_library),
                            label: const Text("Select"),
                            onPressed: controller.pickImages,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: controller.isUploading.value
                              ? const Center(
                            child: CircularProgressIndicator(),
                          )
                              : ElevatedButton.icon(
                            icon: const Icon(Icons.upload),
                            label: const Text("Upload"),
                            onPressed: controller.uploadImages,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// ================= GALLERY HEADER =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Gallery (${controller.uploadedImages.length})",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: controller.loadGallery,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              /// ================= IMAGE GRID =================
              Expanded(
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.uploadedImages.isEmpty
                    ? const Center(
                  child: Text(
                    "No images uploaded",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.uploadedImages.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (_, i) {
                    final MerchantImage image =
                    controller.uploadedImages[i];

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            image.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder:
                                (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              );
                            },
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image,
                                color: Colors.red),
                          ),
                        ),

                        /// ===== DELETE BUTTON =====
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Obx(
                                () => GestureDetector(
                              onTap: controller.deletingIndex.value == i
                                  ? null
                                  : () => DeleteConfirmDialog.show(
                                context: context,
                                title: 'Delete image?',
                                message:
                                'This will permanently remove the image.',
                                onConfirm: () =>
                                    controller.deleteImage(i),
                              ),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black54,
                                child: controller.deletingIndex.value == i
                                    ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Icon(
                                  Icons.delete,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}