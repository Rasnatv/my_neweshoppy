//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../common/style/app_text_style.dart';
// import '../controller/addproduct_controller.dart';
// // import '../controller/addproduct_controller.dart';
//
// class AddProductPage extends StatelessWidget {
//   final ProductController controller = Get.put(ProductController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8F9FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.kPrimary,
//         foregroundColor: Color(0xFF1A1A1A),
//         title: Text(
//           "Add New Product",
//           style: AppTextStyle.rTextNunitoWhite16w600,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save_outlined),
//             onPressed: () => _saveProduct(context),
//             tooltip: "Save Product",
//           ),
//         ],
//       ),
//       body: Obx(() => SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Section
//             _buildHeader(),
//
//             // Main Content
//             Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   // Product Name Card
//                   _buildProductNameCard(),
//                   SizedBox(height: 16),
//
//                   // Category Card
//                   _buildCategoryCard(context),
//                   SizedBox(height: 24),
//
//                   // Variant Attributes Section
//                   if (controller.selectedCategory.value.isNotEmpty) ...[
//                     _buildVariantAttributesSection(),
//                     SizedBox(height: 24),
//                   ],
//
//                   // Common Attributes Section
//                   if (controller.selectedCategory.value.isNotEmpty) ...[
//                     _buildCommonAttributesSection(),
//                     SizedBox(height: 24),
//                   ],
//
//                   // Variants Section
//                   if (controller.variants.isNotEmpty) ...[
//                     _buildVariantsHeader(),
//                     SizedBox(height: 16),
//                     ...controller.variants.asMap().entries.map((entry) {
//                       return _buildVariantCard(context, entry.key, entry.value);
//                     }).toList(),
//                   ] else if (controller.selectedCategory.value.isNotEmpty) ...[
//                     _buildEmptyVariantsState(),
//                   ],
//
//                   SizedBox(height: 100),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )),
//       floatingActionButton: Obx(() => controller.variants.isNotEmpty
//           ? FloatingActionButton.extended(
//         onPressed: () => _saveProduct(context),
//         backgroundColor: Color(0xFF10B981),
//         icon: Icon(Icons.check_circle_outline),
//         label: Text(
//           "Save Product",
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
//           Text(
//             "Basic Information",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             "Fill in the essential details about your product",
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
//             onChanged: (val) => controller.productName.value = val,
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildCategoryCard(BuildContext context) {
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Category", Icons.category_outlined),
//           SizedBox(height: 12),
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0xFFF9FAFB),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Color(0xFFE5E7EB)),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 prefixIcon: Icon(Icons.list_alt, color: Color(0xFF6B7280), size: 20),
//                 hintText: "Choose a category",
//                 hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//               ),
//               value: controller.selectedCategory.value.isEmpty
//                   ? null
//                   : controller.selectedCategory.value,
//               items: controller.categoryConfigs.keys
//                   .map((c) => DropdownMenuItem(
//                 value: c,
//                 child: Text(c, style: TextStyle(fontSize: 15)),
//               ))
//                   .toList(),
//               onChanged: (val) {
//                 controller.onCategoryChanged(val!);
//               },
//               dropdownColor: Colors.white,
//               icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVariantAttributesSection() {
//     final config = controller.categoryConfigs[controller.selectedCategory.value];
//     if (config == null) return SizedBox.shrink();
//
//     return _buildCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Variant Attributes", Icons.tune),
//           SizedBox(height: 8),
//           Text(
//             "Define variations that create separate products (different prices/stock)",
//             style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//           ),
//           SizedBox(height: 16),
//
//           // Variant Attributes
//           ...config.variantAttributes.map((attr) {
//             return Padding(
//               padding: EdgeInsets.only(bottom: 16),
//               child: _buildAttributeValueInput(attr, isVariantAttribute: true),
//             );
//           }).toList(),
//
//           SizedBox(height: 8),
//
//           // Generate Variants Button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: controller.generateVariants,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.kPrimary,
//                 padding: EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: Icon(Icons.auto_awesome),
//               label: Text(
//                 "Generate Variants",
//                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//               ),
//             ),
//           ),
//
//           SizedBox(height: 12),
//
//
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
//
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
//   Widget _buildAttributeValueInput(String attribute, {bool isVariantAttribute = false}) {
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
//
//           // Value chips
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
//
//           SizedBox(height: 8),
//
//           // Add value input
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Add $attribute value (e.g., ${_getExampleValue(attribute)})",
//                     hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
//                     filled: true,
//                     fillColor: Color(0xFFF9FAFB),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Color(0xFFE5E7EB)),
//                     ),
//                     enabledBorder: OutlineInputBorder(
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
//                     // Show dialog to add value
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
//   String _getExampleValue(String attribute) {
//     final examples = {
//       'Size': 'S, M, L, XL',
//       'Color': 'Red, Blue, Black',
//       'Volume': '100ml, 250ml, 500ml',
//       'Weight': '500g, 1kg, 2kg',
//       'RAM': '4GB, 8GB, 16GB',
//       'Storage': '64GB, 128GB, 256GB',
//       'Capacity': '1L, 2L, 5L',
//       'Dosage': '10mg, 20mg, 50mg',
//       'Weight / Quantity': '250g, 500g, 1kg',
//       'Flavor / Type': 'Chocolate, Vanilla',
//       'Shade': 'Light, Medium, Dark',
//       'Age Group': '0-2 years, 3-5 years',
//       'Power': '500W, 1000W, 1500W',
//     };
//     return examples[attribute] ?? 'Value';
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
//   Widget _buildEmptyVariantsState() {
//     return Container(
//       padding: EdgeInsets.all(40),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Color(0xFFE5E7EB), width: 2),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Color(0xFF3B82F6).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.inventory_2_outlined,
//               size: 48,
//               color: Color(0xFF3B82F6),
//             ),
//           ),
//           SizedBox(height: 16),
//           Text(
//             "No variants created yet",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             "Add attribute values and click 'Generate Variants'\nor add a manual variant",
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF6B7280),
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVariantCard(BuildContext context, int index, variant) {
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
//           // Variant Header
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
//
//           // Variant Content
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Image Section
//                 _buildImagePicker(context, index, variant),
//                 SizedBox(height: 20),
//
//                 // Price and Stock Section
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
//
//                 // Variant Attributes
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
//   Widget _buildPriceField(variant) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF10B981).withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
//       ),
//       child: TextField(
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
//   Widget _buildStockField(variant) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF3B82F6).withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.3)),
//       ),
//       child: TextField(
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
//   Widget _buildVariantAttributeField(variant, String attribute) {
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
//         onChanged: (val) {
//           variant.attributes[attribute] = val;
//           controller.variants.refresh();
//         },
//         style: TextStyle(fontSize: 14),
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
//   Widget _buildImagePicker(BuildContext context, int index, variant) {
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
//
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
//
//   void _saveProduct(BuildContext context) {
//     if (!controller.validateForm()) return;
//
//     controller.saveProduct();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.check_circle_outline, size: 64, color: Color(0xFF10B981)),
//               SizedBox(height: 16),
//               Text(
//                 "Product Saved!",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF10B981),
//                   minimumSize: Size(double.infinity, 48),
//                 ),
//                 child: Text("Done"),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../data/models/produuct_variantmodel.dart';
//
// class ProductController extends GetxController {
//   // ---------------- BASIC FIELDS ----------------
//   var productName = ''.obs;
//   var selectedCategory = ''.obs;
//   var productDescription = ''.obs;
//   var isPublished = false.obs;
//   var isFeatured = false.obs;
//
//   // ---------------- CATEGORY CONFIGURATION ----------------
//   // Define which attributes are variant-creating vs informational
//   final Map<String, CategoryConfig> categoryConfigs = {
//     "Fashion & Apparel": CategoryConfig(
//       variantAttributes: ["Size", "Color"],
//       commonAttributes: ["Material", "Brand", "Fit", "Pattern"],
//     ),
//     "Beauty & Personal Care": CategoryConfig(
//       variantAttributes: ["Shade", "Volume"],
//       commonAttributes: ["Skin Type", "Hair Type", "Ingredients", "Brand"],
//     ),
//     "Electronics": CategoryConfig(
//       variantAttributes: ["RAM", "Storage", "Color"],
//       commonAttributes: ["Brand", "Model", "Battery", "Warranty", "Screen Size"],
//     ),
//     "Grocery & Essentials": CategoryConfig(
//       variantAttributes: ["Weight"],
//       commonAttributes: ["Brand", "Expiry Date", "Package Type", "Organic"],
//     ),
//     "Bakery & Food": CategoryConfig(
//       variantAttributes: ["Weight / Quantity", "Flavor / Type"],
//       commonAttributes: ["Ingredients", "Expiry Date", "Brand", "Allergen Info", "Packaging Type"],
//     ),
//     "Home Appliances": CategoryConfig(
//       variantAttributes: ["Capacity", "Power"],
//       commonAttributes: ["Brand", "Model", "Warranty"],
//     ),
//     "Furniture": CategoryConfig(
//       variantAttributes: ["Color", "Size"],
//       commonAttributes: ["Material", "Brand", "Weight", "Style"],
//     ),
//     "Sports & Fitness": CategoryConfig(
//       variantAttributes: ["Size", "Weight"],
//       commonAttributes: ["Material", "Brand", "Capacity"],
//     ),
//     "Kids Products": CategoryConfig(
//       variantAttributes: ["Age Group", "Size"],
//       commonAttributes: ["Material", "Brand", "Safety Info"],
//     ),
//     "Medicine & Healthcare": CategoryConfig(
//       variantAttributes: ["Dosage"],
//       commonAttributes: ["Medicine Type", "Expiry Date", "Composition", "Brand"],
//     ),
//     "Home & Kitchen": CategoryConfig(
//       variantAttributes: ["Size", "Capacity"],
//       commonAttributes: ["Material", "Brand"],
//     ),
//     "Tools & Hardware": CategoryConfig(
//       variantAttributes: ["Size", "Power"],
//       commonAttributes: ["Material", "Brand"],
//     ),
//   };
//
//   // ---------------- VARIANT ATTRIBUTES ----------------
//   // User-defined values for each variant attribute
//   var variantAttributeValues = <String, List<String>>{}.obs;
//
//   // Common attributes (applied to all variants)
//   var commonAttributes = <String, String>{}.obs;
//
//   // ---------------- VARIANTS ----------------
//   var variants = <ProductVariant>[].obs;
//
//   // ---------------- IMAGE PICKER ----------------
//   final ImagePicker picker = ImagePicker();
//
//   // ---------------- DRAFT MANAGEMENT ----------------
//   var isDraft = false.obs;
//   var lastSavedTime = Rx<DateTime?>(null);
//
//   // ---------------- TAGS ----------------
//   var tags = <String>[].obs;
//
//   void addTag(String tag) {
//     if (tag.trim().isNotEmpty && !tags.contains(tag.trim())) {
//       tags.add(tag.trim());
//     }
//   }
//
//   void removeTag(String tag) {
//     tags.remove(tag);
//   }
//
//   // ---------------- CATEGORY CHANGE ----------------
//   void onCategoryChanged(String category) {
//     selectedCategory.value = category;
//     variantAttributeValues.clear();
//     commonAttributes.clear();
//     variants.clear();
//
//     // Initialize variant attribute values
//     final config = categoryConfigs[category];
//     if (config != null) {
//       for (var attr in config.variantAttributes) {
//         variantAttributeValues[attr] = [];
//       }
//     }
//   }
//
//   // ---------------- ATTRIBUTE VALUE MANAGEMENT ----------------
//   void addAttributeValue(String attribute, String value) {
//     if (value.trim().isEmpty) return;
//
//     if (!variantAttributeValues.containsKey(attribute)) {
//       variantAttributeValues[attribute] = [];
//     }
//
//     if (!variantAttributeValues[attribute]!.contains(value.trim())) {
//       variantAttributeValues[attribute]!.add(value.trim());
//       variantAttributeValues.refresh();
//     }
//   }
//
//   void removeAttributeValue(String attribute, String value) {
//     if (variantAttributeValues.containsKey(attribute)) {
//       variantAttributeValues[attribute]!.remove(value);
//       variantAttributeValues.refresh();
//     }
//   }
//
//   void setCommonAttribute(String attribute, String value) {
//     commonAttributes[attribute] = value;
//   }
//
//   // ---------------- VARIANT GENERATION ----------------
//   void generateVariants() {
//     if (selectedCategory.value.isEmpty) {
//       Get.snackbar(
//         "Category Required",
//         "Please select a category first",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     final config = categoryConfigs[selectedCategory.value];
//     if (config == null) return;
//
//     // Check if at least one variant attribute has values
//     bool hasVariantValues = false;
//     for (var attr in config.variantAttributes) {
//       if (variantAttributeValues[attr]?.isNotEmpty ?? false) {
//         hasVariantValues = true;
//         break;
//       }
//     }
//
//     if (!hasVariantValues) {
//       Get.snackbar(
//         "No Variant Attributes",
//         "Please add at least one value for variant attributes (e.g., Size, Color)",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     // Generate all combinations
//     List<Map<String, String>> combinations = _generateCombinations(config.variantAttributes);
//
//     // Create variants from combinations
//     variants.clear();
//     for (var combo in combinations) {
//       // Merge variant attributes with common attributes
//       Map<String, dynamic> attributes = Map<String, dynamic>.from(commonAttributes);
//       attributes.addAll(combo);
//
//       variants.add(ProductVariant(
//         attributes: attributes,
//         price: null,
//         stock: null,
//       ));
//     }
//
//     Get.snackbar(
//       "Variants Generated",
//       "${variants.length} variant(s) created",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Color(0xFF10B981),
//       colorText: Colors.white,
//     );
//   }
//
//   List<Map<String, String>> _generateCombinations(List<String> attributes) {
//     List<Map<String, String>> results = [];
//
//     // Filter attributes that have values
//     List<String> activeAttrs = [];
//     List<List<String>> activeValues = [];
//
//     for (var attr in attributes) {
//       if (variantAttributeValues[attr]?.isNotEmpty ?? false) {
//         activeAttrs.add(attr);
//         activeValues.add(variantAttributeValues[attr]!);
//       }
//     }
//
//     if (activeAttrs.isEmpty) return results;
//
//     // Generate combinations recursively
//     void generate(int index, Map<String, String> current) {
//       if (index == activeAttrs.length) {
//         results.add(Map<String, String>.from(current));
//         return;
//       }
//
//       for (var value in activeValues[index]) {
//         current[activeAttrs[index]] = value;
//         generate(index + 1, current);
//       }
//     }
//
//     generate(0, {});
//     return results;
//   }
//
//   // ---------------- MANUAL VARIANT OPERATIONS ----------------
//   void addManualVariant() {
//     if (selectedCategory.value.isEmpty) {
//       Get.snackbar(
//         "Category Required",
//         "Please select a category first",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     final config = categoryConfigs[selectedCategory.value];
//     if (config == null) return;
//
//     // Initialize with common attributes
//     Map<String, dynamic> attributes = Map<String, dynamic>.from(commonAttributes);
//
//     // Add empty variant attributes
//     for (var attr in config.variantAttributes) {
//       attributes[attr] = '';
//     }
//
//     variants.add(ProductVariant(
//       attributes: attributes,
//       price: null,
//       stock: null,
//     ));
//   }
//
//   void removeVariant(int index) {
//     if (index >= 0 && index < variants.length) {
//       variants.removeAt(index);
//     }
//   }
//
//   void duplicateVariant(int index) {
//     if (index >= 0 && index < variants.length) {
//       final original = variants[index];
//       final duplicate = ProductVariant(
//         title: "${original.title ?? ''} (Copy)",
//         price: original.price,
//         stock: original.stock,
//         imagePath: original.imagePath,
//         attributes: Map<String, dynamic>.from(original.attributes),
//       );
//       variants.insert(index + 1, duplicate);
//       Get.snackbar(
//         "Variant Duplicated",
//         "A copy has been created",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   // ---------------- IMAGE OPERATIONS ----------------
//   Future<void> pickImage(int index) async {
//     if (index < 0 || index >= variants.length) return;
//
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 1920,
//       maxHeight: 1920,
//       imageQuality: 85,
//     );
//
//     if (pickedFile != null) {
//       variants[index].imagePath = pickedFile.path;
//       variants.refresh();
//     }
//   }
//
//   Future<void> pickMultipleImages(int index) async {
//     if (index < 0 || index >= variants.length) return;
//
//     final List<XFile> pickedFiles = await picker.pickMultiImage(
//       maxWidth: 1920,
//       maxHeight: 1920,
//       imageQuality: 85,
//     );
//
//     if (pickedFiles.isNotEmpty) {
//       variants[index].imagePath = pickedFiles.first.path;
//       variants.refresh();
//
//       if (pickedFiles.length > 1) {
//         Get.snackbar(
//           "Multiple Images",
//           "${pickedFiles.length} images selected. First image set as main.",
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     }
//   }
//
//   Future<void> captureImage(int index) async {
//     if (index < 0 || index >= variants.length) return;
//
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.camera,
//       maxWidth: 1920,
//       maxHeight: 1920,
//       imageQuality: 85,
//     );
//
//     if (pickedFile != null) {
//       variants[index].imagePath = pickedFile.path;
//       variants.refresh();
//     }
//   }
//
//   void removeImage(int index) {
//     if (index >= 0 && index < variants.length) {
//       variants[index].imagePath = null;
//       variants.refresh();
//     }
//   }
//
//   // ---------------- VALIDATION ----------------
//   String? validateProductName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Product name is required";
//     }
//     if (value.length < 3) {
//       return "Product name must be at least 3 characters";
//     }
//     if (value.length > 100) {
//       return "Product name must be less than 100 characters";
//     }
//     return null;
//   }
//
//   String? validatePrice(double? value) {
//     if (value == null || value <= 0) {
//       return "Price must be greater than 0";
//     }
//     return null;
//   }
//
//   String? validateStock(int? value) {
//     if (value == null || value < 0) {
//       return "Stock cannot be negative";
//     }
//     return null;
//   }
//
//   bool validateForm() {
//     if (productName.value.trim().isEmpty) {
//       Get.snackbar("Validation Error", "Product name is required");
//       return false;
//     }
//
//     if (selectedCategory.value.isEmpty) {
//       Get.snackbar("Validation Error", "Category is required");
//       return false;
//     }
//
//     if (variants.isEmpty) {
//       Get.snackbar("Validation Error", "At least one variant is required");
//       return false;
//     }
//
//     // Validate each variant
//     for (int i = 0; i < variants.length; i++) {
//       final variant = variants[i];
//
//       if (variant.price == null || variant.price! <= 0) {
//         Get.snackbar(
//           "Validation Error",
//           "Variant ${i + 1} (${variant.getDisplayName()}): Valid price is required",
//         );
//         return false;
//       }
//
//       if (variant.stock == null || variant.stock! < 0) {
//         Get.snackbar(
//           "Validation Error",
//           "Variant ${i + 1} (${variant.getDisplayName()}): Valid stock quantity is required",
//         );
//         return false;
//       }
//
//       if (variant.imagePath == null) {
//         Get.snackbar(
//           "Validation Error",
//           "Variant ${i + 1} (${variant.getDisplayName()}): Product image is required",
//         );
//         return false;
//       }
//     }
//
//     return true;
//   }
//
//   // ---------------- DRAFT OPERATIONS ----------------
//   void saveDraft() {
//     isDraft.value = true;
//     lastSavedTime.value = DateTime.now();
//
//     final draftData = _buildProductData();
//     print("DRAFT_SAVED: $draftData");
//
//     Get.snackbar(
//       "Draft Saved",
//       "Your changes have been saved",
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: 2),
//     );
//   }
//
//   void loadDraft() {
//     Get.snackbar(
//       "Draft Loaded",
//       "Previous draft has been restored",
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   // ---------------- PRODUCT SUBMISSION ----------------
//   void saveProduct() {
//     if (!validateForm()) return;
//
//     final productData = _buildProductData();
//     print("PRODUCT_SAVED: $productData");
//
//     Get.snackbar(
//       "Success",
//       "Product has been saved successfully",
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: 3),
//     );
//   }
//
//   Map<String, dynamic> _buildProductData() {
//     return {
//       "name": productName.value.trim(),
//       "category": selectedCategory.value,
//       "description": productDescription.value.trim(),
//       "isPublished": isPublished.value,
//       "isFeatured": isFeatured.value,
//       "tags": tags.toList(),
//       "commonAttributes": Map<String, String>.from(commonAttributes),
//       "variants": variants.map((variant) => variant.toJson()).toList(),
//       "createdAt": DateTime.now().toIso8601String(),
//       "isDraft": isDraft.value,
//     };
//   }
//
//   // ---------------- BULK OPERATIONS ----------------
//   void applyPriceToAll(double price) {
//     for (var variant in variants) {
//       variant.price = price;
//     }
//     variants.refresh();
//     Get.snackbar(
//       "Price Updated",
//       "Price applied to all variants",
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   void applyStockToAll(int stock) {
//     for (var variant in variants) {
//       variant.stock = stock;
//     }
//     variants.refresh();
//     Get.snackbar(
//       "Stock Updated",
//       "Stock applied to all variants",
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   // ---------------- CLEAR & RESET ----------------
//   void _clearForm() {
//     productName.value = '';
//     selectedCategory.value = '';
//     productDescription.value = '';
//     isPublished.value = false;
//     isFeatured.value = false;
//     variants.clear();
//     tags.clear();
//     variantAttributeValues.clear();
//     commonAttributes.clear();
//     isDraft.value = false;
//     lastSavedTime.value = null;
//   }
//
//   void resetForm() {
//     Get.dialog(
//       AlertDialog(
//         title: Text("Reset Form"),
//         content: Text("Are you sure you want to reset? All unsaved changes will be lost."),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _clearForm();
//               Get.back();
//               Get.snackbar(
//                 "Form Reset",
//                 "All fields have been cleared",
//                 snackPosition: SnackPosition.BOTTOM,
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text("Reset"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
// }
//
// // Category configuration class
// class CategoryConfig {
//   final List<String> variantAttributes;  // Creates separate variants
//   final List<String> commonAttributes;   // Applied to all variants
//
//   CategoryConfig({
//     required this.variantAttributes,
//     required this.commonAttributes,
//   });
// }
//