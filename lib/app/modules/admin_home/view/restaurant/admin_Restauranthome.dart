
import 'package:eshoppy/app/modules/admin_home/view/restaurant/resaturant_menu_updatepage.dart';
import 'package:eshoppy/app/modules/admin_home/view/restaurant/restaurant_menumanagment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';

import '../../../../data/models/adminrestmodel.dart';
import 'controller/admin_restaurantlistcontroller.dart';

import 'restaurantdetailupdatepage.dart';
import 'admin_restaurantregistration.dart';

class AdminRestauranthome extends StatelessWidget {
  AdminRestauranthome({super.key});

  final AdminRestaurantController controller =
  Get.put(AdminRestaurantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Restaurant Home",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ---------------- Register Section ----------------
            _buildRegistrationCard(),

            const SizedBox(height: 24),

            /// ---------------- Restaurant List ----------------
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.restaurant,
                            color: AppColors.kPrimary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Restaurant Lists",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (controller.restaurants.isEmpty) {
                            return _emptyView();
                          }

                          return ListView.builder(
                            itemCount: controller.restaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant =
                              controller.restaurants[index];
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

  /// =========================================================
  /// Register Card
  /// =========================================================
  Widget _buildRegistrationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kcard, AppColors.kcard1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.add_business,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Register a New Restaurant",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.to(() => RestaurantRegistrationPage());
            },
            icon: const Icon(Icons.add),
            label: const Text("Add"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.kPrimary,
              elevation: 0,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =========================================================
  /// Restaurant Tile
  /// =========================================================
  Widget _buildRestaurantTile(NewRestaurantModel restaurant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: restaurant.restaurantImage.isNotEmpty
              ? NetworkImage(_getImageUrl(restaurant.restaurantImage))
              : null,
          child: restaurant.restaurantImage.isEmpty
              ? Icon(
            Icons.restaurant,
            size: 30,
            color: Colors.grey.shade600,
          )
              : null,
        ),
        title: Text(
          restaurant.restaurantName.isNotEmpty
              ? restaurant.restaurantName
              : "Unnamed Restaurant",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.phone,
                      size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    restaurant.phone.isNotEmpty
                        ? restaurant.phone
                        : "N/A",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      restaurant.address.isNotEmpty
                          ? restaurant.address
                          : "N/A",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert,
              color: AppColors.kPrimary),
          onPressed: () {
            _showBottomSheet(restaurant);
          },
        ),
      ),
    );
  }

  /// =========================================================
  /// Bottom Sheet
  /// =========================================================
  void _showBottomSheet(NewRestaurantModel restaurant) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Manage Restaurant",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            /// Edit Restaurant
            ElevatedButton.icon(
              onPressed: () {
                Get.back();

                // Convert NewRestaurantModel to Map for the update page
                final restaurantData = {
                  'id': restaurant.id,
                  'restaurant_name': restaurant.restaurantName,
                  'restaurant_image': restaurant.restaurantImage,
                  'owner_name': restaurant.ownerName,
                  'address': restaurant.address,
                  'phone': restaurant.phone,
                  'email': restaurant.email,
                  'website': restaurant.website,
                  'whatsapp': restaurant.whatsapp,
                  'facebook_link': restaurant.facebookLink,
                  'instagram_link': restaurant.instagramLink,
                  'additional_images': restaurant.additionalImages,
                };

                Get.to(
                      () => AdminRestaurantUpdatePage(
                    restaurantId: restaurant.id,
                    restaurantData: restaurantData,
                  ),
                )?.then((_) {
                  controller.fetchRestaurants();
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Restaurant Details"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 12),

            /// Menu Management
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
               Get.to(() => MenuUpdatePage(restaurantId: int.parse(restaurant.id)));
              },
              icon: const Icon(Icons.restaurant_menu),
              label: const Text("Edit Menu & Tables"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: AppColors.kPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================================================
  /// Helper method to construct proper image URL
  /// =========================================================
  String _getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';

    // If the path already contains the full URL, return it as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Otherwise, prepend the base URL
    return "https://rasma.astradevelops.in/e_shoppyy/public/$imagePath";
  }

  /// =========================================================
  /// Empty View
  /// =========================================================
  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No restaurants found",
            style: TextStyle(
                fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}