// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/models/user_productdetailmodel.dart';
//
// class ProductDetailController extends GetxController {
//   final box = GetStorage();
//
//   var isLoading = false.obs;
//   var product = Rxn<ProductDetailModel>();
//   var selectedVariant = Rxn<ProductVariantModel>();
//   var quantity = 1.obs;
//
//   final String api =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/product-details";
//
//   Future<void> fetchProduct(int productId) async {
//     final token = box.read('auth_token');
//     if (token == null) return;
//
//     try {
//       isLoading.value = true;
//
//       final response = await http.post(
//         Uri.parse(api),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: {
//           "product_id": productId.toString(),
//         },
//       );
//
//       final decoded = json.decode(response.body);
//       product.value = ProductDetailModel.fromJson(decoded['data']);
//
//       /// default variant
//       if (product.value!.variants.isNotEmpty) {
//         selectedVariant.value = product.value!.variants.first;
//       }
//     } catch (e) {
//       product.value = null;
//       print("Product detail error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void selectVariant(ProductVariantModel variant) {
//     selectedVariant.value = variant;
//     quantity.value = 1;
//   }
//
//   void increaseQty() {
//     if (quantity.value <
//         int.parse(selectedVariant.value?.stock ?? "0")) {
//       quantity.value++;
//     }
//   }
//
//   void decreaseQty() {
//     if (quantity.value > 1) quantity.value--;
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/userproductdetail_controller.dart';
//
// class ProductDetailPage extends StatelessWidget {
//   final int productId;
//
//   ProductDetailPage({super.key, required this.productId});
//
//   final controller = Get.put(ProductDetailController());
//
//   @override
//   Widget build(BuildContext context) {
//     controller.fetchProduct(productId);
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black87),
//             onPressed: () => Get.back(),
//           ),
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: IconButton(
//               icon: const Icon(Icons.favorite_border, color: Colors.black87),
//               onPressed: () {},
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final product = controller.product.value;
//         final variant = controller.selectedVariant.value;
//
//         if (product == null || variant == null) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.shopping_bag_outlined,
//                     size: 80, color: Colors.grey[400]),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Product not found",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
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
//                   /// 🔥 IMAGE SLIDER WITH INDICATORS
//                   _buildImageSlider(product),
//
//                   /// PRODUCT DETAILS CARD
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, -5),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           /// PRODUCT NAME & CATEGORY
//                           _buildProductHeader(product),
//
//                           const SizedBox(height: 20),
//
//                           /// PRICE & STOCK
//                           _buildPriceSection(variant),
//
//                           const SizedBox(height: 24),
//
//                           /// VARIANT SELECTION
//                           if (product.variants.length > 1)
//                             _buildVariantSection(product),
//
//                           /// PRODUCT DETAILS
//                           _buildDetailsSection(product),
//
//                           const SizedBox(height: 24),
//
//                           /// DESCRIPTION
//                           _buildDescriptionSection(product),
//
//                           const SizedBox(height: 100), // Space for bottom bar
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             /// BOTTOM ACTION BAR
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: _buildBottomBar(variant),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget _buildImageSlider(product) {
//     return SizedBox(
//       height: 400,
//       child: Stack(
//         children: [
//           Obx(() {
//             final selectedVariant = controller.selectedVariant.value;
//             return Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.grey[100]!,
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: Image.network(
//                 selectedVariant?.image ?? '',
//                 fit: BoxFit.contain,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Center(
//                     child: Icon(
//                       Icons.image_not_supported_outlined,
//                       size: 80,
//                       color: Colors.grey[300],
//                     ),
//                   );
//                 },
//               ),
//             );
//           }),
//
//           /// VARIANT THUMBNAILS
//           if (product.variants.length > 1)
//             Positioned(
//               bottom: 20,
//               left: 0,
//               right: 0,
//               child: Obx(() {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: product.variants.map<Widget>((variant) {
//                     final isSelected =
//                         controller.selectedVariant.value == variant;
//                     return GestureDetector(
//                       onTap: () => controller.selectVariant(variant),
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 6),
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected
//                                 ? Colors.black87
//                                 : Colors.grey[300]!,
//                             width: isSelected ? 3 : 1,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 8,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                             variant.image,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Icon(
//                                 Icons.image,
//                                 color: Colors.grey[400],
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               }),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProductHeader(product) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: Colors.blue[50],
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             product.commonAttributes['brand']?.toString().toUpperCase() ??
//                 'BRAND',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.blue[700],
//               letterSpacing: 0.5,
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           product.productName,
//           style: const TextStyle(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//             height: 1.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPriceSection(variant) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.green[50],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.green[100]!),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Price",
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "₹${variant.price}",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green[700],
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: int.parse(variant.stock) > 5
//                   ? Colors.green[100]
//                   : Colors.orange[100],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   int.parse(variant.stock) > 5
//                       ? Icons.check_circle
//                       : Icons.warning_amber_rounded,
//                   size: 18,
//                   color: int.parse(variant.stock) > 5
//                       ? Colors.green[700]
//                       : Colors.orange[700],
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   "${variant.stock} in stock",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: int.parse(variant.stock) > 5
//                         ? Colors.green[700]
//                         : Colors.orange[700],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVariantSection(product) {
//     // Extract unique colors and sizes from variants
//     final colors = <String, String>{};
//     final sizes = <String>{};
//
//     for (var variant in product.variants) {
//       if (variant.attributes.containsKey('colour')) {
//         colors[variant.attributes['colour']!] = variant.attributes['colour']!;
//       }
//       if (variant.attributes.containsKey('size')) {
//         sizes.add(variant.attributes['size']!);
//       }
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// COLOR SELECTION
//         if (colors.isNotEmpty) ...[
//           const Text(
//             "Select Color",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Obx(() {
//             final selectedColor =
//             controller.selectedVariant.value?.attributes['colour'];
//
//             return Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: colors.entries.map<Widget>((entry) {
//                 final colorName = entry.key;
//                 final isSelected = selectedColor == colorName;
//
//                 // Find a variant with this color
//                 final variantWithColor = product.variants.firstWhere(
//                       (v) => v.attributes['colour'] == colorName,
//                 );
//
//                 return GestureDetector(
//                   onTap: () {
//                     controller.selectVariant(variantWithColor);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isSelected ? Colors.black87 : Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: isSelected ? Colors.black87 : Colors.grey[300]!,
//                         width: isSelected ? 2 : 1,
//                       ),
//                     ),
//                         child:Text(
//                           colorName.toUpperCase(),
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: isSelected ? Colors.white : Colors.black87,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                     ),
//
//                 );
//               }).toList(),
//             );
//           }),
//           const SizedBox(height: 24),
//         ],
//
//         /// SIZE SELECTION
//         if (sizes.isNotEmpty) ...[
//           Row(
//             children: [
//               const Text(
//                 "Select Size",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const Spacer(),
//               Obx(() {
//                 final selectedSize =
//                 controller.selectedVariant.value?.attributes['size'];
//                 if (selectedSize != null) {
//                   return Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.blue[200]!),
//                     ),
//                     child: Text(
//                       selectedSize,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.blue[700],
//                       ),
//                     ),
//                   );
//                 }
//                 return const SizedBox.shrink();
//               }),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Obx(() {
//             final selectedSize =
//             controller.selectedVariant.value?.attributes['size'];
//             final selectedColor =
//             controller.selectedVariant.value?.attributes['colour'];
//
//             return Wrap(
//               spacing: 10,
//               runSpacing: 10,
//               children: sizes.map<Widget>((size) {
//                 final isSelected = selectedSize == size;
//
//                 // Find variant with selected color and this size
//                 dynamic variantWithSize;
//                 try {
//                   variantWithSize = product.variants.firstWhere(
//                         (v) =>
//                     v.attributes['size'] == size &&
//                         (selectedColor == null ||
//                             v.attributes['colour'] == selectedColor),
//                   );
//                 } catch (e) {
//                   variantWithSize = null;
//                 }
//
//                 final isAvailable = variantWithSize != null;
//
//                 return Opacity(
//                   opacity: isAvailable ? 1.0 : 0.4,
//                   child: GestureDetector(
//                     onTap: isAvailable
//                         ? () => controller.selectVariant(variantWithSize!)
//                         : null,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.black87 : Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color:
//                           isSelected ? Colors.black87 : Colors.grey[300]!,
//                           width: isSelected ? 2 : 1,
//                         ),
//                       ),
//                       child: Text(
//                         size,
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: isSelected ? Colors.white : Colors.black87,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             );
//           }),
//           const SizedBox(height: 24),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildDetailsSection(product) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Product Details",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[50],
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.grey[200]!),
//           ),
//           child: Column(
//             children: product.commonAttributes.entries.map<Widget>((e) {
//               return Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                       color: Colors.grey[200]!,
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 100,
//                       child: Text(
//                         e.key.toUpperCase(),
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[600],
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         e.value.toString(),
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDescriptionSection(product) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Description",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           product.description,
//           style: TextStyle(
//             fontSize: 15,
//             height: 1.6,
//             color: Colors.grey[700],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBottomBar(variant) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             /// QUANTITY SELECTOR
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey[300]!),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: controller.decreaseQty,
//                     icon: Icon(Icons.remove, color: Colors.grey[700]),
//                     splashRadius: 20,
//                   ),
//                   Obx(() => Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Text(
//                       controller.quantity.value.toString(),
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   )),
//                   IconButton(
//                     onPressed: controller.increaseQty,
//                     icon: Icon(Icons.add, color: Colors.grey[700]),
//                     splashRadius: 20,
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(width: 12),
//
//             /// ADD TO CART BUTTON
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Add to cart logic
//                   Get.snackbar(
//                     "Success",
//                     "Added to cart successfully",
//                     snackPosition: SnackPosition.BOTTOM,
//                     backgroundColor: Colors.green,
//                     colorText: Colors.white,
//                     margin: const EdgeInsets.all(16),
//                     borderRadius: 12,
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black87,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.shopping_cart_outlined, size: 20),
//                     SizedBox(width: 8),
//                     Text(
//                       "Add to Cart",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }