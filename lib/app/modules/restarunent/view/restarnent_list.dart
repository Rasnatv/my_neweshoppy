
import 'package:eshoppy/app/modules/restarunent/view/Restaurant_mainCart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/userrestaurantmodel.dart';
import '../controller/restaurant_controller.dart';
import '../controller/restaurant_maincartcontroller.dart';
import 'restaurantdetail_page.dart';

// ── Exact color extracted from reference UI ───────────────────────────────────
class _P {
  // Backgrounds
  static const bg         = Color(0xFFF8F8F8);
  static const cardBg     = Color(0xFFFFFFFF);
  static const inputBg    = Color(0xFFF2F3F5);

  // Brand — exact amber from reference image
  static const amber      = Color(0xFF0F5151);
  static const amberDeep  = Color(0xFFCB6405);   // darker press state
  static const amberLight = Color(0xFFFDF3E7);   // tinted bg
  static const amberGlow  = Color(0x25DF7110);   // shadow/glow

  // Text
  static const textDark   = Color(0xFF1A1A1A);
  static const textMid    = Color(0xFF5A5E72);
  static const textLight  = Color(0xFFADB1C4);

  // Structural
  static const border     = Color(0xFFECEDF0);
  static const divider    = Color(0xFFF0F1F4);
  static const shadow     = Color(0x10000000);
}

// ── Page ──────────────────────────────────────────────────────────────────────
class RestaurantListPage extends StatelessWidget {
  RestaurantListPage({super.key});

  final RestaurantController controller = Get.put(RestaurantController());
  final FinalCartController  cartController=Get.put(FinalCartController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _P.bg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: _P.textDark),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,   // ✅ CRITICAL fix — was unconstrained
              children: [
                Container(
                  width: 3.5,
                  height: 38,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Restaurants',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _P.textDark,
                        letterSpacing: -0.4,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Reserve your dining experience',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: _P.textLight,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Obx(() {
              final cartController = Get.find<FinalCartController>();
              final count = cartController.totalItemCount;
              return SizedBox(          // ✅ Constrain the Stack
                width: 48,
                height: 56,
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: _P.textDark,
                        size: 24,
                      ),
                      onPressed: () => Get.to(() => RestaurantFinalCart()),
                    ),
                    if (count > 0)
                      Positioned(
                        top: 8,
                        right: 6,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(width: 8),
          ],
        ),

        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      color: _P.amber,
                      strokeWidth: 2.5,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Loading restaurants...',
                    style: TextStyle(
                      color: _P.textLight,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final list = controller.filteredRestaurants;

          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: const BoxDecoration(
                      color: _P.amberLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_outlined,
                      size: 36,
                      color: _P.amber,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No restaurants found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _P.textDark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Try adjusting your search',
                    style: TextStyle(
                      fontSize: 13,
                      color: _P.textLight,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            itemCount: list.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 260 + index * 55),
                curve: Curves.easeOutCubic,
                builder: (_, v, child) => Opacity(
                  opacity: v,
                  child: Transform.translate(
                    offset: Offset(0, 16 * (1 - v)),
                    child: child,
                  ),
                ),
                child: RestaurantCard(restaurant: list[index]),
              );
            },
          );
        }),
      ),
    );
  }
}

// ── Restaurant Card ───────────────────────────────────────────────────────────
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _P.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _P.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: _P.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Image ──────────────────────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(17),
            ),
            child: Stack(
              children: [
                Image.network(
                  restaurant.imageUrl,
                  width: 120,
                  height: 148,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 120,
                    height: 148,
                    color: _P.inputBg,
                    child: const Icon(
                      Icons.restaurant,
                      size: 36,
                      color: _P.textLight,
                    ),
                  ),
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      width: 120,
                      height: 148,
                      color: _P.inputBg,
                      child: const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: _P.amber,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Subtle dark overlay on image
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.22),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Amber left-edge accent bar


              ],
            ),
          ),

          // ── Content ────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Open badge

                  const SizedBox(height: 7),

                  // Restaurant name
                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: _P.textDark,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Amber underline accent
                  Container(
                    width: 26,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: _P.amber,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 1.5),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: _P.textLight,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          restaurant.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: _P.textMid,
                            height: 1.5,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Book a Table button
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Get.to(() =>
                            RestaurantDetailPage(restaurant: restaurant));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _P.amber,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: _P.amberGlow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.table_restaurant_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Book a Table',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              ]),
            ),
          ) ],
      ),
    );
  }
}
