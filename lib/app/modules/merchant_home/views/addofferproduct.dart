// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../data/controllers/add_offer_product_controller.dart';
// import '../../../data/models/offer_models.dart';
//
// class AddOfferProductPage extends StatelessWidget {
//   final AddOfferProductController controller =
//   Get.put(AddOfferProductController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.kPrimary,
//         foregroundColor: Colors.white,
//         title: Obx(() => Text(
//           "Add Products · Offer #${controller.offerId}",
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//         )),
//         actions: [
//           // Product count badge
//           Obx(() => Center(
//             child: Container(
//               margin: const EdgeInsets.only(right: 8),
//               padding:
//               const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(20),
//                 border:
//                 Border.all(color: Colors.white.withOpacity(0.5)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.inventory_2_outlined,
//                       color: Colors.white, size: 14),
//                   const SizedBox(width: 4),
//                   Text(
//                     "${controller.totalProductsAdded.value}/10",
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ),
//           )),
//           // Done button
//           TextButton.icon(
//             onPressed: controller.finishOffer,
//             icon: const Icon(Icons.check_circle, color: Colors.white),
//             label: const Text("Done",
//                 style: TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.w600)),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 _buildOfferInfoBanner(),
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       _buildProductLimitIndicator(),
//                       const SizedBox(height: 16),
//                       Obx(() => controller.totalProductsAdded.value >= 10
//                           ? _buildMaxProductsReachedCard()
//                           : _buildProductForm(context)),
//                       const SizedBox(height: 120),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildLoadingOverlay(),
//         ],
//       ),
//       floatingActionButton: _buildFab(context),
//     );
//   }
//
//   // ── Offer info banner (shows offer_id + discount from CreateOfferPage) ──
//   Widget _buildOfferInfoBanner() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       decoration: BoxDecoration(
//         color: const Color(0xFF10B981).withOpacity(0.08),
//         border: Border(
//             bottom: BorderSide(
//                 color: const Color(0xFF10B981).withOpacity(0.2))),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: const Color(0xFF10B981).withOpacity(0.15),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.verified,
//                 color: Color(0xFF10B981), size: 18),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Offer #${controller.offerId} Created ✓",
//                   style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF10B981)),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   "${controller.discountPercentage}% discount · Add up to 10 products below",
//                   style: const TextStyle(
//                       fontSize: 12, color: Color(0xFF374151)),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Loading overlay ────────────────────────────────────────────────────
//   Widget _buildLoadingOverlay() {
//     return Obx(() {
//       if (!controller.isSubmitting.value) return const SizedBox.shrink();
//       return Container(
//         color: Colors.black.withOpacity(0.5),
//         child: Center(
//           child: Card(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16)),
//             child: const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 32, vertical: 28),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text("Adding product to offer...",
//                       style: TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.w600)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   // ── FAB ────────────────────────────────────────────────────────────────
//   Widget _buildFab(BuildContext context) {
//     return Obx(() {
//       if (controller.variants.isNotEmpty &&
//           !controller.isSubmitting.value &&
//           controller.totalProductsAdded.value < 10) {
//         return FloatingActionButton.extended(
//           onPressed: () => _saveOfferProduct(context),
//           backgroundColor: const Color(0xFF10B981),
//           icon: const Icon(Icons.add_circle_outline),
//           label: const Text("Add Product to Offer",
//               style: TextStyle(fontWeight: FontWeight.w600)),
//           elevation: 4,
//         );
//       }
//       return const SizedBox.shrink();
//     });
//   }
//
//   // ── Product limit indicator ────────────────────────────────────────────
//   Widget _buildProductLimitIndicator() {
//     return Obx(() {
//       final currentCount = controller.totalProductsAdded.value;
//       const maxCount = 10;
//       final percentage = (currentCount / maxCount).clamp(0.0, 1.0);
//       final isAtLimit = currentCount >= maxCount;
//       final isNearLimit = currentCount >= 8;
//
//       final Color indicatorColor;
//       final Color bgColor;
//       final IconData icon;
//       final String message;
//
//       if (isAtLimit) {
//         indicatorColor = const Color(0xFFEF4444);
//         bgColor = const Color(0xFFFEE2E2);
//         icon = Icons.block;
//         message = "Maximum limit reached!";
//       } else if (isNearLimit) {
//         indicatorColor = const Color(0xFFF59E0B);
//         bgColor = const Color(0xFFFEF3C7);
//         icon = Icons.warning_amber_rounded;
//         message = "Almost at limit! ${maxCount - currentCount} remaining.";
//       } else {
//         indicatorColor = const Color(0xFF10B981);
//         bgColor = const Color(0xFFD1FAE5);
//         icon = Icons.check_circle_outline;
//         message = "$currentCount of $maxCount products added";
//       }
//
//       return Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: indicatorColor.withOpacity(0.3)),
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: indicatorColor, size: 24),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Product Limit",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: indicatorColor)),
//                       const SizedBox(height: 4),
//                       Text(message,
//                           style: TextStyle(
//                               fontSize: 13,
//                               color: indicatorColor.withOpacity(0.8))),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(4),
//               child: LinearProgressIndicator(
//                 value: percentage,
//                 backgroundColor: Colors.white.withOpacity(0.5),
//                 valueColor: AlwaysStoppedAnimation(indicatorColor),
//                 minHeight: 8,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   // ── Max products reached card ──────────────────────────────────────────
//   Widget _buildMaxProductsReachedCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFEE2E2),
//         borderRadius: BorderRadius.circular(16),
//         border:
//         Border.all(color: const Color(0xFFEF4444).withOpacity(0.4)),
//       ),
//       child: Column(
//         children: [
//           const Icon(Icons.block, color: Color(0xFFEF4444), size: 48),
//           const SizedBox(height: 12),
//           const Text("Maximum 10 Products Reached",
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFFEF4444))),
//           const SizedBox(height: 8),
//           const Text(
//             "You've added all 10 products. Tap \"Done\" to finish.",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 13, color: Color(0xFFDC2626)),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: controller.finishOffer,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF10B981),
//               padding:
//               const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//             ),
//             icon: const Icon(Icons.check_circle),
//             label: const Text("Finish Offer",
//                 style:
//                 TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Product form ───────────────────────────────────────────────────────
//   Widget _buildProductForm(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildProductNameCard(),
//         const SizedBox(height: 16),
//         _buildDescriptionCard(),
//         const SizedBox(height: 16),
//         _buildCategoryCard(context),
//         const SizedBox(height: 16),
//         Obx(() => controller.selectedCategory.value.isNotEmpty
//             ? Column(children: [
//           _buildCommonAttributesSection(),
//           const SizedBox(height: 16),
//         ])
//             : const SizedBox.shrink()),
//         Obx(() => (controller.selectedCategory.value.isNotEmpty &&
//             controller.hasVariantAttributes())
//             ? Column(children: [
//           _buildVariantConfigurationSection(context),
//           const SizedBox(height: 16),
//         ])
//             : const SizedBox.shrink()),
//         Obx(() => controller.variants.isNotEmpty
//             ? Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildVariantsHeader(),
//             const SizedBox(height: 16),
//             ...controller.variants
//                 .asMap()
//                 .entries
//                 .map((entry) =>
//                 _buildVariantCard(context, entry.key, entry.value)),
//           ],
//         )
//             : const SizedBox.shrink()),
//       ],
//     );
//   }
//
//   // ── Product name ───────────────────────────────────────────────────────
//   Widget _buildProductNameCard() {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Product Name", Icons.shopping_bag_outlined),
//           const SizedBox(height: 12),
//           _buildTextField(
//             label: "Enter product name",
//             hint: "e.g., Classic Cotton T-Shirt",
//             icon: Icons.label_outline,
//             onChanged: (val) => controller.productName.value = val,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Description ────────────────────────────────────────────────────────
//   Widget _buildDescriptionCard() {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle(
//               "Product Description", Icons.description_outlined),
//           const SizedBox(height: 12),
//           Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFFF9FAFB),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFE5E7EB)),
//             ),
//             child: TextField(
//               onChanged: (val) =>
//               controller.productDescription.value = val,
//               style: const TextStyle(
//                   fontSize: 15, color: Color(0xFF1A1A1A)),
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 hintText: "Describe your product in detail...",
//                 prefixIcon: Padding(
//                   padding: EdgeInsets.only(top: 12),
//                   child: Icon(Icons.text_fields,
//                       color: Color(0xFF6B7280), size: 20),
//                 ),
//                 border: InputBorder.none,
//                 contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 hintStyle:
//                 TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Category ───────────────────────────────────────────────────────────
//   Widget _buildCategoryCard(BuildContext context) {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Category", Icons.category_outlined),
//           const SizedBox(height: 12),
//           Obx(() {
//             if (controller.isLoadingCategories.value) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (controller.apiCategories.isEmpty) {
//               return Row(children: [
//                 const Icon(Icons.warning_amber, color: Colors.orange),
//                 const SizedBox(width: 12),
//                 const Expanded(child: Text("No categories available")),
//                 TextButton(
//                     onPressed: controller.fetchCategories,
//                     child: const Text("Retry")),
//               ]);
//             }
//             return Container(
//               decoration: BoxDecoration(
//                   color: const Color(0xFFF9FAFB),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFE5E7EB))),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     prefixIcon: Icon(Icons.list_alt,
//                         color: Color(0xFF6B7280), size: 20),
//                     hintText: "Choose a category",
//                     hintStyle: TextStyle(
//                         color: Color(0xFF9CA3AF), fontSize: 14)),
//                 value: controller.selectedCategory.value.isEmpty
//                     ? null
//                     : controller.selectedCategory.value,
//                 items: controller.apiCategories
//                     .map((c) => DropdownMenuItem(
//                     value: c.name,
//                     child: Text(c.name,
//                         style: const TextStyle(fontSize: 15))))
//                     .toList(),
//                 onChanged: (val) {
//                   if (val != null) controller.onCategoryChanged(val);
//                 },
//                 dropdownColor: Colors.white,
//                 icon: const Icon(Icons.keyboard_arrow_down,
//                     color: Color(0xFF6B7280)),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   // ── Common attributes ──────────────────────────────────────────────────
//   Widget _buildCommonAttributesSection() {
//     final config =
//     controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null || config.commonAttributes.isEmpty) {
//       return const SizedBox.shrink();
//     }
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Common Attributes", Icons.info_outline),
//           const SizedBox(height: 8),
//           const Text("These attributes apply to all variants",
//               style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
//           const SizedBox(height: 16),
//           ...config.commonAttributes.map((attr) => Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: _buildCommonAttributeInput(attr),
//           )),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCommonAttributeInput(String attribute) {
//     return Container(
//       decoration: BoxDecoration(
//           color: const Color(0xFFF9FAFB),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xFFE5E7EB))),
//       child: TextField(
//         onChanged: (value) =>
//             controller.setCommonAttribute(attribute, value),
//         style: const TextStyle(fontSize: 14),
//         decoration: InputDecoration(
//           labelText: attribute,
//           hintText: "Enter $attribute",
//           border: InputBorder.none,
//           contentPadding:
//           const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           labelStyle:
//           const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//           hintStyle:
//           const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//         ),
//       ),
//     );
//   }
//
//   // ── Variant configuration ──────────────────────────────────────────────
//   Widget _buildVariantConfigurationSection(BuildContext context) {
//     final config =
//     controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null || config.variantAttributes.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Configure Variants", Icons.tune),
//           const SizedBox(height: 8),
//           const Text(
//             "Example: Color 'Green' → sizes 'S'; Color 'Blue' → sizes 'M, L, XL'",
//             style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//           ),
//           const SizedBox(height: 16),
//           // Configured list
//           Obx(() {
//             if (controller.variantTypeConfigurations.isEmpty) {
//               return const SizedBox.shrink();
//             }
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Configured:",
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1A1A1A))),
//                 const SizedBox(height: 8),
//                 ...controller.variantTypeConfigurations.entries
//                     .map((typeEntry) => Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                       color: const Color(0xFF10B981)
//                           .withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                           color: const Color(0xFF10B981)
//                               .withOpacity(0.3))),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(typeEntry.key,
//                           style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF10B981))),
//                       const SizedBox(height: 8),
//                       ...typeEntry.value.entries.map(
//                             (primaryEntry) => Padding(
//                           padding:
//                           const EdgeInsets.only(bottom: 4),
//                           child: Row(children: [
//                             Expanded(
//                               child: Text(
//                                 "• ${primaryEntry.key}: ${primaryEntry.value.join(', ')}",
//                                 style: const TextStyle(
//                                     fontSize: 12,
//                                     color: Color(0xFF6B7280)),
//                               ),
//                             ),
//                             if (controller.selectedVariantType
//                                 .value ==
//                                 typeEntry.key)
//                               GestureDetector(
//                                 onTap: () =>
//                                     controller.removePrimaryValue(
//                                         primaryEntry.key),
//                                 child: const Icon(
//                                     Icons.delete_outline,
//                                     size: 16,
//                                     color: Colors.red),
//                               ),
//                           ]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )),
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 const SizedBox(height: 16),
//               ],
//             );
//           }),
//           // Variant type dropdown
//           Obx(() => Container(
//             decoration: BoxDecoration(
//                 color: const Color(0xFFF9FAFB),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: const Color(0xFFE5E7EB))),
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: DropdownButtonFormField<String>(
//               isExpanded: true,
//               decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   prefixIcon: Icon(Icons.category,
//                       color: Color(0xFF6B7280), size: 20),
//                   hintText: "Select variant type (e.g., Color, Size)",
//                   hintStyle: TextStyle(
//                       color: Color(0xFF9CA3AF), fontSize: 14)),
//               value:
//               controller.selectedVariantType.value.isEmpty
//                   ? null
//                   : controller.selectedVariantType.value,
//               items: config.variantAttributes
//                   .map((attr) => DropdownMenuItem(
//                   value: attr,
//                   child: Text(attr,
//                       style: const TextStyle(fontSize: 15))))
//                   .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   controller.onVariantTypeSelected(value);
//                 }
//               },
//               dropdownColor: Colors.white,
//               icon: const Icon(Icons.keyboard_arrow_down,
//                   color: Color(0xFF6B7280)),
//             ),
//           )),
//           Obx(() => controller.selectedVariantType.value.isNotEmpty
//               ? Column(children: [
//             const SizedBox(height: 20),
//             const Divider(),
//             const SizedBox(height: 20),
//             _buildVariantValueConfiguration(),
//           ])
//               : const SizedBox.shrink()),
//           // Generate button
//           Obx(() {
//             if (controller.variantTypeConfigurations.isEmpty) {
//               return const SizedBox.shrink();
//             }
//             final isAtLimit = controller.variants.length >= 10;
//             return Column(
//               children: [
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: isAtLimit
//                         ? null
//                         : controller.generateVariantsFromConfiguration,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                       isAtLimit ? Colors.grey : const Color(0xFF10B981),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     icon: const Icon(Icons.auto_awesome),
//                     label: Text(
//                         isAtLimit
//                             ? "Limit Reached"
//                             : "Generate All Variants",
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w600, fontSize: 15)),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   // ── Variant value configuration ────────────────────────────────────────
//   Widget _buildVariantValueConfiguration() {
//     return Obx(() {
//       final variantType = controller.selectedVariantType.value;
//       final primarySelected =
//           controller.currentPrimaryValue.value.isNotEmpty;
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Step 1: Add $variantType Value",
//               style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1A1A1A))),
//           const SizedBox(height: 12),
//           Row(children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: const Color(0xFFF9FAFB),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: const Color(0xFFE5E7EB))),
//                 child: TextField(
//                   controller: controller.primaryValueController,
//                   decoration: const InputDecoration(
//                       hintText: "e.g., Green, Blue",
//                       hintStyle: TextStyle(
//                           fontSize: 13, color: Color(0xFF9CA3AF)),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 12)),
//                   onSubmitted: (value) {
//                     if (value.trim().isNotEmpty) {
//                       controller.addPrimaryValue(value.trim());
//                     }
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: () {
//                 final value =
//                 controller.primaryValueController.text.trim();
//                 if (value.isNotEmpty) controller.addPrimaryValue(value);
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3B82F6),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 20, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8))),
//               child: const Text("Add",
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//             ),
//           ]),
//           if (primarySelected) ...[
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                   color: const Color(0xFF3B82F6).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                       color: const Color(0xFF3B82F6).withOpacity(0.3))),
//               child: Row(children: [
//                 const Icon(Icons.check_circle,
//                     color: Color(0xFF3B82F6), size: 20),
//                 const SizedBox(width: 8),
//                 Text(
//                     "Selected: ${controller.currentPrimaryValue.value}",
//                     style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF3B82F6))),
//               ]),
//             ),
//             const SizedBox(height: 20),
//             Text(
//                 "Step 2: Add Values for ${controller.currentPrimaryValue.value}",
//                 style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1A1A1A))),
//             const SizedBox(height: 8),
//             const Text(
//                 "e.g., For Green add 'S'; For Blue add 'M', 'L', 'XL'",
//                 style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
//             const SizedBox(height: 12),
//             if (controller.currentSecondaryValues.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 12),
//                 decoration: BoxDecoration(
//                     color: const Color(0xFFF9FAFB),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: const Color(0xFFE5E7EB))),
//                 child: Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: controller.currentSecondaryValues
//                       .map((value) => Chip(
//                     label: Text(value),
//                     deleteIcon:
//                     const Icon(Icons.close, size: 18),
//                     onDeleted: () =>
//                         controller.removeSecondaryValue(value),
//                     backgroundColor:
//                     const Color(0xFF3B82F6).withOpacity(0.1),
//                     labelStyle: const TextStyle(
//                         color: Color(0xFF3B82F6),
//                         fontWeight: FontWeight.w500),
//                   ))
//                       .toList(),
//                 ),
//               ),
//             Row(children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: const Color(0xFFF9FAFB),
//                       borderRadius: BorderRadius.circular(8),
//                       border:
//                       Border.all(color: const Color(0xFFE5E7EB))),
//                   child: TextField(
//                     controller: controller.secondaryValueController,
//                     decoration: const InputDecoration(
//                         hintText: "e.g., S",
//                         hintStyle: TextStyle(
//                             fontSize: 13, color: Color(0xFF9CA3AF)),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 12)),
//                     onSubmitted: (value) {
//                       if (value.trim().isNotEmpty) {
//                         controller.addSecondaryValue(value.trim());
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: () {
//                   final value =
//                   controller.secondaryValueController.text.trim();
//                   if (value.isNotEmpty)
//                     controller.addSecondaryValue(value);
//                 },
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF3B82F6),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8))),
//                 child: const Text("Add",
//                     style: TextStyle(fontWeight: FontWeight.w600)),
//               ),
//             ]),
//             const SizedBox(height: 16),
//             if (controller.currentSecondaryValues.isNotEmpty)
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: controller.savePrimaryWithSecondary,
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF10B981),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12))),
//                   icon: const Icon(Icons.save),
//                   label: const Text("Save Configuration",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600, fontSize: 15)),
//                 ),
//               ),
//           ],
//         ],
//       );
//     });
//   }
//
//   // ── Variants header ────────────────────────────────────────────────────
//   Widget _buildVariantsHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Product Variants",
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A))),
//         Obx(() {
//           final count = controller.variants.length;
//           return Text("$count variant(s) for this product",
//               style: TextStyle(
//                   fontSize: 13,
//                   color: count >= 10
//                       ? const Color(0xFFEF4444)
//                       : const Color(0xFF6B7280),
//                   fontWeight: count >= 10
//                       ? FontWeight.w600
//                       : FontWeight.normal));
//         }),
//       ],
//     );
//   }
//
//   // ── Variant card ───────────────────────────────────────────────────────
//   Widget _buildVariantCard(
//       BuildContext context, int index, OfferProductVariant variant) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFF3B82F6).withOpacity(0.05),
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   topRight: Radius.circular(16)),
//             ),
//             child: Row(children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Variant ${index + 1}",
//                         style: const TextStyle(
//                             color: Color(0xFF3B82F6),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 13)),
//                     const SizedBox(height: 4),
//                     Text(variant.getDisplayName(),
//                         style: const TextStyle(
//                             color: Color(0xFF1A1A1A),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 15)),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete_outline,
//                     color: Color(0xFFEF4444), size: 20),
//                 onPressed: () => _showDeleteDialog(context, index),
//               ),
//             ]),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildImagePicker(index),
//                 const SizedBox(height: 20),
//                 Row(children: [
//                   Expanded(child: _buildPriceField(variant, index)),
//                   const SizedBox(width: 12),
//                   Expanded(child: _buildStockField(variant)),
//                 ]),
//                 if (variant.attributes.isNotEmpty) ...[
//                   const SizedBox(height: 16),
//                   const Text("Variant Attributes",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1A1A1A))),
//                   const SizedBox(height: 12),
//                   ...variant.attributes.entries.map(
//                         (entry) => Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: _buildVariantAttributeField(
//                           entry.key, entry.value),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Price field ────────────────────────────────────────────────────────
//   Widget _buildPriceField(OfferProductVariant variant, int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: const Color(0xFF10B981).withOpacity(0.05),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                   color: const Color(0xFF10B981).withOpacity(0.3))),
//           child: TextField(
//             key: Key('price_$index'),
//             controller: TextEditingController(
//                 text: variant.price?.toString() ?? ''),
//             onChanged: (val) => controller.updateVariantPrice(
//                 index, double.tryParse(val)),
//             keyboardType:
//             TextInputType.numberWithOptions(decimal: true),
//             style: const TextStyle(
//                 fontSize: 14, fontWeight: FontWeight.w600),
//             decoration: const InputDecoration(
//               labelText: "Original Price (₹)",
//               hintText: "0.00",
//               prefixIcon: Icon(Icons.currency_rupee,
//                   color: Color(0xFF10B981), size: 18),
//               filled: true,
//               fillColor: Colors.white,
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8)),
//                   borderSide: BorderSide.none),
//               contentPadding:
//               EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               labelStyle:
//               TextStyle(fontSize: 12, color: Color(0xFF10B981)),
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         // ✅ Offer price uses discountPercentage passed from CreateOfferPage
//         Obx(() {
//           final _ = controller.variants.length;
//           final offerPrice = variant.offerPrice;
//           if (offerPrice != null &&
//               variant.price != null &&
//               variant.price! > 0) {
//             return Container(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               decoration: BoxDecoration(
//                   color: const Color(0xFFFEF3C7),
//                   borderRadius: BorderRadius.circular(6),
//                   border: Border.all(
//                       color: const Color(0xFFF59E0B).withOpacity(0.3))),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.local_offer,
//                       color: Color(0xFFF59E0B), size: 12),
//                   const SizedBox(width: 4),
//                   Flexible(
//                     child: Text(
//                       "₹${offerPrice.toStringAsFixed(0)} (${controller.discountPercentage}% off)",
//                       style: const TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFFF59E0B)),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         }),
//       ],
//     );
//   }
//
//   // ── Stock field ────────────────────────────────────────────────────────
//   Widget _buildStockField(OfferProductVariant variant) {
//     return Container(
//       decoration: BoxDecoration(
//           color: const Color(0xFF3B82F6).withOpacity(0.05),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//               color: const Color(0xFF3B82F6).withOpacity(0.3))),
//       child: TextField(
//         controller: TextEditingController(
//             text: variant.stock?.toString() ?? ''),
//         onChanged: (val) {
//           variant.stock = int.tryParse(val);
//           controller.variants.refresh();
//         },
//         keyboardType: TextInputType.number,
//         style: const TextStyle(
//             fontSize: 14, fontWeight: FontWeight.w600),
//         decoration: const InputDecoration(
//           labelText: "Stock",
//           hintText: "0",
//           prefixIcon: Icon(Icons.inventory_outlined,
//               color: Color(0xFF3B82F6), size: 18),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(8)),
//               borderSide: BorderSide.none),
//           contentPadding:
//           EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           labelStyle:
//           TextStyle(fontSize: 12, color: Color(0xFF3B82F6)),
//         ),
//       ),
//     );
//   }
//
//   // ── Variant attribute field (read-only) ────────────────────────────────
//   Widget _buildVariantAttributeField(String attribute, String value) {
//     return Container(
//       decoration: BoxDecoration(
//           color: const Color(0xFFF9FAFB),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xFFE5E7EB))),
//       child: TextField(
//         controller: TextEditingController(text: value),
//         enabled: false,
//         style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
//         decoration: InputDecoration(
//           labelText: attribute,
//           border: InputBorder.none,
//           contentPadding:
//           const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           labelStyle:
//           const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//         ),
//       ),
//     );
//   }
//
//   // ── Image picker ───────────────────────────────────────────────────────
//   Widget _buildImagePicker(int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Product Image",
//             style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A))),
//         const SizedBox(height: 12),
//         Obx(() {
//           final imagePath = index < controller.variants.length
//               ? controller.variants[index].imagePath
//               : null;
//           return GestureDetector(
//             onTap: () => controller.pickImage(index),
//             child: Container(
//               height: 160,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: const Color(0xFFF9FAFB),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                       color: const Color(0xFFE5E7EB), width: 2)),
//               child: imagePath == null
//                   ? const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.add_photo_alternate_outlined,
//                       size: 40, color: Color(0xFF3B82F6)),
//                   SizedBox(height: 8),
//                   Text("Tap to add image",
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: Color(0xFF6B7280))),
//                 ],
//               )
//                   : Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.file(File(imagePath),
//                         fit: BoxFit.cover),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.black
//                                     .withOpacity(0.2),
//                                 blurRadius: 8)
//                           ]),
//                       child: IconButton(
//                         icon: const Icon(Icons.edit,
//                             color: Color(0xFF3B82F6), size: 18),
//                         onPressed: () =>
//                             controller.pickImage(index),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
//
//   // ── Shared helpers ─────────────────────────────────────────────────────
//   Widget _buildCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: child,
//     );
//   }
//
//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//               color: const Color(0xFF3B82F6).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8)),
//           child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
//         ),
//         const SizedBox(width: 12),
//         Text(title,
//             style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A))),
//       ],
//     );
//   }
//
//   Widget _buildTextField({
//     required String label,
//     required String hint,
//     required IconData icon,
//     required Function(String) onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//           color: const Color(0xFFF9FAFB),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFFE5E7EB))),
//       child: TextField(
//         onChanged: onChanged,
//         style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           prefixIcon:
//           Icon(icon, color: const Color(0xFF6B7280), size: 20),
//           border: InputBorder.none,
//           contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           labelStyle: const TextStyle(
//               color: Color(0xFF6B7280), fontSize: 14),
//           hintStyle: const TextStyle(
//               color: Color(0xFF9CA3AF), fontSize: 14),
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteDialog(BuildContext context, int index) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16)),
//         title: const Row(children: [
//           Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
//           SizedBox(width: 12),
//           Text("Remove Variant?"),
//         ]),
//         content: const Text(
//             "Are you sure you want to remove this variant?",
//             style:
//             TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.of(ctx).pop(),
//               child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               controller.removeVariant(index);
//               Navigator.of(ctx).pop();
//             },
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFEF4444)),
//             child: const Text("Remove"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _saveOfferProduct(BuildContext context) {
//     if (controller.totalProductsAdded.value >= 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(children: [
//             Icon(Icons.error_outline, color: Colors.white),
//             SizedBox(width: 12),
//             Expanded(
//                 child: Text("Maximum 10 products limit reached!",
//                     style: TextStyle(fontWeight: FontWeight.w500))),
//           ]),
//           backgroundColor: const Color(0xFFEF4444),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8)),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//       return;
//     }
//     controller.saveOfferProduct();
//   }
// }