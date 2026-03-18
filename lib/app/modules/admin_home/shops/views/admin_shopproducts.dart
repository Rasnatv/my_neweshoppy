
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../data/models/admin_shopproductmodel.dart';
import '../controller/adminshop_productcontroller.dart';
import 'admin_productdetailsscreen.dart';

class ShopProductPage extends StatelessWidget {
  ShopProductPage({super.key});

  // Controller reads shop_id from Get.arguments in onInit automatically
  final ShopProductController controller = Get.put(ShopProductController());

  static const Color _teal          = Color(0xFF00897B);
  static const Color _bg            = Color(0xFFF5F6FA);
  static const Color _card          = Colors.white;
  static const Color _textPrimary   = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _border        = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: _teal,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "Shop Products",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            Obx(() => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: controller.products.isEmpty
                  ? const SizedBox()
                  : Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${controller.products.length} items",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )),
          ],
        ),
        body: Obx(() {
          // ── Loading ──
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                      color: _teal, strokeWidth: 2.5),
                  const SizedBox(height: 14),
                  Text(
                    "Loading products…",
                    style: TextStyle(
                        fontSize: 13, color: _textSecondary),
                  ),
                ],
              ),
            );
          }

          // ── Empty State ──
          if (controller.products.isEmpty) {
            return _buildEmptyState();
          }

          // ── Grid ──
          return RefreshIndicator(
            color: _teal,
            backgroundColor: Colors.white,
            onRefresh: () async {
              final args = Get.arguments;
              if (args != null && args['shop_id'] != null) {
                await controller.fetchProducts(args['shop_id']);
              }
            },
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return GestureDetector(onTap: ()=>Get.to(()=> AdminProductDetailScreen(),
                  arguments: {'product_id': product.id},
                ),child:
                  _buildProductCard(product, index));
              },
            ),
          );
        }),
      ),
    );
  }

  // ── PRODUCT CARD (Grid) ───────────────────────────────────────────────────
  Widget _buildProductCard(ShopProduct product, int index) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Image ─────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 150,
                      color: const Color(0xFFECEFF4),
                      child: const Center(
                        child: CircularProgressIndicator(
                            color: _teal, strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Color(0xFFECEFF4),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported_outlined,
                            size: 32, color: Colors.grey[400]),
                        const SizedBox(height: 4),
                        Text(
                          "No image",
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ── Product ID Badge ──────────────────────────────
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "#${product.id}",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // ── Variants Badge ────────────────────────────────
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: _teal.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.layers_outlined,
                          size: 10, color: Colors.white),
                      const SizedBox(width: 3),
                      Text(
                        "${product.variantsCount}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Product Details ───────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Name
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Price + Variants Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _teal.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "₹${product.price}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _teal,
                          ),
                        ),
                      ),
                      Text(
                        "${product.variantsCount} var${product.variantsCount == 1 ? '' : 's'}",
                        style: TextStyle(
                          fontSize: 11,
                          color: _textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── EMPTY STATE ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: _teal.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inventory_2_outlined,
                  size: 40, color: _teal.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),
            const Text(
              "No Products Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "This shop doesn't have any\nproducts listed yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: _textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}