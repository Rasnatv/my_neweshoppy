
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';


class ProductController extends GetxController {
  final box = GetStorage();

  final String categoriesUrl =
      "https://eshoppy.co.in/api/merchant/categories";
  final String addProductUrl =
      "https://eshoppy.co.in/api/merchant/add-product";

  // ---------------- BASIC FIELDS ----------------
  var productName = ''.obs;
  var selectedCategory = ''.obs;
  var selectedCategoryId = 0.obs;
  var productDescription = ''.obs;


  // ← ADD THESE TWO LINES
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();

  var isLoadingCategories = false.obs;
  var isSubmitting = false.obs;

  // ---------------- CATEGORY DATA ----------------
  var apiCategories = <CategoryApiModel>[].obs;
  final Map<String, CategoryConfig> categoryConfigs = {};

  // ---------------- ATTRIBUTES ----------------
  var commonAttributes = <String, String>{}.obs;

  // ---------------- VARIANT TYPE SELECTION ----------------
  var selectedVariantType = ''.obs;
  var expandedVariantType = ''.obs;
  var currentVariantValues = <String>[].obs;
  final TextEditingController variantValueController = TextEditingController();
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

  // ---------------- FETCH CATEGORIES ----------------
  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;

      final token = box.read("auth_token");

      final response = await http.get(
        Uri.parse(categoriesUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          final List<dynamic> categoriesData = body['data'];
          apiCategories.clear();
          categoryConfigs.clear();

          for (var catData in categoriesData) {
            try {
              final int id = catData['id'] is int
                  ? catData['id']
                  : int.parse(catData['id'].toString());
              final String name = catData['name']?.toString() ?? '';
              final String image = catData['image']?.toString() ?? '';

              List<String> commonAttrs = [];
              List<String> variantAttrs = [];

              if (catData['attributes'] != null) {
                final attributes = catData['attributes'];
                if (attributes is Map) {
                  if (attributes['common'] is List) {
                    commonAttrs = List<String>.from(attributes['common']);
                  }
                  if (attributes['variant'] is List) {
                    variantAttrs = List<String>.from(attributes['variant']);
                  }
                } else if (attributes is List) {
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
              categoryConfigs[name] = CategoryConfig(
                id: id,
                commonAttributes: commonAttrs,
                variantAttributes: variantAttrs,
              );
            } catch (e) {
              debugPrint("Error parsing category: $e");
            }
          }
        } else {
          AppSnackbar.error(body['message'] ?? "Failed to fetch categories");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
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
          id: 0, name: '', image: '', commonAttributes: [], variantAttributes: []),
    );
    selectedCategoryId.value = cat.id;

    selectedVariantType.value = '';
    expandedVariantType.value = '';
    currentVariantValues.clear();
    configuredVariantTypes.clear();
    commonAttributes.clear();
    variants.clear();
    variantValueController.clear();
  }

  bool hasVariantAttributes() {
    final config = categoryConfigs[selectedCategory.value];
    return config != null && config.variantAttributes.isNotEmpty;
  }

  // ---------------- COMMON ATTRIBUTES ----------------
  void setCommonAttribute(String attribute, String value) {
    commonAttributes[attribute] = value;
  }

  // ---------------- VARIANT TYPE SELECTION ----------------
  void onVariantTypeSelected(String variantType) {
    if (selectedVariantType.value.isNotEmpty && currentVariantValues.isNotEmpty) {
      configuredVariantTypes[selectedVariantType.value] =
          List.from(currentVariantValues);
    }
    selectedVariantType.value = variantType;
    currentVariantValues.value = configuredVariantTypes.containsKey(variantType)
        ? List.from(configuredVariantTypes[variantType]!)
        : [];
    variantValueController.clear();
    currentVariantValues.refresh();
  }

  void addVariantValue(String value) {
    if (value.trim().isEmpty) return;

    if (selectedVariantType.value.isEmpty) {
      AppSnackbar.warning("Please select a variant type first");
      return;
    }

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
      AppSnackbar.warning("Value already exists");
      return;
    }

    configuredVariantTypes[selectedVariantType.value] =
        List.from(currentVariantValues);
    variantValueController.clear();
    currentVariantValues.refresh();
    configuredVariantTypes.refresh();
  }

  void removeVariantValue(String value) {
    currentVariantValues.remove(value);
    if (currentVariantValues.isEmpty) {
      configuredVariantTypes.remove(selectedVariantType.value);
    } else {
      configuredVariantTypes[selectedVariantType.value] =
          List.from(currentVariantValues);
    }
    currentVariantValues.refresh();
    configuredVariantTypes.refresh();
  }

