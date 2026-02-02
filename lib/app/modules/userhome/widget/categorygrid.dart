//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../data/models/user_category model.dart';
// import '../controller/company_controller.dart';
// import '../controller/usercategory_controller.dart';
// import '../view/categoriesofshoplist.dart';
//
// class CategorySection extends StatelessWidget {
//   CategorySection({super.key});
//
//   final UserCategoryController controller =
//   Get.put(UserCategoryController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       if (controller.categories.isEmpty) {
//         return const Center(child: Text("No categories available"));
//       }
//
//       return GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: controller.categories.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//         ),
//         itemBuilder: (context, index) {
//           final UserCategoryModel cat = controller.categories[index];
//
//           return GestureDetector(
//             onTap: () {
//               final companyController = Get.put(CompanyController());
//               companyController.clearShops();
//               companyController.fetchShopsByCategory(cat.id);
//               Get.to(() => const Categoriesofshoplist());
//             },
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundImage: NetworkImage(cat.image),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   cat.name,
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user_category model.dart';
import '../controller/company_controller.dart';
import '../controller/usercategory_controller.dart';
import '../view/categoriesofshoplist.dart';

class CategorySection extends StatelessWidget {
  CategorySection({super.key});

  final UserCategoryController controller =
  Get.put(UserCategoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ---------- LOADING ----------
      if (controller.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      }

      // ---------- EMPTY ----------
      if (controller.categories.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              "No categories available",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }

      // ---------- GRID ----------
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final UserCategoryModel cat = controller.categories[index];

            return _CategoryCard(
              category: cat,
              onTap: () {
                final companyController =
                Get.put(CompanyController());
                companyController.clearShops();
                companyController.fetchShopsByCategory(cat.id);
                Get.to(() => const Categoriesofshoplist());
              },
            );
          },
        ),
      );
    });
  }
}

/// ================= CATEGORY CARD =================
class _CategoryCard extends StatelessWidget {
  final UserCategoryModel category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // ICON CONTAINER
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                category.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.category,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // TITLE
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
