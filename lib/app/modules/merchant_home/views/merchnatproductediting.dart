// //
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../controller/addproduct_controller.dart';
// //
// // class DummyEditProductPage extends StatelessWidget {
// //   final ProductController controller = Get.put(ProductController());
// //
// //   DummyEditProductPage({super.key}) {
// //     // ---------------- Dummy pre-filled data ----------------
// //     controller.productName.text = "Sample T-Shirt";
// //     controller.price.text = "499";
// //     controller.stockQuantity.text = "20";
// //     controller.selectedCategory.value = "Fashion & Apparel";
// //     controller.productImage.value = null; // no image for dummy
// //     controller.features.addAll([
// //       TextEditingController(text: "Comfortable fabric"),
// //       TextEditingController(text: "Lightweight"),
// //     ]);
// //
// //     controller.attributes.addAll([
// //       {
// //         "selected": "Size",
// //         "isOther": false,
// //         "isVariant": true,
// //         "name": TextEditingController(),
// //         "value": TextEditingController(),
// //         "values": ["M", "L"]
// //       },
// //       {
// //         "selected": "Color",
// //         "isOther": false,
// //         "isVariant": true,
// //         "name": TextEditingController(),
// //         "value": TextEditingController(),
// //         "values": ["Red", "Blue"]
// //       },
// //       {
// //         "selected": "Material",
// //         "isOther": false,
// //         "isVariant": false,
// //         "name": TextEditingController(),
// //         "value": TextEditingController(text: "Cotton"),
// //         "values": <String>[]
// //       },
// //     ]);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Edit Product (Dummy)")),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // ---------------- Product Info ----------------
// //             Card(
// //               elevation: 2,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //               margin: const EdgeInsets.symmetric(vertical: 8),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text("Product Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                     const SizedBox(height: 12),
// //                     TextField(
// //                       controller: controller.productName,
// //                       decoration: const InputDecoration(labelText: "Product Name", border: OutlineInputBorder()),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     TextField(
// //                       controller: controller.price,
// //                       decoration: const InputDecoration(labelText: "Price", border: OutlineInputBorder()),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     TextField(
// //                       controller: controller.stockQuantity,
// //                       decoration: const InputDecoration(labelText: "Stock Quantity", border: OutlineInputBorder()),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //
// //             // ---------------- Features ----------------
// //             Card(
// //               elevation: 2,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //               margin: const EdgeInsets.symmetric(vertical: 8),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: Obx(() => Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         const Text("Features", style: TextStyle(fontWeight: FontWeight.bold)),
// //                         TextButton(
// //                           onPressed: controller.features.length < 5 ? controller.addFeature : null,
// //                           child: const Text("+ Add Feature"),
// //                         ),
// //                       ],
// //                     ),
// //                     Column(
// //                       children: List.generate(controller.features.length, (index) {
// //                         return Padding(
// //                           padding: const EdgeInsets.only(bottom: 8),
// //                           child: Row(
// //                             children: [
// //                               Expanded(
// //                                 child: TextField(
// //                                   controller: controller.features[index],
// //                                   decoration: InputDecoration(
// //                                     labelText: "Feature ${index + 1}",
// //                                     border: const OutlineInputBorder(),
// //                                   ),
// //                                 ),
// //                               ),
// //                               IconButton(
// //                                 icon: const Icon(Icons.delete, color: Colors.red),
// //                                 onPressed: () => controller.removeFeature(index),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       }),
// //                     ),
// //                   ],
// //                 )),
// //               ),
// //             ),
// //
// //             // ---------------- Specifications ----------------
// //             Card(
// //               elevation: 2,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //               margin: const EdgeInsets.symmetric(vertical: 8),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: Obx(() {
// //                   final category = controller.selectedCategory.value;
// //                   final attrList = category.isEmpty
// //                       ? <String>[]
// //                       : controller.categoryAttributes[category] ?? <String>[];
// //
// //                   return Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           const Text("Specifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                           TextButton(
// //                             onPressed: controller.attributes.length < 10 ? controller.addAttributeRow : null,
// //                             child: const Text("+ Add Specification"),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Column(
// //                         children: List.generate(controller.attributes.length, (index) {
// //                           final attr = controller.attributes[index];
// //                           final bool isOther = attr["isOther"] as bool;
// //                           final bool isVariant = attr["isVariant"] as bool;
// //                           final List<String> values = attr["values"] as List<String>;
// //
// //                           return Container(
// //                             margin: const EdgeInsets.only(bottom: 12),
// //                             padding: const EdgeInsets.all(10),
// //                             decoration: BoxDecoration(
// //                               color: Colors.grey[50],
// //                               border: Border.all(color: Colors.grey.shade300),
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Row(
// //                                   children: [
// //                                     Expanded(
// //                                       child: TextField(
// //                                         controller: attr["name"] as TextEditingController,
// //                                         decoration: InputDecoration(
// //                                           labelText: attr["selected"] as String,
// //                                           border: const OutlineInputBorder(),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     IconButton(
// //                                       icon: const Icon(Icons.delete, color: Colors.red),
// //                                       onPressed: () => controller.removeAttributeRow(index),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 if (isVariant)
// //                                   Padding(
// //                                     padding: const EdgeInsets.only(top: 8),
// //                                     child: Wrap(
// //                                       spacing: 6,
// //                                       children: values.map((v) => Chip(label: Text(v))).toList(),
// //                                     ),
// //                                   ),
// //                               ],
// //                             ),
// //                           );
// //                         }),
// //                       ),
// //                     ],
// //                   );
// //                 }),
// //               ),
// //             ),
// //
// //             const SizedBox(height: 20),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: () => Get.snackbar("Update", "Product updated (dummy)"),
// //                 child: const Text("Update Product"),
// //               ),
// //             ),
// //             const SizedBox(height: 40),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../common/style/app_text_style.dart';
// import '../controller/addproduct_controller.dart';
// import 'addproductpage.dart';
//
// class EditProductPage extends StatelessWidget {
//   final ProductController controller = Get.put(ProductController());
//
//   EditProductPage({super.key}) {
//     // ------------------ Dummy pre-filled data ------------------
//     controller.productName.text = "Sample T-Shirt";
//     controller.price.text = "499";
//     controller.stockQuantity.text = "20";
//     //controller.selectedCategory.value = "Fashion & Apparel";
//     controller.productImage.value = null;
//
//     controller.features.addAll([
//       TextEditingController(text: "Comfortable fabric"),
//       TextEditingController(text: "Lightweight"),
//     ]);
//
//     controller.attributes.addAll([
//       {
//         "selected": "Size",
//         "isOther": false,
//         "isVariant": true,
//         "name": TextEditingController(),
//         "value": TextEditingController(),
//         "values": ["M", "L"]
//       },
//       {
//         "selected": "Color",
//         "isOther": false,
//         "isVariant": true,
//         "name": TextEditingController(),
//         "value": TextEditingController(),
//         "values": ["Red", "Blue"]
//       },
//       {
//         "selected": "Material",
//         "isOther": false,
//         "isVariant": false,
//         "name": TextEditingController(),
//         "value": TextEditingController(text: "Cotton"),
//         "values": <String>[]
//       },
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.kPrimary,
//           title: Text("Edit Product",style:AppTextStyle.rTextNunitoWhite17w700)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ---------------- Product Info ----------------
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Product Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: controller.productName,
//                       decoration: const InputDecoration(
//                           labelText: "Product Name", border: OutlineInputBorder()),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: controller.price,
//                       decoration: const InputDecoration(
//                           labelText: "Price", border: OutlineInputBorder()),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: controller.price,
//                       decoration: const InputDecoration(
//                           labelText: "Stock", border: OutlineInputBorder()),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ---------------- Features ----------------
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Obx(() => Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text("Features (up to 5)", style: TextStyle(fontWeight: FontWeight.bold)),
//                         TextButton(
//                           onPressed: controller.features.length < 5 ? controller.addFeature : null,
//                           child: const Text("+ Add Feature"),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: List.generate(controller.features.length, (index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 8.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: controller.features[index],
//                                   decoration: InputDecoration(
//                                     labelText: "Feature ${index + 1}",
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () => controller.removeFeature(index),
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//                     ),
//                   ],
//                 )),
//               ),
//             ),
//
//             // ---------------- Specifications ----------------
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Obx(() {
//                   final category = controller.selectedCategory.value;
//                   final attrList = category.isEmpty
//                       ? <String>[]
//                       : controller.categoryAttributes[category] ?? <String>[];
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text("Specifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                           TextButton(
//                             onPressed: controller.attributes.length < 10 ? controller.addAttributeRow : null,
//                             child: const Text("+ Add Specification"),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Column(
//                         children: List.generate(controller.attributes.length, (index) {
//                           final attr = controller.attributes[index];
//                           final bool isOther = attr["isOther"] as bool;
//                           final bool isVariant = attr["isVariant"] as bool;
//                           final List<String> values = attr["values"] as List<String>;
//
//                           return Container(
//                             margin: const EdgeInsets.only(bottom: 12),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[50],
//                               border: Border.all(color: Colors.grey.shade300),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: DropdownButtonFormField<String>(
//                                         isExpanded: true,
//                                         value: (attr["selected"] as String).isEmpty
//                                             ? null
//                                             : (attr["selected"] as String),
//                                         decoration: const InputDecoration(
//                                           labelText: "Attribute",
//                                           border: OutlineInputBorder(),
//                                         ),
//                                         items: [
//                                           ...attrList.where((e) => e != "Other")
//                                               .map((e) => DropdownMenuItem(value: e, child: Text(e))),
//                                           const DropdownMenuItem(value: "Other", child: Text("Other")),
//                                         ],
//                                         onChanged: (val) => controller.onAttributeSelected(index, val),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     IconButton(
//                                       icon: const Icon(Icons.delete, color: Colors.red),
//                                       onPressed: () => controller.removeAttributeRow(index),
//                                     ),
//                                   ],
//                                 ),
//                                 if (isOther) ...[
//                                   const SizedBox(height: 8),
//                                   TextField(
//                                     controller: attr["name"] as TextEditingController,
//                                     decoration: const InputDecoration(
//                                       labelText: "Custom Name",
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ],
//                                 const SizedBox(height: 8),
//                                 if (isVariant) ...[
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextField(
//                                           controller: TextEditingController(),
//                                           key: ValueKey("variant_input_$index"),
//                                           onSubmitted: (v) => controller.addVariantValue(index, v),
//                                           decoration: const InputDecoration(
//                                             labelText: "Add variant (press enter)",
//                                             border: OutlineInputBorder(),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       IconButton(
//                                         tooltip: "Open suggestions",
//                                         icon: const Icon(Icons.list),
//                                         onPressed: () {
//                                           final name = (attr["selected"] as String);
//                                           final suggestions = controller.attributeValueSuggestions[name] ?? [];
//                                           if (suggestions.isEmpty) {
//                                             Get.snackbar("No suggestions", "No suggestions available for $name");
//                                             return;
//                                           }
//                                           Get.bottomSheet(
//                                             Container(
//                                               padding: const EdgeInsets.all(12),
//                                               decoration: BoxDecoration(
//                                                 color: Theme.of(context).canvasColor,
//                                                 borderRadius: const BorderRadius.only(
//                                                   topLeft: Radius.circular(12),
//                                                   topRight: Radius.circular(12),
//                                                 ),
//                                               ),
//                                               child: Wrap(
//                                                 spacing: 6,
//                                                 runSpacing: 6,
//                                                 children: suggestions.map((v) {
//                                                   return ActionChip(
//                                                     label: Text(v),
//                                                     onPressed: () {
//                                                       controller.addVariantValue(index, v);
//                                                       Get.back();
//                                                     },
//                                                   );
//                                                 }).toList(),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: values.map((v) {
//                                       return Container(
//                                         margin: const EdgeInsets.symmetric(vertical: 3),
//                                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[200],
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(v, style: const TextStyle(fontSize: 14)),
//                                             IconButton(
//                                               icon: const Icon(Icons.close, size: 18, color: Colors.red),
//                                               onPressed: () => controller.removeVariantValue(index, v),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ] else
//                                   TextField(
//                                     controller: attr["value"] as TextEditingController,
//                                     decoration: const InputDecoration(
//                                       labelText: "Value",
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           );
//                         }),
//                       ),
//                     ],
//                   );
//                 }),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => Get.snackbar("Update", "Product updated (dummy)"),
//                 child: const Text("Update Product"),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }
