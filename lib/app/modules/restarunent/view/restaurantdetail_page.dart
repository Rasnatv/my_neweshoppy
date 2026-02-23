
import 'package:eshoppy/app/modules/restarunent/view/user_resaturantgallery.dart';
import 'package:eshoppy/app/modules/restarunent/view/user_restaurantabouttab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/restaruantcartmodel.dart';
import '../../../data/models/userrestaurantmodel.dart';
import '../controller/gallery_controller.dart';
import '../controller/restaurantcartcontroller.dart';
import 'menu_tab.dart';
import 'restaurantcartpage.dart';

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
  final Restaurantcartcontroller cartController =
  Get.put(Restaurantcartcontroller());

  final List<String> menuTypes = ["Breakfast", "Lunch", "Dinner"];
  final RxString selectedMenuType = "Breakfast".obs;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    galleryController = Get.put(
      GalleryController(
        restaurantId: widget.restaurant.restaurantId.toString(),
      ),
      tag: widget.restaurant.restaurantId.toString(),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            /// ---------------- SLIVER APP BAR WITH IMAGE ----------------
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: Container(
                margin: const EdgeInsets.all(8),
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
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Get.back(),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
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
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined,
                            color: Colors.teal),
                        onPressed: () => Get.to(() => Restaurantcartpage()),
                      ),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Obx(() {
                          if (cartController.cartItems.isEmpty) {
                            return const SizedBox();
                          }
                          return Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Center(
                              child: Text(
                                cartController.cartItems.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Obx(() {
                  if (galleryController.isLoading.value) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.teal),
                      ),
                    );
                  }
                  if (galleryController.restaurantImage.isEmpty) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported, size: 64),
                    );
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        galleryController.restaurantImage.value,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported, size: 64),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurant.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.white70, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.restaurant.address,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
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
                    ],
                  );
                }),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            /// ---------------- MODERN TAB BAR ----------------
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: tabController,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: Colors.teal,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(icon: Icon(Icons.restaurant_menu), text: "Menu"),
                  Tab(icon: Icon(Icons.info_outline), text: "About"),
                  Tab(icon: Icon(Icons.photo_library_outlined), text: "Gallery"),
                ],
              ),
            ),

            /// ---------------- TAB BAR VIEW ----------------
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  // menuTab(),
                  RestaurantMenuTab(
                    restaurantId: widget.restaurant.restaurantId.toString(),
                  ),
                  RestaurantAboutTab(
                    restaurantId: widget.restaurant.restaurantId.toString(),
                  ),
                  GalleryTabPage(
                    restaurantId: widget.restaurant.restaurantId.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}