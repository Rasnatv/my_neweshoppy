
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

  // ---------------- COMMON ATTRIBUTES ----------------
  var commonAttributes = <String, String>{}.obs;

  // ---------------- VARIANT TYPE SELECTION (DROPDOWN) ----------------
  // Currently selected variant type from dropdown (e.g., "Size", "Color")
  var selectedVariantType = ''.obs;

  // Track which variant type section is expanded
  var expandedVariantType = ''.obs;

  // Values for the currently selected variant type
  var currentVariantValues = <String>[].obs;

  // Text controller for adding variant values
  final TextEditingController variantValueController = TextEditingController();

  // Store all variant types and their values that have been configured
  var configuredVariantTypes = <String, List<String>>{}.obs;

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

    // Clear previous data
    selectedVariantType.value = '';
    expandedVariantType.value = '';
    currentVariantValues.clear();
    configuredVariantTypes.clear();
    commonAttributes.clear();
    variants.clear();
    variantValueController.clear();

    print("Category changed to: $category");
    final config = categoryConfigs[category];
    if (config != null) {
      print("Common attributes: ${config.commonAttributes}");
      print("Variant attributes: ${config.variantAttributes}");
    }
  }

  // Check if category has variant attributes
  bool hasVariantAttributes() {
    final config = categoryConfigs[selectedCategory.value];
    return config != null && config.variantAttributes.isNotEmpty;
  }

  // ---------------- COMMON ATTRIBUTE MANAGEMENT ----------------
  void setCommonAttribute(String attribute, String value) {
    commonAttributes[attribute] = value;
  }

  // ---------------- VARIANT TYPE SELECTION ----------------
  void onVariantTypeSelected(String variantType) {
    // Save current values before switching if there are any
    if (selectedVariantType.value.isNotEmpty && currentVariantValues.isNotEmpty) {
      configuredVariantTypes[selectedVariantType.value] = List.from(currentVariantValues);
    }

    selectedVariantType.value = variantType;

    // Load existing values if this type was configured before
    if (configuredVariantTypes.containsKey(variantType)) {
      currentVariantValues.value = List.from(configuredVariantTypes[variantType]!);
    } else {
      currentVariantValues.clear();
    }

    variantValueController.clear();

    // Refresh to show the loaded values
    currentVariantValues.refresh();
  }

  // Add a value to current variant type
  void addVariantValue(String value) {
    if (value.trim().isEmpty) return;

    if (selectedVariantType.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a variant type first",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ Split comma-separated values
    final List<String> values = value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    bool addedAny = false;

    for (final v in values) {
      if (!currentVariantValues.contains(v)) {
        currentVariantValues.add(v);
        addedAny = true;
      }
    }

    if (!addedAny) {
      Get.snackbar(
        "Duplicate",
        "Value already exists",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Save immediately
    configuredVariantTypes[selectedVariantType.value] =
        List.from(currentVariantValues);

    variantValueController.clear();
    currentVariantValues.refresh();
    configuredVariantTypes.refresh();
  }

  // Remove a value from current variant type
  void removeVariantValue(String value) {
    currentVariantValues.remove(value);

    // Immediately update configured types
    if (currentVariantValues.isEmpty) {
      configuredVariantTypes.remove(selectedVariantType.value);
    } else {
      configuredVariantTypes[selectedVariantType.value] = List.from(currentVariantValues);
    }

    currentVariantValues.refresh();
    configuredVariantTypes.refresh();
  }

  // Generate variants from the selected variant type
  void generateVariantsFromType() {
    if (configuredVariantTypes.isEmpty) {
      Get.snackbar(
        "Error",
        "Please configure at least one variant type with values",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Save current configuration if editing
    if (selectedVariantType.value.isNotEmpty && currentVariantValues.isNotEmpty) {
      configuredVariantTypes[selectedVariantType.value] = List.from(currentVariantValues);
    }

    // Generate new combinations based on all configured types
    List<Map<String, String>> newCombinations = _generateAllCombinations();

    // Check which combinations already exist
    List<Map<String, String>> combinationsToAdd = [];
    for (var combo in newCombinations) {
      bool exists = variants.any((variant) =>
          _areMapsEqual(variant.attributes, combo)
      );
      if (!exists) {
        combinationsToAdd.add(combo);
      }
    }

    // Add new variants
    for (var combo in combinationsToAdd) {
      variants.add(ProductVariant(
        attributes: combo,
        price: null,
        stock: null,
      ));
    }

    if (combinationsToAdd.isNotEmpty) {
      Get.snackbar(
        "Success",
        "${combinationsToAdd.length} new variant(s) added! Total: ${variants.length}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF10B981),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        "Info",
        "All variants already exist. No new variants added.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF3B82F6),
        colorText: Colors.white,
      );
    }

    // Close all sections after generation
    expandedVariantType.value = '';
  }

  // Helper function to compare two maps
  bool _areMapsEqual(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    for (var key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }

  // Generate all combinations from configured variant types
  List<Map<String, String>> _generateAllCombinations() {
    if (configuredVariantTypes.isEmpty) return [];

    List<String> types = configuredVariantTypes.keys.toList();
    List<List<String>> allValues = types.map((type) => configuredVariantTypes[type]!).toList();

    List<Map<String, String>> results = [];

    void generate(int index, Map<String, String> current) {
      if (index == types.length) {
        results.add(Map<String, String>.from(current));
        return;
      }

      for (var value in allValues[index]) {
        current[types[index]] = value;
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
          "Variant ${i + 1} (${variant.getDisplayName()}): Valid price is required",
        );
        return false;
      }

      if (variant.stock == null || variant.stock! < 0) {
        Get.snackbar(
          "Validation Error",
          "Variant ${i + 1} (${variant.getDisplayName()}): Valid stock quantity is required",
        );
        return false;
      }

      if (variant.imagePath == null) {
        Get.snackbar(
          "Validation Error",
          "Variant ${i + 1} (${variant.getDisplayName()}): Image is required",
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
  void clearVariantConfiguration() {
    selectedVariantType.value = '';
    expandedVariantType.value = '';
    currentVariantValues.clear();
    configuredVariantTypes.clear();
    variantValueController.clear();

    Get.snackbar(
      "Configuration Cleared",
      "Variant configuration has been reset. Your generated variants are safe.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF3B82F6),
      colorText: Colors.white,
    );
  }

  void _clearForm() {
    productName.value = '';
    selectedCategory.value = '';
    selectedCategoryId.value = 0;
    productDescription.value = '';
    variants.clear();
    selectedVariantType.value = '';
    expandedVariantType.value = '';
    currentVariantValues.clear();
    configuredVariantTypes.clear();
    commonAttributes.clear();
    variantValueController.clear();
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
    variantValueController.dispose();
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