
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../controller/productedintingcontroller.dart';

class MerchantProductDetailPage extends StatelessWidget {
  const MerchantProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(merchantProductDetailController());

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (ctrl.isLoading.value) return _buildLoader();
        if (ctrl.product.value == null) return _buildEmpty();
        return _buildForm(context, ctrl);
      }),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        'Edit Product',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      backgroundColor: AppColors.kPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child:
        Container(height: 0.5, color: Colors.white.withOpacity(0.2)),
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF00796B),
            strokeWidth: 2.5,
          ),
          SizedBox(height: 16),
          Text('Loading product...',
              style: TextStyle(color: Color(0xFF78909C), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text('No product data found.',
          style: TextStyle(color: Color(0xFF90A4AE))),
    );
  }

  // ── Main form ─────────────────────────────────────────────────────────────────
  Widget _buildForm(
      BuildContext context, merchantProductDetailController ctrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── BASIC INFO ──────────────────────────────────────────────────────
          _SectionCard(
            title: 'Basic Information',
            icon: Icons.info_outline_rounded,
            children: [
              _buildTextField(ctrl.nameCtrl, 'Product Name',
                  icon: Icons.label_outline),
              const SizedBox(height: 14),
              _buildTextField(ctrl.descCtrl, 'Description',
                  maxLines: 3, icon: Icons.description_outlined),
              const SizedBox(height: 14),
              Obx(() => _buildReadOnly(
                'Category',
                ctrl.product.value?.category.name ?? '',
                icon: Icons.category_outlined,
              )),
            ],
          ),

          const SizedBox(height: 16),

          // ── COMMON ATTRIBUTES ───────────────────────────────────────────────
          _SectionCard(
            title: 'Common Attributes',
            icon: Icons.tune_rounded,
            children: [
              Obx(() {
                if (ctrl.attrCtrls.isEmpty) {
                  return const _EmptyHint(text: 'No common attributes');
                }
                return Column(
                  children: ctrl.attrCtrls.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTextField(
                        entry.value,
                        _capitalize(entry.key),
                        icon: Icons.edit_attributes_outlined,
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),

          const SizedBox(height: 16),

          // ── VARIANTS ────────────────────────────────────────────────────────
          _SectionCard(
            title: 'Variants',
            icon: Icons.layers_outlined,
            children: [
              Obx(() {
                if (ctrl.variantForms.isEmpty) {
                  return const _EmptyHint(text: 'No variants');
                }
                return Column(
                  children: List.generate(ctrl.variantForms.length, (i) {
                    return _VariantCard(
                      index: i,
                      form: ctrl.variantForms[i],
                      onPickImage: () => ctrl.pickVariantImage(i),
                    );
                  }),
                );
              }),
            ],
          ),

          const SizedBox(height: 24),

          // ── UPDATE BUTTON ────────────────────────────────────────────────────
          Obx(() => SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed:
              ctrl.isUpdating.value ? null : ctrl.updateProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B),
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                const Color(0xFF00796B).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: ctrl.isUpdating.value
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('Save Changes',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

// ── VARIANT CARD ──────────────────────────────────────────────────────────────
class _VariantCard extends StatelessWidget {
  final int index;
  final VariantForm form;
  final VoidCallback onPickImage;

  const _VariantCard({
    required this.index,
    required this.form,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2F1),
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.layers_outlined,
                    size: 16, color: Color(0xFF00796B)),
                const SizedBox(width: 6),
                Text(
                  'Variant ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF00796B),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image picker
                _buildImagePicker(),
                const SizedBox(width: 14),
                // Fields
                Expanded(
                  child: Column(
                    children: [
                      // Attributes
                      Obx(() => Column(
                        children: form.attrCtrls.entries.map<Widget>(
                              (entry) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(bottom: 10),
                              child: _buildTextField(
                                entry.value,
                                _capitalize(entry.key),
                                icon: Icons.style_outlined,
                              ),
                            );
                          },
                        ).toList(),
                      )),
                      // Price & Stock
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              form.priceCtrl,
                              'Price (₹)',
                              icon: Icons.currency_rupee_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              form.stockCtrl,
                              'Stock',
                              icon: Icons.inventory_2_outlined,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildImagePicker() {
    return Obx(() {
      final file = form.pickedImage.value;
      final url = form.existingImageUrl;

      return GestureDetector(
        onTap: onPickImage,
        child: Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF00796B).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: file != null
                    ? Image.file(file, fit: BoxFit.cover)
                    : (url != null && url.isNotEmpty)
                    ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Color(0xFF00796B)),
                    ),
                  ),
                  errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image_outlined,
                      color: Color(0xFFB0BEC5), size: 28),
                )
                    : const Icon(Icons.add_photo_alternate_outlined,
                    color: Color(0xFF00796B), size: 28),
              ),
            ),
            // Edit badge
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFF00796B),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, size: 11, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ── SECTION CARD ──────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 15, color: const Color(0xFF00796B)),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF263238),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(color: Color(0xFFF0F0F0)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;
  const _EmptyHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 15, color: Color(0xFFB0BEC5)),
          const SizedBox(width: 6),
          Text(text,
              style:
              const TextStyle(fontSize: 13, color: Color(0xFFB0BEC5))),
        ],
      ),
    );
  }
}

// ── TEXT FIELD ────────────────────────────────────────────────────────────────
Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
      int maxLines = 1,
      IconData? icon,
      TextInputType? keyboardType,
    }) {
  return TextField(
    controller: ctrl,
    maxLines: maxLines,
    keyboardType: keyboardType,
    style: const TextStyle(fontSize: 14, color: Color(0xFF263238)),
    decoration: InputDecoration(
      labelText: label,
      labelStyle:
      const TextStyle(fontSize: 13, color: Color(0xFF90A4AE)),
      prefixIcon: icon != null
          ? Icon(icon, size: 18, color: const Color(0xFF00796B))
          : null,
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
        const BorderSide(color: Color(0xFF00796B), width: 1.5),
      ),
    ),
  );
}

// ── READ ONLY FIELD ───────────────────────────────────────────────────────────
Widget _buildReadOnly(String label, String value, {IconData? icon}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE0E0E0)),
    ),
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: const Color(0xFF90A4AE)),
          const SizedBox(width: 10),
        ],
        Text('$label:  ',
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF78909C))),
        Text(value,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF263238))),
        const Spacer(),
        const Icon(Icons.lock_outline_rounded,
            size: 14, color: Color(0xFFBDBDBD)),
      ],
    ),
  );
}

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);