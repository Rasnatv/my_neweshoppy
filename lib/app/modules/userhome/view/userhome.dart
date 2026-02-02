// //
// // import 'dart:ui';
// // import 'package:eshoppy/app/modules/userhome/view/selectlocationpage.dart' hide UserDistrictController;
// // import 'package:eshoppy/app/modules/userhome/view/user_eventsection.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../../../common/style/app_colors.dart';
// // import '../../../common/style/app_text_style.dart';
// // import '../../../widgets/iconwithbadge.dart';
// // import '../../product/controller/cartcontroller.dart';
// // import '../../product/view/cartscreen.dart';
// // import '../../restarunent/view/restarnent_list.dart';
// // import '../controller/district _controller.dart';
// // import '../controller/usercategory_controller.dart';
// // import '../widget/categorygrid.dart';
// // import '../widget/primaryheader.dart';
// // import 'package:flutter/services.dart';
// // import '../widget/promotionbanner.dart';
// // import '../widget/searchbar.dart';
// //
// // class Userhome extends StatelessWidget {
// //   const Userhome({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // ✅ Initialize controllers without permanent flag
// //     final userLocationController = Get.put(UserLocationController());
// //     final UserCategoryController categoryController =
// //     Get.put(UserCategoryController(), permanent: true);
// //
// //     // final userLocationController = Get.put(UserLocationController());
// //     final CartController cartController = Get.put(CartController());
// //
// //     final List<Map<String, String>> offers = [
// //       {
// //         "title": "Flat 50% OFF",
// //         "subtitle": "On Fashion Stores",
// //         "image": "assets/images/offers1.webp",
// //       },
// //       {
// //         "title": "Buy 1 Get 1",
// //         "subtitle": "Food & Beverages",
// //         "image": "assets/images/offer2.jpg",
// //       },
// //       {
// //         "title": "Mega Electronics Sale",
// //         "subtitle": "Up to 40% OFF",
// //         "image": "assets/images/offer3.jpg",
// //       },
// //     ];
// //
// //     return Scaffold(
// //       body: AnnotatedRegion<SystemUiOverlayStyle>(
// //         value: const SystemUiOverlayStyle(
// //           statusBarIconBrightness: Brightness.light,
// //         ),
// //         child: CustomScrollView(
// //           slivers: [
// //             // ---------------- SLIVER APPBAR ----------------
// //             SliverAppBar(
// //               backgroundColor: AppColors.kPrimary,
// //               pinned: true,
// //               expandedHeight: 180,
// //               automaticallyImplyLeading: false,
// //               title: Text(
// //                 "eShoppy",
// //                 style: AppTextStyle.rTextNunitoWhite26w700,
// //               ),
// //               actions: [
// //                 Obx(() => IconWithBadge(
// //                   icon: Icons.shopping_cart_outlined,
// //                   badgeColor: AppColors.bagecolor,
// //                   badgeCount: cartController.cartItems.length,
// //                   iconColor: Colors.white,
// //                   onPressed: () => Get.to(() => CartScreen()),
// //                 )),
// //                 const SizedBox(width: 12),
// //               ],
// //               flexibleSpace: FlexibleSpaceBar(
// //                 background: DPrimaryHeader(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const SizedBox(height: 50),
// //                       Padding(
// //                         padding: const EdgeInsets.only(left: 16, top: 40),
// //                         child: InkWell(
// //                           onTap: () {
// //                             // Navigate to location selection
// //                             Get.to(() => SelectLocationPage());
// //                           },
// //                           child: Row(
// //                             children: [
// //                               const Icon(Icons.location_on, color: Colors.red, size: 20),
// //                               const SizedBox(width: 4),
// //                               // ✅ Observe location value
// //                               Obx(() {
// //                                 final location = userLocationController.selectedMainLocation.value;
// //
// //                                 return Expanded(
// //                                   child: Text(
// //                                     location.isEmpty ? "Select Location" : location,
// //                                     style: AppTextStyle.rTextNunitoWhite14w700,
// //                                     maxLines: 1,
// //                                     overflow: TextOverflow.ellipsis,
// //                                   ),
// //                                 );
// //                               }),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 6),
// //                       // ---------------- Search Bar ----------------
// //                       Padding(
// //                         padding: const EdgeInsets.all(16),
// //                         child: buildSearchbar(),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //
// //             // ---------------- SLIDER ----------------
// //             SliverToBoxAdapter(
// //               child: Column(
// //                 children: [
// //                   const SizedBox(height: 20),
// //                   HomeCarouselSlider(),
// //                 ],
// //               ),
// //             ),
// //
// //             const SliverToBoxAdapter(child: SizedBox(height: 20)),
// //
// //             // ---------------- CATEGORY TITLE ----------------
// //             SliverToBoxAdapter(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(20),
// //                 child: Text(
// //                   "Categories",
// //                   style: AppTextStyle.rTextRalewayBlack19w800,
// //                 ),
// //               ),
// //             ),
// //
// //             // ---------------- CATEGORY GRID ----------------
// //             SliverToBoxAdapter(child: CategorySection()),
// //
// //             // ---------------- HOTEL BOOKING SECTION ----------------
// //             SliverToBoxAdapter(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(20),
// //                 child: Stack(
// //                   children: [
// //                     // Background Image
// //                     Container(
// //                       width: double.infinity,
// //                       height: 155,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(20),
// //                         image: DecorationImage(
// //                           image: AssetImage("assets/images/HOTELBOOK.png"),
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                     ),
// //                     // Glassmorphism Button
// //                     Positioned(
// //                       top: 3,
// //                       right: 4,
// //                       child: ClipRRect(
// //                         borderRadius: BorderRadius.circular(12),
// //                         child: BackdropFilter(
// //                           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
// //                           child: InkWell(
// //                             onTap: () => Get.to(() => RestaurantListPage()),
// //                             child: Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 24,
// //                                 vertical: 12,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white.withOpacity(0.2),
// //                                 borderRadius: BorderRadius.circular(12),
// //                                 border: Border.all(
// //                                   color: Colors.white.withOpacity(0.3),
// //                                 ),
// //                               ),
// //                               child: const Text(
// //                                 "BOOK NOW",
// //                                 style: TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 16,
// //                                   shadows: [
// //                                     Shadow(
// //                                       color: Colors.black26,
// //                                       offset: Offset(0, 2),
// //                                       blurRadius: 4,
// //                                     )
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //
// //             const SliverToBoxAdapter(child: SizedBox(height: 20)),
// //
// //             // ---------------- UPCOMING EVENTS ----------------
// //             SliverToBoxAdapter(
// //               child: Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: Text(
// //                   "Upcoming Events",
// //                   style: AppTextStyle.rTextRalewayBlack19w800,
// //                 ),
// //               ),
// //             ),
// //             SliverToBoxAdapter(
// //               child: UpcomingEventsSection(),
// //             ),
// //
// //             const SliverToBoxAdapter(child: SizedBox(height: 20)),
// //
// //             // ---------------- OFFERS TITLE ----------------
// //             SliverToBoxAdapter(
// //               child: Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: Text(
// //                   "Hot Offers",
// //                   style: AppTextStyle.rTextRalewayBlack19w800,
// //                 ),
// //               ),
// //             ),
// //
// //             // ---------------- OFFERS LIST ----------------
// //             SliverToBoxAdapter(
// //               child: SizedBox(
// //                 height: 180,
// //                 child: ListView.builder(
// //                   scrollDirection: Axis.horizontal,
// //                   padding: const EdgeInsets.all(16),
// //                   itemCount: offers.length,
// //                   itemBuilder: (context, index) {
// //                     final offer = offers[index];
// //                     return Padding(
// //                       padding: const EdgeInsets.only(right: 12),
// //                       child: ClipRRect(
// //                         borderRadius: BorderRadius.circular(16),
// //                         child: Stack(
// //                           children: [
// //                             // OFFER IMAGE
// //                             Image.asset(
// //                               offer["image"]!,
// //                               width: 260,
// //                               height: 180,
// //                               fit: BoxFit.cover,
// //                             ),
// //
// //                             // DARK OVERLAY
// //                             Container(
// //                               width: 260,
// //                               height: 180,
// //                               decoration: BoxDecoration(
// //                                 gradient: LinearGradient(
// //                                   begin: Alignment.bottomCenter,
// //                                   end: Alignment.topCenter,
// //                                   colors: [
// //                                     Colors.black.withOpacity(0.6),
// //                                     Colors.transparent,
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //
// //                             // TEXT CONTENT
// //                             Positioned(
// //                               left: 16,
// //                               bottom: 16,
// //                               right: 16,
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     offer["title"]!,
// //                                     style: const TextStyle(
// //                                       color: Colors.white,
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 4),
// //                                   Text(
// //                                     offer["subtitle"]!,
// //                                     style: const TextStyle(
// //                                       color: Colors.white70,
// //                                       fontSize: 13,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //
// //                             // OFFER BADGE
// //                             Positioned(
// //                               top: 12,
// //                               left: 12,
// //                               child: Container(
// //                                 padding: const EdgeInsets.symmetric(
// //                                   horizontal: 10,
// //                                   vertical: 6,
// //                                 ),
// //                                 decoration: BoxDecoration(
// //                                   color: AppColors.kPrimary,
// //                                   borderRadius: BorderRadius.circular(20),
// //                                 ),
// //                                 child: const Text(
// //                                   "Shopnow",
// //                                   style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 11,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ),
// //             const SliverToBoxAdapter(child: SizedBox(height: 50)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../widgets/iconwithbadge.dart';
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

