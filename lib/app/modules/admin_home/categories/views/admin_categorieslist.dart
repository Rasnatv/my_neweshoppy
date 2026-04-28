
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshoppy/app/modules/admin_home/categories/views/update_categorypage.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eshoppy/app/common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';
import '../../../../widgets/delete_widget.dart';
import '../controller/admin_categorygetting_controller.dart';
import 'Admin_catgorypage.dart';

class AdminCategoryListPage extends StatelessWidget {
  AdminCategoryListPage({super.key});

  final AdminCategoryListController controller =
  Get.put(AdminCategoryListController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child: Scaffold(

      backgroundColor: Colors.grey[50],

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Categories",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
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
                    child: CachedNetworkImage(
                      imageUrl: category.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,

                      // 🔄 Loading UI
                      placeholder: (context, url) => Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),

                      // ❌ Error UI
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.category),
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: _buildAttributes(category),
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: const Text("Edit"),
                        onTap: () => Get.to(
                              () => EditCategoryPage(),
                          arguments: {'category_id': category.id},
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            DeleteConfirmDialog.show(
                              context: Get.context!, // 👈 important
                              title: "Delete Category",
                              message:
                              'Are you sure you want to delete "${category.name}"?',
                              onConfirm: () {
                                controller.deleteCategory(category.id);
                              },
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    ));
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