  void generateVariantsFromType() {
    if (configuredVariantTypes.isEmpty) {
      AppSnackbar.warning(
          "Please configure at least one variant type with values");
      return;
    }

    if (selectedVariantType.value.isNotEmpty &&
        currentVariantValues.isNotEmpty) {
      configuredVariantTypes[selectedVariantType.value] =
          List.from(currentVariantValues);
    }

    List<Map<String, String>> newCombinations = _generateAllCombinations();
    List<Map<String, String>> combinationsToAdd = newCombinations
        .where((combo) =>
    !variants.any((v) => _areMapsEqual(v.attributes, combo)))
        .toList();

    for (var combo in combinationsToAdd) {
      variants.add(ProductVariant(attributes: combo));
    }

    if (combinationsToAdd.isNotEmpty) {
      AppSnackbar.success(
          "${combinationsToAdd.length} new variant(s) added! Total: ${variants.length}");
    } else {
      AppSnackbar.warning(
          "All variants already exist. No new variants added.");
    }

    expandedVariantType.value = '';
  }

  bool _areMapsEqual(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    for (var key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }

  List<Map<String, String>> _generateAllCombinations() {
    if (configuredVariantTypes.isEmpty) return [];
    List<String> types = configuredVariantTypes.keys.toList();
    List<List<String>> allValues =
    types.map((t) => configuredVariantTypes[t]!).toList();
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
      variants[index].dispose();
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

  // ---------------- VALIDATION (only name, image, price mandatory) ----------------
  bool validateForm() {
    if (productName.value.trim().isEmpty) {
      AppSnackbar.warning("Product name is required");
      return false;
    }

    if (variants.isEmpty) {
      AppSnackbar.warning("At least one variant is required");
      return false;
    }

    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];
      final label = "Variant ${i + 1} (${variant.getDisplayName()})";

      if (variant.price == null || variant.price! <= 0) {
        AppSnackbar.warning("$label: Valid price is required");
        return false;
      }

      if (variant.imagePath == null) {
        AppSnackbar.warning("$label: Image is required");
        return false;
      }
    }

    return true;
  }

  // ---------------- PRODUCT SUBMISSION ----------------
  Future<void> saveProduct() async {
    if (!validateForm()) return;

    try {
      isSubmitting.value = true;

      final token = box.read("auth_token");
      if (token == null) {
        AppSnackbar.error("Authentication token not found");
        return;
      }

      List<Map<String, dynamic>> variantsData = [];

      for (var variant in variants) {
        String? imageBase64;
        if (variant.imagePath != null) {
          final bytes = await File(variant.imagePath!).readAsBytes();
          final ext = variant.imagePath!.split('.').last.toLowerCase();
          final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
          imageBase64 = "data:$mimeType;base64,${base64Encode(bytes)}";
        }

        variantsData.add({
          "attributes": variant.attributes,
          "price": variant.price,
          "stock": variant.stock,
          "image": imageBase64,
        });
      }

      final requestBody = {
        "name": productName.value.trim(),
        "description": productDescription.value.trim(),
        "category_id": selectedCategoryId.value,
        "common_attributes": commonAttributes,
        "variants": variantsData,
      };

      final response = await http.post(
        Uri.parse(addProductUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201 || body['status'] == true) {
        AppSnackbar.success(body['message'] ?? "Product added successfully");
        _clearForm();
        Get.back();
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isSubmitting.value = false;
    }
  }

  // ---------------- CLEAR / RESET ----------------
  void clearVariantConfiguration() {
    selectedVariantType.value = '';
    expandedVariantType.value = '';
    currentVariantValues.clear();
    configuredVariantTypes.clear();
    variantValueController.clear();
    AppSnackbar.success("Variant configuration has been reset.");
  }

  void _clearForm() {
    productName.value = '';
    selectedCategory.value = '';
    selectedCategoryId.value = 0;
    productDescription.value = '';
    for (final v in variants) v.dispose();
    variants.clear();
    selectedVariantType.value = '';
    expandedVariantType.value = '';
    currentVariantValues.clear();
    configuredVariantTypes.clear();
    commonAttributes.clear();
    variantValueController.clear();
    productNameController.clear();       // ← ADD
    productDescriptionController.clear(); // ← ADD
  }

  void resetForm() {
    Get.dialog(
      AlertDialog(
        title: const Text("Reset Form"),
        content: const Text(
            "Are you sure you want to reset? All unsaved changes will be lost."),
        actions: [
          TextButton(
              onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              _clearForm();
              Get.back();
              AppSnackbar.success("All fields have been cleared");
            },
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    variantValueController.dispose();
    productNameController.dispose();       // ← ADD
    productDescriptionController.dispose(); //
    super.onClose();
  }
}

// ---------------- MODELS ----------------

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
}

class ProductVariant {
  Map<String, String> attributes;
  double? price;
  int? stock;
  String? imagePath;

  late final TextEditingController priceController;
  late final TextEditingController stockController;

  ProductVariant({
    required this.attributes,
    this.price,
    this.stock,
    this.imagePath,
  }) {
    priceController = TextEditingController(
        text: price != null ? price.toString() : '');
    stockController = TextEditingController(
        text: stock != null ? stock.toString() : '');
  }

  void dispose() {
    priceController.dispose();
    stockController.dispose();
  }

  String getDisplayName() {
    if (attributes.isEmpty) return "Variant";
    return attributes.values.join(" - ");
  }
}