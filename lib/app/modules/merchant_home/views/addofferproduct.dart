
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../controller/merchant_addofferproductcontroller.dart';


class AddOfferProductPage extends StatelessWidget {
  final AddOfferProductController controller =
  Get.find<AddOfferProductController>();

  AddOfferProductPage({super.key});

  static const Color kPrimary = Colors.teal;
  static const Color kGreen = Color(0xFF10B981);
  static const Color kBlue = Color(0xFF3B82F6);
  static const Color kRed = Color(0xFFEF4444);
  static const Color kAmber = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.kPrimary,
        foregroundColor: Colors.white,
        title: Text(
          'Add Products · Offer #${controller.offerId}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
        ),
        actions: [
          Obx(() => Center(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${controller.totalProductsAdded.value}/10',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          )),
          TextButton.icon(
            onPressed: controller.finishOffer,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Done',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildOfferInfoBanner(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProductLimitIndicator(),
                      const SizedBox(height: 16),
                      Obx(() =>
                      controller.totalProductsAdded.value >= 10
                          ? _buildMaxProductsReachedCard()
                          : _buildProductForm(context)),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildLoadingOverlay(),
        ],
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  // ── Offer info banner ─────────────────────────────────────────────────────
  Widget _buildOfferInfoBanner() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: kGreen.withOpacity(0.08),
        border:
        Border(bottom: BorderSide(color: kGreen.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child:
            const Icon(Icons.verified, color: kGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offer #${controller.offerId} Created ✓',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kGreen),
                ),
                const SizedBox(height: 2),
                Text(
                  '${controller.discountPercentage}% discount · Add up to 10 products below',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF374151)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading overlay ───────────────────────────────────────────────────────
  Widget _buildLoadingOverlay() {
    return Obx(() {
      if (!controller.isSubmitting.value) return const SizedBox.shrink();
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Adding product to offer...',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ── FAB ───────────────────────────────────────────────────────────────────
  Widget _buildFab(BuildContext context) {
    return Obx(() {
      if (controller.variants.isNotEmpty &&
          !controller.isSubmitting.value &&
          controller.totalProductsAdded.value < 10) {
        return FloatingActionButton.extended(
          onPressed: controller.saveOfferProduct,
          backgroundColor: kGreen,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Add Product to Offer',
              style: TextStyle(fontWeight: FontWeight.w600)),
          elevation: 4,
        );
      }
      return const SizedBox.shrink();
    });
  }

  // ── Product limit indicator ───────────────────────────────────────────────
  Widget _buildProductLimitIndicator() {
    return Obx(() {
      final currentCount = controller.totalProductsAdded.value;
      const maxCount = 10;
      final percentage = (currentCount / maxCount).clamp(0.0, 1.0);
      final isAtLimit = currentCount >= maxCount;
      final isNearLimit = currentCount >= 8;

      final Color indicatorColor;
      final Color bgColor;
      final IconData icon;
      final String message;

      if (isAtLimit) {
        indicatorColor = kRed;
        bgColor = const Color(0xFFFEE2E2);
        icon = Icons.block;
        message = 'Maximum limit reached!';
      } else if (isNearLimit) {
        indicatorColor = kAmber;
        bgColor = const Color(0xFFFEF3C7);
        icon = Icons.warning_amber_rounded;
        message =
        'Almost at limit! ${maxCount - currentCount} remaining.';
      } else {
        indicatorColor = kGreen;
        bgColor = const Color(0xFFD1FAE5);
        icon = Icons.check_circle_outline;
        message = '$currentCount of $maxCount products added';
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border:
          Border.all(color: indicatorColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: indicatorColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Limit',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: indicatorColor)),
                      const SizedBox(height: 4),
                      Text(message,
                          style: TextStyle(
                              fontSize: 13,
                              color:
                              indicatorColor.withOpacity(0.8))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor: AlwaysStoppedAnimation(indicatorColor),
                minHeight: 8,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Max products reached card ─────────────────────────────────────────────
  Widget _buildMaxProductsReachedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kRed.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          const Icon(Icons.block, color: kRed, size: 48),
          const SizedBox(height: 12),
          const Text('Maximum 10 Products Reached',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kRed)),
          const SizedBox(height: 8),
          const Text(
            'You\'ve added all 10 products. Tap "Done" to finish.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFFDC2626)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: controller.finishOffer,
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.check_circle),
            label: const Text('Finish Offer',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  // ── Product form ──────────────────────────────────────────────────────────
  Widget _buildProductForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductNameCard(),
        const SizedBox(height: 16),
        _buildDescriptionCard(),
        const SizedBox(height: 16),
        _buildCategoryCard(),
        const SizedBox(height: 16),
        Obx(() => controller.selectedCategory.value.isNotEmpty
            ? Column(children: [
          _buildCommonAttributesSection(),
          const SizedBox(height: 16),
        ])
            : const SizedBox.shrink()),
        Obx(() => (controller.selectedCategory.value.isNotEmpty &&
            controller.hasVariantAttributes())
            ? Column(children: [
          _buildVariantConfigurationSection(),
          const SizedBox(height: 16),
        ])
            : const SizedBox.shrink()),
        Obx(() => controller.variants.isNotEmpty
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVariantsHeader(),
            const SizedBox(height: 12),
            ...controller.variants
                .asMap()
                .entries
                .map((e) =>
                _buildVariantCard(context, e.key, e.value)),
          ],
        )
            : const SizedBox.shrink()),
      ],
    );
  }

  // ── Product name ──────────────────────────────────────────────────────────
  Widget _buildProductNameCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
              'Product Name', Icons.shopping_bag_outlined),
          const SizedBox(height: 12),
          _buildTextField(
            hint: 'e.g., Classic Cotton T-Shirt',
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
          _buildSectionTitle(
              'Description', Icons.description_outlined),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              onChanged: (val) =>
              controller.productDescription.value = val,
              maxLines: 4,
              style: const TextStyle(
                  fontSize: 15, color: Color(0xFF1A1A1A)),
              decoration: const InputDecoration(
                hintText: 'Describe your product in detail...',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Icon(Icons.text_fields,
                      color: Color(0xFF6B7280), size: 20),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category ──────────────────────────────────────────────────────────────
  Widget _buildCategoryCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Category', Icons.category_outlined),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingCategories.value) {
              return const Center(
                  child: CircularProgressIndicator());
            }
            if (controller.apiCategories.isEmpty) {
              return Row(children: [
                const Icon(Icons.warning_amber,
                    color: Colors.orange),
                const SizedBox(width: 12),
                const Expanded(
                    child: Text('No categories available')),
                TextButton(
                    onPressed: controller.fetchCategories,
                    child: const Text('Retry')),
              ]);
            }
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border:
                Border.all(color: const Color(0xFFE5E7EB)),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.list_alt,
                      color: Color(0xFF6B7280), size: 20),
                  hintText: 'Choose a category',
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
                onChanged: (val) {
                  if (val != null) controller.onCategoryChanged(val);
                },
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

  // ── Common attributes ─────────────────────────────────────────────────────
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
          _buildSectionTitle('Common Attributes', Icons.info_outline),
          const SizedBox(height: 6),
          const Text('These attributes apply to all variants',
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
        onChanged: (value) =>
            controller.setCommonAttribute(attribute, value),
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: attribute,
          hintText: 'Enter $attribute',
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

  // ── Variant configuration ─────────────────────────────────────────────────
  Widget _buildVariantConfigurationSection() {
    final config =
    controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.variantAttributes.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Configure Variants', Icons.tune),
          const SizedBox(height: 6),
          const Text(
            'Select a variant type, add values, then generate variants.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),

          // ── Configured summary ──
          Obx(() {
            if (controller.configuredVariantTypes.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Configured:',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A))),
                const SizedBox(height: 8),
                ...controller.configuredVariantTypes.entries
                    .map((entry) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: kGreen.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: kGreen.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${entry.key}: ${entry.value.join(', ')}',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF374151)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.configuredVariantTypes
                              .remove(entry.key);
                          controller.configuredVariantTypes
                              .refresh();
                        },
                        child: const Icon(Icons.delete_outline,
                            size: 18, color: kRed),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
              ],
            );
          }),

          // ── Variant type dropdown ──
          Obx(() => Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border:
              Border.all(color: const Color(0xFFE5E7EB)),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.category,
                    color: Color(0xFF6B7280), size: 20),
                hintText: 'Select variant type (e.g., Color, Size)',
                hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF), fontSize: 14),
              ),
              value: controller.selectedVariantType.value.isEmpty
                  ? null
                  : controller.selectedVariantType.value,
              items: config.variantAttributes
                  .map((attr) => DropdownMenuItem(
                  value: attr,
                  child: Text(attr,
                      style: const TextStyle(fontSize: 15))))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.onVariantTypeSelected(value);
                }
              },
              dropdownColor: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFF6B7280)),
            ),
          )),

          // ── Value input section ──
          Obx(() => controller.selectedVariantType.value.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Add values for "${controller.selectedVariantType.value}"',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 4),
              const Text(
                  'Tip: separate multiple values with a comma (e.g. S, M, L)',
                  style: TextStyle(
                      fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.currentVariantValues.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFFE5E7EB)),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.currentVariantValues
                        .map((value) => Chip(
                      label: Text(value,
                          style: const TextStyle(
                              fontSize: 13)),
                      deleteIcon: const Icon(
                          Icons.close,
                          size: 16),
                      onDeleted: () => controller
                          .removeVariantValue(value),
                      backgroundColor:
                      kBlue.withOpacity(0.1),
                      labelStyle: const TextStyle(
                          color: kBlue,
                          fontWeight: FontWeight.w500),
                    ))
                        .toList(),
                  ),
                );
              }),
              Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller:
                      controller.variantValueController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Red or S, M, L',
                        hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9CA3AF)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      onSubmitted: (val) =>
                          controller.addVariantValue(val),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => controller.addVariantValue(
                      controller.variantValueController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBlue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(8)),
                  ),
                  child: const Text('Add',
                      style: TextStyle(
                          fontWeight: FontWeight.w600)),
                ),
              ]),
            ],
          )
              : const SizedBox.shrink()),

          // ── Generate button ──
          Obx(() {
            if (controller.configuredVariantTypes.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.generateVariantsFromType,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate All Variants',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ── Variants header ───────────────────────────────────────────────────────
  Widget _buildVariantsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product Variants',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A))),
        Obx(() {
          final count = controller.variants.length;
          return Text('$count variant(s) for this product',
              style: TextStyle(
                  fontSize: 13,
                  color:
                  count >= 10 ? kRed : const Color(0xFF6B7280),
                  fontWeight: count >= 10
                      ? FontWeight.w600
                      : FontWeight.normal));
        }),
      ],
    );
  }

  // ── Variant card ──────────────────────────────────────────────────────────
  Widget _buildVariantCard(
      BuildContext context, int index, OfferProductVariant variant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kBlue.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)),
            ),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Variant ${index + 1}',
                        style: const TextStyle(
                            color: kBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(variant.getDisplayName(),
                        style: const TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: kRed, size: 20),
                onPressed: () =>
                    _showDeleteDialog(context, index),
              ),
            ]),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image picker — keyed per variant index ──────────────
                _buildImagePicker(index),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                      child: _buildPriceField(variant, index)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildStockField(variant, index)),
                ]),
                if (variant.attributes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Variant Attributes',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  ...variant.attributes.entries.map((entry) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildVariantAttributeField(
                            entry.key, entry.value),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Price field ───────────────────────────────────────────────────────────
  Widget _buildPriceField(OfferProductVariant variant, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kGreen.withOpacity(0.3)),
          ),
          child: TextField(
            key: Key('price_$index'),
            onChanged: (val) {
              variant.price = double.tryParse(val);
              controller.variants.refresh();
            },
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              labelText: 'Original Price (₹)',
              hintText: '0.00',
              prefixIcon:
              Icon(Icons.currency_rupee, color: kGreen, size: 18),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 12, vertical: 12),
              labelStyle:
              TextStyle(fontSize: 12, color: kGreen),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final _ = controller.variants.length;
          if (variant.price != null && variant.price! > 0) {
            final offerPrice =
            controller.computeOfferPrice(variant.price!);
            if (offerPrice != null) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                  border:
                  Border.all(color: kAmber.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_offer,
                        color: kAmber, size: 12),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '₹${offerPrice.toStringAsFixed(0)} (${controller.discountPercentage}% off)',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: kAmber),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  // ── Stock field ───────────────────────────────────────────────────────────
  Widget _buildStockField(OfferProductVariant variant, int index) {
    return Container(
      decoration: BoxDecoration(
        color: kBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBlue.withOpacity(0.3)),
      ),
      child: TextField(
        key: Key('stock_$index'),
        onChanged: (val) {
          variant.stock = int.tryParse(val);
          controller.variants.refresh();
        },
        keyboardType: TextInputType.number,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(
          labelText: 'Stock',
          hintText: '0',
          prefixIcon: Icon(Icons.inventory_outlined,
              color: kBlue, size: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle: TextStyle(fontSize: 12, color: kBlue),
        ),
      ),
    );
  }

  // ── Variant attribute (read-only display) ─────────────────────────────────
  Widget _buildVariantAttributeField(String attribute, String value) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: TextEditingController(text: value),
        enabled: false,
        style: const TextStyle(
            fontSize: 14, color: Color(0xFF6B7280)),
        decoration: InputDecoration(
          labelText: attribute,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle:
          const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ),
    );
  }

  // ── Image picker ──────────────────────────────────────────────────────────
  /// Uses [controller.variantImagePaths] (a reactive RxMap keyed by index)
  /// so each card independently reacts to its own image change without
  /// triggering a full list rebuild.
  Widget _buildImagePicker(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product Image',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A))),
        const SizedBox(height: 12),
        Obx(() {
          // Reading from the reactive map ensures this Obx rebuilds only
          // when THIS variant's image changes, not when others change.
          final imagePath = controller.variantImagePaths[index];

          return GestureDetector(
            onTap: () => controller.pickImage(index),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: imagePath != null
                        ? kBlue
                        : const Color(0xFFE5E7EB),
                    width: imagePath != null ? 2 : 1),
              ),
              child: imagePath == null
                  ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 40, color: kBlue),
                  SizedBox(height: 8),
                  Text('Tap to add image',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280))),
                  SizedBox(height: 4),
                  Text('Each variant needs its own image',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF))),
                ],
              )
                  : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      // Force re-decode when the path changes
                      key: ValueKey(imagePath),
                    ),
                  ),
                  // Image index badge — confirms which variant this is
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: kBlue.withOpacity(0.85),
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Variant ${index + 1}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  // Edit / Remove action buttons
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _imageActionButton(
                          icon: Icons.edit,
                          color: kBlue,
                          onTap: () =>
                              controller.pickImage(index),
                        ),
                        const SizedBox(width: 6),
                        _imageActionButton(
                          icon: Icons.delete,
                          color: kRed,
                          onTap: () =>
                              controller.removeImage(index),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _imageActionButton(
      {required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2), blurRadius: 6)
          ],
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────
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
              offset: const Offset(0, 2)),
        ],
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
            color: kBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: kBlue, size: 20),
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
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        onChanged: onChanged,
        style:
        const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon:
          Icon(icon, color: const Color(0xFF6B7280), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16),
          hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.warning_amber_rounded, color: kRed),
          SizedBox(width: 12),
          Text('Remove Variant?'),
        ]),
        content: const Text(
            'Are you sure you want to remove this variant?',
            style: TextStyle(
                fontSize: 14, color: Color(0xFF6B7280))),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.removeVariant(index);
              Navigator.of(ctx).pop();
            },
            style:
            ElevatedButton.styleFrom(backgroundColor: kRed),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}