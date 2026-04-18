
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../data/models/offer_productdetailmodel.dart';
import '../controller/merchant_offerproductupdatecontroller.dart';

class UpdateOfferProductPage extends StatefulWidget {
  const UpdateOfferProductPage({super.key});

  @override
  State<UpdateOfferProductPage> createState() => _UpdateOfferProductPageState();
}

class _UpdateOfferProductPageState extends State<UpdateOfferProductPage> {
  final OfferProductDetailController controller =
  Get.put(OfferProductDetailController());

  // ── Stable controllers ─────────────────────────────────────
  TextEditingController? _productNameCtrl;
  TextEditingController? _descriptionCtrl;
  bool _basicControllersInitialized = false;

  final Map<String, TextEditingController> _commonAttrControllers = {};
  final Map<int, TextEditingController> _priceControllers = {};
  final Map<int, TextEditingController> _stockControllers = {};
  int _lastVariantCount = 0;

  // ── Initialize basic controllers once data is loaded ───────
  void _initBasicControllers() {
    if (_basicControllersInitialized) return;
    if (controller.productData.value == null) return;

    _productNameCtrl =
        TextEditingController(text: controller.productName.value);
    _descriptionCtrl =
        TextEditingController(text: controller.description.value);
    _basicControllersInitialized = true;
  }

  TextEditingController _commonCtrl(String key, String initialValue) {
    return _commonAttrControllers.putIfAbsent(
        key, () => TextEditingController(text: initialValue));
  }

  TextEditingController _priceCtrl(int index, MOfferVariant v) {
    return _priceControllers.putIfAbsent(
        index, () => TextEditingController(text: v.price.toString()));
  }

  TextEditingController _stockCtrl(int index, MOfferVariant v) {
    return _stockControllers.putIfAbsent(
        index, () => TextEditingController(text: v.stock.toString()));
  }

  void _syncControllers() {
    final count = controller.variants.length;
    if (count == _lastVariantCount) return;
    if (count < _lastVariantCount) {
      for (int i = count; i < _lastVariantCount; i++) {
        _priceControllers.remove(i)?.dispose();
        _stockControllers.remove(i)?.dispose();
      }
    }
    _lastVariantCount = count;
  }

  @override
  void dispose() {
    _productNameCtrl?.dispose();
    _descriptionCtrl?.dispose();
    for (final c in _commonAttrControllers.values) c.dispose();
    for (final c in _priceControllers.values) c.dispose();
    for (final c in _stockControllers.values) c.dispose();
    super.dispose();
  }

