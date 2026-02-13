//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../data/models/offerproductcontroller.dart';
//
//
// class AddOfferProductPage extends StatelessWidget {
//   final IntegratedOfferController controller = Get.put(IntegratedOfferController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8F9FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor:AppColors.kPrimary,
//         foregroundColor: Colors.white,
//         title: Text(
//           "Add Offer Product",
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         actions: [
//           Obx(() => controller.isSubmitting.value
//               ? Padding(
//             padding: EdgeInsets.all(16),
//             child: SizedBox(
//               width: 24,
//               height: 24,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation(Colors.white),
//               ),
//             ),
//           )
//               : IconButton(
//             icon: Icon(Icons.save_outlined),
//             onPressed: () => _saveOfferProduct(context),
//             tooltip: "Save Offer Product",
//           )),
//         ],
//       ),
//       body: Obx(() => Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 _buildHeader(),
//                 Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       // OFFER DETAILS SECTION
//                       _buildOfferDetailsCard(),
//                       SizedBox(height: 16),
//
//                       // PRODUCT DETAILS SECTION
//                       _buildProductNameCard(),
//                       SizedBox(height: 16),
//                       _buildDescriptionCard(),
//                       SizedBox(height: 16),
//                       _buildCategoryCard(context),
//                       SizedBox(height: 24),
//
//                       // Show common attributes section if category selected
//                       if (controller.selectedCategory.value.isNotEmpty) ...[
//                         _buildCommonAttributesSection(),
//                         SizedBox(height: 24),
//                       ],
//
//                       // Show variant configuration if category has variant attributes
//                       if (controller.selectedCategory.value.isNotEmpty &&
//                           controller.hasVariantAttributes()) ...[
//                         _buildVariantConfigurationSection(context),
//                         SizedBox(height: 24),
//                       ],
//
//                       // Show generated variants list
//                       if (controller.variants.isNotEmpty) ...[
//                         _buildVariantsHeader(),
//                         SizedBox(height: 16),
//                         ...controller.variants
//                             .asMap()
//                             .entries
//                             .map((entry) {
//                           return _buildVariantCard(
//                               context, entry.key, entry.value);
//                         }).toList(),
//                       ],
//
//                       SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (controller.isSubmitting.value)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: Card(
//                   child: Padding(
//                     padding: EdgeInsets.all(24),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 16),
//                         Text(
//                           "Adding offer product...",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       )),
//       floatingActionButton: Obx(() => controller.variants.isNotEmpty &&
//           !controller.isSubmitting.value
//           ? FloatingActionButton.extended(
//         onPressed: () => _saveOfferProduct(context),
//         backgroundColor: Color(0xFF10B981),
//         icon: Icon(Icons.check_circle_outline),
//         label: Text(
//           "Add to Offer",
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         elevation: 4,
//       )
//           : SizedBox.shrink()),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//        child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Create New Offer",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             "Add offer details and product with discount",
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF6B7280),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOfferDetailsCard() {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Offer Details", Icons.local_offer_outlined),
//           SizedBox(height: 16),
//
//           // Discount Percentage
//           Text(
//             "Discount Percentage",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//           SizedBox(height: 8),
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0xFFF9FAFB),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Color(0xFFE5E7EB)),
//             ),
//             child: TextField(
//               controller: controller.discountPercentageCtrl,
//               keyboardType: TextInputType.number,
//               style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
//               decoration: InputDecoration(
//                 hintText: "e.g., 20",
//                 prefixIcon: Icon(Icons.percent, color: Color(0xFF6B7280), size: 20),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//               ),
//               onChanged: (value) {
//                 // Recalculate all variant offer prices when discount changes
//                 for (int i = 0; i < controller.variants.length; i++) {
//                   controller.updateVariantPrice(i, controller.variants[i].price);
//                 }
//               },
//             ),
//           ),
//           SizedBox(height: 16),
//
//           // Offer Banner
//           Text(
//             "Offer Banner",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//           SizedBox(height: 8),
//           Obx(() => GestureDetector(
//             onTap: () => controller.pickBannerImage(),
//             child: Container(
//               height: 180,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Color(0xFFF9FAFB),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Color(0xFFE5E7EB), width: 2),
//               ),
//               child: controller.bannerImage.value == null
//                   ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.add_photo_alternate_outlined,
//                     size: 48,
//                     color: Color(0xFF3B82F6),
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     "Tap to add offer banner",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF6B7280),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     "Recommended: 1920 x 1080",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Color(0xFF9CA3AF),
//                     ),
//                   ),
//                 ],
//               )
//                   : Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.file(
//                       controller.bannerImage.value!,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     top: 12,
//                     right: 12,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 8,
//                           ),
//                         ],
//                       ),
//                       child: IconButton(
//                         icon: Icon(Icons.edit,
//                             color: Color(0xFF3B82F6), size: 20),
//                         onPressed: () => controller.pickBannerImage(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProductNameCard() {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Product Name", Icons.shopping_bag_outlined),
//           SizedBox(height: 12),
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
//   Widget _buildDescriptionCard() {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Product Description", Icons.description_outlined),
//           SizedBox(height: 12),
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0xFFF9FAFB),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Color(0xFFE5E7EB)),
//             ),
//             child: TextField(
//               onChanged: (val) => controller.productDescription.value = val,
//               style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: "Describe your product in detail...",
//                 prefixIcon: Padding(
//                   padding: EdgeInsets.only(top: 12),
//                   child: Icon(Icons.text_fields,
//                       color: Color(0xFF6B7280), size: 20),
//                 ),
//                 border: InputBorder.none,
//                 contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryCard(BuildContext context) {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Category", Icons.category_outlined),
//           SizedBox(height: 12),
//           Obx(() {
//             if (controller.isLoadingCategories.value) {
//               return Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF9FAFB),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Color(0xFFE5E7EB)),
//                 ),
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             }
//
//             if (controller.apiCategories.isEmpty) {
//               return Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF9FAFB),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Color(0xFFE5E7EB)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.warning_amber, color: Colors.orange),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Text("No categories available"),
//                     ),
//                     TextButton(
//                       onPressed: () => controller.fetchCategories(),
//                       child: Text("Retry"),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             return Container(
//               decoration: BoxDecoration(
//                 color: Color(0xFFF9FAFB),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Color(0xFFE5E7EB)),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   prefixIcon: Icon(Icons.list_alt,
//                       color: Color(0xFF6B7280), size: 20),
//                   hintText: "Choose a category",
//                   hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//                 ),
//                 value: controller.selectedCategory.value.isEmpty
//                     ? null
//                     : controller.selectedCategory.value,
//                 items: controller.apiCategories
//                     .map((c) => DropdownMenuItem(
//                   value: c.name,
//                   child: Text(c.name, style: TextStyle(fontSize: 15)),
//                 ))
//                     .toList(),
//                 onChanged: (val) {
//                   controller.onCategoryChanged(val!);
//                 },
//                 dropdownColor: Colors.white,
//                 icon:
//                 Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCommonAttributesSection() {
//     final config =
//     controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null || config.commonAttributes.isEmpty)
//       return SizedBox.shrink();
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Common Attributes", Icons.info_outline),
//           SizedBox(height: 8),
//           Text(
//             "These attributes apply to all variants",
//             style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//           ),
//           SizedBox(height: 16),
//           ...config.commonAttributes.map((attr) {
//             return Padding(
//               padding: EdgeInsets.only(bottom: 12),
//               child: _buildCommonAttributeInput(attr),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCommonAttributeInput(String attribute) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFFF9FAFB),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFFE5E7EB)),
//       ),
//       child: TextField(
//         onChanged: (value) =>
//             controller.setCommonAttribute(attribute, value),
//         style: TextStyle(fontSize: 14),
//         decoration: InputDecoration(
//           labelText: attribute,
//           hintText: "Enter $attribute",
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           labelStyle: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//           hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildVariantConfigurationSection(BuildContext context) {
//     final config =
//     controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null || config.variantAttributes.isEmpty)
//       return SizedBox.shrink();
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Configure Variants", Icons.tune),
//           SizedBox(height: 8),
//           Text(
//             "Example: For Color 'Green' → add sizes 'S'; For Color 'Blue' → add sizes 'M, L, XL'",
//             style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//           ),
//           SizedBox(height: 16),
//
//           // Show configured variant types summary
//           Obx(() {
//             if (controller.variantTypeConfigurations.isNotEmpty) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Configured:",
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   ...controller.variantTypeConfigurations.entries.map((typeEntry) {
//                     return Container(
//                       margin: EdgeInsets.only(bottom: 8),
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Color(0xFF10B981).withOpacity(0.05),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                             color: Color(0xFF10B981).withOpacity(0.3)),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             typeEntry.key,
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF10B981),
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           ...typeEntry.value.entries.map((primaryEntry) {
//                             return Padding(
//                               padding: EdgeInsets.only(bottom: 4),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       "• ${primaryEntry.key}: ${primaryEntry.value.join(', ')}",
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Color(0xFF6B7280),
//                                       ),
//                                     ),
//                                   ),
//                                   if (controller.selectedVariantType.value == typeEntry.key)
//                                     IconButton(
//                                       icon: Icon(Icons.delete_outline, size: 16, color: Colors.red),
//                                       onPressed: () => controller.removePrimaryValue(primaryEntry.key),
//                                       padding: EdgeInsets.zero,
//                                       constraints: BoxConstraints(),
//                                     ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                   SizedBox(height: 16),
//                   Divider(),
//                   SizedBox(height: 16),
//                 ],
//               );
//             }
//             return SizedBox.shrink();
//           }),
//
//           // Select variant type
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0xFFF9FAFB),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Color(0xFFE5E7EB)),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Obx(() => DropdownButtonFormField<String>(
//               isExpanded: true,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 prefixIcon: Icon(Icons.category,
//                     color: Color(0xFF6B7280), size: 20),
//                 hintText: "Select variant type (e.g., Color, Size)",
//                 hintStyle:
//                 TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//               ),
//               value: controller.selectedVariantType.value.isEmpty
//                   ? null
//                   : controller.selectedVariantType.value,
//               items: config.variantAttributes.map((attr) {
//                 return DropdownMenuItem(
//                   value: attr,
//                   child: Text(attr, style: TextStyle(fontSize: 15)),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   controller.onVariantTypeSelected(value);
//                 }
//               },
//               dropdownColor: Colors.white,
//               icon: Icon(Icons.keyboard_arrow_down,
//                   color: Color(0xFF6B7280)),
//             )),
//           ),
//
//           // Show configuration UI when variant type is selected
//           Obx(() {
//             if (controller.selectedVariantType.value.isEmpty) {
//               return SizedBox.shrink();
//             }
//
//             return Column(
//               children: [
//                 SizedBox(height: 20),
//                 Divider(),
//                 SizedBox(height: 20),
//                 _buildVariantValueConfiguration(),
//               ],
//             );
//           }),
//
//           // Generate button
//           Obx(() {
//             if (controller.variantTypeConfigurations.isNotEmpty) {
//               return Column(
//                 children: [
//                   SizedBox(height: 16),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: controller.generateVariantsFromConfiguration,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF10B981),
//                         padding: EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       icon: Icon(Icons.auto_awesome),
//                       label: Text(
//                         "Generate All Variants",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600, fontSize: 15),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//             return SizedBox.shrink();
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVariantValueConfiguration() {
//     return Obx(() {
//       final variantType = controller.selectedVariantType.value;
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Step 1: Add primary value (e.g., Color: Green)
//           Text(
//             "Step 1: Add ${variantType} Value",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//           SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFFF9FAFB),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Color(0xFFE5E7EB)),
//                   ),
//                   child: TextField(
//                     controller: controller.primaryValueController,
//                     decoration: InputDecoration(
//                       hintText: "e.g., Green, Blue",
//                       hintStyle:
//                       TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//                       border: InputBorder.none,
//                       contentPadding:
//                       EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                     ),
//                     onSubmitted: (value) {
//                       if (value.trim().isNotEmpty) {
//                         controller.addPrimaryValue(value.trim());
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: () {
//                   final value = controller.primaryValueController.text.trim();
//                   if (value.isNotEmpty) {
//                     controller.addPrimaryValue(value);
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF3B82F6),
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text("Add", style: TextStyle(fontWeight: FontWeight.w600)),
//               ),
//             ],
//           ),
//
//           // Show current primary value
//           if (controller.currentPrimaryValue.value.isNotEmpty) ...[
//             SizedBox(height: 20),
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Color(0xFF3B82F6).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 20),
//                   SizedBox(width: 8),
//                   Text(
//                     "Selected: ${controller.currentPrimaryValue.value}",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF3B82F6),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // Step 2: Add secondary values for this primary
//             Text(
//               "Step 2: Add Values for ${controller.currentPrimaryValue.value}",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A),
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "Example: For Green color, add 'S' size; For Blue, add 'M', 'L', 'XL'",
//               style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
//             ),
//             SizedBox(height: 12),
//
//             // Show added secondary values
//             if (controller.currentSecondaryValues.isNotEmpty)
//               Container(
//                 padding: EdgeInsets.all(12),
//                 margin: EdgeInsets.only(bottom: 12),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF9FAFB),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Color(0xFFE5E7EB)),
//                 ),
//                 child: Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: controller.currentSecondaryValues.map((value) {
//                     return Chip(
//                       label: Text(value),
//                       deleteIcon: Icon(Icons.close, size: 18),
//                       onDeleted: () => controller.removeSecondaryValue(value),
//                       backgroundColor: Color(0xFF3B82F6).withOpacity(0.1),
//                       labelStyle: TextStyle(
//                         color: Color(0xFF3B82F6),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//
//             // Input for secondary values
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Color(0xFFF9FAFB),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Color(0xFFE5E7EB)),
//                     ),
//                     child: TextField(
//                       controller: controller.secondaryValueController,
//                       decoration: InputDecoration(
//                         hintText: "e.g., S",
//                         hintStyle:
//                         TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//                         border: InputBorder.none,
//                         contentPadding:
//                         EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                       ),
//                       onSubmitted: (value) {
//                         if (value.trim().isNotEmpty) {
//                           controller.addSecondaryValue(value.trim());
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     final value =
//                     controller.secondaryValueController.text.trim();
//                     if (value.isNotEmpty) {
//                       controller.addSecondaryValue(value);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF3B82F6),
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text("Add",
//                       style: TextStyle(fontWeight: FontWeight.w600)),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             // Save button
//             if (controller.currentSecondaryValues.isNotEmpty)
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: controller.savePrimaryWithSecondary,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF10B981),
//                     padding: EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   icon: Icon(Icons.save),
//                   label: Text(
//                     "Save Configuration",
//                     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//                   ),
//                 ),
//               ),
//           ],
//         ],
//       );
//     });
//   }
//
//   Widget _buildVariantsHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Product Variants",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A),
//               ),
//             ),
//             Text(
//               "${controller.variants.length} variant(s)",
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Color(0xFF6B7280),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildVariantCard(
//       BuildContext context, int index, OfferProductVariant variant) {
//     final config =
//     controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null) return SizedBox.shrink();
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Color(0xFF3B82F6).withOpacity(0.05),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Variant ${index + 1}",
//                         style: TextStyle(
//                           color: Color(0xFF3B82F6),
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         variant.getDisplayName(),
//                         style: TextStyle(
//                           color: Color(0xFF1A1A1A),
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete_outline,
//                       color: Color(0xFFEF4444), size: 20),
//                   onPressed: () => _showDeleteDialog(context, index),
//                   tooltip: "Remove variant",
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildImagePicker(context, index, variant),
//                 SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildPriceField(variant, index),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: _buildStockField(variant),
//                     ),
//                   ],
//                 ),
//
//                 if (variant.attributes.isNotEmpty) ...[
//                   SizedBox(height: 16),
//                   Text(
//                     "Variant Attributes",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   SizedBox(height: 12),
//                   ...variant.attributes.entries.map((entry) {
//                     return Padding(
//                       padding: EdgeInsets.only(bottom: 12),
//                       child: _buildVariantAttributeField(entry.key, entry.value),
//                     );
//                   }).toList(),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPriceField(OfferProductVariant variant, int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Color(0xFF10B981).withOpacity(0.05),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
//           ),
//           child: TextField(
//             key: Key('price_$index'),
//             controller:
//             TextEditingController(text: variant.price?.toString() ?? ''),
//             onChanged: (val) {
//               final price = double.tryParse(val);
//               controller.updateVariantPrice(index, price);
//             },
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             decoration: InputDecoration(
//               labelText: "Original Price (₹)",
//               hintText: "0.00",
//               prefixIcon: Icon(Icons.currency_rupee,
//                   color: Color(0xFF10B981), size: 18),
//               filled: true,
//               fillColor: Colors.white,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               labelStyle: TextStyle(fontSize: 12, color: Color(0xFF10B981)),
//               hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//             ),
//           ),
//         ),
//         SizedBox(height: 8),
//         // Show offer price
//         Obx(() {
//           // Trigger rebuild when variants or discount changes
//           final _ = controller.variants.length;
//           final __ = controller.discountPercentageCtrl.text;
//
//           // Use the stored offer price
//           final offerPrice = variant.offerPrice;
//
//           if (offerPrice != null && variant.price != null && variant.price! > 0) {
//             final discount = controller.discountPercentageCtrl.text;
//             return Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Color(0xFFFEF3C7),
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(color: Color(0xFFF59E0B).withOpacity(0.3)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.local_offer, color: Color(0xFFF59E0B), size: 12),
//                   SizedBox(width: 4),
//                   Flexible(
//                     child: Text(
//                       "₹${offerPrice.toStringAsFixed(0)} (${discount}% off)",
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFFF59E0B),
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return SizedBox.shrink();
//         }),
//       ],
//     );
//   }
//
//   Widget _buildStockField(OfferProductVariant variant) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF3B82F6).withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
//       ),
//       child: TextField(
//         controller:
//         TextEditingController(text: variant.stock?.toString() ?? ''),
//         onChanged: (val) {
//           variant.stock = int.tryParse(val);
//           controller.variants.refresh();
//         },
//         keyboardType: TextInputType.number,
//         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         decoration: InputDecoration(
//           labelText: "Stock",
//           hintText: "0",
//           prefixIcon: Icon(Icons.inventory_outlined,
//               color: Color(0xFF3B82F6), size: 18),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           labelStyle: TextStyle(fontSize: 12, color: Color(0xFF3B82F6)),
//           hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildVariantAttributeField(String attribute, String value) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFFF9FAFB),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFFE5E7EB)),
//       ),
//       child: TextField(
//         controller: TextEditingController(text: value),
//         enabled: false,
//         style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
//         decoration: InputDecoration(
//           labelText: attribute,
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           labelStyle: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImagePicker(
//       BuildContext context, int index, OfferProductVariant variant) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Product Image",
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF1A1A1A),
//           ),
//         ),
//         SizedBox(height: 12),
//         GestureDetector(
//           onTap: () => controller.pickImage(index),
//           child: Container(
//             height: 160,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Color(0xFFF9FAFB),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Color(0xFFE5E7EB), width: 2),
//             ),
//             child: variant.imagePath == null
//                 ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.add_photo_alternate_outlined,
//                   size: 40,
//                   color: Color(0xFF3B82F6),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "Tap to add image",
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF6B7280),
//                   ),
//                 ),
//               ],
//             )
//                 : Stack(
//               fit: StackFit.expand,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.file(
//                     File(variant.imagePath!),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: IconButton(
//                       icon: Icon(Icons.edit,
//                           color: Color(0xFF3B82F6), size: 18),
//                       onPressed: () => controller.pickImage(index),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
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
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Color(0xFF3B82F6).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: Color(0xFF3B82F6), size: 20),
//         ),
//         SizedBox(width: 12),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF1A1A1A),
//           ),
//         ),
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
//         color: Color(0xFFF9FAFB),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFE5E7EB)),
//       ),
//       child: TextField(
//         onChanged: onChanged,
//         style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           prefixIcon: Icon(icon, color: Color(0xFF6B7280), size: 20),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           labelStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
//           hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteDialog(BuildContext context, int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Row(
//             children: [
//               Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
//               SizedBox(width: 12),
//               Text("Remove Variant?"),
//             ],
//           ),
//           content: Text(
//             "Are you sure you want to remove this variant?",
//             style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 controller.removeVariant(index);
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFEF4444)),
//               child: Text("Remove"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _saveOfferProduct(BuildContext context) {
//     if (!controller.validateForm()) return;
//     controller.saveOfferProduct();
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/offerproductcontroller.dart';


