
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddOfferProductController extends GetxController {
  // ---------------- BASIC ----------------
  final productName = TextEditingController();
  final price = TextEditingController();
  final TextEditingController stockQuantity = TextEditingController();

  // ---------------- FEATURES (MAX 5) ----------------
  RxList<TextEditingController> features = <TextEditingController>[].obs;

  void addFeature() {
    if (features.length >= 5) {
      Get.snackbar("Limit", "Maximum 5 features allowed");
      return;
    }
    features.add(TextEditingController());
  }

  void removeFeature(int i) {
    features[i].dispose();
    features.removeAt(i);
  }

  // ---------------- CATEGORY ----------------
  final List<String> categories = [
    "Fashion & Apparel",
    "Beauty & Personal Care",
    "Electronics",
    "Grocery & Essentials",
    "Bakery & Food",
    "Home Appliances",
    "Furniture",
    "Sports & Fitness",
    "Kids Products",
    "Pet Supplies",
    "Automobile & Accessories",
    "Medicine & Healthcare",
    "Home & Kitchen",
    "Tools & Hardware",
  ];

  RxString selectedCategory = "".obs;

  final Map<String, List<String>> categoryAttributes = {
    "Fashion & Apparel": ["Size", "Color", "Material", "Brand", "Fit", "Pattern", "Other"],
    "Beauty & Personal Care": ["Shade", "Skin Type", "Hair Type", "Ingredients", "Brand", "Volume", "Other"],
    "Electronics": ["Brand", "Model", "RAM", "Storage", "Battery", "Warranty", "Screen Size", "Other"],
    "Grocery & Essentials": ["Weight", "Brand", "Expiry Date", "Package Type", "Organic", "Other"],
    "Bakery & Food": ["Weight / Quantity", "Flavor / Type", "Ingredients", "Expiry Date", "Brand", "Allergen Info", "Packaging Type", "Other"],
    "Home Appliances": ["Brand", "Model", "Power", "Capacity", "Warranty", "Other"],
    "Furniture": ["Material", "Color", "Size", "Brand", "Weight", "Style", "Other"],
    "Sports & Fitness": ["Size", "Material", "Brand", "Weight", "Capacity", "Other"],
    "Kids Products": ["Age Group", "Material", "Brand", "Safety Info", "Other"],
    "Pet Supplies": ["Pet Type", "Weight", "Ingredients", "Age Group", "Brand", "Other"],
    "Automobile & Accessories": ["Vehicle Type", "Model", "Brand", "Year", "Part Type", "Other"],
    "Medicine & Healthcare": ["Medicine Type", "Dosage", "Expiry Date", "Composition", "Brand", "Other"],
    "Home & Kitchen": ["Material", "Brand", "Size", "Capacity", "Other"],
    "Tools & Hardware": ["Material", "Brand", "Size", "Power", "Other"],
  };

  // ---------------- OFFER ----------------
  final offerTypes = [
    "Flat Discount",
    "Percentage Discount",
    "Buy 1 Get 1",
    "Free Shipping",
  ];

  RxString selectedOfferType = "".obs;
  final discountValue = TextEditingController();
  final buyQty = TextEditingController();
  final getQty = TextEditingController();

  // ---------------- IMAGE ----------------
  final picker = ImagePicker();
  Rx<File?> productImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) productImage.value = File(x.path);
  }

  // ---------------- ATTRIBUTES (MAX 10) ----------------
  RxList<Map<String, dynamic>> attributes = <Map<String, dynamic>>[].obs;

  void addAttribute() {
    if (attributes.length >= 10) {
      Get.snackbar("Limit", "Maximum 10 attributes allowed");
      return;
    }

    attributes.add({
      "selected": "",
      "isOther": false,
      "name": TextEditingController(),
      "value": TextEditingController(),
    });
  }

  void removeAttribute(int index) {
    (attributes[index]["name"] as TextEditingController).dispose();
    (attributes[index]["value"] as TextEditingController).dispose();
    attributes.removeAt(index);
  }

  void onAttributeSelected(int index, String? value) {
    attributes[index]["selected"] = value ?? "";
    attributes[index]["isOther"] = value == "Other";
    attributes.refresh();
  }

  void submitOfferProduct() {
    if (productName.text.isEmpty ||
        price.text.isEmpty ||
        stockQuantity.text.isEmpty ||
        selectedCategory.value.isEmpty ||
        selectedOfferType.value.isEmpty ||
        productImage.value == null) {
      Get.snackbar("Error", "Fill all required fields");
      return;
    }

    final attrPayload = attributes.map((a) {
      final isOther = a["isOther"] as bool;
      return {
        "name": isOther
            ? (a["name"] as TextEditingController).text.trim()
            : a["selected"],
        "value": (a["value"] as TextEditingController).text.trim(),
      };
    }).toList();

    final payload = {
      "name": productName.text.trim(),
      "price": double.parse(price.text),
      "stock": int.parse(stockQuantity.text),
      "category": selectedCategory.value,
      "features": features.map((f) => f.text.trim()).toList(),
      "attributes": attrPayload,
      "offerType": selectedOfferType.value,
      "discountValue": discountValue.text,
      "buyQty": buyQty.text,
      "getQty": getQty.text,
      "image": productImage.value!.path,
    };

    debugPrint("OFFER PRODUCT => $payload");
    Get.snackbar("Success", "Offer Product Added Successfully");
  }}
