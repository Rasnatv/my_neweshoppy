

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/restaruantcartmodel.dart';
import '../../../data/models/restaurantmodel.dart';
import '../../product/controller/cartcontroller.dart';
import '../controller/restaurantcartcontroller.dart';
import 'restaurantcartpage.dart'; // CartPage import

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

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
    },
    {
      "name": "Paneer Butter Masala",
      "price": 150,
      "img": "assets/images/products/chicken biriyani.jpg",
      "type": "Dinner",
    },
    {
      "name": "Grilled Sandwich",
      "price": 90,
      "img": "assets/images/products/chicken biriyani.jpg",
      "type": "Breakfast",
    },
    {
      "name": "Cold Coffee",
      "price": 60,
      "img": "assets/images/products/chicken biriyani.jpg",
      "type": "Breakfast",
    },
  ].obs;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ---------------- APP BAR ----------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(widget.restaurant.name,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.teal),
                onPressed: () {
                  Get.to(() => Restaurantcartpage());
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Obx(() {
                  if (cartController.cartItems.isEmpty) return const SizedBox();
                  return CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartController.cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: Column(
        children: [
          // ---------------- RESTAURANT IMAGE ----------------
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
            child: Image.asset(
              widget.restaurant.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 10),

          // ---------------- TAB BAR ----------------
          TabBar(
            controller: tabController,
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.teal,
            tabs: const [
              Tab(icon: Icon(Icons.restaurant_menu), text: "Menu"),
              Tab(icon: Icon(Icons.info), text: "About"),
              Tab(icon: Icon(Icons.photo_library), text: "Gallery"),
            ],
          ),

          // ---------------- TAB BAR VIEW ----------------
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                menuTab(),
                aboutTab(),
                galleryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================== MENU TAB ==================
  Widget menuTab() {
    return Obx(() {
      var filteredItems = menuItems
          .where((item) => item["type"] == selectedMenuType.value)
          .toList();

      return Column(
        children: [
          /// ---------------- CATEGORY BUTTONS ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: menuTypes.map((type) {
                bool isSelected = selectedMenuType.value == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => selectedMenuType.value = type,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          /// ---------------- PRODUCT LIST ----------------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                var item = filteredItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(item["img"],
                          width: 55, height: 55, fit: BoxFit.cover),
                    ),
                    title: Text(item["name"],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text("₹ ${item["price"]}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        cartController.addToCart(
                          RestaurantCartModel(
                            name: item["name"],
                            price: item["price"],
                            qty: 1,
                            img: item["img"],
                          ),
                        );

                        Get.snackbar("Added", "${item["name"]} added to cart",
                            backgroundColor: Colors.teal, colorText: Colors.white);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Add", style: TextStyle(color: Colors.white)),
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

  // /// ================== ABOUT TAB ==================
  // Widget aboutTab() {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(18),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         infoTile(Icons.location_on, "Address", widget.restaurant.address),
  //         infoTile(Icons.phone, "Phone", "+91 98765 43210"),
  //         infoTile(Icons.email, "Email", "info@restaurant.com"),
  //         infoTile(Icons.language, "Website", "www.restaurant.com"),
  //       ],
  //     ),
  //   );
  // }
  Widget aboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          infoTile(Icons.location_on, "Address", widget.restaurant.address),
          infoTile(Icons.phone, "Phone", "+91 98765 43210"),
          infoTile(Icons.email, "Email", "info@restaurant.com"),
          infoTile(Icons.language, "Website", "www.restaurant.com"),

          const SizedBox(height: 20),

          const Text(
            "Connect With Us",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),

          // ---------------- SOCIAL MEDIA ROW ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              socialIcon(
                icon: Icons.message,
                color: Colors.green,
                onTap: () {},
              ),
              socialIcon(
                icon: Icons.facebook,
                color: Colors.blue,
                onTap: () {},
              ),
              socialIcon(
                icon: Icons.camera,
                color: Colors.purple,
                onTap: () {},
              ),

            ],
          ),
        ],
      ),
    );
  }



  Widget infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(value,
                    style: const TextStyle(color: Colors.black54, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================== GALLERY TAB ==================
  Widget galleryTab() {
    List<String> galleryImages = [
      widget.restaurant.imageUrl,
      widget.restaurant.imageUrl,
      widget.restaurant.imageUrl,
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: galleryImages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(galleryImages[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
Widget socialIcon({
  required IconData icon,
  required Color color,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 28),
    ),
  );
}
