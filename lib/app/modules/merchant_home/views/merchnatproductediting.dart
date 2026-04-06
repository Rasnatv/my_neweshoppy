// import 'dart:io';
// import 'package:eshoppy/app/common/style/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//  import '../controller/productedintingcontroller.dart';
//
//
// /// Update Product Page
// /// Pre-fills all fields with existing product data and allows editing
// class UpdateProductPage extends StatelessWidget {
//   final UpdateProductController controller = Get.put(UpdateProductController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8F9FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.kPrimary,
//         foregroundColor: Colors.white,
//         title: Text(
//           "Update Product",
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
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//           )
//               : IconButton(
//             icon: Icon(Icons.save_outlined),
//             onPressed: () => _updateProduct(context),
//             tooltip: "Update Product",
//           )),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoadingProduct.value || controller.isLoadingCategories.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text(
//                   "Loading product details...",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF6B7280),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildHeader(),
//                   Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         _buildProductNameCard(),
//                         SizedBox(height: 16),
//                         _buildDescriptionCard(),
//                         SizedBox(height: 16),
//                         _buildCategoryCard(context),
//                         SizedBox(height: 24),
//
//                         // Show common attributes section if category selected
//                         if (controller.selectedCategory.value.isNotEmpty) ...[
//                           _buildCommonAttributesSection(),
//                           SizedBox(height: 24),
//                         ],
//
//                         // Show variant attributes section if category selected
//                         if (controller.selectedCategory.value.isNotEmpty) ...[
//                           _buildVariantAttributesSection(),
//                           SizedBox(height: 24),
//                         ],
//
//                         // Show variants
//                         if (controller.variants.isNotEmpty) ...[
//                           _buildVariantsHeader(),
//                           SizedBox(height: 16),
//                           ...controller.variants.asMap().entries.map((entry) {
//                             return _buildVariantCard(context, entry.key, entry.value);
//                           }).toList(),
//                         ],
//                         SizedBox(height: 100),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (controller.isSubmitting.value)
//               Container(
//                 color: Colors.black.withOpacity(0.5),
//                 child: Center(
//                   child: Card(
//                     child: Padding(
//                       padding: EdgeInsets.all(24),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CircularProgressIndicator(),
//                           SizedBox(height: 16),
//                           Text(
//                             "Updating product...",
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         );
//       }),
//       floatingActionButton: Obx(() => controller.variants.isNotEmpty &&
//           !controller.isSubmitting.value &&
//           !controller.isLoadingProduct.value
//           ? FloatingActionButton.extended(
//         onPressed: () => _updateProduct(context),
//         backgroundColor: Color(0xFF10B981),
//         icon: Icon(Icons.check_circle_outline),
//         label: Text(
//           "Update Product",
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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF59E0B).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(Icons.edit, color: Color(0xFFF59E0B), size: 20),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Edit Product",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1A1A1A),
//                       ),
//                     ),
//                     Text(
//                       "Product ID: ${controller.productId.value}",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Color(0xFF6B7280),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             "Update product information and variants",
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
//             initialValue: controller.productName.value,
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
//               controller: TextEditingController(text: controller.productDescription.value)
//                 ..selection = TextSelection.fromPosition(
//                   TextPosition(offset: controller.productDescription.value.length),
//                 ),
//               onChanged: (val) => controller.productDescription.value = val,
//               style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: "Describe your product in detail...",
//                 prefixIcon: Padding(
//                   padding: EdgeInsets.only(top: 12),
//                   child: Icon(Icons.text_fields, color: Color(0xFF6B7280), size: 20),
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
//                   prefixIcon: Icon(Icons.list_alt, color: Color(0xFF6B7280), size: 20),
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
//                   if (val != null) {
//                     controller.onCategoryChanged(val);
//                   }
//                 },
//                 dropdownColor: Colors.white,
//                 icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCommonAttributesSection() {
//     final config = controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null || config.commonAttributes.isEmpty) return SizedBox.shrink();
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
//         controller: TextEditingController(
//           text: controller.commonAttributes[attribute] ?? '',
//         )..selection = TextSelection.fromPosition(
//           TextPosition(offset: (controller.commonAttributes[attribute] ?? '').length),
//         ),
//         onChanged: (value) => controller.setCommonAttribute(attribute, value),
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
//   Widget _buildVariantAttributesSection() {
//     final config = controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null || config.variantAttributes.isEmpty) return SizedBox.shrink();
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Variant Attributes", Icons.tune),
//           SizedBox(height: 8),
//           Text(
//             "Add more attribute values to create additional variants",
//             style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//           ),
//           SizedBox(height: 16),
//           ...config.variantAttributes.map((attr) {
//             return Padding(
//               padding: EdgeInsets.only(bottom: 16),
//               child: _buildAttributeValueInput(attr),
//             );
//           }).toList(),
//           SizedBox(height: 8),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: controller.generateVariants,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF3B82F6),
//                 padding: EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: Icon(Icons.auto_awesome),
//               label: Text(
//                 "Generate New Variants",
//                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAttributeValueInput(String attribute) {
//     return Obx(() {
//       final values = controller.variantAttributeValues[attribute] ?? [];
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             attribute,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//           SizedBox(height: 8),
//           if (values.isNotEmpty)
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: values.map((value) {
//                 return Chip(
//                   label: Text(value),
//                   deleteIcon: Icon(Icons.close, size: 18),
//                   onDeleted: () => controller.removeAttributeValue(attribute, value),
//                   backgroundColor: Color(0xFF3B82F6).withOpacity(0.1),
//                   labelStyle: TextStyle(
//                     color: Color(0xFF3B82F6),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 );
//               }).toList(),
//             ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Add $attribute value",
//                     hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//                     filled: true,
//                     fillColor: Color(0xFFF9FAFB),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Color(0xFFE5E7EB)),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                   ),
//                   onSubmitted: (value) {
//                     if (value.trim().isNotEmpty) {
//                       controller.addAttributeValue(attribute, value.trim());
//                     }
//                   },
//                 ),
//               ),
//               SizedBox(width: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Color(0xFF3B82F6),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: IconButton(
//                   icon: Icon(Icons.add, color: Colors.white),
//                   onPressed: () {
//                     _showAddValueDialog(attribute);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     });
//   }
//
//   void _showAddValueDialog(String attribute) {
//     final TextEditingController textController = TextEditingController();
//
//     Get.dialog(
//       AlertDialog(
//         title: Text("Add $attribute"),
//         content: TextField(
//           controller: textController,
//           decoration: InputDecoration(
//             hintText: "Enter $attribute value",
//             border: OutlineInputBorder(),
//           ),
//           autofocus: true,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (textController.text.trim().isNotEmpty) {
//                 controller.addAttributeValue(attribute, textController.text.trim());
//                 Get.back();
//               }
//             },
//             child: Text("Add"),
//           ),
//         ],
//       ),
//     );
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
//   Widget _buildVariantCard(BuildContext context, int index, DProductVariant variant) {
//     final config = controller.categoryConfigs[controller.selectedCategory.value];
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
//               color: variant.isExisting
//                   ? Color(0xFF10B981).withOpacity(0.05)
//                   : Color(0xFF3B82F6).withOpacity(0.05),
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
//                       Row(
//                         children: [
//                           Text(
//                             "Variant ${index + 1}",
//                             style: TextStyle(
//                               color: variant.isExisting ? Color(0xFF10B981) : Color(0xFF3B82F6),
//                               fontWeight: FontWeight.w600,
//                               fontSize: 13,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           if (variant.isExisting)
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFF10B981).withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 "EXISTING",
//                                 style: TextStyle(
//                                   color: Color(0xFF10B981),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             )
//                           else
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFF3B82F6).withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 "NEW",
//                                 style: TextStyle(
//                                   color: Color(0xFF3B82F6),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                         ],
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
//                   icon: Icon(Icons.content_copy, color: Color(0xFF3B82F6), size: 20),
//                   onPressed: () => controller.duplicateVariant(index),
//                   tooltip: "Duplicate variant",
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
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
//                       child: _buildPriceField(variant),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: _buildStockField(variant),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 if (config.variantAttributes.isNotEmpty) ...[
//                   Text(
//                     "Variant Attributes",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   SizedBox(height: 12),
//                   ...config.variantAttributes.map((attr) {
//                     return Padding(
//                       padding: EdgeInsets.only(bottom: 12),
//                       child: _buildVariantAttributeField(variant, attr),
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
//   Widget _buildPriceField(DProductVariant variant) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF10B981).withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
//       ),
//       child: TextField(
//         controller: TextEditingController(text: variant.price?.toString() ?? ''),
//         onChanged: (val) {
//           variant.price = double.tryParse(val);
//           controller.variants.refresh();
//         },
//         keyboardType: TextInputType.numberWithOptions(decimal: true),
//         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         decoration: InputDecoration(
//           labelText: "Price (₹)",
//           hintText: "0.00",
//           prefixIcon: Icon(Icons.currency_rupee, color: Color(0xFF10B981), size: 18),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           labelStyle: TextStyle(fontSize: 12, color: Color(0xFF10B981)),
//           hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStockField(DProductVariant variant) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF3B82F6).withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
//       ),
//       child: TextField(
//         controller: TextEditingController(text: variant.stock?.toString() ?? ''),
//         onChanged: (val) {
//           variant.stock = int.tryParse(val);
//           controller.variants.refresh();
//         },
//         keyboardType: TextInputType.number,
//         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         decoration: InputDecoration(
//           labelText: "Stock",
//           hintText: "0",
//           prefixIcon: Icon(Icons.inventory_outlined, color: Color(0xFF3B82F6), size: 18),
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
//   Widget _buildVariantAttributeField(DProductVariant variant, String attribute) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFFF9FAFB),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFFE5E7EB)),
//       ),
//       child: TextField(
//         controller: TextEditingController(
//           text: variant.attributes[attribute]?.toString() ?? '',
//         ),
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
//   Widget _buildImagePicker(BuildContext context, int index, DProductVariant variant) {
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
//                   child: variant.imagePath!.startsWith('http')
//                       ? Image.network(
//                     variant.imagePath!,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.broken_image, size: 40, color: Colors.grey),
//                             SizedBox(height: 8),
//                             Text("Failed to load image", style: TextStyle(color: Colors.grey)),
//                           ],
//                         ),
//                       );
//                     },
//                   )
//                       : Image.file(
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
//                       icon: Icon(Icons.edit, color: Color(0xFF3B82F6), size: 18),
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
//     required String initialValue,
//     required Function(String) onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFFF9FAFB),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFE5E7EB)),
//       ),
//       child: TextField(
//         controller: TextEditingController(text: initialValue)
//           ..selection = TextSelection.fromPosition(
//             TextPosition(offset: initialValue.length),
//           ),
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
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
//               style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF4444)),
//               child: Text("Remove"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _updateProduct(BuildContext context) {
//     if (!controller.validateForm()) return;
//     controller.updateProduct();
//   }
// }
import 'dart:io';
import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/productedintingcontroller.dart';

