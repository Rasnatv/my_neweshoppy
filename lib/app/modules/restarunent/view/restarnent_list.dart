//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../data/models/restaurantmodel.dart';
// import '../controller/restaurant_controller.dart';
// import 'restaurantdetail_page.dart';
//
// class RestaurantListPage extends StatelessWidget {
//   RestaurantListPage({super.key});
//
//   final RestaurantController controller =
//   Get.put(RestaurantController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.kPrimary,
//         title: const Text("Restaurants"),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//
//           /// 🔍 Search Bar
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 6,
//                     offset: const Offset(0, 3),
//                   )
//                 ],
//               ),
//               child: TextField(
//                 onChanged: controller.setSearchQuery,
//                 decoration: const InputDecoration(
//                   hintText: "Search restaurants...",
//                   prefixIcon: Icon(Icons.search, color: Colors.grey),
//                   border: InputBorder.none,
//                   contentPadding:
//                   EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           /// 📃 Restaurant List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               final list = controller.filteredRestaurants;
//
//               if (list.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     "No restaurants found",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 );
//               }
//
//               return ListView.builder(
//                 padding: const EdgeInsets.all(20),
//                 itemCount: list.length,
//                 itemBuilder: (context, index) {
//                   return RestaurantCard(restaurant: list[index]);
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class RestaurantCard extends StatelessWidget {
//   final Restaurant restaurant;
//
//   const RestaurantCard({super.key, required this.restaurant});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           /// 🖼 Restaurant Image (NETWORK)
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(18),
//               bottomLeft: Radius.circular(18),
//             ),
//             child: Image.network(
//               restaurant.imageUrl,
//               width: 130,
//               height: 140,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) {
//                 return Container(
//                   width: 130,
//                   height: 140,
//                   color: Colors.grey.shade300,
//                   child: const Icon(Icons.restaurant, size: 40),
//                 );
//               },
//             ),
//           ),
//
//           /// ℹ Info
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(restaurant.name),
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on,
//                           size: 16, color: Colors.black),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           restaurant.address,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   /// 📅 Book Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xffe8af2e),
//                         foregroundColor: Colors.black,
//                         padding:
//                         const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 4,
//                       ),
//                       onPressed: () {
//                         Get.to(() => RestaurantDetailPage(
//                           restaurant: restaurant,
//                         ));
//                       },
//                       child: const Text(
//                         "Book a Table",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 14),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
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
        backgroundColor: AppColors.kPrimary,
        title: const Text("Restaurants"),
        centerTitle: true,
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