class Userhome extends StatelessWidget {
  const Userhome({super.key});

  @override
  Widget build(BuildContext context) {
    final userLocationController = Get.put(UserLocationController());
    final categoryController =
    Get.put(UserCategoryController(), permanent: true);
    final cartController = Get.put(CartController());

    final List<Map<String, String>> offers = [
      {
        "title": "Flat 50% OFF",
        "subtitle": "On Fashion Stores",
        "image": "assets/images/offers1.webp",
      },
      {
        "title": "Buy 1 Get 1",
        "subtitle": "Food & Beverages",
        "image": "assets/images/offer2.jpg",
      },
      {
        "title": "Mega Electronics Sale",
        "subtitle": "Up to 40% OFF",
        "image": "assets/images/offer3.jpg",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        child: CustomScrollView(
          slivers: [
            // ================= HEADER =================
            SliverAppBar(
              pinned: true,
              expandedHeight: 210, // ✅ increased height
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF009788),
                        Color(0xFF10887C),
                        Color(0xFF009788),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ---------- TOP ROW ----------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// LOCATION
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      Get.to(() => SelectLocationPage()),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "eShoppy",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:30,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                      ),
                                      const SizedBox(height: 4),

                                      /// ✅ Correct Obx usage
                                      Obx(() {
                                        final location =
                                            userLocationController
                                                .selectedMainLocation.value;

                                        return Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                color: Colors.pinkAccent,
                                                size: 18),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                location.isEmpty
                                                    ? "Select Location"
                                                    : location,
                                                maxLines: 1,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),

                              /// ACTION ICONS
                              Row(
                                children: [
                                  Obx(() => IconWithBadge(
                  icon: Icons.shopping_cart_outlined,
                  badgeColor: Colors.white.withOpacity(0.5),
                  badgeCount: cartController.cartItems.length,
                  iconColor: Colors.white,
                  onPressed: () => Get.to(() => CartScreen()),
                )),

                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// ---------- SEARCH BAR ----------
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        hintText: "Search",
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                ),

                         ] ),
                          )],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            /// ================= SPECIAL OFFERS =================
            SliverToBoxAdapter(child:HomeCarouselSlider()),

            const SliverToBoxAdapter(child: SizedBox(height: 15)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.category_sharp,
                            color: Colors.orange.shade600,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.kPrimary,
                      ),
                      label: Text(
                        "View All",
                        style: TextStyle(
                          color: AppColors.kPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ================= CATEGORIES =================
             SliverToBoxAdapter(child: CategorySection()),

            const SliverToBoxAdapter(child: SizedBox(height: 15)),

            /// ================= HOTEL BOOKING =================
        SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: Image.asset(
                            "assets/images/logo/restaurantimag.png",
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Gradient Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withOpacity(0.65),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Content
                        Positioned(
                          left: 24,
                          top: 24,
                          bottom: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "NEW",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Restaurant Booking",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Find your perfect stay",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Book Now Button
                        Positioned(
                          right: 15,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: InkWell(
                              onTap: () => Get.to(() => RestaurantListPage()),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Book Now",
                                      style: TextStyle(
                                        color: AppColors.kPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppColors.kPrimary,
                                      size: 16,
                                    ),
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
              ),
            ),
           const SliverToBoxAdapter(child: SizedBox(height: 32)),
            // ============ UPCOMING EVENTS SECTION ============
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.event,
                            color: Colors.purple.shade600,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Upcoming Events",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.kPrimary,
                      ),
                      label: Text(
                        "View All",
                        style: TextStyle(
                          color: AppColors.kPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// ================= EVENTS =================
            SliverToBoxAdapter(
              child: UpcomingEventsSection(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ============ HOT OFFERS ============
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.red.shade600,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Hot Offers",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.kPrimary,
                      ),
                      label: Text(
                        "Explore",
                        style: TextStyle(
                          color: AppColors.kPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Offers List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        width: 320,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              // Image
                              Positioned.fill(
                                child: Image.asset(
                                  offer["image"]!,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // Gradient Overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.75),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Badge
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_offer_rounded,
                                        size: 14,
                                        color: AppColors.kPrimary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Limited",
                                        style: TextStyle(
                                          color: AppColors.kPrimary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Text Content
                              Positioned(
                                left: 20,
                                right: 20,
                                bottom: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offer["title"]!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      offer["subtitle"]!,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.95),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Shop Now",
                                            style: TextStyle(
                                              color: AppColors.kPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: AppColors.kPrimary,
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 60)),
          ],
        ),
      ),

    );
  }
}
