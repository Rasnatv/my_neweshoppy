//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/merchant_offerproductupdatecontroller.dart';
//
// class EditOfferProductPage extends StatelessWidget {
//   final int productId;
//   final int offerId;
//
//   EditOfferProductPage({
//     super.key,
//     required this.productId,
//     required this.offerId,
//   });
//
//   late final KEditOfferProductController controller = Get.put(
//     KEditOfferProductController(productId: productId, offerId: offerId),
//     tag: productId.toString(),
//   );
//
//   static const Color kPrimary = Color(0xFF6366F1);
//   static const Color kGreen   = Color(0xFF10B981);
//   static const Color kBlue    = Color(0xFF3B82F6);
//   static const Color kRed     = Color(0xFFEF4444);
//   static const Color kAmber   = Color(0xFFF59E0B);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: kPrimary,
//         foregroundColor: Colors.white,
//         title: const Text('Edit Offer Product',
//             style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
//         actions: [
//           Obx(() => controller.isSubmitting.value
//               ? const Padding(
//               padding: EdgeInsets.all(16),
//               child: SizedBox(width: 20, height: 20,
//                   child: CircularProgressIndicator(
//                       color: Colors.white, strokeWidth: 2)))
//               : TextButton.icon(
//               onPressed: controller.updateOfferProduct,
//               icon: const Icon(Icons.save_alt_rounded,
//                   color: Colors.white, size: 18),
//               label: const Text('Save',
//                   style: TextStyle(color: Colors.white,
//                       fontWeight: FontWeight.w700, fontSize: 14)))),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoadingProduct.value ||
//             controller.isLoadingCategories.value) {
//           return const Center(child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Loading product details...',
//                   style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
//             ],
//           ));
//         }
//         return Stack(children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildDiscountBanner(),
//                 const SizedBox(height: 16),
//                 _buildProductNameCard(),
//                 const SizedBox(height: 16),
//                 _buildDescriptionCard(),
//                 const SizedBox(height: 16),
//                 _buildCategoryCard(),
//                 const SizedBox(height: 16),
//                 Obx(() => controller.selectedCategory.value.isNotEmpty
//                     ? _buildCommonAttributesSection()
//                     : const SizedBox.shrink()),
//                 Obx(() => (controller.selectedCategory.value.isNotEmpty &&
//                     controller.hasVariantAttributes())
//                     ? Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: _buildVariantConfigurationSection())
//                     : const SizedBox.shrink()),
//                 const SizedBox(height: 16),
//                 Obx(() => controller.variants.isNotEmpty
//                     ? _buildVariantsList(context)
//                     : const SizedBox.shrink()),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//           _buildLoadingOverlay(),
//         ]);
//       }),
//     );
//   }
//
//   Widget _buildDiscountBanner() {
//     return Obx(() => Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [
//           kAmber.withOpacity(0.15), kAmber.withOpacity(0.05)]),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kAmber.withOpacity(0.3)),
//       ),
//       child: Row(children: [
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//               color: kAmber.withOpacity(0.2), shape: BoxShape.circle),
//           child: const Icon(Icons.local_offer, color: kAmber, size: 18),
//         ),
//         const SizedBox(width: 12),
//         Expanded(child: Text(
//           'Product #$productId  ·  '
//               '${controller.discountPercentage.value.toStringAsFixed(0)}% discount applied',
//           style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
//               color: Color(0xFF92400E)),
//         )),
//       ]),
//     ));
//   }
//
//   Widget _buildLoadingOverlay() {
//     return Obx(() {
//       if (!controller.isSubmitting.value) return const SizedBox.shrink();
//       return Container(
//         color: Colors.black.withOpacity(0.5),
//         child: Center(child: Card(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           child: const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 32, vertical: 28),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Updating product...',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//             ]),
//           ),
//         )),
//       );
//     });
//   }
//
//   Widget _buildProductNameCard() {
//     return _buildCard(child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Product Name', Icons.shopping_bag_outlined),
//         const SizedBox(height: 12),
//         _inputBox(child: TextField(
//           controller: controller.productNameController,
//           onChanged: (val) => controller.productName.value = val,
//           style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
//           decoration: const InputDecoration(
//             hintText: 'e.g., Classic Cotton T-Shirt',
//             prefixIcon: Icon(Icons.label_outline, color: Color(0xFF6B7280), size: 20),
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//           ),
//         )),
//       ],
//     ));
//   }
//
//   Widget _buildDescriptionCard() {
//     return _buildCard(child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Description', Icons.description_outlined),
//         const SizedBox(height: 12),
//         _inputBox(child: TextField(
//           controller: controller.productDescriptionController,
//           onChanged: (val) => controller.productDescription.value = val,
//           maxLines: 4,
//           style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
//           decoration: const InputDecoration(
//             hintText: 'Describe your product in detail...',
//             prefixIcon: Padding(
//               padding: EdgeInsets.only(top: 12),
//               child: Icon(Icons.text_fields, color: Color(0xFF6B7280), size: 20),
//             ),
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//           ),
//         )),
//       ],
//     ));
//   }
//
//   Widget _buildCategoryCard() {
//     return _buildCard(child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Category', Icons.category_outlined),
//         const SizedBox(height: 12),
//         Obx(() {
//           if (controller.isLoadingCategories.value)
//             return const Center(child: CircularProgressIndicator());
//           if (controller.apiCategories.isEmpty) {
//             return Row(children: [
//               const Icon(Icons.warning_amber, color: Colors.orange),
//               const SizedBox(width: 12),
//               const Expanded(child: Text('No categories available')),
//               TextButton(onPressed: controller.fetchCategories,
//                   child: const Text('Retry')),
//             ]);
//           }
//           return _inputBox(child: DropdownButtonFormField<String>(
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               prefixIcon: Icon(Icons.list_alt, color: Color(0xFF6B7280), size: 20),
//               hintText: 'Choose a category',
//               hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//               contentPadding: EdgeInsets.symmetric(horizontal: 16),
//             ),
//             value: controller.selectedCategory.value.isEmpty
//                 ? null : controller.selectedCategory.value,
//             items: controller.apiCategories
//                 .map((c) => DropdownMenuItem(
//                 value: c.name,
//                 child: Text(c.name, style: const TextStyle(fontSize: 15))))
//                 .toList(),
//             onChanged: (val) {
//               if (val != null) controller.onCategoryChanged(val);
//             },
//             dropdownColor: Colors.white,
//             icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
//           ));
//         }),
//       ],
//     ));
//   }
//
//   Widget _buildCommonAttributesSection() {
//     final config = controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null || config.commonAttributes.isEmpty)
//       return const SizedBox.shrink();
//     return _buildCard(child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Common Attributes', Icons.info_outline),
//         const SizedBox(height: 6),
//         const Text('These attributes apply to all variants',
//             style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
//         const SizedBox(height: 16),
//         ...config.commonAttributes.map((attr) => Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: _buildCommonAttributeInput(attr),
//         )),
//       ],
//     ));
//   }
//
//   Widget _buildCommonAttributeInput(String attribute) {
//     final textController = controller.getCommonAttrController(attribute);
//     return _inputBox(child: TextField(
//       controller: textController,
//       onChanged: (value) => controller.setCommonAttribute(attribute, value),
//       style: const TextStyle(fontSize: 14),
//       decoration: InputDecoration(
//         labelText: attribute, hintText: 'Enter $attribute',
//         border: InputBorder.none,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//         hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//       ),
//     ));
//   }
//
//   Widget _buildVariantConfigurationSection() {
//     final config = controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null || config.variantAttributes.isEmpty)
//       return const SizedBox.shrink();
//
//     return _buildCard(child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Configure Variants', Icons.tune),
//         const SizedBox(height: 6),
//         const Text('Select a variant type, add values, then generate variants.',
//             style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
//         const SizedBox(height: 16),
//
//         Obx(() {
//           if (controller.configuredVariantTypes.isEmpty) return const SizedBox.shrink();
//           return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             const Text('Configured:', style: TextStyle(
//                 fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
//             const SizedBox(height: 8),
//             ...controller.configuredVariantTypes.entries.map((entry) =>
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: kGreen.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: kGreen.withOpacity(0.3)),
//                   ),
//                   child: Row(children: [
//                     Expanded(child: Text('${entry.key}: ${entry.value.join(', ')}',
//                         style: const TextStyle(fontSize: 13, color: Color(0xFF374151)))),
//                     GestureDetector(
//                       onTap: () {
//                         controller.configuredVariantTypes.remove(entry.key);
//                         controller.configuredVariantTypes.refresh();
//                       },
//                       child: const Icon(Icons.delete_outline, size: 18, color: kRed),
//                     ),
//                   ]),
//                 )),
//             const SizedBox(height: 12),
//             const Divider(),
//             const SizedBox(height: 12),
//           ]);
//         }),
//
//         Obx(() => _inputBox(child: DropdownButtonFormField<String>(
//           isExpanded: true,
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//             prefixIcon: Icon(Icons.category, color: Color(0xFF6B7280), size: 20),
//             hintText: 'Select variant type (e.g., Color, Size)',
//             hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16),
//           ),
//           value: controller.selectedVariantType.value.isEmpty
//               ? null : controller.selectedVariantType.value,
//           items: config.variantAttributes
//               .map((attr) => DropdownMenuItem(
//               value: attr,
//               child: Text(attr, style: const TextStyle(fontSize: 15))))
//               .toList(),
//           onChanged: (value) {
//             if (value != null) controller.onVariantTypeSelected(value);
//           },
//           dropdownColor: Colors.white,
//           icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
//         ))),
//
//         Obx(() => controller.selectedVariantType.value.isNotEmpty
//             ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const SizedBox(height: 20),
//           const Divider(),
//           const SizedBox(height: 16),
//           Text('Add values for "${controller.selectedVariantType.value}"',
//               style: const TextStyle(fontSize: 14,
//                   fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
//           const SizedBox(height: 4),
//           const Text('Tip: separate multiple values with a comma',
//               style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
//           const SizedBox(height: 12),
//           Obx(() {
//             if (controller.currentVariantValues.isEmpty)
//               return const SizedBox.shrink();
//             return Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               margin: const EdgeInsets.only(bottom: 12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF9FAFB),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: const Color(0xFFE5E7EB)),
//               ),
//               child: Wrap(
//                 spacing: 8, runSpacing: 8,
//                 children: controller.currentVariantValues.map((value) =>
//                     Chip(
//                       label: Text(value, style: const TextStyle(fontSize: 13)),
//                       deleteIcon: const Icon(Icons.close, size: 16),
//                       onDeleted: () => controller.removeVariantValue(value),
//                       backgroundColor: kBlue.withOpacity(0.1),
//                       labelStyle: const TextStyle(
//                           color: kBlue, fontWeight: FontWeight.w500),
//                     )).toList(),
//               ),
//             );
//           }),
//           Row(children: [
//             Expanded(child: _inputBox(child: TextField(
//               controller: controller.variantValueController,
//               decoration: const InputDecoration(
//                 hintText: 'e.g., Red or S, M, L',
//                 hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(
//                     horizontal: 12, vertical: 12),
//               ),
//               onSubmitted: (val) => controller.addVariantValue(val),
//             ))),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: () => controller.addVariantValue(
//                   controller.variantValueController.text),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: kBlue,
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 20, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8))),
//               child: const Text('Add',
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//             ),
//           ]),
//         ])
//             : const SizedBox.shrink()),
//
//         Obx(() {
//           if (controller.configuredVariantTypes.isEmpty)
//             return const SizedBox.shrink();
//           return Column(children: [
//             const SizedBox(height: 16),
//             SizedBox(width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: controller.generateVariantsFromType,
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: kGreen,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12))),
//                   icon: const Icon(Icons.auto_awesome),
//                   label: const Text('Generate All Variants',
//                       style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
//                 )),
//           ]);
//         }),
//       ],
//     ));
//   }
//
//   Widget _buildVariantsList(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Product Variants',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
//                     color: Color(0xFF1A1A1A))),
//             Obx(() => Text('${controller.variants.length} variant(s)',
//                 style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)))),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Obx(() => Column(
//           children: controller.variants.asMap().entries
//               .map((e) => _buildVariantCard(context, e.key, e.value))
//               .toList(),
//         )),
//       ],
//     );
//   }
//
//   Widget _buildVariantCard(
//       BuildContext context, int index, KEditOfferVariant variant) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
//             blurRadius: 10, offset: const Offset(0, 2))],
//       ),
//       child: Column(children: [
//         // Header
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: kBlue.withOpacity(0.05),
//             borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16), topRight: Radius.circular(16)),
//           ),
//           child: Row(children: [
//             Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Variant ${index + 1}',
//                     style: const TextStyle(color: kBlue,
//                         fontWeight: FontWeight.w600, fontSize: 13)),
//                 const SizedBox(height: 4),
//                 Text(variant.getDisplayName(),
//                     style: const TextStyle(color: Color(0xFF1A1A1A),
//                         fontWeight: FontWeight.w600, fontSize: 15)),
//               ],
//             )),
//             if (variant.finalPrice != null && variant.finalPrice! > 0)
//               Container(
//                 margin: const EdgeInsets.only(right: 8),
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: kAmber.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: kAmber.withOpacity(0.4)),
//                 ),
//                 child: Text('₹${variant.finalPrice!.toStringAsFixed(0)} offer',
//                     style: const TextStyle(fontSize: 11,
//                         fontWeight: FontWeight.w700, color: kAmber)),
//               ),
//             IconButton(
//               icon: const Icon(Icons.delete_outline, color: kRed, size: 20),
//               onPressed: () => _showDeleteDialog(context, index),
//             ),
//           ]),
//         ),
//
//         // Body
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildImagePicker(index),
//               const SizedBox(height: 20),
//               Row(children: [
//                 Expanded(child: _buildPriceField(variant, index)),
//                 const SizedBox(width: 12),
//                 Expanded(child: _buildStockField(variant, index)),
//               ]),
//               if (variant.attributes.isNotEmpty) ...[
//                 const SizedBox(height: 16),
//                 const Text('Variant Attributes',
//                     style: TextStyle(fontSize: 14,
//                         fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
//                 const SizedBox(height: 12),
//                 ...variant.attributes.entries.map((entry) => Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: _buildVariantAttributeField(entry.key, entry.value),
//                 )),
//               ],
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
//
//   // ── Image picker ──────────────────────────────────────────────────────────
//   Widget _buildImagePicker(int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Product Image', style: TextStyle(fontSize: 14,
//             fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
//         const SizedBox(height: 12),
//         Obx(() {
//           // ✅ FIX: Bounds check prevents stale index reads after variant removal
//           if (index >= controller.variants.length) return const SizedBox.shrink();
//           final variant = controller.variants[index];
//
//           final hasAny       = variant.hasImage;
//           final isLocal      = variant.isLocalImage;
//           final displayPath  = variant.displayImagePath;
//
//           return GestureDetector(
//             onTap: () => controller.pickImage(index),
//             child: Container(
//               height: 160, width: double.infinity,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF9FAFB),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                     color: hasAny ? kBlue : const Color(0xFFE5E7EB),
//                     width: hasAny ? 2 : 1),
//               ),
//               child: !hasAny
//                   ? const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.add_photo_alternate_outlined,
//                         size: 40, color: kBlue),
//                     SizedBox(height: 8),
//                     Text('Tap to add image',
//                         style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
//                   ])
//                   : Stack(fit: StackFit.expand, children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   // ✅ FIX: Use isLocalImage to decide File vs Network
//                   //         Previously always fell through to Network after
//                   //         existingImageUrl was wiped — now each variant
//                   //         correctly shows its own image at all times
//                   child: isLocal
//                       ? Image.file(File(displayPath!), fit: BoxFit.cover)
//                       : Image.network(
//                     displayPath!,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       color: Colors.grey.shade200,
//                       child: const Icon(Icons.image_not_supported,
//                           color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 if (!isLocal)
//                   Positioned(
//                     bottom: 8, left: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: const Text('Current image',
//                           style: TextStyle(
//                               color: Colors.white, fontSize: 11)),
//                     ),
//                   ),
//                 Positioned(
//                   top: 8, right: 8,
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     _imageActionButton(
//                         icon: Icons.edit, color: kBlue,
//                         onTap: () => controller.pickImage(index)),
//                     const SizedBox(width: 6),
//                     _imageActionButton(
//                         icon: Icons.delete, color: kRed,
//                         onTap: () => controller.removeImage(index)),
//                   ]),
//                 ),
//               ]),
//             ),
//           );
//         }),
//       ],
//     );
//   }
//
//   Widget _imageActionButton(
//       {required IconData icon, required Color color, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(6),
//         decoration: BoxDecoration(
//           color: Colors.white, shape: BoxShape.circle,
//           boxShadow: [BoxShadow(
//               color: Colors.black.withOpacity(0.2), blurRadius: 6)],
//         ),
//         child: Icon(icon, color: color, size: 18),
//       ),
//     );
//   }
//
//   Widget _buildPriceField(KEditOfferVariant variant, int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: kGreen.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: kGreen.withOpacity(0.3)),
//           ),
//           child: TextField(
//             key: Key('edit_price_$index'),
//             controller: variant.priceController,
//             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             decoration: const InputDecoration(
//               labelText: 'Original Price (₹)', hintText: '0.00',
//               prefixIcon: Icon(Icons.currency_rupee, color: kGreen, size: 18),
//               filled: true, fillColor: Colors.white,
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8)),
//                   borderSide: BorderSide.none),
//               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               labelStyle: TextStyle(fontSize: 12, color: kGreen),
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         ValueListenableBuilder<TextEditingValue>(
//           valueListenable: variant.priceController,
//           builder: (_, value, __) {
//             final price = double.tryParse(value.text.trim());
//             if (price != null && price > 0) {
//               final offerPrice = controller.computeOfferPrice(price);
//               if (offerPrice != null) {
//                 return Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFEF3C7),
//                     borderRadius: BorderRadius.circular(6),
//                     border: Border.all(color: kAmber.withOpacity(0.3)),
//                   ),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     const Icon(Icons.local_offer, color: kAmber, size: 12),
//                     const SizedBox(width: 4),
//                     Flexible(child: Obx(() => Text(
//                       '₹${offerPrice.toStringAsFixed(0)} '
//                           '(${controller.discountPercentage.value.toStringAsFixed(0)}% off)',
//                       style: const TextStyle(fontSize: 11,
//                           fontWeight: FontWeight.w700, color: kAmber),
//                       overflow: TextOverflow.ellipsis,
//                     ))),
//                   ]),
//                 );
//               }
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStockField(KEditOfferVariant variant, int index) {
//     return Container(
//       decoration: BoxDecoration(
//         color: kBlue.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: kBlue.withOpacity(0.3)),
//       ),
//       child: TextField(
//         key: Key('edit_stock_$index'),
//         controller: variant.stockController,
//         keyboardType: TextInputType.number,
//         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         decoration: const InputDecoration(
//           labelText: 'Stock', hintText: '0',
//           prefixIcon: Icon(Icons.inventory_outlined, color: kBlue, size: 18),
//           filled: true, fillColor: Colors.white,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(8)),
//               borderSide: BorderSide.none),
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           labelStyle: TextStyle(fontSize: 12, color: kBlue),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildVariantAttributeField(String attribute, String value) {
//     return _inputBox(child: TextField(
//       controller: TextEditingController(text: value),
//       enabled: false,
//       style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
//       decoration: InputDecoration(
//         labelText: attribute, border: InputBorder.none,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//       ),
//     ));
//   }
//
//   void _showDeleteDialog(BuildContext context, int index) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Row(children: [
//           Icon(Icons.warning_amber_rounded, color: kRed),
//           SizedBox(width: 12),
//           Text('Remove Variant?'),
//         ]),
//         content: const Text('Are you sure you want to remove this variant?',
//             style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
//         actions: [
//           TextButton(onPressed: () => Navigator.of(ctx).pop(),
//               child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () { controller.removeVariant(index); Navigator.of(ctx).pop(); },
//             style: ElevatedButton.styleFrom(backgroundColor: kRed),
//             child: const Text('Remove'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard({required Widget child}) {
//     return Container(
//       width: double.infinity, padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
//             blurRadius: 10, offset: const Offset(0, 2))],
//       ),
//       child: child,
//     );
//   }
//
//   Widget _inputBox({required Widget child}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9FAFB),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//       ),
//       child: child,
//     );
//   }
//
//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Row(children: [
//       Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             color: kBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
//         child: Icon(icon, color: kBlue, size: 20),
//       ),
//       const SizedBox(width: 12),
//       Text(title, style: const TextStyle(fontSize: 16,
//           fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
//     ]);
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/merchant_offerproductupdatecontroller.dart';

class EditOfferProductPage extends StatelessWidget {
  final int productId;
  final int offerId;

  const EditOfferProductPage({
    super.key,
    required this.productId,
    required this.offerId,
  });

  static const Color kPrimary = Color(0xFF6366F1);
  static const Color kGreen   = Color(0xFF10B981);
  static const Color kBlue    = Color(0xFF3B82F6);
  static const Color kRed     = Color(0xFFEF4444);
  static const Color kAmber   = Color(0xFFF59E0B);

  // ── Controller ────────────────────────────────────────────────────────────
  // FIX: Delete any stale instance with this tag before putting a fresh one.
  //      Without this, Get.put() returns the cached (empty) controller when
  //      the user navigates back and opens a different product.
  KEditOfferProductController _getController() {
    final tag = 'edit_offer_product_$productId';
    if (Get.isRegistered<KEditOfferProductController>(tag: tag)) {
      Get.delete<KEditOfferProductController>(tag: tag, force: true);
    }
    return Get.put(
      KEditOfferProductController(
          productId: productId, offerId: offerId),
      tag: tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _getController();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        title: const Text('Edit Offer Product',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 16)),
        actions: [
          Obx(() => controller.isSubmitting.value
              ? const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)))
              : TextButton.icon(
              onPressed: controller.updateOfferProduct,
              icon: const Icon(Icons.save_alt_rounded,
                  color: Colors.white, size: 18),
              label: const Text('Save',
                  style: TextStyle(
                      color:      Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize:   14)))),
        ],
      ),
      // FIX: Show loading overlay only while BOTH categories AND product are
      //      fetching. Once either finishes we show what we have.
      //      Previously isLoadingProduct alone could briefly hide a loaded form.
      body: Obx(() {
        final loading = controller.isLoadingProduct.value ||
            controller.isLoadingCategories.value;

        if (loading) {
          return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading product details…',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF6B7280))),
                ],
              ));
        }

        return Stack(children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDiscountBanner(controller),
                const SizedBox(height: 16),
                _buildProductNameCard(controller),
                const SizedBox(height: 16),
                _buildDescriptionCard(controller),
                const SizedBox(height: 16),
                _buildCategoryCard(controller),
                const SizedBox(height: 16),
                Obx(() =>
                controller.selectedCategory.value.isNotEmpty
                    ? _buildCommonAttributesSection(controller)
                    : const SizedBox.shrink()),
                Obx(() => (controller.selectedCategory.value
                    .isNotEmpty &&
                    controller.hasVariantAttributes())
                    ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildVariantConfigurationSection(
                        controller))
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),
                Obx(() => controller.variants.isNotEmpty
                    ? _buildVariantsList(context, controller)
                    : const SizedBox.shrink()),
                const SizedBox(height: 40),
              ],
            ),
          ),
          _buildLoadingOverlay(controller),
        ]);
      }),
    );
  }

  // ── Discount banner ───────────────────────────────────────────────────────
  Widget _buildDiscountBanner(KEditOfferProductController controller) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          kAmber.withOpacity(0.15),
          kAmber.withOpacity(0.05)
        ]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kAmber.withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color:  kAmber.withOpacity(0.2),
              shape: BoxShape.circle),
          child: const Icon(Icons.local_offer,
              color: kAmber, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Product #$productId  ·  '
                '${controller.discountPercentage.value.toStringAsFixed(0)}% discount applied',
            style: const TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w600,
                color:      Color(0xFF92400E)),
          ),
        ),
      ]),
    ));
  }

  // ── Loading overlay ───────────────────────────────────────────────────────
  Widget _buildLoadingOverlay(
      KEditOfferProductController controller) {
    return Obx(() {
      if (!controller.isSubmitting.value)
        return const SizedBox.shrink();
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 32, vertical: 28),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Updating product…',
                      style: TextStyle(
                          fontSize:   16,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
            )),
      );
    });
  }

  // ── Product name ──────────────────────────────────────────────────────────
  Widget _buildProductNameCard(
      KEditOfferProductController controller) {
    return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
                'Product Name', Icons.shopping_bag_outlined),
            const SizedBox(height: 12),
            _inputBox(
                child: TextField(
                  controller: controller.productNameController,
                  onChanged: (val) =>
                  controller.productName.value = val,
                  style: const TextStyle(
                      fontSize: 15, color: Color(0xFF1A1A1A)),
                  decoration: const InputDecoration(
                    hintText: 'e.g., Classic Cotton T-Shirt',
                    prefixIcon: Icon(Icons.label_outline,
                        color: Color(0xFF6B7280), size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    hintStyle: TextStyle(
                        color: Color(0xFF9CA3AF), fontSize: 14),
                  ),
                )),
          ],
        ));
  }

  // ── Description ───────────────────────────────────────────────────────────
  Widget _buildDescriptionCard(
      KEditOfferProductController controller) {
    return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
                'Description', Icons.description_outlined),
            const SizedBox(height: 12),
            _inputBox(
                child: TextField(
                  controller: controller.productDescriptionController,
                  onChanged: (val) =>
                  controller.productDescription.value = val,
                  maxLines: 4,
                  style: const TextStyle(
                      fontSize: 15, color: Color(0xFF1A1A1A)),
                  decoration: const InputDecoration(
                    hintText: 'Describe your product in detail…',
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
                )),
          ],
        ));
  }

  // ── Category ──────────────────────────────────────────────────────────────
  Widget _buildCategoryCard(
      KEditOfferProductController controller) {
    return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Category', Icons.category_outlined),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoadingCategories.value)
                return const Center(child: CircularProgressIndicator());
              if (controller.apiCategories.isEmpty) {
                return Row(children: [
                  const Icon(Icons.warning_amber, color: Colors.orange),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Text('No categories available')),
                  TextButton(
                      onPressed: controller.fetchCategories,
                      child: const Text('Retry')),
                ]);
              }
              return _inputBox(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.list_alt,
                          color: Color(0xFF6B7280), size: 20),
                      hintText: 'Choose a category',
                      hintStyle: TextStyle(
                          color: Color(0xFF9CA3AF), fontSize: 14),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16),
                    ),
                    value: controller.selectedCategory.value.isEmpty
                        ? null
                        : controller.selectedCategory.value,
                    items: controller.apiCategories
                        .map((c) => DropdownMenuItem(
                        value: c.name,
                        child: Text(c.name,
                            style:
                            const TextStyle(fontSize: 15))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null)
                        controller.onCategoryChanged(val);
                    },
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFF6B7280)),
                  ));
            }),
          ],
        ));
  }

  // ── Common attributes ─────────────────────────────────────────────────────
  Widget _buildCommonAttributesSection(
      KEditOfferProductController controller) {
    final config = controller
        .categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.commonAttributes.isEmpty)
      return const SizedBox.shrink();
    return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
                'Common Attributes', Icons.info_outline),
            const SizedBox(height: 6),
            const Text(
                'These attributes apply to all variants',
                style: TextStyle(
                    fontSize: 13, color: Color(0xFF6B7280))),
            const SizedBox(height: 16),
            ...config.commonAttributes.map((attr) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCommonAttributeInput(
                  controller, attr),
            )),
          ],
        ));
  }

  Widget _buildCommonAttributeInput(
      KEditOfferProductController controller, String attribute) {
    final textController =
    controller.getCommonAttrController(attribute);
    return _inputBox(
        child: TextField(
          controller: textController,
          onChanged: (value) =>
              controller.setCommonAttribute(attribute, value),
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: attribute,
            hintText:  'Enter $attribute',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 12),
            labelStyle: const TextStyle(
                fontSize: 13, color: Color(0xFF6B7280)),
            hintStyle: const TextStyle(
                fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
        ));
  }

  // ── Variant configuration ─────────────────────────────────────────────────
  Widget _buildVariantConfigurationSection(
      KEditOfferProductController controller) {
    final config = controller
        .categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.variantAttributes.isEmpty)
      return const SizedBox.shrink();

    return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Configure Variants', Icons.tune),
            const SizedBox(height: 6),
            const Text(
                'Select a variant type, add values, then generate variants.',
                style: TextStyle(
                    fontSize: 13, color: Color(0xFF6B7280))),
            const SizedBox(height: 16),

            // Configured summary
            Obx(() {
              if (controller.configuredVariantTypes.isEmpty)
                return const SizedBox.shrink();
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Configured:',
                        style: TextStyle(
                            fontSize:   13,
                            fontWeight: FontWeight.w600,
                            color:      Color(0xFF1A1A1A))),
                    const SizedBox(height: 8),
                    ...controller.configuredVariantTypes.entries
                        .map((entry) => Container(
                      margin: const EdgeInsets.only(
                          bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: kGreen.withOpacity(0.05),
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            kGreen.withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        Expanded(
                            child: Text(
                              '${entry.key}: ${entry.value.join(', ')}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color:
                                  Color(0xFF374151)),
                            )),
                        GestureDetector(
                          onTap: () {
                            controller
                                .configuredVariantTypes
                                .remove(entry.key);
                            controller
                                .configuredVariantTypes
                                .refresh();
                          },
                          child: const Icon(
                              Icons.delete_outline,
                              size:  18,
                              color: kRed),
                        ),
                      ]),
                    )),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                  ]);
            }),

            // Variant type dropdown
            Obx(() => _inputBox(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.category,
                        color: Color(0xFF6B7280), size: 20),
                    hintText:
                    'Select variant type (e.g., Color, Size)',
                    hintStyle: TextStyle(
                        color: Color(0xFF9CA3AF), fontSize: 14),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16),
                  ),
                  value: controller.selectedVariantType.value.isEmpty
                      ? null
                      : controller.selectedVariantType.value,
                  items: config.variantAttributes
                      .map((attr) => DropdownMenuItem(
                      value: attr,
                      child: Text(attr,
                          style:
                          const TextStyle(fontSize: 15))))
                      .toList(),
                  onChanged: (value) {
                    if (value != null)
                      controller.onVariantTypeSelected(value);
                  },
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Color(0xFF6B7280)),
                ))),

            // Value input
            Obx(() =>
            controller.selectedVariantType.value.isNotEmpty
                ? Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                      'Add values for "${controller.selectedVariantType.value}"',
                      style: const TextStyle(
                          fontSize:   14,
                          fontWeight: FontWeight.w600,
                          color:
                          Color(0xFF1A1A1A))),
                  const SizedBox(height: 4),
                  const Text(
                      'Tip: separate multiple values with a comma',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280))),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller
                        .currentVariantValues.isEmpty)
                      return const SizedBox.shrink();
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(
                          bottom: 12),
                      decoration: BoxDecoration(
                        color:
                        const Color(0xFFF9FAFB),
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(
                                0xFFE5E7EB)),
                      ),
                      child: Wrap(
                        spacing:    8,
                        runSpacing: 8,
                        children: controller
                            .currentVariantValues
                            .map((value) => Chip(
                          label: Text(value,
                              style:
                              const TextStyle(
                                  fontSize:
                                  13)),
                          deleteIcon:
                          const Icon(
                              Icons.close,
                              size: 16),
                          onDeleted: () =>
                              controller
                                  .removeVariantValue(
                                  value),
                          backgroundColor:
                          kBlue.withOpacity(
                              0.1),
                          labelStyle:
                          const TextStyle(
                              color: kBlue,
                              fontWeight:
                              FontWeight
                                  .w500),
                        ))
                            .toList(),
                      ),
                    );
                  }),
                  Row(children: [
                    Expanded(
                        child: _inputBox(
                            child: TextField(
                              controller: controller
                                  .variantValueController,
                              decoration:
                              const InputDecoration(
                                hintText:
                                'e.g., Red or S, M, L',
                                hintStyle: TextStyle(
                                    fontSize: 13,
                                    color:
                                    Color(0xFF9CA3AF)),
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical:   12),
                              ),
                              onSubmitted: (val) =>
                                  controller
                                      .addVariantValue(val),
                            ))),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () =>
                          controller.addVariantValue(
                              controller
                                  .variantValueController
                                  .text),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kBlue,
                          padding: const EdgeInsets
                              .symmetric(
                              horizontal: 20,
                              vertical:   12),
                          shape:
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  8))),
                      child: const Text('Add',
                          style: TextStyle(
                              fontWeight:
                              FontWeight.w600)),
                    ),
                  ]),
                ])
                : const SizedBox.shrink()),

            // Generate button
            Obx(() {
              if (controller.configuredVariantTypes.isEmpty)
                return const SizedBox.shrink();
              return Column(children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                    controller.generateVariantsFromType,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kGreen,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12))),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate All Variants',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize:   15)),
                  ),
                ),
              ]);
            }),
          ],
        ));
  }

  // ── Variants list ─────────────────────────────────────────────────────────
  Widget _buildVariantsList(
      BuildContext context, KEditOfferProductController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Product Variants',
                style: TextStyle(
                    fontSize:   18,
                    fontWeight: FontWeight.w600,
                    color:      Color(0xFF1A1A1A))),
            Obx(() => Text(
                '${controller.variants.length} variant(s)',
                style: const TextStyle(
                    fontSize: 13,
                    color:    Color(0xFF6B7280)))),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() => Column(
          children: controller.variants
              .asMap()
              .entries
              .map((e) => _buildVariantCard(
              context, controller, e.key, e.value))
              .toList(),
        )),
      ],
    );
  }

  // ── Single variant card ───────────────────────────────────────────────────
  Widget _buildVariantCard(
      BuildContext context,
      KEditOfferProductController controller,
      int index,
      KEditOfferVariant variant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color:      Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset:     const Offset(0, 2))
        ],
      ),
      child: Column(children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kBlue.withOpacity(0.05),
            borderRadius: const BorderRadius.only(
                topLeft:  Radius.circular(16),
                topRight: Radius.circular(16)),
          ),
          child: Row(children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Variant ${index + 1}',
                        style: const TextStyle(
                            color:      kBlue,
                            fontWeight: FontWeight.w600,
                            fontSize:   13)),
                    const SizedBox(height: 4),
                    Text(variant.getDisplayName(),
                        style: const TextStyle(
                            color:      Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w600,
                            fontSize:   15)),
                  ],
                )),
            if (variant.finalPrice != null &&
                variant.finalPrice! > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: kAmber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: kAmber.withOpacity(0.4)),
                ),
                child: Text(
                    '₹${variant.finalPrice!.toStringAsFixed(0)} offer',
                    style: const TextStyle(
                        fontSize:   11,
                        fontWeight: FontWeight.w700,
                        color:      kAmber)),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: kRed, size: 20),
              onPressed: () =>
                  _showDeleteDialog(context, controller, index),
            ),
          ]),
        ),

        // Body
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePicker(controller, index),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                      child: _buildPriceField(
                          controller, variant, index)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildStockField(
                          variant, index)),
                ]),
                if (variant.attributes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Variant Attributes',
                      style: TextStyle(
                          fontSize:   14,
                          fontWeight: FontWeight.w600,
                          color:      Color(0xFF1A1A1A))),
                  const SizedBox(height: 12),
                  ...variant.attributes.entries.map((entry) =>
                      Padding(
                        padding:
                        const EdgeInsets.only(bottom: 12),
                        child: _buildVariantAttributeField(
                            entry.key, entry.value),
                      )),
                ],
              ]),
        ),
      ]),
    );
  }

  // ── Image picker ──────────────────────────────────────────────────────────
  Widget _buildImagePicker(
      KEditOfferProductController controller, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product Image',
            style: TextStyle(
                fontSize:   14,
                fontWeight: FontWeight.w600,
                color:      Color(0xFF1A1A1A))),
        const SizedBox(height: 12),
        Obx(() {
          // Bounds check: prevents stale index after variant removal
          if (index >= controller.variants.length)
            return const SizedBox.shrink();

          final variant      = controller.variants[index];
          final hasAny       = variant.hasImage;
          final isLocal      = variant.isLocalImage;
          final displayPath  = variant.displayImagePath;

          return GestureDetector(
            onTap: () => controller.pickImage(index),
            child: Container(
              height: 160,
              width:  double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: hasAny
                        ? kBlue
                        : const Color(0xFFE5E7EB),
                    width: hasAny ? 2 : 1),
              ),
              child: !hasAny
                  ? const Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                        Icons
                            .add_photo_alternate_outlined,
                        size:  40,
                        color: kBlue),
                    SizedBox(height: 8),
                    Text('Tap to add image',
                        style: TextStyle(
                            fontSize: 13,
                            color:
                            Color(0xFF6B7280))),
                  ])
                  : Stack(fit: StackFit.expand, children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(10),
                  child: isLocal
                      ? Image.file(
                    File(displayPath!),
                    fit: BoxFit.cover,
                    key: ValueKey(displayPath),
                  )
                      : Image.network(
                    displayPath!,
                    fit: BoxFit.cover,
                    key: ValueKey(displayPath),
                    errorBuilder: (_, __, ___) =>
                        Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                              Icons
                                  .image_not_supported,
                              color: Colors.grey),
                        ),
                  ),
                ),
                if (!isLocal)
                  Positioned(
                    bottom: 8,
                    left:   8,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical:   4),
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.6),
                        borderRadius:
                        BorderRadius.circular(6),
                      ),
                      child: const Text(
                          'Current image',
                          style: TextStyle(
                              color:    Colors.white,
                              fontSize: 11)),
                    ),
                  ),
                Positioned(
                  top:   8,
                  right: 8,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _imageActionButton(
                            icon:  Icons.edit,
                            color: kBlue,
                            onTap: () => controller
                                .pickImage(index)),
                        const SizedBox(width: 6),
                        _imageActionButton(
                            icon:  Icons.delete,
                            color: kRed,
                            onTap: () => controller
                                .removeImage(index)),
                      ]),
                ),
              ]),
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
          color:  Colors.white,
          shape:  BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color:      Colors.black.withOpacity(0.2),
                blurRadius: 6)
          ],
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  // ── Price field ───────────────────────────────────────────────────────────
  Widget _buildPriceField(KEditOfferProductController controller,
      KEditOfferVariant variant, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color:  kGreen.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kGreen.withOpacity(0.3)),
          ),
          child: TextField(
            key:        Key('edit_price_$index'),
            controller: variant.priceController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true),
            style: const TextStyle(
                fontSize:   14,
                fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              labelText: 'Original Price (₹)',
              hintText:  '0.00',
              prefixIcon: Icon(Icons.currency_rupee,
                  color: kGreen, size: 18),
              filled:     true,
              fillColor:  Colors.white,
              border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 12, vertical: 12),
              labelStyle:
              TextStyle(fontSize: 12, color: kGreen),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: variant.priceController,
          builder: (_, value, __) {
            final price =
            double.tryParse(value.text.trim());
            if (price != null && price > 0) {
              final offerPrice =
              controller.computeOfferPrice(price);
              if (offerPrice != null) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: kAmber.withOpacity(0.3)),
                  ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_offer,
                            color: kAmber, size: 12),
                        const SizedBox(width: 4),
                        Flexible(
                            child: Obx(() => Text(
                              '₹${offerPrice.toStringAsFixed(0)} '
                                  '(${controller.discountPercentage.value.toStringAsFixed(0)}% off)',
                              style: const TextStyle(
                                  fontSize:   11,
                                  fontWeight: FontWeight.w700,
                                  color:      kAmber),
                              overflow:
                              TextOverflow.ellipsis,
                            ))),
                      ]),
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // ── Stock field ───────────────────────────────────────────────────────────
  Widget _buildStockField(
      KEditOfferVariant variant, int index) {
    return Container(
      decoration: BoxDecoration(
        color:  kBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBlue.withOpacity(0.3)),
      ),
      child: TextField(
        key:        Key('edit_stock_$index'),
        controller: variant.stockController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
            fontSize:   14,
            fontWeight: FontWeight.w600),
        decoration: const InputDecoration(
          labelText: 'Stock',
          hintText:  '0',
          prefixIcon: Icon(Icons.inventory_outlined,
              color: kBlue, size: 18),
          filled:    true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 12, vertical: 12),
          labelStyle:
          TextStyle(fontSize: 12, color: kBlue),
        ),
      ),
    );
  }

  // ── Variant attribute (read-only) ─────────────────────────────────────────
  Widget _buildVariantAttributeField(
      String attribute, String value) {
    return _inputBox(
        child: TextField(
          controller: TextEditingController(text: value),
          enabled: false,
          style: const TextStyle(
              fontSize: 14, color: Color(0xFF6B7280)),
          decoration: InputDecoration(
            labelText: attribute,
            border:    InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 12),
            labelStyle: const TextStyle(
                fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ));
  }

  // ── Delete dialog ─────────────────────────────────────────────────────────
  void _showDeleteDialog(BuildContext context,
      KEditOfferProductController controller, int index) {
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
            style: ElevatedButton.styleFrom(
                backgroundColor: kRed),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────
  Widget _buildCard({required Widget child}) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color:      Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset:     const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  Widget _inputBox({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color:        const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color:        kBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: kBlue, size: 20),
      ),
      const SizedBox(width: 12),
      Text(title,
          style: const TextStyle(
              fontSize:   16,
              fontWeight: FontWeight.w600,
              color:      Color(0xFF1A1A1A))),
    ]);
  }
}