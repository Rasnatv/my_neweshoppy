

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  final box = GetStorage();

  // API URLs
  final String categoriesUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/categories";
  final String addProductUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/add-product";

  // ---------------- BASIC FIELDS ----------------
  var productName = ''.obs;
  var selectedCategory = ''.obs;
  var selectedCategoryId = 0.obs;
  var productDescription = ''.obs;

  // Loading states
  var isLoadingCategories = false.obs;
  var isSubmitting = false.obs;

  // ---------------- CATEGORY DATA FROM API ----------------
  var apiCategories = <CategoryApiModel>[].obs;

  // ---------------- CATEGORY CONFIGURATION ----------------
  final Map<String, CategoryConfig> categoryConfigs = {};

  // ---------------- COMMON & VARIANT ATTRIBUTES ----------------
  var commonAttributes = <String, String>{}.obs;
  var variantAttributeValues = <String, List<String>>{}.obs;

  // ---------------- VARIANTS ----------------
  var variants = <ProductVariant>[].obs;

  // ---------------- IMAGE PICKER ----------------
  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // ---------------- FETCH CATEGORIES FROM API ----------------
  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;

      final token = box.read("auth_token");
      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      print("Fetching categories...");
      print("Token: $token");

      final response = await http.get(
        Uri.parse(categoriesUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          final List<dynamic> categoriesData = body['data'];

          apiCategories.clear();
          categoryConfigs.clear();

          for (var catData in categoriesData) {
            try {
              // Parse category carefully
              final int id = catData['id'] is int
                  ? catData['id']
                  : int.parse(catData['id'].toString());

              final String name = catData['name']?.toString() ?? '';
              final String image = catData['image']?.toString() ?? '';

              // Parse attributes - handle both Map and List cases
              List<String> commonAttrs = [];
              List<String> variantAttrs = [];

              if (catData['attributes'] != null) {
                final attributes = catData['attributes'];

                print("Category: $name");
                print("Attributes type: ${attributes.runtimeType}");
                print("Attributes value: $attributes");

                if (attributes is Map) {
                  // If it's a map with 'common' and 'variant' keys
                  if (attributes['common'] != null) {
                    if (attributes['common'] is List) {
                      commonAttrs = List<String>.from(attributes['common']);
                    }
                  }

                  if (attributes['variant'] != null) {
                    if (attributes['variant'] is List) {
                      variantAttrs = List<String>.from(attributes['variant']);
                    }
                  }
                } else if (attributes is List) {
                  // If it's just a list, treat them as variant attributes
                  variantAttrs = List<String>.from(attributes);
                }
              }

              final category = CategoryApiModel(
                id: id,
                name: name,
                image: image,
                commonAttributes: commonAttrs,
                variantAttributes: variantAttrs,
              );

              apiCategories.add(category);

              // Build category config
              categoryConfigs[name] = CategoryConfig(
                id: id,
                commonAttributes: commonAttrs,
                variantAttributes: variantAttrs,
              );

              print("✓ Loaded: $name (Common: ${commonAttrs.length}, Variant: ${variantAttrs.length})");

            } catch (e) {
              print("Error parsing category: $e");
              print("Category data: $catData");
            }
          }

          print("✓ Total categories loaded: ${apiCategories.length}");

          // Get.snackbar(
          //   "Success",
          //   "${apiCategories.length} categories loaded",
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          //   snackPosition: SnackPosition.BOTTOM,
          // );

        } else {
          Get.snackbar("Error", body['message'] ?? "Failed to fetch categories");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch categories: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch categories: $e");
      print("❌ Error fetching categories: $e");
      print("Stack trace: ${StackTrace.current}");
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ---------------- CATEGORY CHANGE ----------------
  void onCategoryChanged(String category) {
    selectedCategory.value = category;

    final cat = apiCategories.firstWhere(
          (c) => c.name == category,
      orElse: () => CategoryApiModel(
        id: 0,
        name: '',
        image: '',
        commonAttributes: [],
        variantAttributes: [],
      ),
    );
    selectedCategoryId.value = cat.id;

    variantAttributeValues.clear();
    commonAttributes.clear();
    variants.clear();

    // Initialize variant attribute values
    final config = categoryConfigs[category];
    if (config != null) {
      for (var attr in config.variantAttributes) {
        variantAttributeValues[attr] = [];
      }

      print("Category changed to: $category");
      print("Common attributes: ${config.commonAttributes}");
      print("Variant attributes: ${config.variantAttributes}");
    }
  }

  // ---------------- COMMON ATTRIBUTE MANAGEMENT ----------------
  void setCommonAttribute(String attribute, String value) {
    commonAttributes[attribute] = value;
  }

  // ---------------- VARIANT ATTRIBUTE VALUE MANAGEMENT ----------------
  void addAttributeValue(String attribute, String value) {
    if (value.trim().isEmpty) return;

    if (!variantAttributeValues.containsKey(attribute)) {
      variantAttributeValues[attribute] = [];
    }

    if (!variantAttributeValues[attribute]!.contains(value.trim())) {
      variantAttributeValues[attribute]!.add(value.trim());
      variantAttributeValues.refresh();
    }
  }

  void removeAttributeValue(String attribute, String value) {
    if (variantAttributeValues.containsKey(attribute)) {
      variantAttributeValues[attribute]!.remove(value);
      variantAttributeValues.refresh();
    }
  }

  // ---------------- VARIANT GENERATION ----------------
  void generateVariants() {
    if (selectedCategory.value.isEmpty) {
      Get.snackbar(
        "Category Required",
        "Please select a category first",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final config = categoryConfigs[selectedCategory.value];
    if (config == null) return;

    // Check if at least one variant attribute has values
    bool hasVariantValues = false;
    for (var attr in config.variantAttributes) {
      if (variantAttributeValues[attr]?.isNotEmpty ?? false) {
        hasVariantValues = true;
        break;
      }
    }

    if (!hasVariantValues) {
      Get.snackbar(
        "No Variant Attributes",
        "Please add at least one value for variant attributes",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Generate all combinations
    List<Map<String, String>> combinations = _generateCombinations(config.variantAttributes);

    // Create variants from combinations
    variants.clear();
    for (var combo in combinations) {
      variants.add(ProductVariant(
        attributes: combo,
        price: null,
        stock: null,
      ));
    }

    Get.snackbar(
      "Variants Generated",
      "${variants.length} variant(s) created",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  List<Map<String, String>> _generateCombinations(List<String> attributes) {
    List<Map<String, String>> results = [];

    List<String> activeAttrs = [];
    List<List<String>> activeValues = [];

    for (var attr in attributes) {
      if (variantAttributeValues[attr]?.isNotEmpty ?? false) {
        activeAttrs.add(attr);
        activeValues.add(variantAttributeValues[attr]!);
      }
    }

    if (activeAttrs.isEmpty) return results;

    void generate(int index, Map<String, String> current) {
      if (index == activeAttrs.length) {
        results.add(Map<String, String>.from(current));
        return;
      }

      for (var value in activeValues[index]) {
        current[activeAttrs[index]] = value;
        generate(index + 1, current);
      }
    }

    generate(0, {});
    return results;
  }

  // ---------------- MANUAL VARIANT OPERATIONS ----------------
  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants.removeAt(index);
    }
  }

  void duplicateVariant(int index) {
    if (index >= 0 && index < variants.length) {
      final original = variants[index];
      final duplicate = ProductVariant(
        price: original.price,
        stock: original.stock,
        imagePath: original.imagePath,
        attributes: Map<String, String>.from(original.attributes),
      );
      variants.insert(index + 1, duplicate);
      Get.snackbar(
        "Variant Duplicated",
        "A copy has been created",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ---------------- IMAGE OPERATIONS ----------------
  Future<void> pickImage(int index) async {
    if (index < 0 || index >= variants.length) return;

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      variants[index].imagePath = pickedFile.path;
      variants.refresh();
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < variants.length) {
      variants[index].imagePath = null;
      variants.refresh();
    }
  }

  // ---------------- VALIDATION ----------------
  bool validateForm() {
    if (productName.value.trim().isEmpty) {
      Get.snackbar("Validation Error", "Product name is required");
      return false;
    }

    if (selectedCategory.value.isEmpty) {
      Get.snackbar("Validation Error", "Category is required");
      return false;
    }

    if (productDescription.value.trim().isEmpty) {
      Get.snackbar("Validation Error", "Product description is required");
      return false;
    }

    // Validate common attributes
    final config = categoryConfigs[selectedCategory.value];
    if (config != null) {
      for (var attr in config.commonAttributes) {
        if (commonAttributes[attr]?.trim().isEmpty ?? true) {
          Get.snackbar("Validation Error", "$attr is required");
          return false;
        }
      }
    }

    if (variants.isEmpty) {
      Get.snackbar("Validation Error", "At least one variant is required");
      return false;
    }

    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];

      if (variant.price == null || variant.price! <= 0) {
        Get.snackbar(
          "Validation Error",
          "Variant ${i + 1}: Valid price is required",
        );
        return false;
      }

      if (variant.stock == null || variant.stock! < 0) {
        Get.snackbar(
          "Validation Error",
          "Variant ${i + 1}: Valid stock quantity is required",
        );
        return false;
      }

      if (variant.imagePath == null) {
        Get.snackbar(
          "Validation Error",
          "Variant ${i + 1}: Image is required",
        );
        return false;
      }
    }

    return true;
  }

  // ---------------- PRODUCT SUBMISSION TO API ----------------
  Future<void> saveProduct() async {
    if (!validateForm()) return;

    try {
      isSubmitting.value = true;

      final token = box.read("auth_token");
      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      // Build variants data for API
      List<Map<String, dynamic>> variantsData = [];

      for (var variant in variants) {
        // Convert image to base64 if exists
        String? imageBase64;
        if (variant.imagePath != null) {
          final bytes = await File(variant.imagePath!).readAsBytes();
          final extension = variant.imagePath!.split('.').last.toLowerCase();
          String mimeType = 'image/jpeg';

          if (extension == 'png') {
            mimeType = 'image/png';
          } else if (extension == 'jpg' || extension == 'jpeg') {
            mimeType = 'image/jpeg';
          }

          imageBase64 = "data:$mimeType;base64,${base64Encode(bytes)}";
        }

        variantsData.add({
          "attributes": variant.attributes,
          "price": variant.price,
          "stock": variant.stock,
          "image": imageBase64,
        });
      }

      // Build request body
      final requestBody = {
        "name": productName.value.trim(),
        "description": productDescription.value.trim(),
        "category_id": selectedCategoryId.value,
        "common_attributes": commonAttributes,
        "variants": variantsData,
      };

      print("Request body: ${jsonEncode(requestBody)}");

      // Make API call
      final response = await http.post(
        Uri.parse(addProductUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 201 || body['status'] == true) {
        Get.snackbar(
          "Success",
          body['message'] ?? "Product added successfully",
          backgroundColor: Color(0xFF10B981),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // Clear form after successful submission
        _clearForm();

        // Navigate back or to product list
        Get.back();
      } else {
        Get.snackbar(
          "Error",
          body['message'] ?? "Failed to add product",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error saving product: $e");
      Get.snackbar(
        "Error",
        "Failed to save product: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // ---------------- CLEAR & RESET ----------------
  void _clearForm() {
    productName.value = '';
    selectedCategory.value = '';
    selectedCategoryId.value = 0;
    productDescription.value = '';
    variants.clear();
    variantAttributeValues.clear();
    commonAttributes.clear();
  }

  void resetForm() {
    Get.dialog(
      AlertDialog(
        title: Text("Reset Form"),
        content: Text("Are you sure you want to reset? All unsaved changes will be lost."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _clearForm();
              Get.back();
              Get.snackbar(
                "Form Reset",
                "All fields have been cleared",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Reset"),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}

// ---------------- MODELS ----------------

// Category configuration class
class CategoryConfig {
  final int id;
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  CategoryConfig({
    required this.id,
    required this.commonAttributes,
    required this.variantAttributes,
  });
}

// Category API Model with safe parsing
class CategoryApiModel {
  final int id;
  final String name;
  final String image;
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  CategoryApiModel({
    required this.id,
    required this.name,
    required this.image,
    required this.commonAttributes,
    required this.variantAttributes,
  });

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    // Safe parsing with detailed error handling
    try {
      final int id = json['id'] is int
          ? json['id']
          : int.parse(json['id'].toString());

      final String name = json['name']?.toString() ?? '';
      final String image = json['image']?.toString() ?? '';

      List<String> commonAttrs = [];
      List<String> variantAttrs = [];

      // Handle attributes field safely
      if (json['attributes'] != null) {
        final attributes = json['attributes'];

        if (attributes is Map) {
          // Case 1: {"common": [...], "variant": [...]}
          if (attributes['common'] != null && attributes['common'] is List) {
            commonAttrs = List<String>.from(attributes['common']);
          }

          if (attributes['variant'] != null && attributes['variant'] is List) {
            variantAttrs = List<String>.from(attributes['variant']);
          }
        } else if (attributes is List) {
          // Case 2: Just a list of attributes (treat as variant)
          variantAttrs = List<String>.from(attributes);
        }
      }

      return CategoryApiModel(
        id: id,
        name: name,
        image: image,
        commonAttributes: commonAttrs,
        variantAttributes: variantAttrs,
      );
    } catch (e) {
      print("Error in CategoryApiModel.fromJson: $e");
      print("JSON data: $json");
      rethrow;
    }
  }
}

// Product Variant Model
class ProductVariant {
  Map<String, String> attributes;
  double? price;
  int? stock;
  String? imagePath;

  ProductVariant({
    required this.attributes,
    this.price,
    this.stock,
    this.imagePath,
  });

  String getDisplayName() {
    if (attributes.isEmpty) return "Variant";
    return attributes.values.join(" - ");
  }
}