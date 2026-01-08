

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/restaurantmodel.dart';
import '../controller/restaurant_controller.dart';
import 'restaurantdetail_page.dart';

class RestaurantListPage extends StatelessWidget {
  final RestaurantController controller = Get.put(RestaurantController());

  RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.kPrimary,),
      backgroundColor: Colors.white,
      body: Column(
        children: [
           const SizedBox(height: 20),

          /// 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                onChanged: controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = controller.filteredRestaurants;

              if (list.isEmpty) {
                return const Center(child: Text(
                  "No restaurants found",
                  style: TextStyle(color: Colors.white),
                ));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return RestaurantCard(restaurant: list[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // shadow color
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // shadow position
          ),
        ],
      ),
      child: Row(
        children: [
          /// Restaurant Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
            child: Image.asset(
              restaurant.imageUrl,
              width: 130,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),

          /// Info and Button
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name + Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.black),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${restaurant.name}, ${restaurant.address}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Book Table Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffe8af2e),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4, // button shadow
                      ),
                      onPressed: () {
                        Get.to(() =>
                            //RestaurantDetailPage());
                            RestaurantDetailPage(restaurant: restaurant));
                      },
                      child: const Text(
                        "Book a Table",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