class AddOfferProductPage extends StatelessWidget {
  final IntegratedOfferController controller = Get.put(IntegratedOfferController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:AppColors.kPrimary,
        foregroundColor: Colors.white,
        title: Text(
          "Add Offer Product",
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
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          )
              : IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () => _saveOfferProduct(context),
            tooltip: "Save Offer Product",
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
                      // OFFER DETAILS SECTION
                      _buildOfferDetailsCard(),
                      SizedBox(height: 16),

                      // PRODUCT LIMIT INDICATOR
                      _buildProductLimitIndicator(),
                      SizedBox(height: 16),

                      // PRODUCT DETAILS SECTION
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
                        _buildVariantConfigurationSection(context),
                        SizedBox(height: 24),
                      ],

                      // Show generated variants list
                      if (controller.variants.isNotEmpty) ...[
                        _buildVariantsHeader(),
                        SizedBox(height: 16),
                        ...controller.variants
                            .asMap()
                            .entries
                            .map((entry) {
                          return _buildVariantCard(
                              context, entry.key, entry.value);
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
                          "Adding offer product...",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
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
          !controller.isSubmitting.value &&
          _canAddMoreProducts()
          ? FloatingActionButton.extended(
        onPressed: () => _saveOfferProduct(context),
        backgroundColor: Color(0xFF10B981),
        icon: Icon(Icons.check_circle_outline),
        label: Text(
          "Add to Offer",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 4,
      )
          : SizedBox.shrink()),
    );
  }

  // Check if more products can be added (max 10 per discount)
  bool _canAddMoreProducts() {
    // This should be implemented in your controller
    // For now, assuming controller has a method to check this
    return controller.variants.length < 10;
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
            "Create New Offer",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Add offer details and product with discount (Max 10 products per offer)",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // New widget to show product limit
  Widget _buildProductLimitIndicator() {
    return Obx(() {
      final currentCount = controller.variants.length;
      final maxCount = 10;
      final percentage = (currentCount / maxCount);
      final isNearLimit = currentCount >= 8;
      final isAtLimit = currentCount >= maxCount;

      Color indicatorColor;
      Color bgColor;
      IconData icon;
      String message;

      if (isAtLimit) {
        indicatorColor = Color(0xFFEF4444);
        bgColor = Color(0xFFFEE2E2);
        icon = Icons.block;
        message = "Maximum limit reached! Cannot add more products to this offer.";
      } else if (isNearLimit) {
        indicatorColor = Color(0xFFF59E0B);
        bgColor = Color(0xFFFEF3C7);
        icon = Icons.warning_amber_rounded;
        message = "Almost at limit! ${maxCount - currentCount} product(s) remaining.";
      } else {
        indicatorColor = Color(0xFF10B981);
        bgColor = Color(0xFFD1FAE5);
        icon = Icons.check_circle_outline;
        message = "${currentCount} of ${maxCount} products added";
      }

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: indicatorColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: indicatorColor, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Limit",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: indicatorColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 13,
                          color: indicatorColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Progress bar
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

  Widget _buildOfferDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Offer Details", Icons.local_offer_outlined),
          SizedBox(height: 16),

          // Discount Percentage
          Text(
            "Discount Percentage",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: controller.discountPercentageCtrl,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
              decoration: InputDecoration(
                hintText: "e.g., 20",
                prefixIcon: Icon(Icons.percent, color: Color(0xFF6B7280), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              ),
              onChanged: (value) {
                // Recalculate all variant offer prices when discount changes
                for (int i = 0; i < controller.variants.length; i++) {
                  controller.updateVariantPrice(i, controller.variants[i].price);
                }
              },
            ),
          ),
          SizedBox(height: 16),

          // Offer Banner
          Text(
            "Offer Banner",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          Obx(() => GestureDetector(
            onTap: () => controller.pickBannerImage(),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE5E7EB), width: 2),
              ),
              child: controller.bannerImage.value == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Color(0xFF3B82F6),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Tap to add offer banner",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Recommended: 1920 x 1080",
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
                      controller.bannerImage.value!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
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
                        icon: Icon(Icons.edit,
                            color: Color(0xFF3B82F6), size: 20),
                        onPressed: () => controller.pickBannerImage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
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
                  child: Icon(Icons.text_fields,
                      color: Color(0xFF6B7280), size: 20),
                ),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  prefixIcon: Icon(Icons.list_alt,
                      color: Color(0xFF6B7280), size: 20),
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
                icon:
                Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommonAttributesSection() {
    final config =
    controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.commonAttributes.isEmpty)
      return SizedBox.shrink();

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
        onChanged: (value) =>
            controller.setCommonAttribute(attribute, value),
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

  Widget _buildVariantConfigurationSection(BuildContext context) {
    final config =
    controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.variantAttributes.isEmpty)
      return SizedBox.shrink();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Configure Variants", Icons.tune),
          SizedBox(height: 8),
          Text(
            "Example: For Color 'Green' → add sizes 'S'; For Color 'Blue' → add sizes 'M, L, XL'",
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          SizedBox(height: 16),

          // Show configured variant types summary
          Obx(() {
            if (controller.variantTypeConfigurations.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Configured:",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 8),
                  ...controller.variantTypeConfigurations.entries.map((typeEntry) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF10B981).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Color(0xFF10B981).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            typeEntry.key,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          SizedBox(height: 8),
                          ...typeEntry.value.entries.map((primaryEntry) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "• ${primaryEntry.key}: ${primaryEntry.value.join(', ')}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                  if (controller.selectedVariantType.value == typeEntry.key)
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, size: 16, color: Colors.red),
                                      onPressed: () => controller.removePrimaryValue(primaryEntry.key),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                ],
              );
            }
            return SizedBox.shrink();
          }),

          // Select variant type
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E7EB)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.category,
                    color: Color(0xFF6B7280), size: 20),
                hintText: "Select variant type (e.g., Color, Size)",
                hintStyle:
                TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              ),
              value: controller.selectedVariantType.value.isEmpty
                  ? null
                  : controller.selectedVariantType.value,
              items: config.variantAttributes.map((attr) {
                return DropdownMenuItem(
                  value: attr,
                  child: Text(attr, style: TextStyle(fontSize: 15)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.onVariantTypeSelected(value);
                }
              },
              dropdownColor: Colors.white,
              icon: Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFF6B7280)),
            )),
          ),

          // Show configuration UI when variant type is selected
          Obx(() {
            if (controller.selectedVariantType.value.isEmpty) {
              return SizedBox.shrink();
            }

            return Column(
              children: [
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                _buildVariantValueConfiguration(),
              ],
            );
          }),

          // Generate button with limit check
          Obx(() {
            final canGenerate = controller.variantTypeConfigurations.isNotEmpty;
            final currentCount = controller.variants.length;
            final wouldExceedLimit = currentCount >= 10;

            if (canGenerate) {
              return Column(
                children: [
                  SizedBox(height: 16),

                  // Warning if at limit
                  if (wouldExceedLimit)
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFEF4444).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Cannot generate more variants. Maximum 10 products limit reached.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: wouldExceedLimit
                          ? null
                          : controller.generateVariantsFromConfiguration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: wouldExceedLimit
                            ? Colors.grey
                            : Color(0xFF10B981),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      icon: Icon(Icons.auto_awesome),
                      label: Text(
                        wouldExceedLimit
                            ? "Limit Reached"
                            : "Generate All Variants",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildVariantValueConfiguration() {
    return Obx(() {
      final variantType = controller.selectedVariantType.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step 1: Add primary value (e.g., Color: Green)
          Text(
            "Step 1: Add ${variantType} Value",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 12),
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
                    controller: controller.primaryValueController,
                    decoration: InputDecoration(
                      hintText: "e.g., Green, Blue",
                      hintStyle:
                      TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        controller.addPrimaryValue(value.trim());
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final value = controller.primaryValueController.text.trim();
                  if (value.isNotEmpty) {
                    controller.addPrimaryValue(value);
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

          // Show current primary value
          if (controller.currentPrimaryValue.value.isNotEmpty) ...[
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Selected: ${controller.currentPrimaryValue.value}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Step 2: Add secondary values for this primary
            Text(
              "Step 2: Add Values for ${controller.currentPrimaryValue.value}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Example: For Green color, add 'S' size; For Blue, add 'M', 'L', 'XL'",
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            SizedBox(height: 12),

            // Show added secondary values
            if (controller.currentSecondaryValues.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFE5E7EB)),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.currentSecondaryValues.map((value) {
                    return Chip(
                      label: Text(value),
                      deleteIcon: Icon(Icons.close, size: 18),
                      onDeleted: () => controller.removeSecondaryValue(value),
                      backgroundColor: Color(0xFF3B82F6).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Input for secondary values
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
                      controller: controller.secondaryValueController,
                      decoration: InputDecoration(
                        hintText: "e.g., S",
                        hintStyle:
                        TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          controller.addSecondaryValue(value.trim());
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final value =
                    controller.secondaryValueController.text.trim();
                    if (value.isNotEmpty) {
                      controller.addSecondaryValue(value);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Add",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Save button
            if (controller.currentSecondaryValues.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.savePrimaryWithSecondary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF10B981),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.save),
                  label: Text(
                    "Save Configuration",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
          ],
        ],
      );
    });
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
            Obx(() {
              final count = controller.variants.length;
              return Text(
                "$count of 10 variant(s)",
                style: TextStyle(
                  fontSize: 13,
                  color: count >= 10 ? Color(0xFFEF4444) : Color(0xFF6B7280),
                  fontWeight: count >= 10 ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildVariantCard(
      BuildContext context, int index, OfferProductVariant variant) {
    final config =
    controller.categoryConfigs[controller.selectedCategory.value];
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
                  icon: Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444), size: 20),
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
                      child: _buildPriceField(variant, index),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStockField(variant),
                    ),
                  ],
                ),

                if (variant.attributes.isNotEmpty) ...[
                  SizedBox(height: 16),
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

  Widget _buildPriceField(OfferProductVariant variant, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF10B981).withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
          ),
          child: TextField(
            key: Key('price_$index'),
            controller:
            TextEditingController(text: variant.price?.toString() ?? ''),
            onChanged: (val) {
              final price = double.tryParse(val);
              controller.updateVariantPrice(index, price);
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              labelText: "Original Price (₹)",
              hintText: "0.00",
              prefixIcon: Icon(Icons.currency_rupee,
                  color: Color(0xFF10B981), size: 18),
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
        ),
        SizedBox(height: 8),
        // Show offer price
        Obx(() {
          // Trigger rebuild when variants or discount changes
          final _ = controller.variants.length;
          final __ = controller.discountPercentageCtrl.text;

          // Use the stored offer price
          final offerPrice = variant.offerPrice;

          if (offerPrice != null && variant.price != null && variant.price! > 0) {
            final discount = controller.discountPercentageCtrl.text;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Color(0xFFF59E0B).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_offer, color: Color(0xFFF59E0B), size: 12),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      "₹${offerPrice.toStringAsFixed(0)} (${discount}% off)",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF59E0B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildStockField(OfferProductVariant variant) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: TextField(
        controller:
        TextEditingController(text: variant.stock?.toString() ?? ''),
        onChanged: (val) {
          variant.stock = int.tryParse(val);
          controller.variants.refresh();
        },
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: "Stock",
          hintText: "0",
          prefixIcon: Icon(Icons.inventory_outlined,
              color: Color(0xFF3B82F6), size: 18),
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

  Widget _buildImagePicker(
      BuildContext context, int index, OfferProductVariant variant) {
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
                      icon: Icon(Icons.edit,
                          color: Color(0xFF3B82F6), size: 18),
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
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF4444)),
              child: Text("Remove"),
            ),
          ],
        );
      },
    );
  }

  void _saveOfferProduct(BuildContext context) {
    // Check if limit is reached
    if (controller.variants.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Maximum 10 products limit reached for this discount!",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!controller.validateForm()) return;
    controller.saveOfferProduct();
  }
}