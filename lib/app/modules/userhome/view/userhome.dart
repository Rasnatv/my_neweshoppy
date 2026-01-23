

import 'dart:ui';

import 'package:eshoppy/app/modules/userhome/view/selectlocationpage.dart' hide UserDistrictController;
import 'package:eshoppy/app/modules/userhome/view/user_eventsection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../widgets/iconwithbadge.dart';
import '../../product/controller/cartcontroller.dart';
import '../../product/view/cartscreen.dart';
import '../../restarunent/view/restarnent_list.dart';
import '../controller/district _controller.dart';
import '../widget/categorygrid.dart';
import '../widget/primaryheader.dart';
import 'package:flutter/services.dart';
import '../widget/promotionbanner.dart';
import '../widget/searchbar.dart';

class Userhome extends StatelessWidget {
  const Userhome({super.key});

  @override
  Widget build(BuildContext context) {
    final userLocationController = Get.put(UserLocationController(), permanent: true);
    final CartController cartController = Get.put(CartController());

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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: CustomScrollView(
          slivers: [
            // ---------------- SLIVER APPBAR ----------------
            SliverAppBar(
              backgroundColor: AppColors.kPrimary,
              pinned: true,
              expandedHeight: 180,
              automaticallyImplyLeading: false,
              title: Text(
                "eShoppy",
                style: AppTextStyle.rTextNunitoWhite26w700,
              ),
              actions: [
                Obx(() => IconWithBadge(
                  icon: Icons.shopping_cart_outlined,
                  badgeCount: cartController.cartItems.length,
                  iconColor: Colors.white,
                  onPressed: () => Get.to(() => CartPage()),
                )),
                const SizedBox(width: 12),
              ],

              flexibleSpace: FlexibleSpaceBar(
                background: DPrimaryHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 40),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => SelectLocationPage());
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red, size: 20),
                              const SizedBox(width: 4),
                              Obx(() {
                                final location =
                                    Get.find<UserLocationController>().selectedMainLocation.value;

                                return Text(
                                  location.isEmpty ? "Select Location" : location,
                                  style: AppTextStyle.rTextNunitoWhite14w700,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),
                      // ---------------- Search Bar ----------------
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: buildSearchbar(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ---------------- SLIDER ----------------
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  HomeCarouselSlider(),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ---------------- CATEGORY TITLE ----------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Categories",
                    style: AppTextStyle.rTextRalewayBlack19w800),
              ),
            ),

            // ---------------- CATEGORY GRID ----------------
            SliverToBoxAdapter(child: CategorySection ()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    // Background Image
                    Container(
                      width: double.infinity,
                      height: 155,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage("assets/images/HOTELBOOK.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Glassmorphism Button
                    Positioned(
                      top:3,
                      right:4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: InkWell(onTap: ()=>Get.to(()=>RestaurantListPage()),child:
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: const Text(
                              "BOOK NOW",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                            ),
                          ),
                          ),
                        ),
                      ),
                    ) ],
                ),
              ),
            ),



            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ---------------- UPCOMING EVENTS ----------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Upcoming Events",
                  style: AppTextStyle.rTextRalewayBlack19w800,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: UpcomingEventsSection(),
            ),


            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // ---------------- OFFERS TITLE ----------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Hot Offers",
                  style: AppTextStyle.rTextRalewayBlack19w800,
                ),
              ),
            ),

// ---------------- OFFERS LIST ----------------
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // OFFER IMAGE
                            Image.asset(
                              offer["image"]!,
                              width: 260,
                              height: 180,
                              fit: BoxFit.cover,
                            ),

                            // DARK OVERLAY
                            Container(
                              width: 260,
                              height: 180,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),

                            // TEXT CONTENT
                            Positioned(
                              left: 16,
                              bottom: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    offer["title"]!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    offer["subtitle"]!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // OFFER BADGE
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Shopnow",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),

          ],
        ),
      ),
    );
  }
}
