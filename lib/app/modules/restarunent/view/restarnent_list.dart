
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../data/models/restaurantmodel.dart';
import '../controller/restaurant_controller.dart';
import 'restaurantdetail_page.dart';

class RestaurantListPage extends StatelessWidget {
  RestaurantListPage({super.key});

  final RestaurantController controller = Get.put(RestaurantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:IconThemeData(color: Colors.white),
        backgroundColor: AppColors.kPrimary,
        title:  Text("Restaurants",style:AppTextStyle.rTextNunitoWhite17w700),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = controller.filteredRestaurants;

        if (list.isEmpty) {
          return const Center(child: Text("No restaurants found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return RestaurantCard(restaurant: list[index]);
          },
        );
      }),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
            child: Image.network(
              restaurant.imageUrl,
              width: 120,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 120,
                height: 130,
                color: Colors.grey.shade300,
                child: const Icon(Icons.restaurant, size: 40),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    restaurant.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => RestaurantDetailPage(
                          restaurant: restaurant,
                        ));
                      },
                      child: const Text("Book a Table"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
