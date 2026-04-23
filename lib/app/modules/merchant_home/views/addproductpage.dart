
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../controller/addproduct_controller.dart';
// import '../../../common/utils/app_snackbars.dart';

class AddProductPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.kPrimary,
        foregroundColor: Colors.white,
        title: const Text(
          "Add New Product",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
        ),
        actions: [
          Obx(() => controller.isSubmitting.value
              ? const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white)),
            ),
          )
              : IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: controller.saveProduct,
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProductNameCard(),
                      const SizedBox(height: 16),
                      _buildDescriptionCard(),
                      const SizedBox(height: 16),
                      _buildCategoryCard(),
                      const SizedBox(height: 24),

                      // Common attributes — only when category has them
                      if (controller.selectedCategory.value.isNotEmpty) ...[
                        _buildCommonAttributesSection(),
                        const SizedBox(height: 24),
                      ],

                      // Variant type configurator — only when category has variant attributes
                      if (controller.selectedCategory.value.isNotEmpty &&
                          controller.hasVariantAttributes()) ...[
                        _buildVariantConfigurationCard(),
                        const SizedBox(height: 24),
                      ],

                      // "Add Variant" button — ALWAYS visible (no category needed)
                      _buildAddPlainVariantButton(),
                      const SizedBox(height: 24),

                      if (controller.variants.isNotEmpty) ...[
                        _buildVariantsHeader(),
                        const SizedBox(height: 16),
                        ...controller.variants
                            .asMap()
                            .entries
                            .map((e) =>
                            _buildVariantCard(context, e.key, e.value))
                            .toList(),
                      ],
                      const SizedBox(height: 100),
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
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Saving product...",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      )),
      floatingActionButton: Obx(() =>
      controller.variants.isNotEmpty && !controller.isSubmitting.value
          ? FloatingActionButton.extended(
        onPressed: controller.saveProduct,
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.check_circle_outline),
        label: const Text("Save Product",
            style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 4,
      )
          : const SizedBox.shrink()),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Basic Information",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A))),
          SizedBox(height: 8),
          Text("Fill in the essential details about your product",
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  // ── Product Name ─────────────────────────────────────────────────────────────

  Widget _buildProductNameCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Product Name *", Icons.shopping_bag_outlined),
          const SizedBox(height: 12),
          // _buildTextField(
          //   label: "Enter product name",
          //   hint: "e.g., Classic Cotton T-Shirt",
          //   icon: Icons.label_outline,
          //   onChanged: (v) => controller.productName.value = v,
          // ),
          // AFTER
          _buildTextField(
            label: "Enter product name",
            hint: "e.g., Classic Cotton T-Shirt",
            icon: Icons.label_outline,
            controller: controller.productNameController,   // ← ADD
            onChanged: (v) => controller.productName.value = v,
          ),
        ],
      ),
    );
  }

  // ── Description ──────────────────────────────────────────────────────────────

  Widget _buildDescriptionCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
              "Product Description", Icons.description_outlined),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: controller.productDescriptionController,
              onChanged: (v) => controller.productDescription.value = v,
              maxLines: 4,
              style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
              decoration: InputDecoration(
                hintText: "Describe your product in detail...",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Icon(Icons.text_fields,
                      color: const Color(0xFF6B7280), size: 20),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category ─────────────────────────────────────────────────────────────────

  Widget _buildCategoryCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Category", Icons.category_outlined),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingCategories.value) {
              return _infoBox(
                  child: const Center(child: CircularProgressIndicator()));
            }
            if (controller.apiCategories.isEmpty) {
              return _infoBox(
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.orange),
                    const SizedBox(width: 12),
                    const Expanded(
                        child: Text("No categories available")),
                    TextButton(
                        onPressed: controller.fetchCategories,
                        child: const Text("Retry")),
                  ],
                ),
              );
            }
            return _infoBox(
              padding:
              const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.list_alt,
                      color: Color(0xFF6B7280), size: 20),
                  hintText: "Choose a category",
                  hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF), fontSize: 14),
                ),
                value: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value,
                items: controller.apiCategories
                    .map((c) => DropdownMenuItem(
                    value: c.name,
                    child: Text(c.name,
                        style: const TextStyle(fontSize: 15))))
                    .toList(),
                onChanged: (v) => controller.onCategoryChanged(v!),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF6B7280)),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Common Attributes ────────────────────────────────────────────────────────

  Widget _buildCommonAttributesSection() {
    final config =
    controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.commonAttributes.isEmpty) {
      return const SizedBox.shrink();
    }
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Common Attributes", Icons.info_outline),
          const SizedBox(height: 4),
          const Text("These attributes apply to all variants",
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
          const SizedBox(height: 16),
          ...config.commonAttributes.map((attr) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildCommonAttributeInput(attr),
          )),
        ],
      ),
    );
  }

  Widget _buildCommonAttributeInput(String attribute) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        onChanged: (v) => controller.setCommonAttribute(attribute, v),
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: attribute,
          hintText: "Enter $attribute",
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle:
          const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          hintStyle:
          const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  // ── Variant Configuration ────────────────────────────────────────────────────

  Widget _buildVariantConfigurationCard() {
    final config =
    controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.variantAttributes.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.tune, color: Color(0xFF3B82F6), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Variant Configuration",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A))),
                  Text(
                      "Add values for each variant type to generate all combinations",
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF6B7280))),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 20),
          ...config.variantAttributes
              .map((vt) => _buildVariantTypeSection(vt)),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.configuredVariantTypes.isNotEmpty) {
              return _buildGenerateVariantsSection();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildVariantTypeSection(String variantType) {
    return Obx(() {
      final values =
          controller.configuredVariantTypes[variantType] ?? [];
      final isExpanded =
          controller.expandedVariantType.value == variantType;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: values.isNotEmpty
                ? const Color(0xFF10B981)
                : const Color(0xFFE5E7EB),
            width: values.isNotEmpty ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                if (isExpanded) {
                  controller.expandedVariantType.value = '';
                } else {
                  controller.expandedVariantType.value = variantType;
                  controller.selectedVariantType.value = variantType;
                  controller.currentVariantValues.value =
                      List.from(values);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: values.isNotEmpty
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        values.isNotEmpty
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: values.isNotEmpty
                            ? const Color(0xFF10B981)
                            : const Color(0xFF3B82F6),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(variantType,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A))),
                          if (values.isNotEmpty)
                            Text(
                                "${values.length} value(s): ${values.join(', ')}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)
                          else
                            const Text("Tap to add values",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF))),
                        ],
                      ),
                    ),
                    Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF6B7280)),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (values.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: values
                            .map((v) => Chip(
                          label: Text(v),
                          deleteIcon: const Icon(Icons.close,
                              size: 16),
                          onDeleted: () =>
                              controller.removeVariantValue(v),
                          backgroundColor:
                          const Color(0xFF3B82F6)
                              .withOpacity(0.1),
                          labelStyle: const TextStyle(
                              color: Color(0xFF3B82F6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(0xFFE5E7EB)),
                            ),
                            child: TextField(
                              controller:
                              controller.variantValueController,
                              decoration: InputDecoration(
                                hintText:
                                "e.g., ${_getExampleValue(variantType)}",
                                hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9CA3AF)),
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                prefixIcon: const Icon(Icons.add,
                                    size: 18,
                                    color: Color(0xFF6B7280)),
                              ),
                              onSubmitted: (v) {
                                if (v.trim().isNotEmpty) {
                                  controller.addVariantValue(v.trim());
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final v = controller
                                .variantValueController.text
                                .trim();
                            if (v.isNotEmpty) {
                              controller.addVariantValue(v);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Add",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "💡 Tip: Separate multiple values with commas (e.g., S, M, L)",
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                          fontStyle: FontStyle.italic),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF10B981).withOpacity(0.1),
            const Color(0xFF10B981).withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.preview,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                  child: Text("Variants Preview",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A)))),
              TextButton.icon(
                onPressed: () =>
                    _showClearConfigurationDialog(Get.context!),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text("Reset"),
                style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.configuredVariantTypes.entries
                    .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text("${e.key}:",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(e.value.join(", "),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280)))),
                    ],
                  ),
                ))
                    .toList(),
                const Divider(height: 20),
                Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        size: 16, color: Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Will generate ${_calculateTotalCombinations()} combination(s)",
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
                if (controller.variants.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: Color(0xFF3B82F6)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${controller.variants.length} variant(s) already exist. New ones will be added.",
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF3B82F6)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.generateVariantsFromType,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: Text(
                controller.variants.isEmpty
                    ? "Generate Variants"
                    : "Add More Variants",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Plain variant (no variant attributes) ────────────────────────────────────

  Widget _buildAddPlainVariantButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          controller.variants.add(ProductVariant(attributes: {}));
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF3B82F6),
          side: const BorderSide(color: Color(0xFF3B82F6)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.add),
        label: const Text("Add Variant",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ),
    );
  }

  // ── Variants Header ──────────────────────────────────────────────────────────

  Widget _buildVariantsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
        Border.all(color: const Color(0xFF10B981), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.inventory_2,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Generated Variants",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A))),
                Text(
                  "${controller.variants.length} variant(s) • Name *, Image * and Price * required",
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                _showClearAllVariantsDialog(Get.context!),
            icon: const Icon(Icons.delete_sweep,
                color: Color(0xFFEF4444)),
            tooltip: "Clear all variants",
          ),
        ],
      ),
    );
  }

  // ── Variant Card ─────────────────────────────────────────────────────────────

  Widget _buildVariantCard(
      BuildContext context, int index, ProductVariant variant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          // Card header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0xFF3B82F6).withOpacity(0.1),
                const Color(0xFF3B82F6).withOpacity(0.05),
              ]),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text("#${index + 1}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    variant.getDisplayName(),
                    style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444), size: 22),
                  onPressed: () =>
                      _showDeleteDialog(context, index),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image — MANDATORY
                _buildImagePicker(context, index, variant),
                const SizedBox(height: 20),

                // Price (mandatory) + Stock (optional)
                Row(
                  children: [
                    Expanded(child: _buildPriceField(variant)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStockField(variant)),
                  ],
                ),

                // Variant attributes chips
                if (variant.attributes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text("Variant Specifications",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280))),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: variant.attributes.entries
                              .map((e) => Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                                horizontal: 10,
                                vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(
                                  6),
                              border: Border.all(
                                  color: const Color(
                                      0xFFE5E7EB)),
                            ),
                            child: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Text("${e.key}:",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                            0xFF6B7280))),
                                const SizedBox(width: 4),
                                Text(e.value,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w600,
                                        color: Color(
                                            0xFF1A1A1A))),
                              ],
                            ),
                          ))
                              .toList(),
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

  // ── Image Picker ─────────────────────────────────────────────────────────────

  Widget _buildImagePicker(
      BuildContext context, int index, ProductVariant variant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text("Product Image",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A))),
            SizedBox(width: 4),
            Text("*",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444))),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => controller.pickImage(index),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: variant.imagePath != null
                    ? const Color(0xFF10B981)
                    : const Color(0xFFE5E7EB),
                width: 2,
              ),
            ),
            child: variant.imagePath == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6)
                          .withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: Color(0xFF3B82F6)),
                ),
                const SizedBox(height: 12),
                const Text("Tap to add image",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280))),
                const Text("Required *",
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFEF4444))),
              ],
            )
                : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                      File(variant.imagePath!),
                      fit: BoxFit.cover),
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
                            color: Colors.black
                                .withOpacity(0.2),
                            blurRadius: 8)
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit,
                          color: Color(0xFF3B82F6),
                          size: 20),
                      onPressed: () =>
                          controller.pickImage(index),
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

  // ── Price & Stock Fields ─────────────────────────────────────────────────────

  Widget _buildPriceField(ProductVariant variant) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: TextField(
        controller: variant.priceController,
        onChanged: (v) {
          variant.price = double.tryParse(v);
        },
        keyboardType:
        const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: "Price (₹) *",
          hintText: "0.00",
          prefixIcon: const Icon(Icons.currency_rupee,
              color: Color(0xFF10B981), size: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle: const TextStyle(
              fontSize: 12, color: Color(0xFF10B981)),
          hintStyle: const TextStyle(
              fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  Widget _buildStockField(ProductVariant variant) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: TextField(
        controller: variant.stockController,
        onChanged: (v) {
          variant.stock = int.tryParse(v);
        },
        keyboardType: TextInputType.number,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: "Stock (optional)",
          hintText: "0",
          prefixIcon: const Icon(Icons.inventory_outlined,
              color: Color(0xFF3B82F6), size: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle: const TextStyle(
              fontSize: 12, color: Color(0xFF3B82F6)),
          hintStyle: const TextStyle(
              fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────────

  void _showClearConfigurationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Row(children: const [
          Icon(Icons.warning_amber_rounded,
              color: Color(0xFFEF4444)),
          SizedBox(width: 12),
          Text("Reset Configuration?"),
        ]),
        content: const Text(
            "This will clear all configured variant types. Generated variants will not be affected.",
            style:
            TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              controller.clearVariantConfiguration();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444)),
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  void _showClearAllVariantsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Row(children: const [
          Icon(Icons.warning_amber_rounded,
              color: Color(0xFFEF4444)),
          SizedBox(width: 12),
          Text("Clear All Variants?"),
        ]),
        content: Text(
            "Remove all ${controller.variants.length} variants? This cannot be undone.",
            style: const TextStyle(
                fontSize: 14, color: Color(0xFF6B7280))),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              controller.variants.clear();
              Navigator.of(context).pop();
              AppSnackbar.success("All variants have been removed");
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444)),
            child: const Text("Clear All"),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Row(children: const [
          Icon(Icons.warning_amber_rounded,
              color: Color(0xFFEF4444)),
          SizedBox(width: 12),
          Text("Remove Variant?"),
        ]),
        content: const Text(
            "Are you sure you want to remove this variant?",
            style: TextStyle(
                fontSize: 14, color: Color(0xFF6B7280))),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              controller.removeVariant(index);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444)),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  int _calculateTotalCombinations() {
    if (controller.configuredVariantTypes.isEmpty) return 0;
    int total = 1;
    for (var v in controller.configuredVariantTypes.values) {
      total *= v.length;
    }
    return total;
  }

  String _getExampleValue(String attribute) {
    final examples = {
      'size': 'S, M, L',
      'color': 'Red, Blue',
      'colour': 'Red, Blue',
      'material': 'Cotton, Polyester',
      'style': 'Casual, Formal',
    };
    return examples[attribute.toLowerCase()] ?? 'Value1, Value2';
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  Widget _infoBox(
      {required Widget child,
        EdgeInsets padding =
        const EdgeInsets.all(20)}) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
        ),
        const SizedBox(width: 12),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A))),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon:
          Icon(icon, color: const Color(0xFF6B7280), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16),
          labelStyle:
          const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          hintStyle:
          const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      ),
    );
  }
}