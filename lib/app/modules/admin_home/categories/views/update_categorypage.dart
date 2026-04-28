import 'package:eshoppy/app/modules/admin_home/categories/views/update_categorycontroller.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';


class EditCategoryPage extends StatelessWidget {
  EditCategoryPage({super.key});

  // ── Controller (fresh instance per navigation) ───────────────────────────
  final controller = Get.put(AdminEditCategoryController());

  // ── Local text controllers for attribute input fields ────────────────────
  final commonCtrl = TextEditingController();
  final variantCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // category_id is passed via Get.arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final int categoryId = args['category_id'] ?? 0;

    // Fetch + pre-fill on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(categoryId);
    });

    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Edit Category",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.kPrimary),
          );
        }
        return SingleChildScrollView(
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
                    _label("Upload Image"),
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
                          child: controller.imageFile.value != null
                          // ── Newly picked local image ──────────────
                              ? Stack(
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
                              _editOverlay(),
                            ],
                          )
                              : controller.existingImageUrl.isNotEmpty
                          // ── Existing network image ────────────
                              ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(10),
                                child: Image.network(
                                  controller.existingImageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (_, __, ___) =>
                                      _uploadPlaceholder(),
                                ),
                              ),
                              _editOverlay(),
                            ],
                          )
                          // ── No image yet ──────────────────────
                              : _uploadPlaceholder(),
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
                    // ── Existing chips (pre-filled from API) ────────────
                    Obx(() => controller.commonAttributes.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Attributes",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.commonAttributes
                              .map(
                                (e) => _buildAttributeChip(
                              label: e,
                              onDeleted: () =>
                                  controller.removeCommon(e),
                              color: Colors.blue,
                            ),
                          )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 12),
                      ],
                    )
                        : const SizedBox()),

                    // ── Add new common attribute ─────────────────────────
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

                    // ── Empty state ──────────────────────────────────────
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
                        : const SizedBox()),
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
                    // ── Existing chips (pre-filled from API) ────────────
                    Obx(() => controller.variantAttributes.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Attributes",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.variantAttributes
                              .map(
                                (e) => _buildAttributeChip(
                              label: e,
                              onDeleted: () =>
                                  controller.removeVariant(e),
                              color: Colors.purple,
                            ),
                          )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 12),
                      ],
                    )
                        : const SizedBox()),

                    // ── Add new variant attribute ─────────────────────────
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

                    // ── Empty state ──────────────────────────────────────
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
                        : const SizedBox()),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// UPDATE BUTTON
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: controller.isUpdating.value
                        ? null
                        : controller.submit,
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
                    child: controller.isUpdating.value
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
                          "Update Category",
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
        );
      }),
    ));
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Edit Category",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Update the details below to modify this product category",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ── Upload placeholder ────────────────────────────────────────────────────

  Widget _uploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined,
            size: 48, color: Colors.grey.shade400),
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
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
      ],
    );
  }

  // ── Edit overlay on image ─────────────────────────────────────────────────

  Widget _editOverlay() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: const Icon(Icons.edit, color: Colors.white, size: 20),
          onPressed: controller.pickImage,
        ),
      ),
    );
  }

  // ── Shared card ───────────────────────────────────────────────────────────

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
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
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
                color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
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
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(Icons.close, size: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }
}