/// Update Product Page
/// Pre-fills all fields with existing product data and allows editing
class UpdateProductPage extends StatefulWidget {
  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final UpdateProductController controller = Get.put(UpdateProductController());

  // ── Stable controllers for price & stock so they don't reset on rebuild ──
  final Map<int, TextEditingController> _priceControllers = {};
  final Map<int, TextEditingController> _stockControllers = {};

  // Track how many variants existed when we last synced controllers
  int _lastVariantCount = 0;

  /// Returns a stable price controller for [index].
  /// Creates one pre-filled with the variant's current price if absent.
  TextEditingController _priceCtrl(int index, DProductVariant variant) {
    if (!_priceControllers.containsKey(index)) {
      _priceControllers[index] =
          TextEditingController(text: variant.price?.toString() ?? '');
    }
    return _priceControllers[index]!;
  }

  /// Returns a stable stock controller for [index].
  TextEditingController _stockCtrl(int index, DProductVariant variant) {
    if (!_stockControllers.containsKey(index)) {
      _stockControllers[index] =
          TextEditingController(text: variant.stock?.toString() ?? '');
    }
    return _stockControllers[index]!;
  }

  /// Called when variants list changes length (e.g. after duplicate/remove/generate).
  /// Removes stale controllers for indices that no longer exist and pre-fills
  /// new ones for freshly added variants.
  void _syncControllers() {
    final count = controller.variants.length;
    if (count == _lastVariantCount) return;

    // Remove controllers for removed indices
    if (count < _lastVariantCount) {
      for (int i = count; i < _lastVariantCount; i++) {
        _priceControllers.remove(i)?.dispose();
        _stockControllers.remove(i)?.dispose();
      }
    }

    // Pre-fill controllers for new variants (they won't have one yet)
    for (int i = _lastVariantCount; i < count; i++) {
      final v = controller.variants[i];
      _priceControllers[i] =
          TextEditingController(text: v.price?.toString() ?? '');
      _stockControllers[i] =
          TextEditingController(text: v.stock?.toString() ?? '');
    }

    _lastVariantCount = count;
  }

