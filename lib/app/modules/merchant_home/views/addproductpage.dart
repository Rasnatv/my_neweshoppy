//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../common/style/app_text_style.dart';
// import '../controller/addproduct_controller.dart';
//
// class AddProductPage extends StatelessWidget {
//   final ProductController controller = Get.put(ProductController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         backgroundColor: AppColors.kPrimary,
//           iconTheme: const IconThemeData(
//             color: Colors.white, // back arrow color
//           ),
//           title: Text("Add New Product",style:  AppTextStyle.rTextNunitoWhite16w600)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
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
//                           labelText: "Product Name", border: OutlineInputBorder()
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: controller.productName,
//                       decoration: const InputDecoration(
//                           labelText: "Price", border: OutlineInputBorder()
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//
//             // ---------------- Image Picker ----------------
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Obx(() => Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Product Image", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     const SizedBox(height: 12),
//                     GestureDetector(
//                       onTap: controller.pickSingleImage,
//                       child: Container(
//                         width: double.infinity,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.grey[100],
//                         ),
//                         child: controller.productImage.value == null
//                             ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.image, size: 36, color: Colors.grey),
//                             SizedBox(height: 8),
//                             Text("Tap to pick product image")
//                           ],
//                         )
//                             : ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.file(
//                             controller.productImage.value!,
//                             width: double.infinity,
//                             height: 150,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     if (controller.productImage.value != null)
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: IconButton(
//                           icon: const Icon(Icons.close, color: Colors.red),
//                           onPressed: controller.removeImage,
//                         ),
//                       )
//                   ],
//                 )),
//               ),
//             ),
// //---------------- Category & Stock ----------------
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Category & Stock", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     const SizedBox(height: 12),
//                     // Category Dropdown
//                     Obx(() => DropdownButtonFormField<String>(
//                       value: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
//                       decoration: const InputDecoration(
//                         labelText: "Select Category",
//                         border: OutlineInputBorder(),
//                       ),
//                       items: controller.productCategories
//                           .map((c) => DropdownMenuItem(value: c, child: Text(c)))
//                           .toList(),
//                       onChanged: (v) => controller.selectedCategory.value = v!,
//                     )),
//                     const SizedBox(height: 12),
//                     // Number of items in stock
//                     TextField(
//                       controller: controller.stockQuantity,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: "Number of items in stock",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//
//             // ---------------- Features ----------------
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
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
//                     const SizedBox(height: 8),
//                     Obx(() => Column(
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
//                     )),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ---------------- Specifications (Attributes) ----------------
//             // ---------------- Specifications (Attributes) ----------------
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Specifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     const SizedBox(height: 12),
//                     TextButton(
//                       onPressed: controller.attributes.length < 10 ? controller.addAttributeRow : null,
//                       child: const Text("+ Add Attribute"),
//                     ),
//                     const SizedBox(height: 12),
//                     Obx(() {
//                       if (controller.selectedCategory.value.isEmpty) {
//                         return const Text("Select category to see suggested attributes");
//                       }
//                       final attrList = controller.categoryAttributes[controller.selectedCategory.value] ?? <String>[];
//
//                       return Column(
//                         children: List.generate(controller.attributes.length, (index) {
//                           final attr = controller.attributes[index];
//                           final bool isOther = attr["isOther"] as bool;
//                           final bool isVariant = attr["isVariant"] as bool;
//                           final values = attr["values"] as List<String>;
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
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//
//
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: controller.addProduct,
//                   child: Text("Submit Product"),
//                 ),
//               ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// Flutter Variant Product Add Page (Merchant)
// Matches API payload structure exactly

import 'package:flutter/material.dart';

class AddVariantProductPage extends StatefulWidget {
  const AddVariantProductPage({super.key});

  @override
  State<AddVariantProductPage> createState() => _AddVariantProductPageState();
}

class _AddVariantProductPageState extends State<AddVariantProductPage> {
  // Selected attribute values
  List<String> sizes = ['S', 'M'];
  List<String> colors = ['Red', 'Blue'];

  List<Map<String, dynamic>> variants = [];

  @override
  void initState() {
    super.initState();
    generateVariants();
  }

  void generateVariants() {
    variants.clear();
    for (var size in sizes) {
      for (var color in colors) {
        variants.add({
          'size': size,
          'color': color,
          'price': TextEditingController(),
          'stock': TextEditingController(),
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Variant Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Basic Information'),
            _textField('Product Name'),
            _dropdown('Category'),

            const SizedBox(height: 20),
            _sectionTitle('Attributes'),
            Wrap(
              spacing: 10,
              children: const [
                Chip(label: Text('Size')),
                Chip(label: Text('Color')),
              ],
            ),

            const SizedBox(height: 20),
            _sectionTitle('Variants'),
            _variantTable(),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Build API payload here
                },
                child: const Text('Save Product'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _variantTable() {
    return Column(
      children: variants.map((variant) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: Text('${variant['size']} / ${variant['color']}')),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: variant['price'],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: variant['stock'],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Stock'),
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _textField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _dropdown(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        items: const [],
        onChanged: (v) {},
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
