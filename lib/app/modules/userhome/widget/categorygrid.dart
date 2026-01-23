//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../data/models/user_category model.dart';
// import '../controller/company_controller.dart';
// import '../controller/usercategory_controller.dart';
// import '../controller/usershoplist_controller.dart';
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
//           final UserCategoryModel cat =
//           controller.categories[index];
//
//           return GestureDetector(
//               onTap: () {
//                 final controller = Get.put(CompanyController());
//                 controller.clearShops();
//                 controller.fetchShopsByCategory(cat.id);
//
//                 Get.to(() => const Categoriesofshoplist());
//               },
//               child: Column(
//             children: [
//
//               CircleAvatar(
//                 radius: 28,
//                 backgroundImage: NetworkImage(cat.image),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 cat.name,
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 12),
//               ),
//             ],
//           ));
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
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.categories.isEmpty) {
        return const Center(child: Text("No categories available"));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final UserCategoryModel cat = controller.categories[index];

          return GestureDetector(
            onTap: () {
              final companyController = Get.put(CompanyController());
              companyController.clearShops();
              companyController.fetchShopsByCategory(cat.id);
              Get.to(() => const Categoriesofshoplist());
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(cat.image),
                ),
                const SizedBox(height: 6),
                Text(
                  cat.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
