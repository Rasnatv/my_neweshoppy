
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/addofferproduct_controller.dart';

class AddOfferProductPage extends StatelessWidget {
  AddOfferProductPage({super.key});

  final controller = Get.put(AddOfferProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: Colors.white, // back arrow color
          ),
        backgroundColor: AppColors.kPrimary,
          title:  Text("Add Offer Product",style:  AppTextStyle.rTextNunitoWhite16w600),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ---------------- PRODUCT INFO ----------------
            _card(
              "Product Info",
              Column(
                children: [
                  TextField(
                    controller: controller.productName,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.stockQuantity,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stock Qty",
                      border: OutlineInputBorder(),
                    )) ],
              ),
            ),

            // ---------------- IMAGE ----------------
            _card(
              "Product Image",
              Obx(() => GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: controller.productImage.value == null
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40, color: Colors.grey),
                      SizedBox(height: 6),
                      Text("Tap to pick image"),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      controller.productImage.value!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
            ),

            // ---------------- CATEGORY ----------------
            _card(
              "Category",
              Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value,
                items: controller.categories
                    .map((c) =>
                    DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  controller.selectedCategory.value = v ?? "";
                  controller.attributes.clear();
                },
                decoration: const InputDecoration(
                  labelText: "Select Category",
                  border: OutlineInputBorder(),
                ),
              )),
            ),

            // ---------------- OFFER SECTION ----------------
            _card(
              "Offer Details",
              Obx(() => Column(
                children: [

                  DropdownButtonFormField<String>(
                    value: controller.selectedOfferType.value.isEmpty
                        ? null
                        : controller.selectedOfferType.value,
                    items: controller.offerTypes
                        .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      controller.selectedOfferType.value = v ?? "";
                      controller.discountValue.clear();
                      controller.buyQty.clear();
                      controller.getQty.clear();
                    },
                    decoration: const InputDecoration(
                      labelText: "Offer Type",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (controller.selectedOfferType.value ==
                      "Flat Discount" ||
                      controller.selectedOfferType.value ==
                          "Percentage Discount")
                    TextField(
                      controller: controller.discountValue,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: controller.selectedOfferType.value ==
                            "Flat Discount"
                            ? "Discount Amount"
                            : "Discount Percentage (%)",
                        border: const OutlineInputBorder(),
                      ),
                    ),

                  if (controller.selectedOfferType.value ==
                      "Buy 1 Get 1")
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.buyQty,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Buy Quantity",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: controller.getQty,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Get Quantity",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                  if (controller.selectedOfferType.value ==
                      "Free Shipping")
                    const Text(
                      "Free shipping will be applied",
                      style: TextStyle(color: Colors.green),
                    ),
                ],
              )),
            ),

            // ---------------- ATTRIBUTES ----------------
            _card(
              "Attributes (Max 10)",
              Obx(() {
                if (controller.selectedCategory.value.isEmpty) {
                  return const Text("Select category first");
                }

                final attrList = controller.categoryAttributes[
                controller.selectedCategory.value]!;

                return Column(
                  children: [
                    ...List.generate(controller.attributes.length, (i) {
                      final attr = controller.attributes[i];
                      final bool isOther = attr["isOther"];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: attr["selected"].isEmpty
                                          ? null
                                          : attr["selected"],
                                      items: attrList
                                          .map((e) =>
                                          DropdownMenuItem(
                                              value: e,
                                              child: Text(e)))
                                          .toList(),
                                      onChanged: (v) =>
                                          controller.onAttributeSelected(
                                              i, v),
                                      decoration:
                                      const InputDecoration(
                                        labelText: "Attribute",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        controller.removeAttribute(i),
                                  )
                                ],
                              ),

                              if (isOther) ...[
                                const SizedBox(height: 10),
                                TextField(
                                  controller: attr["name"],
                                  decoration: const InputDecoration(
                                    labelText: "Custom Attribute Name",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 10),

                              TextField(
                                controller: attr["value"],
                                decoration: const InputDecoration(
                                  labelText: "Value",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: controller.addAttribute,
                        icon: const Icon(Icons.add),
                        label: const Text("Add Attribute"),
                      ),
                    )
                  ],
                );
              }),
            ),

            // ---------------- FEATURES ----------------
            _card(
              "Features (Max 5)",
              Column(
                children: [
                  Obx(() => Column(
                    children: List.generate(
                      controller.features.length,
                          (i) => Padding(
                        padding:
                        const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller:
                                controller.features[i],
                                decoration:
                                const InputDecoration(
                                  labelText: "Feature",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.red),
                              onPressed: () =>
                                  controller.removeFeature(i),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: controller.addFeature,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Feature"),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- SUBMIT ----------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.submitOfferProduct,
                child: const Text("Submit Offer Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, Widget child) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
