
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../product/controller/whishlistcontroller.dart';
import '../../product/view/prodductdetailscreen.dart';
import '../../userhome/view/user_offerproductdetail.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({super.key});

  final WishlistController controller =
  Get.isRegistered<WishlistController>()
      ? Get.find<WishlistController>()
      : Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kPrimary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Wishlist",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.wishlist.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Your wishlist is empty",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: controller.wishlist.length,
            itemBuilder: (context, index) {
              final item = controller.wishlist[index];
              return _WishlistProductCard(
                item: item,
                wishlistController: controller,
              );
            },
          );
        }),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// Card widget — handles both type 0 and type 1
/// ─────────────────────────────────────────────
class _WishlistProductCard extends StatelessWidget {
  final dynamic item; // WishlistItem
  final WishlistController wishlistController;

  const _WishlistProductCard({
    required this.item,
    required this.wishlistController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.type == 1) {
          Get.to(() => UserOfferProductDetailScreen(offerProductId: item.productId));
        } else {
          Get.to(() => ProductDetailPage(productId: item.productId));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + Badges + Heart ──
            Expanded(
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      item.image ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[100],
                        child: Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              size: 40, color: Colors.grey[400]),
                        ),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.kPrimary,
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),

                  // 🏷️ Offer badge — top left, only for type 1
                  if (item.type == 1)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildOfferBadge(
                          item.originalPrice, item.offerPrice),
                    ),

                  // ❤️ Wishlist toggle — top right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(() {
                      final isFav =
                      wishlistController.isInWishlist(item.productId);
                      return GestureDetector(
                        onTap: () => wishlistController.toggleWishlist(
                          item.productId,
                          type: item.type,
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
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // ── Product Info ──
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ✅ Price row — same row for both types
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Strikethrough original price — only for type 1
                      if (item.type == 1) ...[
                        Text(
                          "₹${_formatPrice(item.originalPrice ?? '0')}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],

                      // ✅ Main price — offer price for type 1, normal price for type 0
                      Text(
                        "₹${_formatPrice(item.price)}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.green[700],
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
  }

  /// Removes trailing .00 — e.g. "745.00" → "745", "275.50" → "275.50"
  String _formatPrice(String raw) {
    final parsed = double.tryParse(raw);
    if (parsed == null) return raw;
    return parsed % 1 == 0
        ? parsed.toInt().toString()
        : parsed.toStringAsFixed(2);
  }

  Widget _buildOfferBadge(String? original, String? offer) {
    final orig = double.tryParse(original ?? '');
    final off = double.tryParse(offer ?? '');
    if (orig == null || off == null || orig <= 0) return const SizedBox();
    final discount = (((orig - off) / orig) * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$discount% OFF',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}