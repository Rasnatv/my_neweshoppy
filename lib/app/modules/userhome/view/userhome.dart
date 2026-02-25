//
//
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../widgets/iconwithbadge.dart';
// import '../../product/controller/cartcontroller.dart';
// import '../../product/view/cartscreen.dart';
// import '../../restarunent/view/restarnent_list.dart';
// import '../controller/district _controller.dart';
// import '../controller/usercategory_controller.dart';
//
// import '../widget/categorygrid.dart';
// import '../widget/promotionbanner.dart';
// import '../widget/searchbar.dart';
// import '../widget/primaryheader.dart';
// import '../view/selectlocationpage.dart';
// import '../view/user_eventsection.dart';
// import '../widget/user_offer.dart';
//
// class Userhome extends StatelessWidget {
//   const Userhome({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final userLocationController = Get.put(UserLocationController());
//     final categoryController =
//     Get.put(UserCategoryController(), permanent: true);
//     final cartController = Get.put(CartController());
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: const SystemUiOverlayStyle(
//           statusBarIconBrightness: Brightness.light,
//           statusBarColor: Colors.transparent,
//         ),
//         child: CustomScrollView(
//           slivers: [
//             // ================= HEADER =================
//             SliverAppBar(
//               pinned: true,
//               expandedHeight: 210, // ✅ increased height
//               backgroundColor: Colors.transparent,
//               automaticallyImplyLeading: false,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Color(0xFF009788),
//                         Color(0xFF10887C),
//                         Color(0xFF009788),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(32),
//                       bottomRight: Radius.circular(32),
//                     ),
//                   ),
//                   child: SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           /// ---------- TOP ROW ----------
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               /// LOCATION
//                               Expanded(
//                                 child: InkWell(
//                                   onTap: () =>
//                                       Get.to(() => SelectLocationPage()),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "eShoppy",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize:30,
//                                       fontWeight: FontWeight.bold,
//                                       letterSpacing: 0.3,
//                                     ),
//                                       ),
//                                       const SizedBox(height: 4),
//
//                                       /// ✅ Correct Obx usage
//                                       Obx(() {
//                                         final location =
//                                             userLocationController
//                                                 .selectedMainLocation.value;
//
//                                         return Row(
//                                           children: [
//                                             const Icon(Icons.location_on,
//                                                 color: Colors.pinkAccent,
//                                                 size: 18),
//                                             const SizedBox(width: 4),
//                                             Flexible(
//                                               child: Text(
//                                                 location.isEmpty
//                                                     ? "Select Location"
//                                                     : location,
//                                                 maxLines: 1,
//                                                 overflow:
//                                                 TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                             ),
//                                             const Icon(
//                                               Icons.keyboard_arrow_down,
//                                               color: Colors.white,
//                                             ),
//                                           ],
//                                         );
//                                       }),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//
//                               /// ACTION ICONS
//                               Row(
//                                 children: [
//                                   Obx(() => IconWithBadge(
//                   icon: Icons.shopping_cart_outlined,
//                   badgeColor: Colors.white.withOpacity(0.5),
//                   badgeCount: cartController.cartItems.length,
//                   iconColor: Colors.white,
//                   onPressed: () => Get.to(() => CartScreen()),
//                 )),
//
//                                 ],
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(height: 10),
//
//                           /// ---------- SEARCH BAR ----------
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     height: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius:
//                                       BorderRadius.circular(12),
//                                     ),
//                                     child: const TextField(
//                                       decoration: InputDecoration(
//                                         hintText: "Search",
//                                         border: InputBorder.none,
//                                         prefixIcon: Icon(Icons.search),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                          ] ),
//                           )],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SliverToBoxAdapter(child: SizedBox(height: 24)),
//
//             /// ================= SPECIAL OFFERS =================
//             SliverToBoxAdapter(child:HomeCarouselSlider()),
//
//             const SliverToBoxAdapter(child: SizedBox(height: 15)),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: Colors.orange.shade50,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Icon(
//                             Icons.category_sharp,
//                             color: Colors.orange.shade600,
//                             size: 18,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         const Text(
//                           "Categories",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1A1A1A),
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                       ],
//                     ),
//                     TextButton.icon(
//                       onPressed: () {},
//                       icon: Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         size: 14,
//                         color: AppColors.kPrimary,
//                       ),
//                       label: Text(
//                         "View All",
//                         style: TextStyle(
//                           color: AppColors.kPrimary,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             /// ================= CATEGORIES =================
//              SliverToBoxAdapter(child: CategorySection()),
//
//             const SliverToBoxAdapter(child: SizedBox(height: 15)),
//
//             /// ================= HOTEL BOOKING =================
//         SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   height: 160,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 20,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Stack(
//                       children: [
//                         // Background Image
//                         Positioned.fill(
//                           child: Image.asset(
//                             "assets/images/logo/restaurantimag.png",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//
//                         // Gradient Overlay
//                         Positioned.fill(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                                 colors: [
//                                   Colors.black.withOpacity(0.65),
//                                   Colors.transparent,
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         // Content
//                         Positioned(
//                           left: 24,
//                           top: 24,
//                           bottom: 24,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.orange,
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: const Text(
//                                   "NEW",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                     letterSpacing: 0.5,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               const Text(
//                                 "Restaurant Booking",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 0.3,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 "Find your perfect stay",
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.95),
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         // Book Now Button
//                         Positioned(
//                           right: 15,
//                           top: 0,
//                           bottom: 0,
//                           child: Center(
//                             child: InkWell(
//                               onTap: () => Get.to(() => RestaurantListPage()),
//                               borderRadius: BorderRadius.circular(14),
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 12,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(14),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.15),
//                                       blurRadius: 12,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       "Book Now",
//                                       style: TextStyle(
//                                         color: AppColors.kPrimary,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                         letterSpacing: 0.3,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Icon(
//                                       Icons.arrow_forward_rounded,
//                                       color: AppColors.kPrimary,
//                                       size: 16,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//            const SliverToBoxAdapter(child: SizedBox(height: 32)),
//             // ============ UPCOMING EVENTS SECTION ============
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: Colors.purple.shade50,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Icon(
//                             Icons.event,
//                             color: Colors.purple.shade600,
//                             size: 18,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         const Text(
//                           "Upcoming Events",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1A1A1A),
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                       ],
//                     ),
//                     TextButton.icon(
//                       onPressed: () {},
//                       icon: Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         size: 14,
//                         color: AppColors.kPrimary,
//                       ),
//                       label: Text(
//                         "View All",
//                         style: TextStyle(
//                           color: AppColors.kPrimary,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SliverToBoxAdapter(child: SizedBox(height: 16)),
//
//             /// ================= EVENTS =================
//             SliverToBoxAdapter(
//               child: UpcomingEventsSection(),
//             ),
//
//             const SliverToBoxAdapter(child: SizedBox(height: 32)),
//
//             // ============ HOT OFFERS ============
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade50,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Icon(
//                             Icons.local_fire_department_rounded,
//                             color: Colors.red.shade600,
//                             size: 18,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         const Text(
//                           "Hot Offers",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1A1A1A),
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                       ],
//                     ),
//                     TextButton.icon(
//                       onPressed: () {},
//                       icon: Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         size: 14,
//                         color: AppColors.kPrimary,
//                       ),
//                       label: Text(
//                         "Explore",
//                         style: TextStyle(
//                           color: AppColors.kPrimary,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SliverToBoxAdapter(child: SizedBox(height: 16)),
//             UserOfferSection(),
//             const SliverToBoxAdapter(child: SizedBox(height: 60)),
//           ],
//         ),
//       ),
//
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../product/controller/cartcontroller.dart';
import '../../product/view/cartscreen.dart';
import '../../restarunent/view/restarnent_list.dart';
import '../controller/district _controller.dart';
import '../controller/usercategory_controller.dart';
import '../widget/categorygrid.dart';
import '../widget/promotionbanner.dart';
import '../widget/searchbar.dart';
import '../widget/primaryheader.dart';
import '../view/selectlocationpage.dart';
import '../view/user_eventsection.dart';
import '../widget/user_offer.dart';

