
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/addproduct_controller.dart';


/// Add Product Page with Variant Type Dropdown
class AddProductPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        title: Text(
          "Add New Product",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Obx(() => controller.isSubmitting.value
              ? Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
              : IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () => _saveProduct(context),
            tooltip: "Save Product",
          )),
        ],
      ),
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProductNameCard(),
                      SizedBox(height: 16),
                      _buildDescriptionCard(),
                      SizedBox(height: 16),
                      _buildCategoryCard(context),
                      SizedBox(height: 24),

                      // Show common attributes section if category selected
                      if (controller.selectedCategory.value.isNotEmpty) ...[
                        _buildCommonAttributesSection(),
                        SizedBox(height: 24),
                      ],

                      // Show variant type dropdown if category has variant attributes
                      if (controller.selectedCategory.value.isNotEmpty &&
                          controller.hasVariantAttributes()) ...[
                        _buildVariantTypeDropdown(context),
                        SizedBox(height: 24),
                      ],

                      // Show selected variants list
                      if (controller.variants.isNotEmpty) ...[
                        _buildVariantsHeader(),
                        SizedBox(height: 16),
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
          ),
          if (controller.isSubmitting.value)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          "Saving product...",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      )),
      floatingActionButton: Obx(() => controller.variants.isNotEmpty &&
          !controller.isSubmitting.value
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

  Widget _buildHeader() {
    return Container(
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
    );
  }

  Widget _buildProductNameCard() {
    return _buildCard(
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
    );
  }

  Widget _buildDescriptionCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Product Description", Icons.description_outlined),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E7EB)),
            ),
            child: TextField(
              onChanged: (val) => controller.productDescription.value = val,
              style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Describe your product in detail...",
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Icon(Icons.text_fields, color: Color(0xFF6B7280), size: 20),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Category", Icons.category_outlined),
          SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingCategories.value) {
              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE5E7EB)),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (controller.apiCategories.isEmpty) {
              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text("No categories available"),
                    ),
                    TextButton(
                      onPressed: () => controller.fetchCategories(),
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            }

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
                items: controller.apiCategories
                    .map((c) => DropdownMenuItem(
                  value: c.name,
                  child: Text(c.name, style: TextStyle(fontSize: 15)),
                ))
                    .toList(),
                onChanged: (val) {
                  controller.onCategoryChanged(val!);
                },
                dropdownColor: Colors.white,
                icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommonAttributesSection() {
    final config = controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.commonAttributes.isEmpty) return SizedBox.shrink();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Common Attributes", Icons.info_outline),
          SizedBox(height: 8),
          Text(
            "These attributes apply to all variants",
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          SizedBox(height: 16),
          ...config.commonAttributes.map((attr) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _buildCommonAttributeInput(attr),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCommonAttributeInput(String attribute) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextField(
        onChanged: (value) => controller.setCommonAttribute(attribute, value),
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: attribute,
          hintText: "Enter $attribute",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  // NEW: Variant Type Dropdown - shows variant attribute types (Size, Color, etc.)
  Widget _buildVariantTypeDropdown(BuildContext context) {
    final config = controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.variantAttributes.isEmpty) return SizedBox.shrink();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Select Variant Type", Icons.tune),
          SizedBox(height: 8),
          Text(
            "Choose which variant type to add (Size, Color, etc.)",
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          SizedBox(height: 16),

          // Show already configured variant types
          Obx(() {
            if (controller.configuredVariantTypes.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Configured Types:",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.configuredVariantTypes.entries.map((entry) {
                      final isSelected = controller.selectedVariantType.value == entry.key;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFF10B981).withOpacity(0.1)
                              : Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Color(0xFF10B981)
                                : Color(0xFF3B82F6),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: isSelected
                                  ? Color(0xFF10B981)
                                  : Color(0xFF3B82F6),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "${entry.key} (${entry.value.length})",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Color(0xFF10B981)
                                    : Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                ],
              );
            }
            return SizedBox.shrink();
          }),

          // Dropdown to select variant attribute type
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E7EB)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.category, color: Color(0xFF6B7280), size: 20),
                hintText: "Select variant type",
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              ),
              value: controller.selectedVariantType.value.isEmpty
                  ? null
                  : controller.selectedVariantType.value,
              items: config.variantAttributes.map((attr) {
                final hasValues = controller.configuredVariantTypes.containsKey(attr);
                return DropdownMenuItem(
                  value: attr,
                  child: Row(
                    children: [
                      Text(attr, style: TextStyle(fontSize: 15)),
                      if (hasValues) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${controller.configuredVariantTypes[attr]!.length}",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.onVariantTypeSelected(value);
                }
              },
              dropdownColor: Colors.white,
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
            )),
          ),

          // Show variant values input section when a type is selected
          Obx(() {
            if (controller.selectedVariantType.value.isEmpty) {
              return SizedBox.shrink();
            }

            return Column(
              children: [
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                _buildVariantValuesSection(),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVariantValuesSection() {
    return Obx(() {
      final variantType = controller.selectedVariantType.value;
      final values = controller.currentVariantValues;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list, color: Color(0xFF3B82F6), size: 20),
              SizedBox(width: 8),
              Text(
                "$variantType Values",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Spacer(),
              if (values.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${values.length} value(s)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),

          // Display added values
          if (values.isNotEmpty)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE5E7EB)),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: values.map((value) {
                  return Chip(
                    label: Text(value),
                    deleteIcon: Icon(Icons.close, size: 18),
                    onDeleted: () => controller.removeVariantValue(value),
                    backgroundColor: Color(0xFF3B82F6).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE5E7EB)),
              ),
              child: Center(
                child: Text(
                  "No values added yet for $variantType",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),

          SizedBox(height: 12),

          // Input to add new value
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFE5E7EB)),
                  ),
                  child: TextField(
                    controller: controller.variantValueController,
                    decoration: InputDecoration(
                      hintText: "Add $variantType value (e.g., ${_getExampleValue(variantType)})",
                      hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        controller.addVariantValue(value.trim());
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final value = controller.variantValueController.text.trim();
                  if (value.isNotEmpty) {
                    controller.addVariantValue(value);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3B82F6),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Add", style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Generate Variants Button - only show if we have configured types
          Obx(() {
            if (controller.configuredVariantTypes.isNotEmpty) {
              return Column(
                children: [
                  // Show summary of all configured types
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Color(0xFF10B981)),
                            SizedBox(width: 8),
                            Text(
                              "Ready to generate variants:",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        ...controller.configuredVariantTypes.entries.map((entry) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                SizedBox(width: 24),
                                Text(
                                  "• ${entry.key}: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value.join(", "),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.generateVariantsFromType,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF10B981),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.auto_awesome),
                      label: Text(
                        "Generate All Variants",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          }),
        ],
      );
    });
  }

  String _getExampleValue(String attribute) {
    final examples = {
      'size': 'S, M, L',
      'color': 'Red, Blue',
      'colour': 'Red, Blue',
      'Size': 'S, M, L',
      'Color': 'Red, Blue',
      'Colour': 'Red, Blue',
    };
    return examples[attribute] ?? 'Value';
  }

  Widget _buildVariantsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Variants",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Text(
              "${controller.variants.length} variant(s)",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVariantCard(BuildContext context, int index, ProductVariant variant) {
    final config = controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null) return SizedBox.shrink();

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Variant ${index + 1}",
                        style: TextStyle(
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        variant.getDisplayName(),
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
                  onPressed: () => _showDeleteDialog(context, index),
                  tooltip: "Remove variant",
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePicker(context, index, variant),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildPriceField(variant),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStockField(variant),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (variant.attributes.isNotEmpty) ...[
                  Text(
                    "Variant Attributes",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 12),
                  ...variant.attributes.entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: _buildVariantAttributeField(entry.key, entry.value),
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField(ProductVariant variant) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF10B981).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: TextField(
        controller: TextEditingController(text: variant.price?.toString() ?? ''),
        onChanged: (val) {
          variant.price = double.tryParse(val);
          controller.variants.refresh();
        },
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: "Price (₹)",
          hintText: "0.00",
          prefixIcon: Icon(Icons.currency_rupee, color: Color(0xFF10B981), size: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle: TextStyle(fontSize: 12, color: Color(0xFF10B981)),
          hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  Widget _buildStockField(ProductVariant variant) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: TextField(
        controller: TextEditingController(text: variant.stock?.toString() ?? ''),
        onChanged: (val) {
          variant.stock = int.tryParse(val);
          controller.variants.refresh();
        },
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: "Stock",
          hintText: "0",
          prefixIcon: Icon(Icons.inventory_outlined, color: Color(0xFF3B82F6), size: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle: TextStyle(fontSize: 12, color: Color(0xFF3B82F6)),
          hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  Widget _buildVariantAttributeField(String attribute, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: TextEditingController(text: value),
        enabled: false,
        style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        decoration: InputDecoration(
          labelText: attribute,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, int index, ProductVariant variant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () => controller.pickImage(index),
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E7EB), width: 2),
            ),
            child: variant.imagePath == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                  color: Color(0xFF3B82F6),
                ),
                SizedBox(height: 8),
                Text(
                  "Tap to add image",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
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
                      icon: Icon(Icons.edit, color: Color(0xFF3B82F6), size: 18),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Color(0xFF6B7280), size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      ),
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
            "Are you sure you want to remove this variant?",
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.removeVariant(index);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF4444)),
              child: Text("Remove"),
            ),
          ],
        );
      },
    );
  }

  void _saveProduct(BuildContext context) {
    if (!controller.validateForm()) return;
    controller.saveProduct();
  }
}
