
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProductController extends GetxController {
  // TEXT FIELDS
  final TextEditingController productName = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController price = TextEditingController();

  // STOCK (Dropdown)
  RxString stockStatus = "In Stock".obs;
  final List<String> stockOptions = ["In Stock", "Out of Stock"];

  // CATEGORY
  final TextEditingController categoryField = TextEditingController();
  final TextEditingController subCategoryField = TextEditingController();

  // CATEGORY MAP
  final Map<String, List<String>> categoryMap = {
    "Fashion & Apparel": ["Men Clothing", "Women Clothing", "Kids Clothing"],
    "Electronics": ["Mobiles", "Laptops", "Tablets"],
    "Home & Furniture": ["Furniture", "Home Decor", "Kitchen Appliances"],
    "Others": [],
  };

  List<String> get categories => categoryMap.keys.toList();
  List<String> getSubCategories(String c) => categoryMap[c] ?? [];

  void pickCategory(String v) {
    categoryField.text = v;
    subCategoryField.clear();
    update();
  }

  void pickSubCategory(String v) {
    subCategoryField.text = v;
    update();
  }

  // IMAGE (ONLY ONE)
  Rx<File?> productImage = Rx<File?>(null);

  Future<void> pickProductImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      productImage.value = File(image.path);
    }
  }

  // PRODUCT SPECIFICATIONS (5 FIXED)
  RxList<Map<String, dynamic>> specifications = <Map<String, dynamic>>[
    {"name": TextEditingController()},
    {"name": TextEditingController()},
    {"name": TextEditingController()},
    {"name": TextEditingController()},
    {"name": TextEditingController()},
  ].obs;
  final List<String> attributeList = ["Size","Color","Material","Brand","Weight","Capacity","Warranty","Model","Type","Other"];

  RxList<Map<String, dynamic>> attributes = <Map<String, dynamic>>[
    {"name": TextEditingController(), "value": TextEditingController(), "isCustom": false, "customName": TextEditingController()},
    {"name": TextEditingController(), "value": TextEditingController(), "isCustom": false, "customName": TextEditingController()},
    {"name": TextEditingController(), "value": TextEditingController(), "isCustom": false, "customName": TextEditingController()},
  ].obs;

  void selectAttributeName(int i, String value) {
    attributes[i]["name"].text = value;
    if(value=="Other"){
      attributes[i]["isCustom"]=true;
    } else {
      attributes[i]["isCustom"]=false;
      attributes[i]["customName"].clear();
    }
    attributes.refresh();
  }

  void deleteAttribute(int i){
    if(attributes.length>1){
      attributes.removeAt(i);
    } else {
      Get.snackbar("Warning", "At least one attribute is required");
    }
  }


  void saveProduct() {
    final data = {
      "name": productName.text,
      "description": description.text,
      "price": price.text,
      "stockStatus": stockStatus.value,
      "category": categoryField.text,
      "subcategory": subCategoryField.text,
      "image": productImage.value?.path ?? "",
      "specifications": specifications
          .map((e) => {"name": e["name"].text})
          .toList(),
      "attributes": attributes.map((e){
        return {
          "name": e["isCustom"] ? e["customName"].text : e["name"].text,
          "value": e["value"].text
        };
      }).toList()
    };

    print("UPDATED PRODUCT: $data");

    Get.snackbar("Success", "Product Updated Successfully",
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}