class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF5F5F5),
                Color(0xFFFFFFFF),
                Color(0xFFF5F5F5),
                Color(0xFFE8E8E8),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  SHIMMER SKELETON: Home Page Loading State
// ─────────────────────────────────────────────
class HomeShimmerSkeleton extends StatelessWidget {
  const HomeShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // Header shimmer — uses SafeArea + mainAxisSize.min to never overflow
        SliverToBoxAdapter(
          child: Container(
            height: 185,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF009788), Color(0xFF10887C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _whiteShimmer(130, 22, radius: 6),
                          Row(
                            children: [
                              _whiteShimmer(38, 38, radius: 10),
                              const SizedBox(width: 8),
                              _whiteShimmer(38, 38, radius: 10),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _whiteShimmer(130, 14, radius: 7),
                      const SizedBox(height: 10),
                      _whiteShimmer(double.infinity, 44, radius: 14),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        // Carousel shimmer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ShimmerBox(width: double.infinity, height: 170, borderRadius: 20),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        // Section header shimmer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 130, height: 22, borderRadius: 6),
                ShimmerBox(width: 70, height: 16, borderRadius: 6),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        // Category grid shimmer
        SliverToBoxAdapter(
          child: SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Column(
                  children: [
                    ShimmerBox(width: 64, height: 64, borderRadius: 16),
                    const SizedBox(height: 8),
                    ShimmerBox(width: 52, height: 12, borderRadius: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        // Banner shimmer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ShimmerBox(width: double.infinity, height: 160, borderRadius: 20),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        // Events shimmer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 160, height: 22, borderRadius: 6),
                ShimmerBox(width: 60, height: 16, borderRadius: 6),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ShimmerBox(width: 200, height: 130, borderRadius: 16),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 60)),
      ],
    );
  }

  Widget _whiteShimmer(double w, double h, {double radius = 8}) {
    return Container(
      width: w == double.infinity ? null : w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MAIN HOME PAGE
// ─────────────────────────────────────────────
class Userhome extends StatefulWidget {
  const Userhome({super.key});

  @override
  State<Userhome> createState() => _UserhomeState();
}

class _UserhomeState extends State<Userhome> with TickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    // Simulate data load — replace with your actual async init
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userLocationController = Get.put(UserLocationController());
    final categoryController =
    Get.put(UserCategoryController(), permanent: true);
    final cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isLoading
              ? const HomeShimmerSkeleton()
              : FadeTransition(
            opacity: _fadeAnimation,
            child: _buildContent(
                context, userLocationController, cartController),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      UserLocationController userLocationController,
      CartController cartController,
      ) {
    return CustomScrollView(
      slivers: [
        // ══════════════════════════════════════
        //  PREMIUM HEADER
        // ══════════════════════════════════════
        SliverAppBar(
          pinned: true,
          expandedHeight: 185,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: _PremiumHeader(
              locationController: userLocationController,
              cartController: cartController,
            ),
          ),
          // Collapsed state — keep gradient visible
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(color: Colors.transparent),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        /// CAROUSEL
        SliverToBoxAdapter(child: HomeCarouselSlider()),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        /// SECTION: CATEGORIES
        SliverToBoxAdapter(
          child: _SectionHeader(
            icon: Icons.category_sharp,
            iconBg: Colors.orange.shade50,
            iconColor: Colors.orange.shade600,
            title: "Categories",
            actionLabel: "View All",
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(child: CategorySection()),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        /// RESTAURANT BANNER
        SliverToBoxAdapter(child: _RestaurantBanner()),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        /// SECTION: UPCOMING EVENTS
        SliverToBoxAdapter(
          child: _SectionHeader(
            icon: Icons.event_rounded,
            iconBg: Colors.purple.shade50,
            iconColor: Colors.purple.shade600,
            title: "Upcoming Events",
            actionLabel: "View All",
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(child: UpcomingEventsSection()),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        /// SECTION: HOT OFFERS
        SliverToBoxAdapter(
          child: _SectionHeader(
            icon: Icons.local_fire_department_rounded,
            iconBg: Colors.red.shade50,
            iconColor: Colors.red.shade600,
            title: "Hot Offers",
            actionLabel: "Explore",
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        UserOfferSection(),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  PREMIUM HEADER WIDGET
// ─────────────────────────────────────────────
class _PremiumHeader extends StatelessWidget {
  final UserLocationController locationController;
  final CartController cartController;

  const _PremiumHeader({
    required this.locationController,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00BFA5),
              Color(0xFF009788),
              Color(0xFF00796B),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Decorative circles (purely visual, overflow clipped)
              Positioned(
                top: -30,
                right: -20,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 60,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: -10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),

              // Main content — SafeArea only for top, Column uses min size
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Row 1: brand + actions (all in one row, compact) ──
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(Icons.shopping_bag_rounded,
                                color: Colors.white, size: 15),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "eShoppy",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD740),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "PRO",
                              style: TextStyle(
                                color: Color(0xFF00695C),
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const Spacer(),
                          _HeaderIconButton(
                            icon: Icons.notifications_none_rounded,
                            onTap: () {},
                          ),
                          const SizedBox(width: 8),
                          Obx(() => _HeaderIconButton(
                            icon: Icons.shopping_cart_outlined,
                            badgeCount: cartController.cartItems.length,
                            onTap: () => Get.to(() => CartScreen()),
                          )),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // ── Row 2: location pill ──
                      InkWell(
                        onTap: () => Get.to(() => SelectLocationPage()),
                        borderRadius: BorderRadius.circular(16),
                        child: Obx(() {
                          final loc =
                              locationController.selectedMainLocation.value;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  color: Colors.pinkAccent, size: 13),
                              const SizedBox(width: 4),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 180),
                                child: Text(
                                  loc.isEmpty ? "Select Location" : loc,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white60, size: 14),
                            ],
                          );
                        }),
                      ),

                      const SizedBox(height: 10),

                      // ── Row 3: search bar ──
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Icon(Icons.search_rounded,
                                color: Colors.teal.shade600, size: 19),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search products, restaurants...",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF009788),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(Icons.tune_rounded,
                                  color: Colors.white, size: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
    }
}
class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            if (badgeCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5252),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badgeCount > 9 ? "9+" : "$badgeCount",
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
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String actionLabel;

  const _SectionHeader({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF009788).withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    actionLabel,
                    style: const TextStyle(
                      color: Color(0xFF009788),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 12, color: Color(0xFF009788)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _RestaurantBanner extends StatelessWidget {
  const _RestaurantBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // BG image
              Positioned.fill(
                child: Image.asset(
                  "assets/images/logo/restaurantimag.png",
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xCC000000), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // Left content
              Positioned(
                left: 22,
                top: 22,
                bottom: 22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "NEW",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Restaurant\nBooking",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Find your perfect stay",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Book now button
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: InkWell(
                    onTap: () => Get.to(() => RestaurantListPage()),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Book Now",
                            style: TextStyle(
                              color: Color(0xFF009788),
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded,
                              color: Color(0xFF009788), size: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}