//
// import 'package:eshoppy/app/common/style/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../common/style/app_text_style.dart';
// import '../controller/admin_categorygetting_controller.dart';
//
// class AdminCategoryListPage extends StatelessWidget {
//   final AdminCategoryListController controller =
//   Get.put(AdminCategoryListController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         title: Text(
//           "Categories",
//           style: AppTextStyle.rTextNunitoWhite17w700,
//         ),
//         backgroundColor: AppColors.kPrimary,
//         foregroundColor: Colors.black87,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Loading categories...",
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (controller.categories.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.category_outlined,
//                   size: 80,
//                   color: Colors.grey[300],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "No categories found",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Categories will appear here once added",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return RefreshIndicator(
//           onRefresh: () => controller.fetchCategories(),
//           color: Colors.blueAccent,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: controller.categories.length,
//                   itemBuilder: (context, index) {
//                     final category = controller.categories[index];
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.04),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         leading: Container(
//                           width: 60,
//                           height: 60,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.grey[100],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.network(
//                               category.image,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) => Icon(
//                                 Icons.category,
//                                 color: Colors.grey[400],
//                                 size: 30,
//                               ),
//                               loadingBuilder: (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return Center(
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.grey[300]!,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           category.name,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         subtitle: category.attributes.isNotEmpty
//                             ? Padding(
//                           padding: const EdgeInsets.only(top: 6),
//                           child: Wrap(
//                             spacing: 6,
//                             runSpacing: 4,
//                             children: [
//                               ...category.attributes
//                                   .take(3) // Only show first 3 attributes
//                                   .map(
//                                     (attr) => Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue[50],
//                                     borderRadius: BorderRadius.circular(6),
//                                     border: Border.all(
//                                       color: Colors.blue[100]!,
//                                       width: 0.5,
//                                     ),
//                                   ),
//                                   child: Text(
//                                     attr,
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.blue[700],
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                                   .toList(),
//                             ],
//                           ),
//                         )
//                             : Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: Text(
//                             "No attributes",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey[500],
//                             ),
//                           ),
//                         ),
//                         trailing: PopupMenuButton<String>(
//                           icon: Icon(
//                             Icons.more_vert,
//                             color: Colors.grey[600],
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           onSelected: (value) {
//                             switch (value) {
//                               case 'edit':
//                               // Navigate to edit page
//                                 break;
//                               case 'delete':
//                               // Show delete confirmation
//                                 break;
//                             }
//                           },
//                           itemBuilder: (BuildContext context) => [
//                             const PopupMenuItem(
//                               value: 'edit',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.edit_outlined, size: 20),
//                                   SizedBox(width: 12),
//                                   Text('Edit'),
//                                 ],
//                               ),
//                             ),
//                             const PopupMenuItem(
//                               value: 'delete',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.delete_outline,
//                                       size: 20, color: Colors.red),
//                                   SizedBox(width: 12),
//                                   Text('Delete',
//                                       style: TextStyle(color: Colors.red)),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           // Navigate to add category page
//         },
//         icon: const Icon(Icons.add),
//         label: const Text("Add Category"),
//         backgroundColor: Colors.blueAccent,
//         elevation: 4,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eshoppy/app/common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../controller/admin_categorygetting_controller.dart';

class AdminCategoryListPage extends StatelessWidget {
  AdminCategoryListPage({super.key});

  final AdminCategoryListController controller =
  Get.put(AdminCategoryListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Categories",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return const Center(child: Text("No categories found"));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchCategories,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      category.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.category),
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: _buildAttributes(category),
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text("Edit")),
                      PopupMenuItem(value: 'delete', child: Text("Delete")),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Add Category"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAttributes(category) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (category.commonAttributes.isNotEmpty) ...[
            _label("Common"),
            _chipWrap(category.commonAttributes, Colors.green),
          ],
          if (category.variantAttributes.isNotEmpty) ...[
            _label("Variant"),
            _chipWrap(category.variantAttributes, Colors.blue),
          ],
          if (category.commonAttributes.isEmpty &&
              category.variantAttributes.isEmpty &&
              category.legacyAttributes.isNotEmpty)
            _chipWrap(category.legacyAttributes, Colors.orange),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _chipWrap(List<String> list, Color color) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: list.take(3).map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            e,
            style: TextStyle(fontSize: 11, color: color),
          ),
        );
      }).toList(),
    );
  }
}
