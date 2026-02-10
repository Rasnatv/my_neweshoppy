//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../common/style/app_colors.dart';
// import '../../../../common/style/app_text_style.dart';
// import '../controller/admin_addcategory_controller.dart';
// import 'admin_categorieslist.dart';
//
// class AddCategoryPage extends StatelessWidget {
//   AddCategoryPage({super.key});
//
//   final controller = Get.put(AdminCategoryController());
//
//   final commonCtrl = TextEditingController();
//   final variantCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Add Category",
//           style: AppTextStyle.rTextNunitoWhite17w700,
//         ),
//         backgroundColor: AppColors.kPrimary,
//         actions: [
//           IconButton(onPressed: ()=>Get.to(()=>AdminCategoryListPage()), icon: Icon(Icons.category))
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// CATEGORY NAME
//             _label("Category Name"),
//             TextField(
//               controller: controller.titleCtrl,
//               decoration: const InputDecoration(
//                 hintText: "Enter category name",
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             /// IMAGE
//             _label("Category Image"),
//             const SizedBox(height: 8),
//             Obx(
//                   () => GestureDetector(
//                 onTap: controller.pickImage,
//                 child: Container(
//                   height: 180,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: controller.imageFile.value == null
//                       ? const Center(child: Text("Tap to upload image"))
//                       : Image.file(
//                     controller.imageFile.value!,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             /// COMMON ATTRIBUTES
//             _label("Common Attributes"),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: commonCtrl,
//                     decoration:
//                     const InputDecoration(hintText: "Brand, Material"),
//                     onSubmitted: (v) {
//                       controller.addCommon(v.trim());
//                       commonCtrl.clear();
//                     },
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () {
//                     controller.addCommon(commonCtrl.text.trim());
//                     commonCtrl.clear();
//                   },
//                 ),
//               ],
//             ),
//
//             Obx(() => Wrap(
//               spacing: 8,
//               children: controller.commonAttributes
//                   .map(
//                     (e) => Chip(
//                   label: Text(e),
//                   onDeleted: () => controller.removeCommon(e),
//                 ),
//               )
//                   .toList(),
//             )),
//
//             const SizedBox(height: 24),
//
//             /// VARIANT ATTRIBUTES
//             _label("Variant Attributes"),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: variantCtrl,
//                     decoration:
//                     const InputDecoration(hintText: "Size, Color"),
//                     onSubmitted: (v) {
//                       controller.addVariant(v.trim());
//                       variantCtrl.clear();
//                     },
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () {
//                     controller.addVariant(variantCtrl.text.trim());
//                     variantCtrl.clear();
//                   },
//                 ),
//               ],
//             ),
//
//             Obx(() => Wrap(
//               spacing: 8,
//               children: controller.variantAttributes
//                   .map(
//                     (e) => Chip(
//                   label: Text(e),
//                   onDeleted: () => controller.removeVariant(e),
//                 ),
//               )
//                   .toList(),
//             )),
//
//             const SizedBox(height: 32),
//
//             /// SUBMIT BUTTON
//             Obx(
//                   () => SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed:
//                   controller.isLoading.value ? null : controller.submit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.kPrimary,
//                   ),
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Create Category"),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _label(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 15,
//         ),
//       ),
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Add Category",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => AdminCategoryListPage()),
            icon: const Icon(Icons.list_alt_rounded,color: Colors.white),
            tooltip: 'View Categories',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            _buildHeader(),
            const SizedBox(height: 24),

            /// CATEGORY NAME CARD
            _buildCard(
              title: "Category Information",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Category Name", isRequired: true),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.titleCtrl,
                    hintText: "e.g., Electronics, Clothing, Books",
                    prefixIcon: Icons.category_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// IMAGE CARD
            _buildCard(
              title: "Category Image",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Upload Image", isRequired: true),
                  const SizedBox(height: 12),
                  Obx(
                        () => GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: controller.imageFile.value == null
                                ? Colors.grey.shade300
                                : AppColors.kPrimary.withOpacity(0.5),
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: controller.imageFile.value == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Tap to upload image",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "PNG, JPG up to 5MB",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                            : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                controller.imageFile.value!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: controller.pickImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// COMMON ATTRIBUTES CARD
            _buildCard(
              title: "Common Attributes",
              subtitle: "Attributes shared across all product variants",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: commonCtrl,
                          hintText: "e.g., Brand, Material, Weight",
                          prefixIcon: Icons.label_outline,
                          onSubmitted: (v) {
                            if (v.trim().isNotEmpty) {
                              controller.addCommon(v.trim());
                              commonCtrl.clear();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            if (commonCtrl.text.trim().isNotEmpty) {
                              controller.addCommon(commonCtrl.text.trim());
                              commonCtrl.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() => controller.commonAttributes.isEmpty
                      ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          "No common attributes added yet",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.commonAttributes
                        .map(
                          (e) => _buildAttributeChip(
                        label: e,
                        onDeleted: () => controller.removeCommon(e),
                        color: Colors.blue,
                      ),
                    )
                        .toList(),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// VARIANT ATTRIBUTES CARD
            _buildCard(
              title: "Variant Attributes",
              subtitle: "Attributes that differ between product variants",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: variantCtrl,
                          hintText: "e.g., Size, Color, Storage",
                          prefixIcon: Icons.tune,
                          onSubmitted: (v) {
                            if (v.trim().isNotEmpty) {
                              controller.addVariant(v.trim());
                              variantCtrl.clear();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            if (variantCtrl.text.trim().isNotEmpty) {
                              controller.addVariant(variantCtrl.text.trim());
                              variantCtrl.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() => controller.variantAttributes.isEmpty
                      ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          "No variant attributes added yet",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.variantAttributes
                        .map(
                          (e) => _buildAttributeChip(
                        label: e,
                        onDeleted: () => controller.removeVariant(e),
                        color: Colors.purple,
                      ),
                    )
                        .toList(),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// SUBMIT BUTTON
            Obx(
                  () => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                  controller.isLoading.value ? null : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    shadowColor: AppColors.kPrimary.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle_outline, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Create Category",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create New Category",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Fill in the details below to add a new product category",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _label(String text, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        if (isRequired)
          const Text(
            " *",
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey.shade400, size: 20)
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.kPrimary, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildAttributeChip({
    required String label,
    required VoidCallback onDeleted,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.purple,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(
              Icons.close,
              size: 16,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
