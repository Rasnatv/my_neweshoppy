
import 'package:eshoppy/app/modules/admin_home/view/restaurant/restaurant_menumanagment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../../restarunent/controller/admin_restaurantlistcontroller.dart';
import '../../../restarunent/view/restaurantdetailupdatepage.dart';

import 'admin_restaurantregistration.dart';

class AdminRestauranthome extends StatelessWidget {
  AdminRestauranthome({super.key});

  final AdminRestaurantController controller = Get.put(AdminRestaurantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Home", style: AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// ---------------- Restaurant Registration Section ----------------
            _buildRegistrationCard(),

            const SizedBox(height: 24),

            /// ---------------- Restaurant List Section ----------------
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.restaurant, color: AppColors.kPrimary, size: 28),
                          const SizedBox(width: 12),
                          const Text(
                            "Restaurant Lists",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (controller.restaurants.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.restaurant_menu, size: 80, color: Colors.grey.shade300),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No restaurants found",
                                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: controller.restaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant = controller.restaurants[index];
                              return _buildRestaurantTile(restaurant);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.add_business, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Register a New Restaurant",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.to(() => RestaurantRegistrationPage());
            },
            label: const Text("Add"),
            icon: const Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantTile(Map<String, dynamic> restaurant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: restaurant["restaurant_image"] != null && restaurant["restaurant_image"].isNotEmpty
              ? NetworkImage(restaurant["restaurant_image"])
              : null,
          child: restaurant["restaurant_image"] == null || restaurant["restaurant_image"].isEmpty
              ? Icon(Icons.restaurant, size: 30, color: Colors.grey.shade600)
              : null,
        ),
        title: Text(
          restaurant['owner_name'] ?? "Unnamed",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    restaurant['phone'] ?? "N/A",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      restaurant['address'] ?? "N/A",
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
          child: IconButton(
            icon: Icon(Icons.edit, color: Colors.blue.shade700),
            onPressed: () {
              _showBottomSheet(restaurant);
            },
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(Map<String, dynamic> restaurant) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text("Manage Restaurant", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            /// Edit Restaurant Details
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
                Get.to(() => AdminRestaurantUpdatePage(
                  restaurantId: restaurant['id'],
                  restaurantData: restaurant,
                ))?.then((_) {
                  controller.fetchRestaurants(); // Refresh after update
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Restaurant Details"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            /// Edit Menu & Tables
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
                Get.to(()=>MenuManagementPage());
                // Get.to(() => MenuManagementPage(restaurantId: restaurant['id']));
              },
              icon: const Icon(Icons.restaurant_menu),
              label: const Text("Edit Menu & Tables"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
