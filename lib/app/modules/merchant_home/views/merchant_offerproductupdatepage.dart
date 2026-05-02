import 'dart:io';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
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

  TextEditingController? _productNameCtrl;
  TextEditingController? _descriptionCtrl;
  bool _basicControllersInitialized = false;

  final Map<String, TextEditingController> _commonAttrControllers = {};
  final Map<int, TextEditingController> _priceControllers = {};
  final Map<int, TextEditingController> _stockControllers = {};

  // ✅ FIX: Cache read-only attribute controllers so they are not
  // recreated on every rebuild (which leaks TextEditingControllers).
  final Map<String, TextEditingController> _readOnlyAttrControllers = {};

  int _lastVariantCount = 0;

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

  // ✅ FIX: Cached read-only controller — keyed by "variantIndex_attrKey"
  // so each variant's attribute gets its own stable controller.
  TextEditingController _readOnlyCtrl(int variantIndex, String key,
      String value) {
    final cacheKey = '${variantIndex}_$key';
    return _readOnlyAttrControllers.putIfAbsent(
        cacheKey, () => TextEditingController(text: value));
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
    // ✅ FIX: Dispose cached read-only controllers.
    for (final c in _readOnlyAttrControllers.values) c.dispose();
    super.dispose();
  }

  static const _primary = Color(0xFF6366F1);
  static const _green = Color(0xFF10B981);
  static const _bg = Color(0xFFF5F6FA);
  static const _textDark = Color(0xFF1A1A2E);
  static const _textMid = Color(0xFF6B7280);
  static const _border = Color(0xFFE8E8F0);

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
        child: Scaffold(
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
                          backgroundColor: _primary,
                          foregroundColor: Colors.white),
                    ),
                  ],
                ),
              );
            }

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
        ));
  }

  // ── Basic Info Card ────────────────────────────────────────────
  Widget _buildBasicInfoCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Basic Information', Icons.info_outline_rounded),
          const SizedBox(height: 16),
          _label('Product Name'),
          const SizedBox(height: 6),
          TextField(
            controller: _productNameCtrl,
            onChanged: (v) => controller.productName.value = v,
            style: const TextStyle(fontSize: 14, color: _textDark),
            decoration: _inputDecoration(hint: 'Enter product name'),
          ),
          const SizedBox(height: 14),
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

  // ── Common Attributes Card ─────────────────────────────────────
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
                      style: const TextStyle(
                          fontSize: 14, color: _textDark),
                      decoration:
                      _inputDecoration(hint: 'Enter ${e.key}'),
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

  // ── Variants Section ───────────────────────────────────────────
  // ✅ FIX: This Obx only rebuilds when variants list length/identity
  // changes (add/remove). Price edits no longer trigger this rebuild
  // because updateVariantPrice() no longer calls variants.refresh().
  Widget _buildVariantsSection() {
    return Obx(() {
      if (controller.variants.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Variants',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textDark)),
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
          ...controller.variants
              .asMap()
              .entries
              .map((e) => _buildVariantCard(e.key, e.value)),
        ],
      );
    });
  }

  // ── Variant Card ───────────────────────────────────────────────
  Widget _buildVariantCard(int index, MOfferVariant variant) {
    final attrs = variant.attributes;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.06),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.layers_outlined, size: 16, color: _primary),
                const SizedBox(width: 6),
                Text(
                  'Variant ${index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: _primary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    variant.getDisplayName(),
                    style: const TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // ── Body ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left: image picker ──────────────────────────
                _buildImagePicker(index),
                const SizedBox(width: 14),

                // ── Right: fields column ─────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ FIX: Pass variantIndex to _buildReadOnlyAttr
                      // so controllers are keyed per variant, not just
                      // per attribute name (which collides across variants).
                      if (attrs.isNotEmpty)
                        ...attrs.entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildReadOnlyAttr(
                            index,
                            e.key,
                            '${e.key[0].toUpperCase()}${e.key.substring(1)}',
                            e.value,
                          ),
                        )),

                      Row(
                        children: [
                          Expanded(
                              child: _buildPriceField(index, variant)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _buildStockField(index, variant)),
                        ],
                      ),

                      // ✅ FIX: Obx reads controller.priceTick to subscribe
                      // to the lightweight tick observable. This Obx ONLY
                      // rebuilds when a price changes — not the full card.
                      Obx(() {
                        controller.priceTick; // subscribe to tick
                        if (controller.variants.length <= index) {
                          return const SizedBox.shrink();
                        }
                        final currentPrice =
                            controller.variants[index].price;
                        final serverFinal =
                            controller.variants[index].finalPrice;
                        final offerPrice =
                        controller.computeOfferPrice(currentPrice);
                        final displayPrice = offerPrice ??
                            (serverFinal > 0 ? serverFinal : null);

                        if (displayPrice == null || currentPrice <= 0) {
                          return const SizedBox.shrink();
                        }

                        final discount =
                            controller.discountPercentage.value;
                        final saved = currentPrice - displayPrice;
                        final isConfirmed = serverFinal > 0 &&
                            (serverFinal - displayPrice).abs() < 1;

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: isConfirmed
                                  ? _green.withOpacity(0.08)
                                  : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: (isConfirmed
                                    ? _green
                                    : const Color(0xFFF59E0B))
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isConfirmed
                                      ? Icons.verified_outlined
                                      : Icons.local_offer_outlined,
                                  size: 13,
                                  color: isConfirmed
                                      ? _green
                                      : const Color(0xFFF59E0B),
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    offerPrice != null
                                        ? '₹${offerPrice.toStringAsFixed(2)}  •  Save ₹${saved.toStringAsFixed(0)} ($discount% off)${isConfirmed ? ' ✓' : ''}'
                                        : '₹${serverFinal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isConfirmed
                                          ? _green
                                          : const Color(0xFFF59E0B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Image picker ───────────────────────────────────────────────
  Widget _buildImagePicker(int index) {
    return Obx(() {
      if (controller.variants.length <= index) return const SizedBox.shrink();
      final path = controller.variants[index].imagePath;

      return GestureDetector(
        onTap: () => controller.pickImage(index),
        child: Stack(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEFF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _primary.withOpacity(0.3), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: path.isEmpty
                    ? const Icon(Icons.add_photo_alternate_outlined,
                    color: _primary, size: 30)
                    : path.startsWith('http')
                    ? Image.network(
                  path,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image_outlined,
                      color: Color(0xFFB0BEC5),
                      size: 28),
                )
                    : Image.file(File(path), fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, size: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Price field ────────────────────────────────────────────────
  // ✅ FIX: onChanged only calls updateVariantPrice — no variants.refresh().
  // The _priceCtrl is stable (putIfAbsent) so the text field never loses
  // focus or resets while the user is typing.
  Widget _buildPriceField(int index, MOfferVariant variant) {
    return TextField(
      controller: _priceCtrl(index, variant),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (v) {
        final parsed = double.tryParse(v) ?? 0;
        controller.updateVariantPrice(index, parsed);
        // ✅ No variants.refresh() here — _priceTick handles badge update
      },
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      decoration: _inputDecoration(
        hint: '0.00',
        label: 'Price (₹)',
        prefixIcon: Icons.currency_rupee_rounded,
        prefixColor: _green,
      ),
    );
  }

  // ── Stock field ────────────────────────────────────────────────
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

  // ── Read-only attribute field ──────────────────────────────────
  // ✅ FIX: Controller is now cached via _readOnlyCtrl() keyed by
  // variantIndex + attrKey — no leak on every rebuild.
  Widget _buildReadOnlyAttr(
      int variantIndex, String attrKey, String label, String value) {
    return TextField(
      readOnly: true,
      controller: _readOnlyCtrl(variantIndex, attrKey, value),
      style: const TextStyle(fontSize: 14, color: _textDark),
      decoration: _inputDecoration(
        hint: '',
        label: label,
        prefixIcon: Icons.style_outlined,
        prefixColor: _textMid,
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────
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
        Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _textDark)),
      ],
    );
  }

  Widget _label(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: _textMid));
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
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

// ─── Card wrapper ──────────────────────────────────────────────────────────
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