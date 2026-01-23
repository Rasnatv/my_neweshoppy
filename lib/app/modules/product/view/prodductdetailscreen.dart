//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/userproductdetail_controller.dart';
// import '../../../data/models/user_productdetailmodel.dart';
//
// class ProductDetailPage extends StatelessWidget {
//   final int productId;
//
//   ProductDetailPage({super.key, required this.productId});
//
//   final ProductDetailController controller =
//   Get.put(ProductDetailController());
//
//   @override
//   Widget build(BuildContext context) {
//     controller.fetchProduct(productId);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         title: const Text(
//           "Product Details",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black87),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite_border),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.share_outlined),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
//             ),
//           );
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
//                 Icon(
//                   Icons.shopping_bag_outlined,
//                   size: 80,
//                   color: Colors.grey[400],
//                 ),
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
//               padding: const EdgeInsets.only(bottom: 100),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildImageGallery(variant),
//                   const SizedBox(height: 8),
//                   _buildProductInfo(product, variant),
//                   const Divider(height: 32, thickness: 8, color: Color(0xFFF0F0F0)),
//                   _buildVariantSection(product),
//                   const Divider(height: 32, thickness: 8, color: Color(0xFFF0F0F0)),
//                   _buildCommonAttributes(product),
//                   const Divider(height: 32, thickness: 8, color: Color(0xFFF0F0F0)),
//                   _buildDescription(product),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//             _buildBottomBar(variant),
//           ],
//         );
//       }),
//     );
//   }
//
//   /// IMAGE GALLERY with modern design
//   Widget _buildImageGallery(ProductVariantModel variant) {
//     return Container(
//       height: 380,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//       ),
//       child: Center(
//           child: Image.network(
//             variant.image,
//             fit: BoxFit.contain,
//             errorBuilder: (_, __, ___) => Icon(
//               Icons.image_not_supported_outlined,
//               size: 100,
//               color: Colors.grey[300],
//             ),
//           ),
//         ),
//     );
//   }
//
//   /// PRODUCT INFO - Price and Title
//   Widget _buildProductInfo(ProductDetailModel product, ProductVariantModel variant) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Product Name
//           Text(
//             product.productName,
//             style: const TextStyle(
//               fontSize: 26,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//               letterSpacing: -0.5,
//               height: 1.3,
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Price Row
//           Row(
//             children: [
//               Text(
//                 "₹${variant.price}",
//                 style: const TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2E7D32),
//                   letterSpacing: -1,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// VARIANT SECTION with modern chip design
//   Widget _buildVariantSection(ProductDetailModel product) {
//     final attributeMap = controller.getVariantAttributes();
//
//     if (attributeMap.isEmpty) return const SizedBox.shrink();
//
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: attributeMap.entries.map((entry) {
//           final attribute = entry.key;
//           final values = entry.value.toList();
//
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       attribute.toLowerCase() == 'color'
//                           ? Icons.palette_outlined
//                           : attribute.toLowerCase() == 'size'
//                           ? Icons.straighten_outlined
//                           : Icons.tune,
//                       size: 20,
//                       color: Colors.black54,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       attribute.toUpperCase(),
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 14),
//                 Obx(() {
//                   final selected =
//                   controller.selectedVariant.value?.attributes[attribute];
//
//                   return Wrap(
//                     spacing: 12,
//                     runSpacing: 12,
//                     children: values.map((value) {
//                       final isSelected = selected == value;
//
//                       ProductVariantModel? matchedVariant;
//                       try {
//                         matchedVariant = product.variants.firstWhere(
//                               (v) => v.attributes[attribute] == value,
//                         );
//                       } catch (_) {
//                         matchedVariant = null;
//                       }
//
//                       final isAvailable = matchedVariant != null;
//
//                       return GestureDetector(
//                         onTap: isAvailable
//                             ? () => controller.selectVariant(matchedVariant!)
//                             : null,
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 200),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? Colors.black87
//                                 : isAvailable
//                                 ? Colors.white
//                                 : Colors.grey[200],
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: isSelected
//                                   ? Colors.black87
//                                   : isAvailable
//                                   ? Colors.grey[300]!
//                                   : Colors.grey[300]!,
//                               width: isSelected ? 2 : 1.5,
//                             ),
//                             boxShadow: isSelected
//                                 ? [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ]
//                                 : [],
//                           ),
//                           child: Text(
//                             value.toUpperCase(),
//                             style: TextStyle(
//                               color: isSelected
//                                   ? Colors.white
//                                   : isAvailable
//                                   ? Colors.black87
//                                   : Colors.grey[500],
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 }),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   /// COMMON ATTRIBUTES Section
//   Widget _buildCommonAttributes(ProductDetailModel product) {
//     // Check if common attributes exist and is not empty
//     if (product.commonAttributes == null || product.commonAttributes!.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(
//                 Icons.info_outline,
//                 size: 20,
//                 color: Colors.black54,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 "SPECIFICATIONS",
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...product.commonAttributes!.entries.map((entry) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       entry.key,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     flex: 3,
//                     child: Text(
//                       entry.value.toString(),
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   /// DESCRIPTION with better formatting
//   Widget _buildDescription(ProductDetailModel product) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(
//                 Icons.description_outlined,
//                 size: 20,
//                 color: Colors.black54,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 "DESCRIPTION",
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           Text(
//             product.description,
//             style: TextStyle(
//               fontSize: 15,
//               height: 1.6,
//               color: Colors.grey[700],
//               letterSpacing: 0.2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// BOTTOM BAR with modern design
//   Widget _buildBottomBar(ProductVariantModel variant) {
//     final stockCount = int.parse(variant.stock);
//     final isOutOfStock = stockCount == 0;
//
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: const Offset(0, -5),
//             ),
//           ],
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         child: SafeArea(
//           child: Row(
//             children: [
//               // Quantity Selector
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey[300]!),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.remove, size: 20),
//                       onPressed: controller.decreaseQty,
//                       color: Colors.black87,
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Obx(() => Text(
//                         controller.quantity.value.toString(),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       )),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.add, size: 20),
//                       onPressed: controller.increaseQty,
//                       color: Colors.black87,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               // Add to Cart Button
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: isOutOfStock
//                       ? null
//                       : () {
//                     Get.snackbar(
//                       "Success",
//                       "Added ${controller.quantity.value} item(s) to cart",
//                       backgroundColor: const Color(0xFF2E7D32),
//                       colorText: Colors.white,
//                       icon: const Icon(
//                         Icons.check_circle_outline,
//                         color: Colors.white,
//                       ),
//                       snackPosition: SnackPosition.BOTTOM,
//                       margin: const EdgeInsets.all(16),
//                       borderRadius: 12,
//                       duration: const Duration(seconds: 2),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                     isOutOfStock ? Colors.grey[400] : Colors.black87,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         isOutOfStock
//                             ? Icons.block
//                             : Icons.shopping_cart_outlined,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         isOutOfStock ? "Out of Stock" : "Add to Cart",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/userproductdetail_controller.dart';
import '../../../data/models/user_productdetailmodel.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  ProductDetailPage({super.key, required this.productId});

  final ProductDetailController controller =
  Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    controller.fetchProduct(productId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Product Details",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
            ),
          );
        }

        final product = controller.product.value;
        final variant = controller.selectedVariant.value;

        if (product == null || variant == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "Product not found",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageGallery(variant),
                  const SizedBox(height: 8),
                  _buildProductInfo(product, variant),
                  const Divider(height: 32, thickness: 8, color: Color(0xFFF0F0F0)),
                  _buildVariantSection(product),
                  const Divider(height: 32, thickness: 8, color: Color(0xFFF0F0F0)),
                  _buildCommonAttributes(product),
                  const Divider(height: 32, thickness: 8, color: Color(0xFFF0F0F0)),
                  _buildDescription(product),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            _buildBottomBar(variant),
          ],
        );
      }),
    );
  }

  /// IMAGE GALLERY with modern design
  Widget _buildImageGallery(ProductVariantModel variant) {
    return Container(
      height: 380,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Center(
          child: Image.network(
            variant.image,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.image_not_supported_outlined,
              size: 100,
              color: Colors.grey[300],
            ),
          ),
        ),
    );
  }

  /// PRODUCT INFO - Price and Title
  Widget _buildProductInfo(ProductDetailModel product, ProductVariantModel variant) {
    final stockCount = int.parse(variant.stock);
    final isLowStock = stockCount <= 5;
    final isOutOfStock = stockCount == 0;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product.productName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: -0.5,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          // Price and Stock Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "₹${variant.price}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  letterSpacing: -1,
                ),
              ),
              // Stock Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isOutOfStock
                      ? Colors.red.withOpacity(0.1)
                      : isLowStock
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isOutOfStock
                        ? Colors.red
                        : isLowStock
                        ? Colors.orange
                        : Colors.green,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOutOfStock
                          ? Icons.cancel_outlined
                          : isLowStock
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: isOutOfStock
                          ? Colors.red
                          : isLowStock
                          ? Colors.orange
                          : Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isOutOfStock
                          ? "Out of Stock"
                          : "$stockCount in Stock",
                      style: TextStyle(
                        color: isOutOfStock
                            ? Colors.red
                            : isLowStock
                            ? Colors.orange
                            : Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// VARIANT SECTION with modern chip design
  Widget _buildVariantSection(ProductDetailModel product) {
    final attributeMap = controller.getVariantAttributes();

    if (attributeMap.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: attributeMap.entries.map((entry) {
          final attribute = entry.key;
          final values = entry.value.toList();

          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      attribute.toLowerCase() == 'color'
                          ? Icons.palette_outlined
                          : attribute.toLowerCase() == 'size'
                          ? Icons.straighten_outlined
                          : Icons.tune,
                      size: 20,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      attribute.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Obx(() {
                  final selected =
                  controller.selectedVariant.value?.attributes[attribute];

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: values.map((value) {
                      final isSelected = selected == value;

                      ProductVariantModel? matchedVariant;
                      try {
                        matchedVariant = product.variants.firstWhere(
                              (v) => v.attributes[attribute] == value,
                        );
                      } catch (_) {
                        matchedVariant = null;
                      }

                      final isAvailable = matchedVariant != null;

                      return GestureDetector(
                        onTap: isAvailable
                            ? () => controller.selectVariant(matchedVariant!)
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black87
                                : isAvailable
                                ? Colors.white
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black87
                                  : isAvailable
                                  ? Colors.grey[300]!
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                                : [],
                          ),
                          child: Text(
                            value.toUpperCase(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : isAvailable
                                  ? Colors.black87
                                  : Colors.grey[500],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// COMMON ATTRIBUTES Section
  Widget _buildCommonAttributes(ProductDetailModel product) {
    // Check if common attributes exist and is not empty
    if (product.commonAttributes == null || product.commonAttributes!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Colors.black54,
              ),
              SizedBox(width: 8),
              Text(
                "SPECIFICATIONS",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...product.commonAttributes!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// DESCRIPTION with better formatting
  Widget _buildDescription(ProductDetailModel product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 20,
                color: Colors.black54,
              ),
              SizedBox(width: 8),
              Text(
                "DESCRIPTION",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey[700],
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// BOTTOM BAR with modern design
  Widget _buildBottomBar(ProductVariantModel variant) {
    final stockCount = int.parse(variant.stock);
    final isOutOfStock = stockCount == 0;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: controller.decreaseQty,
                      color: Colors.black87,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Obx(() => Text(
                        controller.quantity.value.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: controller.increaseQty,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: isOutOfStock
                      ? null
                      : () {
                    Get.snackbar(
                      "Success",
                      "Added ${controller.quantity.value} item(s) to cart",
                      backgroundColor: const Color(0xFF2E7D32),
                      colorText: Colors.white,
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isOutOfStock ? Colors.grey[400] : Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isOutOfStock
                            ? Icons.block
                            : Icons.shopping_cart_outlined,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isOutOfStock ? "Out of Stock" : "Add to Cart",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}