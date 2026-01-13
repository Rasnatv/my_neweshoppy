
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/addproduct_controller.dart';

class AddProductPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.kPrimary,
        foregroundColor: Color(0xFF1A1A1A),
        title: Text(
          "Add New Product",style:  AppTextStyle.rTextNunitoWhite16w600
          ),

        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () => _saveProduct(context),
            tooltip: "Add Product",
          ),
        ],
      ),
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Basic Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Fill in the essential details about your product",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Product Name Card
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Product Name", Icons.shopping_bag_outlined),
                        SizedBox(height: 12),
                        _buildTextField(
                          label: "Enter product name",
                          hint: "e.g., Classic Cotton T-Shirt",
                          icon: Icons.label_outline,
                          onChanged: (val) => controller.productName.value = val,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Category Card
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Category", Icons.category_outlined),
                        SizedBox(height: 12),
                        _buildCategoryDropdown(context),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Variants Section
                  if (controller.selectedCategory.value.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product Variants",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF3B82F6).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: controller.addVariant,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, color: Colors.white, size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      "Add Variant",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Variant Cards
                    if (controller.variants.isEmpty)
                      _buildEmptyState()
                    else
                      ...controller.variants.asMap().entries.map((entry) {
                        return _buildVariantCard(context, entry.key, entry.value);
                      }).toList(),
                  ],

                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: Obx(() => controller.variants.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: () => _saveProduct(context),
        backgroundColor: Color(0xFF10B981),
        icon: Icon(Icons.check_circle_outline),
        label: Text(
          "Save Product",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 4,
      )
          : SizedBox.shrink()),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF3B82F6), size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    String? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Color(0xFF6B7280), size: 20),
          suffixText: suffix,
          suffixStyle: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.list_alt, color: Color(0xFF6B7280), size: 20),
          hintText: "Choose a category",
          hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
        value: controller.selectedCategory.value.isEmpty
            ? null
            : controller.selectedCategory.value,
        items: controller.categoryAttributes.keys
            .map((c) => DropdownMenuItem(
          value: c,
          child: Text(c, style: TextStyle(fontSize: 15)),
        ))
            .toList(),
        onChanged: (val) {
          controller.selectedCategory.value = val!;
          controller.variants.clear();
        },
        dropdownColor: Colors.white,
        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB), width: 2, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF3B82F6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: Color(0xFF3B82F6),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "No variants added yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Click 'Add Variant' to create product variations",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVariantCard(BuildContext context, int index, variant) {
    var featureKeys = controller.categoryAttributes[controller.selectedCategory.value] ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Variant Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF3B82F6).withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Variant ${index + 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                  onPressed: () => _showDeleteDialog(context, index),
                  tooltip: "Remove variant",
                ),
              ],
            ),
          ),

          // Variant Content
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                _buildImagePicker(context, index, variant),
                SizedBox(height: 16),

                // Price and Stock Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: "Price",
                        hint: "0.00",
                        icon: Icons.currency_rupee,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (val) => variant.price = double.tryParse(val),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        label: "Stock",
                        hint: "0",
                        icon: Icons.inventory_outlined,
                        keyboardType: TextInputType.number,
                        suffix: "units",
                        onChanged: (val) => variant.stock = int.tryParse(val),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Features Section
                Text(
                  "Attributes",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    children: featureKeys.map((key) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: key == featureKeys.last ? 0 : 12),
                        child: TextField(
                          onChanged: (val) => variant.features[key] = val,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: key,
                            hintText: "Enter $key",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            labelStyle: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                            hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, int index, variant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product Image",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () => controller.pickImage(index),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFE5E7EB),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: variant.imagePath == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF3B82F6).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 40,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Tap to add image",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "JPG, PNG up to 10MB",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            )
                : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(variant.imagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Color(0xFF3B82F6), size: 20),
                      onPressed: () => controller.pickImage(index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
              SizedBox(width: 12),
              Text("Remove Variant?"),
            ],
          ),
          content: Text(
            "Are you sure you want to remove this variant? This action cannot be undone.",
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Color(0xFF6B7280))),
            ),
            ElevatedButton(
              onPressed: () {
                controller.removeVariant(index);
                Navigator.of(context).pop();
                Get.snackbar(
                  "Removed",
                  "Variant has been removed",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFFEF4444),
                  colorText: Colors.white,
                  margin: EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Remove"),
            ),
          ],
        );
      },
    );
  }

  void _saveProduct(BuildContext context) {
    if (controller.productName.value.isEmpty) {
      Get.snackbar(
        "Missing Information",
        "Please enter a product name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFF59E0B),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.info_outline, color: Colors.white),
      );
      return;
    }

    if (controller.selectedCategory.value.isEmpty) {
      Get.snackbar(
        "Missing Information",
        "Please select a category",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFF59E0B),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.info_outline, color: Colors.white),
      );
      return;
    }

    if (controller.variants.isEmpty) {
      Get.snackbar(
        "Missing Information",
        "Please add at least one variant",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFF59E0B),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.info_outline, color: Colors.white),
      );
      return;
    }

    // Validation passed, show success
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Color(0xFF10B981),
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Product Saved!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Your product has been successfully added",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print("Product Name: ${controller.productName.value}");
                  print("Category: ${controller.selectedCategory.value}");
                  print("Variants: ${controller.variants}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF10B981),
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );
      },

    );
  }
}