  @override
  void dispose() {
    for (final c in _priceControllers.values) {
      c.dispose();
    }
    for (final c in _stockControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.kPrimary,
        foregroundColor: Colors.white,
        title: Text(
          "Update Product",
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
                valueColor:
                AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
              : IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () => _updateProduct(context),
            tooltip: "Update Product",
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingProduct.value ||
            controller.isLoadingCategories.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  "Loading product details...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          );
        }

        // Sync controllers whenever variant count changes
        _syncControllers();

        return Stack(
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

                        // Show variant attributes section if category selected
                        if (controller.selectedCategory.value.isNotEmpty) ...[
                          _buildVariantAttributesSection(),
                          SizedBox(height: 24),
                        ],

                        // Show variants
                        if (controller.variants.isNotEmpty) ...[
                          _buildVariantsHeader(),
                          SizedBox(height: 16),
                          ...controller.variants.asMap().entries.map((entry) {
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
                            "Updating product...",
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
        );
      }),
      floatingActionButton: Obx(() => controller.variants.isNotEmpty &&
          !controller.isSubmitting.value &&
          !controller.isLoadingProduct.value
          ? FloatingActionButton.extended(
        onPressed: () => _updateProduct(context),
        backgroundColor: Color(0xFF10B981),
        icon: Icon(Icons.check_circle_outline),
        label: Text(
          "Update Product",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 4,
      )
          : SizedBox.shrink()),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // UI HELPERS
  // ─────────────────────────────────────────────────────────────────────────

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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.edit, color: Color(0xFFF59E0B), size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Product",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      "Product ID: ${controller.productId.value}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Update product information and variants",
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
            initialValue: controller.productName.value,
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
              "Product Description", Icons.description_outlined),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller:
              TextEditingController(text: controller.productDescription.value)
                ..selection = TextSelection.fromPosition(
                  TextPosition(
                      offset:
                      controller.productDescription.value.length),
                ),
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
                hintStyle:
                TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
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
                    Expanded(child: Text("No categories available")),
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
                  hintStyle:
                  TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                ),
                value: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value,
                items: controller.apiCategories
                    .map((c) => DropdownMenuItem(
                  value: c.name,
                  child: Text(c.name,
                      style: TextStyle(fontSize: 15)),
                ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.onCategoryChanged(val);
                  }
                },
                dropdownColor: Colors.white,
                icon: Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF6B7280)),
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
    if (config == null || config.commonAttributes.isEmpty) {
      return SizedBox.shrink();
    }

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
        controller: TextEditingController(
          text: controller.commonAttributes[attribute] ?? '',
        )..selection = TextSelection.fromPosition(
          TextPosition(
              offset:
              (controller.commonAttributes[attribute] ?? '').length),
        ),
        onChanged: (value) =>
            controller.setCommonAttribute(attribute, value),
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: attribute,
          hintText: "Enter $attribute",
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle:
          TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          hintStyle:
          TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  Widget _buildVariantAttributesSection() {
    final config =
    controller.categoryConfigs[controller.selectedCategory.value];
    if (config == null || config.variantAttributes.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Variant Attributes", Icons.tune),
          SizedBox(height: 8),
          Text(
            "Add more attribute values to create additional variants",
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          SizedBox(height: 16),
          ...config.variantAttributes.map((attr) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildAttributeValueInput(attr),
            );
          }).toList(),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.generateVariants,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B82F6),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.auto_awesome),
              label: Text(
                "Generate New Variants",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeValueInput(String attribute) {
    return Obx(() {
      final values =
          controller.variantAttributeValues[attribute] ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            attribute,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          if (values.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: values.map((value) {
                return Chip(
                  label: Text(value),
                  deleteIcon: Icon(Icons.close, size: 18),
                  onDeleted: () =>
                      controller.removeAttributeValue(attribute, value),
                  backgroundColor:
                  Color(0xFF3B82F6).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Add $attribute value",
                    hintStyle: TextStyle(
                        fontSize: 13, color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      controller.addAttributeValue(
                          attribute, value.trim());
                    }
                  },
                ),
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    _showAddValueDialog(attribute);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  void _showAddValueDialog(String attribute) {
    final TextEditingController textController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text("Add $attribute"),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: "Enter $attribute value",
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.addAttributeValue(
                    attribute, textController.text.trim());
                Get.back();
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
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

  Widget _buildVariantCard(
      BuildContext context, int index, DProductVariant variant) {
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
          // ── Card header ──
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: variant.isExisting
                  ? Color(0xFF10B981).withOpacity(0.05)
                  : Color(0xFF3B82F6).withOpacity(0.05),
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
                      Row(
                        children: [
                          Text(
                            "Variant ${index + 1}",
                            style: TextStyle(
                              color: variant.isExisting
                                  ? Color(0xFF10B981)
                                  : Color(0xFF3B82F6),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: variant.isExisting
                                  ? Color(0xFF10B981).withOpacity(0.2)
                                  : Color(0xFF3B82F6).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              variant.isExisting ? "EXISTING" : "NEW",
                              style: TextStyle(
                                color: variant.isExisting
                                    ? Color(0xFF10B981)
                                    : Color(0xFF3B82F6),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
                  icon: Icon(Icons.content_copy,
                      color: Color(0xFF3B82F6), size: 20),
                  onPressed: () => controller.duplicateVariant(index),
                  tooltip: "Duplicate variant",
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

          // ── Card body ──
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePicker(context, index, variant),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildPriceField(index, variant)),
                    SizedBox(width: 12),
                    Expanded(child: _buildStockField(index, variant)),
                  ],
                ),
                SizedBox(height: 16),
                if (config.variantAttributes.isNotEmpty) ...[
                  Text(
                    "Variant Attributes",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 12),
                  ...config.variantAttributes.map((attr) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child:
                      _buildVariantAttributeField(variant, attr),
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

  // ── FIX: stable controllers, no variants.refresh() ──
  Widget _buildPriceField(int index, DProductVariant variant) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF10B981).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: TextField(
        controller: _priceCtrl(index, variant), // stable controller
        onChanged: (val) {
          // Update the model directly — no refresh() call to avoid rebuild
          variant.price = double.tryParse(val);
        },
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: "Price (₹)",
          hintText: "0.00",
          prefixIcon: Icon(Icons.currency_rupee,
              color: Color(0xFF10B981), size: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle:
          TextStyle(fontSize: 12, color: Color(0xFF10B981)),
          hintStyle:
          TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  // ── FIX: stable controllers, no variants.refresh() ──
  Widget _buildStockField(int index, DProductVariant variant) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: TextField(
        controller: _stockCtrl(index, variant), // stable controller
        onChanged: (val) {
          // Update the model directly — no refresh() call to avoid rebuild
          variant.stock = int.tryParse(val);
        },
        keyboardType: TextInputType.number,
        style:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
          contentPadding:
          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle:
          TextStyle(fontSize: 12, color: Color(0xFF3B82F6)),
          hintStyle:
          TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  Widget _buildVariantAttributeField(
      DProductVariant variant, String attribute) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: TextEditingController(
          text: variant.attributes[attribute]?.toString() ?? '',
        ),
        enabled: false,
        style:
        TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        decoration: InputDecoration(
          labelText: attribute,
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          labelStyle:
          TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ),
    );
  }

  Widget _buildImagePicker(
      BuildContext context, int index, DProductVariant variant) {
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
              border:
              Border.all(color: Color(0xFFE5E7EB), width: 2),
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
                  child: variant.imagePath!.startsWith('http')
                      ? Image.network(
                    variant.imagePath!,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image,
                                size: 40,
                                color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Failed to load image",
                                style: TextStyle(
                                    color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  )
                      : Image.file(
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
                          color:
                          Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit,
                          color: Color(0xFF3B82F6), size: 18),
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
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: TextEditingController(text: initialValue)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: initialValue.length),
          ),
        onChanged: onChanged,
        style: TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Color(0xFF6B7280), size: 20),
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle:
          TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          hintStyle:
          TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFEF4444)),
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

  void _updateProduct(BuildContext context) {
    if (!controller.validateForm()) return;
    controller.updateProduct();
  }
}
