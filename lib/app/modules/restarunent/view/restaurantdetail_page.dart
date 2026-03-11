//
// import 'package:eshoppy/app/modules/restarunent/view/user_resaturantgallery.dart';
// import 'package:eshoppy/app/modules/restarunent/view/user_restaurantabouttab.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../../data/models/userrestaurantmodel.dart';
// import '../controller/gallery_controller.dart';
// import '../controller/restaurantcartcontroller.dart';
// import 'menu_tab.dart';
// import 'restaurantcartpage.dart';
//
// // ── Premium Palette ────────────────────────────────────────────────────────
// class _P {
//   static const bg          = Color(0xFFF5F0EB);
//   static const appBar      = Color(0xFF0F5151);
//   static const appBarLight = Color(0xFF701221);
//   static const gold        = Color(0xFFC9A96E);
//   static const goldLight   = Color(0xFFE8D5A3);
//   static const text        = Color(0xFF1C1008);
//   static const textSub     = Color(0xFF7A7169);
//   static const cardBg      = Color(0xFFFFFFFF);
//   static const border      = Color(0xFFEAE2D6);
// }
//
// class RestaurantDetailPage extends StatefulWidget {
//   final Restaurant restaurant;
//   const RestaurantDetailPage({super.key, required this.restaurant});
//
//   @override
//   State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
// }
//
// class _RestaurantDetailPageState extends State<RestaurantDetailPage>
//     with SingleTickerProviderStateMixin {
//   late TabController tabController;
//   late GalleryController galleryController;
//
//   Restaurantcartcontroller get cartController {
//     if (Get.isRegistered<Restaurantcartcontroller>()) {
//       return Get.find<Restaurantcartcontroller>();
//     }
//     return Get.put(Restaurantcartcontroller(), permanent: true);
//   }
//
//   int get rid => int.tryParse(widget.restaurant.restaurantId) ?? 0;
//   String get ridStr => widget.restaurant.restaurantId;
//
//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 3, vsync: this);
//     galleryController = Get.put(
//       GalleryController(restaurantId: ridStr),
//       tag: ridStr,
//     );
//     cartController.setRestaurant(rid);
//
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _P.bg,
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 320,
//               floating: false,
//               pinned: true,
//               elevation: 0,
//               backgroundColor: _P.appBar,
//
//               // ── BACK BUTTON ──────────────────────────────────────────────
//               leading: Padding(
//                 padding: const EdgeInsets.all(9),
//                 child: _GlassActionButton(
//                   icon: Icons.arrow_back_ios_new_rounded,
//                   onTap: () => Get.back(),
//                 ),
//               ),
//
//               // ── CART BUTTON ──────────────────────────────────────────────
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.all(9),
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       _GlassActionButton(
//                         icon: Icons.shopping_bag_outlined,
//                         onTap: () => Get.to(
//                                 () => RestaurantCartPage(restaurantId: rid)),
//                       ),
//                       Obx(() {
//                         final count =
//                         cartController.totalItemsForRestaurant(rid);
//                         if (count == 0) return const SizedBox();
//                         return Positioned(
//                           right: -2,
//                           top: -2,
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [_P.gold, _P.goldLight],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                   color: Colors.white, width: 1.5),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: _P.gold.withOpacity(0.45),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             constraints: const BoxConstraints(
//                                 minWidth: 18, minHeight: 18),
//                             child: Text(
//                               count > 99 ? '99+' : '$count',
//                               style: const TextStyle(
//                                 color: Color(0xFF3A0A10),
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w900,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//               ],
//
//               // Pinned gold separator line
//               bottom: PreferredSize(
//                 preferredSize: const Size.fromHeight(1),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 250),
//                   height: innerBoxIsScrolled ? 1.5 : 0,
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.transparent,
//                         _P.gold,
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // ── HERO IMAGE ─────────────────────────────────────────────
//               flexibleSpace: FlexibleSpaceBar(
//                 collapseMode: CollapseMode.parallax,
//                 background: Obx(() {
//                   if (galleryController.isLoading.value) {
//                     return Container(
//                       color: _P.appBar,
//                       child: const Center(
//                         child: CircularProgressIndicator(
//                             color: _P.gold, strokeWidth: 2),
//                       ),
//                     );
//                   }
//                   if (galleryController.restaurantImage.isEmpty) {
//                     return _HeroPlaceholder();
//                   }
//                   return _HeroImage(
//                     imageUrl: galleryController.restaurantImage.value,
//                     name: widget.restaurant.name,
//                     address: widget.restaurant.address,
//                   );
//                 }),
//               ),
//             ),
//           ];
//         },
//
//         body: Column(
//           children: [
//             // ── PREMIUM TAB BAR ───────────────────────────────────────────
//             _PremiumTabBar(controller: tabController),
//
//             // ── TAB VIEWS ────────────────────────────────────────────────
//             Expanded(
//               child: TabBarView(
//                 controller: tabController,
//                 children: [
//                   RestaurantMenuTab(restaurantId: ridStr),
//                   RestaurantAboutTab(restaurantId: ridStr),
//                   GalleryTabPage(restaurantId: ridStr),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Hero Image
// // ─────────────────────────────────────────────────────────────────────────────
// class _HeroImage extends StatelessWidget {
//   final String imageUrl;
//   final String name;
//   final String address;
//
//   const _HeroImage({
//     required this.imageUrl,
//     required this.name,
//     required this.address,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Image.network(
//           imageUrl,
//           fit: BoxFit.cover,
//           errorBuilder: (_, __, ___) => _HeroPlaceholder(),
//         ),
//
//         // Deep layered gradient overlay
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.black.withOpacity(0.22),
//                 Colors.transparent,
//                 Colors.black.withOpacity(0.25),
//                 _P.appBar.withOpacity(0.94),
//               ],
//               stops: const [0.0, 0.3, 0.58, 1.0],
//             ),
//           ),
//         ),
//
//         // Bottom info section
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Gold decorative accent
//                 Row(
//                   children: [
//                     Container(
//                       width: 30,
//                       height: 2.5,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                             colors: [_P.gold, _P.goldLight]),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                     const SizedBox(width: 7),
//                     Container(
//                       width: 5,
//                       height: 5,
//                       decoration: const BoxDecoration(
//                         color: _P.gold,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 11),
//
//                 // Restaurant name
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 27,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                     letterSpacing: -0.7,
//                     height: 1.1,
//                     shadows: [
//                       Shadow(
//                         color: Colors.black45,
//                         offset: Offset(0, 2),
//                         blurRadius: 12,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 11),
//
//                 // Address pill badge
//                 IntrinsicWidth(
//                   child: Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.28),
//                       borderRadius: BorderRadius.circular(24),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.18), width: 1),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.location_on_rounded,
//                             color: _P.gold, size: 13),
//                         const SizedBox(width: 5),
//                         Flexible(
//                           child: Text(
//                             address,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.white.withOpacity(0.9),
//                               letterSpacing: 0.1,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Hero Placeholder
// // ─────────────────────────────────────────────────────────────────────────────
// class _HeroPlaceholder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [_P.appBar, _P.appBarLight],
//         ),
//       ),
//       child: Center(
//         child: Icon(Icons.restaurant,
//             size: 64, color: _P.gold.withOpacity(0.3)),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Premium Tab Bar with custom gold indicator
// // ─────────────────────────────────────────────────────────────────────────────
// class _PremiumTabBar extends StatelessWidget {
//   final TabController controller;
//   const _PremiumTabBar({required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _P.cardBg,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.07),
//             blurRadius: 14,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           TabBar(
//             controller: controller,
//             labelColor: _P.appBar,
//             unselectedLabelColor: _P.textSub,
//             indicatorSize: TabBarIndicatorSize.tab,
//             dividerColor: Colors.transparent,
//             indicator: const _GoldTabIndicator(),
//             labelStyle: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.2,
//             ),
//             unselectedLabelStyle: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//             tabs: const [
//               _PremiumTab(icon: Icons.restaurant_menu_rounded, label: "Menu"),
//               _PremiumTab(icon: Icons.info_outline_rounded, label: "About"),
//               _PremiumTab(icon: Icons.photo_library_outlined, label: "Gallery"),
//             ],
//           ),
//           Container(
//             height: 1,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   _P.border,
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _PremiumTab extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _PremiumTab({required this.icon, required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Tab(
//       height: 58,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 20),
//           const SizedBox(height: 4),
//           Text(label),
//         ],
//       ),
//     );
//   }
// }
//
// // Custom gold gradient tab indicator with rounded ends
// class _GoldTabIndicator extends Decoration {
//   const _GoldTabIndicator();
//
//   @override
//   BoxPainter createBoxPainter([VoidCallback? onChanged]) {
//     return _GoldTabPainter();
//   }
// }
//
// class _GoldTabPainter extends BoxPainter {
//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
//     final rect = offset & configuration.size!;
//     const barHeight = 3.0;
//     const hPad = 22.0;
//     final barRect = Rect.fromLTWH(
//       rect.left + hPad,
//       rect.bottom - barHeight,
//       rect.width - hPad * 2,
//       barHeight,
//     );
//
//     final paint = Paint()
//       ..shader = LinearGradient(
//         colors: [
//           _P.gold.withOpacity(0.7),
//           _P.gold,
//           _P.goldLight,
//           _P.gold,
//           _P.gold.withOpacity(0.7),
//         ],
//       ).createShader(barRect)
//       ..style = PaintingStyle.fill;
//
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(barRect, const Radius.circular(3)),
//       paint,
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Glass Action Button
// // ─────────────────────────────────────────────────────────────────────────────
// class _GlassActionButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//
//   const _GlassActionButton({
//     required this.icon,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 38,
//         height: 38,
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.92),
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 14,
//               offset: const Offset(0, 3),
//               spreadRadius: -2,
//             ),
//           ],
//         ),
//         child: Icon(icon, color: _P.appBar, size: 17),
//       ),
//     );
//   }
// }
import 'package:eshoppy/app/modules/restarunent/view/user_resaturantgallery.dart';
import 'package:eshoppy/app/modules/restarunent/view/user_restaurantabouttab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/userrestaurantmodel.dart';
import '../controller/gallery_controller.dart';
import '../controller/restaurantcartcontroller.dart';
import 'menu_tab.dart';
import 'restaurantcartpage.dart';

// ── Design System ─────────────────────────────────────────────────────────────
class _D {
  // Core palette — deep forest green + warm cream
  static const dark        = Color(0xFF0F5151);
  static const darkMid     = Color(0xFF163028);
  static const accent      = Color(0xFFE8B86D);   // warm amber
  static const accentDim   = Color(0xFFF5DFA8);
  static const surface     = Color(0xFFFAF8F4);
  static const surfaceCard = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF12211C);
  static const textSub     = Color(0xFF7E8E88);
  static const divider     = Color(0xFFECE8E1);

  static const shadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, 6)),
  ];
}

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late GalleryController galleryController;

  Restaurantcartcontroller get cartController {
    if (Get.isRegistered<Restaurantcartcontroller>()) {
      return Get.find<Restaurantcartcontroller>();
    }
    return Get.put(Restaurantcartcontroller(), permanent: true);
  }

  int get rid => int.tryParse(widget.restaurant.restaurantId) ?? 0;
  String get ridStr => widget.restaurant.restaurantId;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    galleryController = Get.put(
      GalleryController(restaurantId: ridStr),
      tag: ridStr,
    );
    cartController.setRestaurant(rid);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _D.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 340,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: _D.dark,
            surfaceTintColor: Colors.transparent,

            // ── Back button
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child:IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.arrow_back))),

            // ── Cart button
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14, top: 10, bottom: 10),
                child: Obx(() {
                  final count = cartController.totalItemsForRestaurant(rid);
                  return _CircleButton(
                    icon: Icons.shopping_bag_outlined,
                    onTap: () => Get.to(() => RestaurantCartPage(restaurantId: rid)),
                    badge: count > 0 ? (count > 99 ? '99+' : '$count') : null,
                  );
                }),
              ),
            ],

            // ── Scrolled separator
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: innerBoxIsScrolled ? 1 : 0,
                color: _D.accent.withOpacity(0.35),
              ),
            ),

            // ── Hero
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Obx(() {
                if (galleryController.isLoading.value) {
                  return Container(
                    color: _D.dark,
                    child: const Center(
                      child: CircularProgressIndicator(
                          color: _D.accent, strokeWidth: 2),
                    ),
                  );
                }
                if (galleryController.restaurantImage.isEmpty) {
                  return _HeroPlaceholder();
                }
                return _HeroImage(
                  imageUrl: galleryController.restaurantImage.value,
                  name: widget.restaurant.name,
                  address: widget.restaurant.address,
                );
              }),
            ),
          ),
        ],

        body: Column(
          children: [
            _TabBar(controller: tabController),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  RestaurantMenuTab(restaurantId: ridStr),
                  RestaurantAboutTab(restaurantId: ridStr),
                  GalleryTabPage(restaurantId: ridStr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Hero Image
// ─────────────────────────────────────────────────────────────────────────────
class _HeroImage extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String address;

  const _HeroImage({
    required this.imageUrl,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Photo
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _HeroPlaceholder(),
        ),

        // Gradient overlay — strong at top (for nav) & bottom (for text)
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.55),
                Colors.transparent,
                Colors.black.withOpacity(0.15),
                Colors.black.withOpacity(0.75),
                _D.dark.withOpacity(0.97),
              ],
              stops: const [0.0, 0.28, 0.5, 0.78, 1.0],
            ),
          ),
        ),

        // Bottom text block
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amber accent rule
                Container(
                  width: 36,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: _D.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),

                // Address chip
                Row(
                  children: [
                    const Icon(Icons.place_rounded,
                        color: _D.accent, size: 14),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        address,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 0.1,
                          height: 1.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Hero Placeholder
// ─────────────────────────────────────────────────────────────────────────────
class _HeroPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_D.dark, _D.darkMid],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 72,
          color: _D.accent.withOpacity(0.2),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab Bar
// ─────────────────────────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final TabController controller;
  const _TabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _D.surfaceCard,
        boxShadow: _D.shadow,
      ),
      child: TabBar(
        controller: controller,
        labelColor: _D.textPrimary,
        unselectedLabelColor: _D.textSub,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: _D.divider,
        dividerHeight: 1,
        indicator: _AmberIndicator(),
        labelStyle: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          _Tab(icon: Icons.menu_book_rounded, label: "Menu"),
          _Tab(icon: Icons.storefront_outlined, label: "About"),
          _Tab(icon: Icons.collections_outlined, label: "Gallery"),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tab({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 19),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}

class _AmberIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _AmberIndicatorPainter();
}

class _AmberIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final size = cfg.size!;
    const h = 3.0;
    const hPad = 20.0;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          offset.dx + hPad, offset.dy + size.height - h,
          size.width - hPad * 2, h),
      const Radius.circular(3),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFD4913A), _D.accent, _D.accentDim],
        ).createShader(rect.outerRect),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Circle Action Button (back / cart)
// ─────────────────────────────────────────────────────────────────────────────
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withOpacity(0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 17),
          ),
          if (badge != null)
            Positioned(
              right: -3,
              top: -3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 2.5),
                decoration: BoxDecoration(
                  color: _D.accent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: _D.accent.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 18),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: _D.dark,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}