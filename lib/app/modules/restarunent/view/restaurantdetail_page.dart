//
// import 'package:eshoppy/app/modules/restarunent/view/user_resaturantgallery.dart';
// import 'package:eshoppy/app/modules/restarunent/view/user_restaurantabouttab.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../data/models/restaruantcartmodel.dart';
// import '../../../data/models/restaurantmodel.dart';
// import '../controller/gallery_controller.dart';
// import '../controller/restaurantcartcontroller.dart';
// import 'restaurantcartpage.dart';
//
// class RestaurantDetailPage extends StatefulWidget {
//   final Restaurant restaurant;
//
//   const RestaurantDetailPage({super.key, required this.restaurant});
//
//   @override
//   State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
// }
//
// class _RestaurantDetailPageState extends State<RestaurantDetailPage>
//     with SingleTickerProviderStateMixin {
//
//   late TabController tabController;
//
//   late GalleryController galleryController;
//
//   final Restaurantcartcontroller cartController =
//   Get.put(Restaurantcartcontroller());
//
//   final List<String> menuTypes = ["Breakfast", "Lunch", "Dinner"];
//   final RxString selectedMenuType = "Breakfast".obs;
//
//   final RxList<Map<String, dynamic>> menuItems = [
//     {
//       "name": "Chicken Biryani",
//       "price": 180,
//       "img": "assets/images/products/chicken biriyani.jpg",
//       "type": "Lunch",
//     },
//     {
//       "name": "Paneer Butter Masala",
//       "price": 150,
//       "img": "assets/images/products/chicken biriyani.jpg",
//       "type": "Dinner",
//     },
//     {
//       "name": "Grilled Sandwich",
//       "price": 90,
//       "img": "assets/images/products/chicken biriyani.jpg",
//       "type": "Breakfast",
//     },
//     {
//       "name": "Cold Coffee",
//       "price": 60,
//       "img": "assets/images/products/chicken biriyani.jpg",
//       "type": "Breakfast",
//     },
//   ].obs;
//
//   @override
//   void initState() {
//     super.initState();
//
//     tabController = TabController(length: 3, vsync: this);
//
//     /// ✅ INIT GALLERY CONTROLLER PROPERLY
//     galleryController = Get.put(
//       GalleryController(
//         restaurantId: widget.restaurant.restaurantId.toString(),
//       ),
//       tag: widget.restaurant.restaurantId.toString(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       /// ---------------- APP BAR ----------------
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text(
//           widget.restaurant.name,
//           style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black),
//         ),
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(
//                     Icons.shopping_cart_outlined,
//                     color: Colors.teal),
//                 onPressed: () {
//                   Get.to(() => Restaurantcartpage());
//                 },
//               ),
//               Positioned(
//                 right: 6,
//                 top: 6,
//                 child: Obx(() {
//                   if (cartController.cartItems.isEmpty) {
//                     return const SizedBox();
//                   }
//                   return CircleAvatar(
//                     radius: 10,
//                     backgroundColor: Colors.red,
//                     child: Text(
//                       cartController.cartItems.length.toString(),
//                       style: const TextStyle(
//                           color: Colors.white, fontSize: 12),
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ],
//       ),
//
//       body: Column(
//         children: [
//
//           /// ---------------- RESTAURANT IMAGE (API) ----------------
//           Obx(() {
//             if (galleryController.isLoading.value) {
//               return Container(
//                 height: 200,
//                 color: Colors.grey.shade200,
//               );
//             }
//
//             if (galleryController.restaurantImage.isEmpty) {
//               return Container(
//                 height: 200,
//                 color: Colors.grey.shade300,
//                 child: const Icon(Icons.image_not_supported),
//               );
//             }
//
//             return ClipRRect(
//               borderRadius: const BorderRadius.vertical(
//                 bottom: Radius.circular(25),
//               ),
//               child: Image.network(
//                 galleryController.restaurantImage.value,
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             );
//           }),
//
//           const SizedBox(height: 10),
//
//           /// ---------------- TAB BAR ----------------
//           TabBar(
//             controller: tabController,
//             labelColor: Colors.teal,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: Colors.teal,
//             tabs: const [
//               Tab(icon: Icon(Icons.restaurant_menu), text: "Menu"),
//               Tab(icon: Icon(Icons.info), text: "About"),
//               Tab(icon: Icon(Icons.photo_library), text: "Gallery"),
//             ],
//           ),
//
//           /// ---------------- TAB BAR VIEW ----------------
//           Expanded(
//             child: TabBarView(
//               controller: tabController,
//               children: [
//                 menuTab(),
//                 RestaurantAboutTab(
//                   restaurantId:
//                   widget.restaurant.restaurantId.toString(),
//                 ),
//                 GalleryTabPage(
//                   restaurantId:
//                   widget.restaurant.restaurantId.toString(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// ================== MENU TAB ==================
//   Widget menuTab() {
//     return Obx(() {
//       var filteredItems = menuItems
//           .where((item) =>
//       item["type"] == selectedMenuType.value)
//           .toList();
//
//       return Column(
//         children: [
//
//           /// CATEGORY BUTTONS
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 16, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: menuTypes.map((type) {
//                 bool isSelected =
//                     selectedMenuType.value == type;
//                 return Expanded(
//                   child: GestureDetector(
//                     onTap: () =>
//                     selectedMenuType.value = type,
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 4),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12),
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? Colors.teal
//                             : Colors.grey.shade200,
//                         borderRadius:
//                         BorderRadius.circular(12),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         type,
//                         style: TextStyle(
//                           color: isSelected
//                               ? Colors.white
//                               : Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//
//           /// PRODUCT LIST
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: filteredItems.length,
//               itemBuilder: (context, index) {
//                 var item = filteredItems[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 15),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                     BorderRadius.circular(14),
//                     boxShadow: const [
//                       BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 6)
//                     ],
//                   ),
//                   child: ListTile(
//                     leading: ClipRRect(
//                       borderRadius:
//                       BorderRadius.circular(10),
//                       child: Image.asset(
//                         item["img"],
//                         width: 55,
//                         height: 55,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: Text(
//                       item["name"],
//                       style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     subtitle:
//                     Text("₹ ${item["price"]}"),
//                     trailing: ElevatedButton(
//                       onPressed: () {
//                         cartController.addToCart(
//                           RestaurantCartModel(
//                             name: item["name"],
//                             price: item["price"],
//                             qty: 1,
//                             img: item["img"],
//                           ),
//                         );
//
//                         Get.snackbar(
//                           "Added",
//                           "${item["name"]} added to cart",
//                           backgroundColor: Colors.teal,
//                           colorText: Colors.white,
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.teal,
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                           BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         "Add",
//                         style:
//                         TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
import 'package:eshoppy/app/modules/restarunent/view/user_resaturantgallery.dart';
import 'package:eshoppy/app/modules/restarunent/view/user_restaurantabouttab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/restaruantcartmodel.dart';
import '../../../data/models/restaurantmodel.dart';
import '../controller/gallery_controller.dart';
import '../controller/restaurantcartcontroller.dart';
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

  final RxList<Map<String, dynamic>> menuItems = [
    {
      "name": "Chicken Biryani",
      "price": 180,
      "img": "assets/images/products/chicken biriyani.jpg",
      "type": "Lunch",
      "description": "Aromatic rice with tender chicken",
      "rating": 4.5,
    },
    {
      "name": "Paneer Butter Masala",
      "price": 150,
      "img": "assets/images/products/chicken biriyani.jpg",
      "type": "Dinner",
      "description": "Creamy paneer in rich tomato gravy",
      "rating": 4.3,
    },
    {
      "name": "Grilled Sandwich",
      "price": 90,
      "img": "assets/images/products/chicken biriyani.jpg",
      "type": "Breakfast",
      "description": "Fresh veggies with melted cheese",
      "rating": 4.0,
    },
    {
      "name": "Cold Coffee",
      "price": 60,
      "img": "assets/images/products/chicken biriyani.jpg",
      "type": "Breakfast",
      "description": "Chilled coffee with ice cream",
      "rating": 4.7,
    },
  ].obs;

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
                        fit: BoxFit.cover
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
                                fontSize: 35,
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
                  menuTab(),
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

  /// ================== ENHANCED MENU TAB ==================
  Widget menuTab() {
    return Obx(() {
      var filteredItems = menuItems
          .where((item) => item["type"] == selectedMenuType.value)
          .toList();

      return Column(
        children: [
          /// STYLISH CATEGORY CHIPS
          Container(
            height: 60,
            margin: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: menuTypes.length,
              itemBuilder: (context, index) {
                String type = menuTypes[index];
                bool isSelected = selectedMenuType.value == type;

                return GestureDetector(
                  onTap: () => selectedMenuType.value = type,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                        colors: [Colors.teal, Color(0xFF00897B)],
                      )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? Colors.teal : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ELEGANT PRODUCT GRID
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    "No items available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                var item = filteredItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      children: [
                        /// PRODUCT IMAGE
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: Image.asset(
                            item["img"],
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// PRODUCT DETAILS
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["name"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["description"] ?? "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber.shade700,
                                        size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      item["rating"].toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "₹${item["price"]}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// ADD BUTTON
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Material(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () {
                                cartController.addToCart(
                                  RestaurantCartModel(
                                    name: item["name"],
                                    price: item["price"],
                                    qty: 1,
                                    img: item["img"],
                                  ),
                                );
                                Get.snackbar(
                                  "Added to Cart",
                                  "${item["name"]} added successfully",
                                  backgroundColor: Colors.teal,
                                  colorText: Colors.white,
                                  icon: const Icon(Icons.check_circle,
                                      color: Colors.white),
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: 12,
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: const Text(
                                  "ADD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
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
        ],
      );
    });
  }
}