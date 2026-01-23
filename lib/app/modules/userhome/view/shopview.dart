
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../product/widgtet/productcard.dart';
import '../controller/userproductshop_controller.dart';

class ShopDetailPage extends StatelessWidget {
  final int merchantId;

  ShopDetailPage({super.key, required this.merchantId});

  final UserShopProductController controller =
  Get.put(UserShopProductController());

  @override
  Widget build(BuildContext context) {
    controller.loadShop(merchantId);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [

            /// 🔥 SHOP HEADER
            Obx(() {
              if (controller.isShopLoading.value) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final shop = controller.shopDetail.value;
              if (shop == null) return const SizedBox();

              return SizedBox(
                height: 220,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      shop.image,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 20,
                      child: Text(
                        shop.shopName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 8,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ],
                ),
              );
            }),

            /// 🔥 TAB BAR
            const TabBar(
              tabs: [
                Tab(text: 'PRODUCT'),
                Tab(text: 'GALLERY'),
                Tab(text: 'ABOUT'),
              ],
            ),

            /// 🔥 TAB CONTENT
            Expanded(
              child: TabBarView(
                children: [

                  /// PRODUCTS
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.products.isEmpty) {
                      return const Center(child: Text("No products available"));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: controller.products.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final product = controller.products[index];
                        return ProductCard(
                          productName: product.productName,
                          imageUrl: product.image,
                          price: product.price,
                          productId: product.productId,
                        );
                      },
                    );
                  }),

                  /// GALLERY
                  const Center(child: Text("Gallery coming soon")),

                  /// ABOUT
                  const Center(child: Text("About shop")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