  // ── Colors ─────────────────────────────────────────────────
  static const _primary = Color(0xFF6366F1);
  static const _green = Color(0xFF10B981);
  static const _bg = Color(0xFFF5F6FA);
  static const _textDark = Color(0xFF1A1A2E);
  static const _textMid = Color(0xFF6B7280);
  static const _border = Color(0xFFE8E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.kPrimary,
        title: const Text(
          'Update Offer Product',
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
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
          )
              : IconButton(
            icon: const Icon(Icons.save_outlined, color: Colors.white),
            onPressed: controller.updateProduct,
            tooltip: 'Save',
          )),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: _border, height: 1),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: _primary, strokeWidth: 2.5),
                SizedBox(height: 14),
                Text('Loading product...',
                    style: TextStyle(color: _textMid, fontSize: 14)),
              ],
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.productData.value == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 52, color: Colors.red),
                const SizedBox(height: 12),
                Text(controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _textMid, fontSize: 14)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.fetchProductDetail,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _primary, foregroundColor: Colors.white),
                ),
              ],
            ),
          );
        }

        // ✅ Initialize stable controllers once data is available
        _initBasicControllers();
        _syncControllers();

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoCard(),
                  const SizedBox(height: 16),
                  if (controller.commonAttributes.isNotEmpty) ...[
                    _buildCommonAttributesCard(),
                    const SizedBox(height: 16),
                  ],
                  _buildVariantsSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Submit overlay
            Obx(() => controller.isSubmitting.value
                ? Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: _primary),
                      SizedBox(height: 14),
                      Text('Updating product...',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        );
      }),
      floatingActionButton: Obx(() => !controller.isLoading.value &&
          !controller.isSubmitting.value &&
          controller.productData.value != null
          ? FloatingActionButton.extended(
        onPressed: controller.updateProduct,
        backgroundColor: _green,
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Update Product',
            style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 4,
      )
          : const SizedBox.shrink()),
    );
  }

  // ── Basic Info Card ────────────────────────────────────────
  // ✅ Uses stable TextEditingControllers — no cursor jump / rebuild issues
  Widget _buildBasicInfoCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Basic Information', Icons.info_outline_rounded),
          const SizedBox(height: 16),

          // Product Name
          _label('Product Name'),
          const SizedBox(height: 6),
          TextField(
            controller: _productNameCtrl,
            onChanged: (v) => controller.productName.value = v,
            style: const TextStyle(fontSize: 14, color: _textDark),
            decoration: _inputDecoration(hint: 'Enter product name'),
          ),
          const SizedBox(height: 14),

          // Description
          _label('Description'),
          const SizedBox(height: 6),
          TextField(
            controller: _descriptionCtrl,
            onChanged: (v) => controller.description.value = v,
            maxLines: 3,
            style: const TextStyle(fontSize: 14, color: _textDark),
            decoration: _inputDecoration(hint: 'Enter description'),
          ),
        ],
      ),
    );
  }

  // ── Common Attributes Card ─────────────────────────────────
  Widget _buildCommonAttributesCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Common Attributes', Icons.tune_rounded),
          const SizedBox(height: 4),
          const Text('These apply to all variants',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 16),
          Obx(() => Column(
            children: controller.commonAttributes.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(e.key[0].toUpperCase() + e.key.substring(1)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _commonCtrl(e.key, e.value),
                      onChanged: (v) =>
                          controller.updateCommonAttribute(e.key, v),
                      style:
                      const TextStyle(fontSize: 14, color: _textDark),
                      decoration: _inputDecoration(hint: 'Enter ${e.key}'),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  // ── Variants Section ───────────────────────────────────────
  Widget _buildVariantsSection() {
    return Obx(() {
      if (controller.variants.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Variants',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${controller.variants.length} variants',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...controller.variants.asMap().entries.map(
                (e) => _buildVariantCard(e.key, e.value),
          ),
        ],
      );
    });
  }

  Widget _buildVariantCard(int index, MOfferVariant variant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.05),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Variant ${index + 1}',
                    style: const TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  variant.getDisplayName(),
                  style: const TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image picker
                _buildImagePicker(index, variant),
                const SizedBox(height: 16),

                // Price & Stock
                Row(
                  children: [
                    Expanded(child: _buildPriceField(index, variant)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStockField(index, variant)),
                  ],
                ),
                const SizedBox(height: 16),

                // Read-only attributes
                if (variant.attributes.isNotEmpty) ...[
                  _label('Attributes'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: variant.attributes.entries.map((e) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${e.key[0].toUpperCase()}${e.key.substring(1)}: ${e.value}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // Final price display
                if (variant.finalPrice > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _green.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _green.withOpacity(0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_offer_outlined,
                            size: 14, color: _green),
                        const SizedBox(width: 6),
                        Text(
                          'Offer price: ₹${variant.finalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _green,
                          ),
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

  Widget _buildImagePicker(int index, MOfferVariant variant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Product Image'),
        const SizedBox(height: 8),
        Obx(() {
          final path = controller.variants[index].imagePath;
          return GestureDetector(
            onTap: () => controller.pickImage(index),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border, width: 2),
              ),
              child: path.isEmpty
                  ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 40, color: _primary),
                  SizedBox(height: 8),
                  Text('Tap to add image',
                      style: TextStyle(fontSize: 13, color: _textMid)),
                ],
              )
                  : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: path.startsWith('http')
                        ? Image.network(path,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Color(0xFFD1D5DB)))
                        : Image.file(File(path), fit: BoxFit.cover),
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
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            size: 18, color: _primary),
                        onPressed: () => controller.pickImage(index),
                      ),
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

  Widget _buildPriceField(int index, MOfferVariant variant) {
    return TextField(
      controller: _priceCtrl(index, variant),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (v) =>
          controller.updateVariantPrice(index, double.tryParse(v) ?? 0),
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      decoration: _inputDecoration(
        hint: '0.00',
        label: 'Price (₹)',
        prefixIcon: Icons.currency_rupee_rounded,
        prefixColor: _green,
      ),
    );
  }

  Widget _buildStockField(int index, MOfferVariant variant) {
    return TextField(
      controller: _stockCtrl(index, variant),
      keyboardType: TextInputType.number,
      onChanged: (v) =>
          controller.updateVariantStock(index, int.tryParse(v) ?? 0),
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      decoration: _inputDecoration(
        hint: '0',
        label: 'Stock',
        prefixIcon: Icons.inventory_2_outlined,
        prefixColor: _primary,
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: _primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: _primary),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _textMid,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    String? label,
    IconData? prefixIcon,
    Color? prefixColor,
  }) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
      labelStyle: const TextStyle(fontSize: 12, color: _textMid),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 18, color: prefixColor ?? _textMid)
          : null,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

// ─── Card wrapper ─────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}