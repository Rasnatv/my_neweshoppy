
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../controller/addproduct_controller.dart';


/// Add Product Page with Enhanced Variant Generation UI
class AddProductPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:AppColors.kPrimary,
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

                      // Show variant configuration if category has variant attributes
                      if (controller.selectedCategory.value.isNotEmpty &&
                          controller.hasVariantAttributes()) ...[
                        _buildVariantConfigurationCard(context),
                        SizedBox(height: 24),
                      ],

                      // Show generated variants list
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

  // NEW: Enhanced Variant Configuration Card
  Widget _buildVariantConfigurationCard(BuildContext context) {
    final config = controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.variantAttributes.isEmpty) return SizedBox.shrink();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: Color(0xFF3B82F6), size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Variant Configuration",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      "Add values for each variant type to generate all combinations",
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Display each variant type
          ...config.variantAttributes.map((variantType) {
            return _buildVariantTypeSection(variantType);
          }).toList(),

          SizedBox(height: 20),

          // Preview and Generate Button
          Obx(() {
            if (controller.configuredVariantTypes.isNotEmpty) {
              return _buildGenerateVariantsSection();
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildVariantTypeSection(String variantType) {
    return Obx(() {
      final values = controller.configuredVariantTypes[variantType] ?? [];
      final isExpanded = controller.expandedVariantType.value == variantType;

      return Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: values.isNotEmpty ? Color(0xFF10B981) : Color(0xFFE5E7EB),
            width: values.isNotEmpty ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Header
            InkWell(
              onTap: () {
                if (isExpanded) {
                  controller.expandedVariantType.value = '';
                } else {
                  controller.expandedVariantType.value = variantType;
                  controller.selectedVariantType.value = variantType;
                  controller.currentVariantValues.value = List.from(values);
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: values.isNotEmpty
                            ? Color(0xFF10B981).withOpacity(0.1)
                            : Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        values.isNotEmpty ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: values.isNotEmpty ? Color(0xFF10B981) : Color(0xFF3B82F6),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            variantType,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          if (values.isNotEmpty)
                            Text(
                              "${values.length} value(s): ${values.join(', ')}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          else
                            Text(
                              "Tap to add values",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Color(0xFF6B7280),
                    ),
                  ],
                ),
              ),
            ),

            // Expanded content
            if (isExpanded) ...[
              Divider(height: 1),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display current values
                    if (values.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: values.map((value) {
                          return Chip(
                            label: Text(value),
                            deleteIcon: Icon(Icons.close, size: 16),
                            onDeleted: () => controller.removeVariantValue(value),
                            backgroundColor: Color(0xFF3B82F6).withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: Color(0xFF3B82F6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 12),
                    ],

                    // Input field
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFFE5E7EB)),
                            ),
                            child: TextField(
                              controller: controller.variantValueController,
                              decoration: InputDecoration(
                                hintText: "e.g., ${_getExampleValue(variantType)}",
                                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                prefixIcon: Icon(Icons.add, size: 18, color: Color(0xFF6B7280)),
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
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text("Add", style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),
                    Text(
                      "💡 Tip: Separate multiple values with commas (e.g., S, M, L)",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildGenerateVariantsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF10B981).withOpacity(0.1),
            Color(0xFF10B981).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.preview, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Variants Preview",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              // Clear configuration button
              TextButton.icon(
                onPressed: () => _showClearConfigurationDialog(Get.context!),
                icon: Icon(Icons.refresh, size: 18),
                label: Text("Reset"),
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Show combinations that will be generated
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.configuredVariantTypes.entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${entry.key}:",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value.join(", "),
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                Divider(height: 20),
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Color(0xFF10B981)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Will generate ${_calculateTotalCombinations()} combination(s)",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                if (controller.variants.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Color(0xFF3B82F6)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${controller.variants.length} variant(s) already exist. New ones will be added.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 16),

          // Generate button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.generateVariantsFromType,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF10B981),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              icon: Icon(Icons.add_circle_outline, size: 20),
              label: Text(
                controller.variants.isEmpty ? "Generate Variants" : "Add More Variants",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          SizedBox(height: 8),
          Center(
            child: Text(
              controller.variants.isEmpty
                  ? "Each variant will have its own price, stock, and image"
                  : "Keep adding more color/size combinations incrementally",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfigurationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
              SizedBox(width: 12),
              Text("Reset Configuration?"),
            ],
          ),
          content: Text(
            "This will clear all configured variant types. Generated variants will not be affected.",
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.clearVariantConfiguration();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF4444)),
              child: Text("Reset"),
            ),
          ],
        );
      },
    );
  }

  int _calculateTotalCombinations() {
    if (controller.configuredVariantTypes.isEmpty) return 0;

    int total = 1;
    for (var values in controller.configuredVariantTypes.values) {
      total *= values.length;
    }
    return total;
  }

  String _getExampleValue(String attribute) {
    final examples = {
      'size': 'S, M, L',
      'color': 'Red, Blue',
      'colour': 'Red, Blue',
      'Size': 'S, M, L',
      'Color': 'Red, Blue',
      'Colour': 'Red, Blue',
      'material': 'Cotton, Polyester',
      'style': 'Casual, Formal',
    };
    return examples[attribute.toLowerCase()] ?? 'Value1, Value2';
  }

  Widget _buildVariantsHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF10B981), width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.inventory_2, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Generated Variants",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      "${controller.variants.length} variant(s) • Set price, stock & image for each",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showClearAllVariantsDialog(Get.context!),
                icon: Icon(Icons.delete_sweep, color: Color(0xFFEF4444)),
                tooltip: "Clear all variants",
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF10B981).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Color(0xFF10B981)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "You can add more variants incrementally by configuring more combinations above",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllVariantsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
              SizedBox(width: 12),
              Text("Clear All Variants?"),
            ],
          ),
          content: Text(
            "Are you sure you want to remove all ${controller.variants.length} generated variants? This action cannot be undone.",
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.variants.clear();
                Navigator.of(context).pop();
                Get.snackbar(
                  "Variants Cleared",
                  "All variants have been removed",
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF4444)),
              child: Text("Clear All"),
            ),
          ],
        );
      },
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
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3B82F6).withOpacity(0.1),
                  Color(0xFF3B82F6).withOpacity(0.05),
                ],
              ),
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
                    color: Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "#${index + 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    variant.getDisplayName(),
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 22),
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
                if (variant.attributes.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Variant Specifications",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: variant.attributes.entries.map((entry) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Color(0xFFE5E7EB)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${entry.key}:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
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
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: variant.imagePath != null
                    ? Color(0xFF10B981)
                    : Color(0xFFE5E7EB),
                width: 2,
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
                Text(
                  "Required",
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
            "Are you sure you want to remove this variant? This action cannot be undone.",
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