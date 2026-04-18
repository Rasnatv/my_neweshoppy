
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshoppy/app/modules/userhome/view/user_shopabotus.dart';
import 'package:eshoppy/app/modules/userhome/view/user_viewmerchantgallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../product/widgtet/productcard.dart';
import '../controller/userproductshop_controller.dart';

class ShopDetailPage extends StatelessWidget {
  final int merchantId;

  ShopDetailPage({super.key, required this.merchantId});

  final UserShopProductController controller =
  Get.put(UserShopProductController());

  // ── Teal palette ───────────────────────────────────────────
  static const _teal      = Color(0xFF009688);
  static const _tealDark  = Color(0xFF00796B);
  static const _tealLight = Color(0xFFE0F2F1);
  static const _bg        = Color(0xFFF4F7F6);
  static const _textDark  = Color(0xFF1A2E2C);
  static const _textMid   = Color(0xFF546E6B);
  static const _textLight = Color(0xFF90AFAC);

  @override
  Widget build(BuildContext context) {
    controller.loadShop(merchantId);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: _bg,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // ── Sliver AppBar ────────────────────────────────
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: _teal,
                iconTheme: const IconThemeData(color: Colors.white),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),

                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    if (controller.isShopLoading.value) {
                      return Container(
                        color: _teal,
                        child: const Center(
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        ),
                      );
                    }

                    final shop = controller.shopDetail.value;
                    if (shop == null) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_teal, _tealDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      );
                    }

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // ── Cover image ────────────────────────
                        CachedNetworkImage(
                          imageUrl: shop.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: _teal,
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_teal, _tealDark],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Icon(Icons.store_rounded,
                                  size: 80,
                                  color: Colors.white.withOpacity(0.4)),
                            ),
                          ),
                        ),

                        // ── Gradient overlay ───────────────────
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black54,
                              ],
                              stops: [0.4, 1.0],
                            ),
                          ),
                        ),

                        // ── Shop info at bottom ────────────────
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Shop avatar
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Colors.white, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 12,
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: CachedNetworkImage(
                                    imageUrl: shop.image,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: _tealLight,
                                      child: const Center(
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: _teal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: _tealLight,
                                          child: const Icon(
                                              Icons.store_rounded,
                                              color: _teal,
                                              size: 32),
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Shop name + meta
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      shop.shopName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 6,
                                            color: Colors.black45,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              // ── Sticky Tab Bar ────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    labelColor: _teal,
                    unselectedLabelColor: const Color(0xFF90AFAC),
                    indicatorColor: _teal,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: const Color(0xFFECF2F1),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.grid_view_rounded, size: 15),
                            SizedBox(width: 5),
                            Text('Products'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_library_outlined, size: 15),
                            SizedBox(width: 5),
                            Text('Gallery'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline_rounded, size: 15),
                            SizedBox(width: 5),
                            Text('About'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },

          // ── Tab Body ────────────────────────────────────────
          body: TabBarView(
            children: [
              // ── Products Tab ─────────────────────────────────
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                            color: _teal, strokeWidth: 2.5),
                        SizedBox(height: 14),
                        Text(
                          'Loading products...',
                          style: TextStyle(
                              fontSize: 13, color: _textLight),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.products.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(28),
                            decoration: const BoxDecoration(
                              color: _tealLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                                Icons.shopping_bag_outlined,
                                size: 56,
                                color: _teal),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No Products Yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: _textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "This shop hasn't added any products.\nCheck back soon!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: _textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(14),
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

              // ── Gallery Tab ──────────────────────────────────
              UserMerchantGalleryViewPage(merchantId: merchantId),

              // ── About Tab ────────────────────────────────────
              MerchantAboutPage(merchantId: merchantId),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Status Badge widget
// ─────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sticky Tab Bar Delegate
// ─────────────────────────────────────────────

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}