//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../common/style/app_colors.dart';
// import '../../../../common/style/app_text_style.dart';
// import '../controller/admin_addcategory_controller.dart';
// import 'admin_categorieslist.dart';
//
// class AddCategoryPage extends StatelessWidget {
//   AddCategoryPage({super.key});
//
//   final AdminCategoryController controller = Get.put(AdminCategoryController());
//   final attrCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         title: Text(
//           "Add Category",
//           style: AppTextStyle.rTextNunitoWhite17w700,
//         ),
//         backgroundColor: AppColors.kPrimary,
//         actions: [
//           IconButton(
//             onPressed: () => Get.to(() => AdminCategoryListPage()),
//             icon: const Icon(Icons.list_alt_rounded),
//             tooltip: "View Categories",
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: AppColors.kPrimary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(
//                       Icons.category_rounded,
//                       color: AppColors.kPrimary,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Create New Category",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Fill in the details below",
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // Form Section
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Category Name Section
//                   _buildSectionLabel("Category Name", Icons.title),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: controller.titleCtrl,
//                     style: const TextStyle(fontSize: 15),
//                     decoration: InputDecoration(
//                       hintText: "Enter category name",
//                       hintStyle: TextStyle(color: Colors.grey[400]),
//                       prefixIcon: Icon(
//                         Icons.label_outline,
//                         color: Colors.grey[400],
//                         size: 22,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[50],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.grey[300]!),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.grey[300]!),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                           color: AppColors.kPrimary,
//                           width: 2,
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 16,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Image Upload Section
//                   _buildSectionLabel("Category Image", Icons.image),
//                   const SizedBox(height: 12),
//                   Obx(() => GestureDetector(
//                     onTap: controller.pickImage,
//                     child: Container(
//                       height: 200,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[50],
//                         border: Border.all(
//                           color: Colors.grey[300]!,
//                           width: 2,
//                           style: BorderStyle.solid,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: controller.imageFile.value == null
//                           ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: AppColors.kPrimary
//                                   .withOpacity(0.1),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.cloud_upload_outlined,
//                               size: 48,
//                               color: AppColors.kPrimary,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             "Tap to upload image",
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Supports: JPG, PNG (Max 5MB)",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[500],
//                             ),
//                           ),
//                         ],
//                       )
//                           : Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.file(
//                               controller.imageFile.value!,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               height: double.infinity,
//                             ),
//                           ),
//                           Positioned(
//                             top: 8,
//                             right: 8,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.black54,
//                                 borderRadius:
//                                 BorderRadius.circular(20),
//                               ),
//                               child: IconButton(
//                                 icon: const Icon(
//                                   Icons.edit,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                                 onPressed: controller.pickImage,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )),
//                   const SizedBox(height: 24),
//
//                   // Attributes Section
//                   _buildSectionLabel("Attributes", Icons.tune),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: attrCtrl,
//                           style: const TextStyle(fontSize: 15),
//                           decoration: InputDecoration(
//                             hintText: "e.g., Size, Color, Material",
//                             hintStyle: TextStyle(color: Colors.grey[400]),
//                             prefixIcon: Icon(
//                               Icons.add_circle_outline,
//                               color: Colors.grey[400],
//                               size: 22,
//                             ),
//                             filled: true,
//                             fillColor: Colors.grey[50],
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.grey[300]!),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.grey[300]!),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(
//                                 color: AppColors.kPrimary,
//                                 width: 2,
//                               ),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 16,
//                             ),
//                           ),
//                           onSubmitted: (value) {
//                             if (value.trim().isNotEmpty) {
//                               controller.addAttribute(value.trim());
//                               attrCtrl.clear();
//                             }
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Container(
//                         height: 52,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           gradient: LinearGradient(
//                             colors: [
//                               AppColors.kPrimary,
//                               AppColors.kPrimary.withOpacity(0.8),
//                             ],
//                           ),
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (attrCtrl.text.trim().isNotEmpty) {
//                               controller.addAttribute(attrCtrl.text.trim());
//                               attrCtrl.clear();
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             shadowColor: Colors.transparent,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             padding: const EdgeInsets.symmetric(horizontal: 24),
//                           ),
//                           child: const Text(
//                             "Add",
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Attributes Display
//                   Obx(() {
//                     if (controller.attributes.isEmpty) {
//                       return Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[50],
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.grey[200]!),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.info_outline,
//                               color: Colors.grey[400],
//                               size: 20,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 "No attributes added yet",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     return Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50]?.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.blue[100]!),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.check_circle,
//                                 color: Colors.green[600],
//                                 size: 18,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "${controller.attributes.length} attribute(s) added",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: controller.attributes
//                                 .map(
//                                   (e) => Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                     color: AppColors.kPrimary
//                                         .withOpacity(0.3),
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.02),
//                                       blurRadius: 4,
//                                       offset: const Offset(0, 1),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       e,
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.grey[800],
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     GestureDetector(
//                                       onTap: () =>
//                                           controller.removeAttribute(e),
//                                       child: Container(
//                                         padding: const EdgeInsets.all(2),
//                                         decoration: BoxDecoration(
//                                           color: Colors.red[50],
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: Icon(
//                                           Icons.close,
//                                           size: 16,
//                                           color: Colors.red[600],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                                 .toList(),
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             // Submit Button
//             Obx(() => Container(
//               width: double.infinity,
//               height: 56,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 gradient: controller.isLoading.value
//                     ? null
//                     : LinearGradient(
//                   colors: [
//                     AppColors.kPrimary,
//                     AppColors.kPrimary.withOpacity(0.8),
//                   ],
//                 ),
//                 boxShadow: controller.isLoading.value
//                     ? null
//                     : [
//                   BoxShadow(
//                     color: AppColors.kPrimary.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 onPressed:
//                 controller.isLoading.value ? null : controller.submit,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: controller.isLoading.value
//                       ? Colors.grey[300]
//                       : Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   disabledBackgroundColor: Colors.grey[300],
//                 ),
//                 child: controller.isLoading.value
//                     ? Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.5,
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Colors.grey[600]!,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       "Creating...",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 )
//                     : const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.check_circle_outline,
//                       color: Colors.white,
//                       size: 22,
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       "Create Category",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionLabel(String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 20,
//           color: AppColors.kPrimary,
//         ),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           "*",
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Colors.red[600],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../controller/admin_addcategory_controller.dart';
import 'admin_categorieslist.dart';

class AddCategoryPage extends StatelessWidget {
  AddCategoryPage({super.key});

  final controller = Get.put(AdminCategoryController());

  final commonCtrl = TextEditingController();
  final variantCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Category",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
        actions: [
          IconButton(onPressed: ()=>Get.to(()=>AdminCategoryListPage()), icon: Icon(Icons.category))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CATEGORY NAME
            _label("Category Name"),
            TextField(
              controller: controller.titleCtrl,
              decoration: const InputDecoration(
                hintText: "Enter category name",
              ),
            ),

            const SizedBox(height: 20),

            /// IMAGE
            _label("Category Image"),
            const SizedBox(height: 8),
            Obx(
                  () => GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: controller.imageFile.value == null
                      ? const Center(child: Text("Tap to upload image"))
                      : Image.file(
                    controller.imageFile.value!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// COMMON ATTRIBUTES
            _label("Common Attributes"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commonCtrl,
                    decoration:
                    const InputDecoration(hintText: "Brand, Material"),
                    onSubmitted: (v) {
                      controller.addCommon(v.trim());
                      commonCtrl.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    controller.addCommon(commonCtrl.text.trim());
                    commonCtrl.clear();
                  },
                ),
              ],
            ),

            Obx(() => Wrap(
              spacing: 8,
              children: controller.commonAttributes
                  .map(
                    (e) => Chip(
                  label: Text(e),
                  onDeleted: () => controller.removeCommon(e),
                ),
              )
                  .toList(),
            )),

            const SizedBox(height: 24),

            /// VARIANT ATTRIBUTES
            _label("Variant Attributes"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: variantCtrl,
                    decoration:
                    const InputDecoration(hintText: "Size, Color"),
                    onSubmitted: (v) {
                      controller.addVariant(v.trim());
                      variantCtrl.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    controller.addVariant(variantCtrl.text.trim());
                    variantCtrl.clear();
                  },
                ),
              ],
            ),

            Obx(() => Wrap(
              spacing: 8,
              children: controller.variantAttributes
                  .map(
                    (e) => Chip(
                  label: Text(e),
                  onDeleted: () => controller.removeVariant(e),
                ),
              )
                  .toList(),
            )),

            const SizedBox(height: 32),

            /// SUBMIT BUTTON
            Obx(
                  () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                  controller.isLoading.value ? null : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Create Category"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
