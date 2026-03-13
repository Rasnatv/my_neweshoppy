//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
//
// class AddOfferProductController extends GetxController {
//   final box = GetStorage();
//
//   final int offerId;
//   final double discountPercentage;
//
//   AddOfferProductController({
//     required this.offerId,
//     required this.discountPercentage,
//   });
//
//   // ── API URLs ──────────────────────────────────────────────────────────────
//   final String categoriesUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/categories";
//   final String addOfferProductUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/offers/add-products";
//
//   // ── Basic fields ──────────────────────────────────────────────────────────
//   var productName = ''.obs;
//   var selectedCategory = ''.obs;
//   var selectedCategoryId = 0.obs;
//   var productDescription = ''.obs;
//
//   // ── Loading states ────────────────────────────────────────────────────────
//   var isLoadingCategories = false.obs;
//   var isSubmitting = false.obs;
//
//   /// Total products successfully added to this offer so far.
//   var totalProductsAdded = 0.obs;
//
//   // ── Category data ─────────────────────────────────────────────────────────
//   var apiCategories = <CategoryApiModel>[].obs;
//   final Map<String, CategoryConfig> categoryConfigs = {};
//
//   // ── Common attributes ─────────────────────────────────────────────────────
//   var commonAttributes = <String, String>{}.obs;
//
//   // ── Variant type selection ────────────────────────────────────────────────
//   var selectedVariantType = ''.obs;
//   var expandedVariantType = ''.obs;
//   var currentVariantValues = <String>[].obs;
//   final TextEditingController variantValueController = TextEditingController();
//   var configuredVariantTypes = <String, List<String>>{}.obs;
//
//   // ── Variants ──────────────────────────────────────────────────────────────
//   var variants = <OfferProductVariant>[].obs;
//
//   // ── Image picker ──────────────────────────────────────────────────────────
//   final ImagePicker picker = ImagePicker();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategories();
//   }
//
//   // ── Fetch categories ──────────────────────────────────────────────────────
//   Future<void> fetchCategories() async {
//     try {
//       isLoadingCategories.value = true;
//
//       final token = box.read("auth_token");
//       if (token == null) {
//         Get.snackbar("Error", "Authentication token not found");
//         return;
//       }
//
//       final response = await http.get(
//         Uri.parse(categoriesUrl),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//
//         if (_isSuccess(body['status'])) {
//           final List<dynamic> categoriesData = body['data'] ?? [];
//
//           apiCategories.clear();
//           categoryConfigs.clear();
//
//           for (var catData in categoriesData) {
//             try {
//               final int id = _parseInt(catData['id']);
//               final String name = catData['name']?.toString() ?? '';
//               final String image = catData['image']?.toString() ?? '';
//
//               List<String> commonAttrs = [];
//               List<String> variantAttrs = [];
//
//               if (catData['attributes'] != null) {
//                 final attributes = catData['attributes'];
//                 if (attributes is Map) {
//                   if (attributes['common'] is List) {
//                     commonAttrs = List<String>.from(attributes['common']);
//                   }
//                   if (attributes['variant'] is List) {
//                     variantAttrs = List<String>.from(attributes['variant']);
//                   }
//                 } else if (attributes is List) {
//                   variantAttrs = List<String>.from(attributes);
//                 }
//               }
//
//               final category = CategoryApiModel(
//                 id: id,
//                 name: name,
//                 image: image,
//                 commonAttributes: commonAttrs,
//                 variantAttributes: variantAttrs,
//               );
//
//               apiCategories.add(category);
//               categoryConfigs[name] = CategoryConfig(
//                 id: id,
//                 commonAttributes: commonAttrs,
//                 variantAttributes: variantAttrs,
//               );
//             } catch (e) {
//               debugPrint("Error parsing category: $e");
//             }
//           }
//         } else {
//           Get.snackbar("Error", body['message'] ?? "Failed to fetch categories");
//         }
//       } else {
//         Get.snackbar("Error", "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to fetch categories: $e");
//       debugPrint("fetchCategories error: $e");
//     } finally {
//       isLoadingCategories.value = false;
//     }
//   }
//
//   // ── Category change ───────────────────────────────────────────────────────
//   void onCategoryChanged(String category) {
//     selectedCategory.value = category;
//
//     final cat = apiCategories.firstWhere(
//           (c) => c.name == category,
//       orElse: () => CategoryApiModel(
//           id: 0, name: '', image: '', commonAttributes: [], variantAttributes: []),
//     );
//     selectedCategoryId.value = cat.id;
//
//     // Reset everything
//     selectedVariantType.value = '';
//     expandedVariantType.value = '';
//     currentVariantValues.clear();
//     configuredVariantTypes.clear();
//     commonAttributes.clear();
//     variants.clear();
//     variantValueController.clear();
//   }
//
//   bool hasVariantAttributes() {
//     final config = categoryConfigs[selectedCategory.value];
//     return config != null && config.variantAttributes.isNotEmpty;
//   }
//
//   // ── Common attribute management ───────────────────────────────────────────
//   void setCommonAttribute(String attribute, String value) {
//     commonAttributes[attribute] = value;
//   }
//
//   // ── Variant type selection ────────────────────────────────────────────────
//   void onVariantTypeSelected(String variantType) {
//     if (selectedVariantType.value.isNotEmpty && currentVariantValues.isNotEmpty) {
//       configuredVariantTypes[selectedVariantType.value] =
//           List.from(currentVariantValues);
//     }
//
//     selectedVariantType.value = variantType;
//
//     currentVariantValues.value =
//         List.from(configuredVariantTypes[variantType] ?? []);
//
//     variantValueController.clear();
//     currentVariantValues.refresh();
//   }
//
//   void addVariantValue(String value) {
//     if (value.trim().isEmpty) return;
//
//     if (selectedVariantType.value.isEmpty) {
//       Get.snackbar("Error", "Please select a variant type first",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     final List<String> values = value
//         .split(',')
//         .map((e) => e.trim())
//         .where((e) => e.isNotEmpty)
//         .toSet()
//         .toList();
//
//     bool addedAny = false;
//     for (final v in values) {
//       if (!currentVariantValues.contains(v)) {
//         currentVariantValues.add(v);
//         addedAny = true;
//       }
//     }
//
//     if (!addedAny) {
//       Get.snackbar("Duplicate", "Value already exists",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     configuredVariantTypes[selectedVariantType.value] =
//         List.from(currentVariantValues);
//
//     variantValueController.clear();
//     currentVariantValues.refresh();
//     configuredVariantTypes.refresh();
//   }
//
//   void removeVariantValue(String value) {
//     currentVariantValues.remove(value);
//
//     if (currentVariantValues.isEmpty) {
//       configuredVariantTypes.remove(selectedVariantType.value);
//     } else {
//       configuredVariantTypes[selectedVariantType.value] =
//           List.from(currentVariantValues);
//     }
//
//     currentVariantValues.refresh();
//     configuredVariantTypes.refresh();
//   }
//
//   void generateVariantsFromType() {
//     if (configuredVariantTypes.isEmpty) {
//       Get.snackbar("Error", "Please configure at least one variant type with values",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     // Save current editing state
//     if (selectedVariantType.value.isNotEmpty && currentVariantValues.isNotEmpty) {
//       configuredVariantTypes[selectedVariantType.value] =
//           List.from(currentVariantValues);
//     }
//
//     final newCombinations = _generateAllCombinations();
//
//     final combinationsToAdd = newCombinations
//         .where((combo) =>
//     !variants.any((v) => _areMapsEqual(v.attributes, combo)))
//         .toList();
//
//     for (var combo in combinationsToAdd) {
//       variants.add(OfferProductVariant(attributes: combo));
//     }
//
//     if (combinationsToAdd.isNotEmpty) {
//       Get.snackbar(
//         "Success",
//         "${combinationsToAdd.length} variant(s) added! Total: ${variants.length}",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: const Color(0xFF10B981),
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } else {
//       Get.snackbar("Info", "All variants already exist.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: const Color(0xFF3B82F6),
//           colorText: Colors.white);
//     }
//
//     expandedVariantType.value = '';
//   }
//
//   bool _areMapsEqual(Map<String, String> a, Map<String, String> b) {
//     if (a.length != b.length) return false;
//     for (final k in a.keys) {
//       if (a[k] != b[k]) return false;
//     }
//     return true;
//   }
//
//   List<Map<String, String>> _generateAllCombinations() {
//     if (configuredVariantTypes.isEmpty) return [];
//
//     final types = configuredVariantTypes.keys.toList();
//     final allValues = types.map((t) => configuredVariantTypes[t]!).toList();
//     final results = <Map<String, String>>[];
//
//     void generate(int index, Map<String, String> current) {
//       if (index == types.length) {
//         results.add(Map<String, String>.from(current));
//         return;
//       }
//       for (final value in allValues[index]) {
//         current[types[index]] = value;
//         generate(index + 1, current);
//       }
//     }
//
//     generate(0, {});
//     return results;
//   }
//
//   // ── Variant / image operations ────────────────────────────────────────────
//   void removeVariant(int index) {
//     if (index >= 0 && index < variants.length) {
//       variants.removeAt(index);
//     }
//   }
//
//   Future<void> pickImage(int index) async {
//     if (index < 0 || index >= variants.length) return;
//
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 1920,
//       maxHeight: 1920,
//       imageQuality: 85,
//     );
//
//     if (pickedFile != null) {
//       variants[index].imagePath = pickedFile.path;
//       variants.refresh();
//     }
//   }
//
//   void removeImage(int index) {
//     if (index >= 0 && index < variants.length) {
//       variants[index].imagePath = null;
//       variants.refresh();
//     }
//   }
//
//   // ── Offer price calculation ───────────────────────────────────────────────
//   double? computeOfferPrice(double originalPrice) {
//     if (originalPrice <= 0) return null;
//     return originalPrice - (originalPrice * discountPercentage / 100);
//   }
//
//   // ── Validation ────────────────────────────────────────────────────────────
//   bool validateForm() {
//     if (productName.value.trim().isEmpty) {
//       Get.snackbar("Validation Error", "Product name is required");
//       return false;
//     }
//
//     if (selectedCategory.value.isEmpty) {
//       Get.snackbar("Validation Error", "Category is required");
//       return false;
//     }
//
//     final config = categoryConfigs[selectedCategory.value];
//     if (config != null) {
//       for (final attr in config.commonAttributes) {
//         if (commonAttributes[attr]?.trim().isEmpty ?? true) {
//           Get.snackbar("Validation Error", "$attr is required");
//           return false;
//         }
//       }
//     }
//
//     if (variants.isEmpty) {
//       Get.snackbar("Validation Error", "At least one variant is required");
//       return false;
//     }
//
//     for (int i = 0; i < variants.length; i++) {
//       final variant = variants[i];
//       final label = "Variant ${i + 1} (${variant.getDisplayName()})";
//
//       if (variant.price == null || variant.price! <= 0) {
//         Get.snackbar("Validation Error", "$label: Valid price is required");
//         return false;
//       }
//       if (variant.stock == null || variant.stock! < 0) {
//         Get.snackbar("Validation Error", "$label: Valid stock is required");
//         return false;
//       }
//       if (variant.imagePath == null) {
//         Get.snackbar("Validation Error", "$label: Image is required");
//         return false;
//       }
//     }
//
//     if (totalProductsAdded.value >= 10) {
//       Get.snackbar("Error", "Maximum 10 products limit reached!");
//       return false;
//     }
//
//     return true;
//   }
//
//   // ── Save offer product ────────────────────────────────────────────────────
//   /// Builds the request exactly as the API expects:
//   ///
//   /// POST /api/offers/add-products
//   /// {
//   ///   "offer_id": 1,
//   ///   "products": [
//   ///     {
//   ///       "product_name": "...",
//   ///       "category_id": 19,
//   ///       "description": "...",          // optional
//   ///       "common_attributes": { ... },
//   ///       "variants": [
//   ///         {
//   ///           "attributes": { "color": "Red", "size": "M" },
//   ///           "price": 1000,
//   ///           "stock": 10,
//   ///           "image": "data:image/jpeg;base64,..."
//   ///         }
//   ///       ]
//   ///     }
//   ///   ]
//   /// }
//   Future<void> saveOfferProduct() async {
//     if (!validateForm()) return;
//
//     try {
//       isSubmitting.value = true;
//
//       final token = box.read("auth_token");
//       if (token == null) {
//         Get.snackbar("Error", "Authentication token not found");
//         return;
//       }
//
//       // Build variants list — image is INSIDE each variant object
//       final List<Map<String, dynamic>> variantsData = [];
//
//       for (final variant in variants) {
//         // Convert image file → base64 data URI
//         String? imageBase64;
//         if (variant.imagePath != null) {
//           final bytes = await File(variant.imagePath!).readAsBytes();
//           final ext = variant.imagePath!.split('.').last.toLowerCase();
//           final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
//           imageBase64 = "data:$mime;base64,${base64Encode(bytes)}";
//         }
//
//         variantsData.add({
//           "attributes": variant.attributes,        // e.g. { "color": "Red", "size": "M" }
//           "price": variant.price,                  // original price (int/double)
//           "stock": variant.stock,                  // quantity
//           "image": imageBase64,                    // data URI string
//         });
//       }
//
//       // Single product entry inside the products array
//       final Map<String, dynamic> productEntry = {
//         "product_name": productName.value.trim(),
//         "category_id": selectedCategoryId.value,
//         "common_attributes": Map<String, String>.from(commonAttributes),
//         "variants": variantsData,
//       };
//
//       // description is optional — only include if provided
//       if (productDescription.value.trim().isNotEmpty) {
//         productEntry["description"] = productDescription.value.trim();
//       }
//
//       final requestBody = {
//         "offer_id": offerId,
//         "products": [productEntry],
//       };
//
//       debugPrint("➡️ POST $addOfferProductUrl");
//       debugPrint("Request body: ${jsonEncode(requestBody)}");
//
//       final response = await http.post(
//         Uri.parse(addOfferProductUrl),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       debugPrint("⬅️ Status: ${response.statusCode}");
//       debugPrint("Response: ${response.body}");
//
//       final body = jsonDecode(response.body) as Map<String, dynamic>;
//
//       // API returns: { "status": 1, "message": "...", "data": [...] }
//       final isOk = response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           _isSuccess(body['status']);
//
//       if (isOk) {
//         // Count how many products were actually saved from the response
//         final List<dynamic> savedProducts =
//             (body['data'] as List<dynamic>?) ?? [];
//
//         // Increment by the number of products returned (usually 1 per call)
//         totalProductsAdded.value += savedProducts.isNotEmpty
//             ? savedProducts.length
//             : 1;
//
//         Get.snackbar(
//           "✅ Success",
//           body['message'] ?? "Product added to offer successfully!",
//           backgroundColor: const Color(0xFF10B981),
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//         );
//
//         _clearForm();
//       } else {
//         Get.snackbar(
//           "Error",
//           body['message'] ?? "Failed to add product to offer",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e, stack) {
//       debugPrint("saveOfferProduct error: $e\n$stack");
//       Get.snackbar(
//         "Error",
//         "Something went wrong: $e",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
//
//   // ── Finish offer ──────────────────────────────────────────────────────────
//   void finishOffer() {
//     if (totalProductsAdded.value == 0) {
//       Get.snackbar("Error", "Please add at least one product before finishing.",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//     Get.back();
//   }
//
//   // ── Clear ─────────────────────────────────────────────────────────────────
//   void _clearForm() {
//     productName.value = '';
//     selectedCategory.value = '';
//     selectedCategoryId.value = 0;
//     productDescription.value = '';
//     variants.clear();
//     selectedVariantType.value = '';
//     expandedVariantType.value = '';
//     currentVariantValues.clear();
//     configuredVariantTypes.clear();
//     commonAttributes.clear();
//     variantValueController.clear();
//   }
//
//   void resetForm() {
//     Get.dialog(
//       AlertDialog(
//         title: const Text("Reset Form"),
//         content: const Text(
//             "Are you sure you want to reset? All unsaved changes will be lost."),
//         actions: [
//           TextButton(
//               onPressed: () => Get.back(), child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               _clearForm();
//               Get.back();
//               Get.snackbar("Form Reset", "All fields have been cleared",
//                   snackPosition: SnackPosition.BOTTOM);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Reset"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Helpers ───────────────────────────────────────────────────────────────
//   bool _isSuccess(dynamic status) =>
//       status == true || status == 1 || status == '1';
//
//   int _parseInt(dynamic value) =>
//       value is int ? value : int.parse(value.toString());
//
//   @override
//   void onClose() {
//     variantValueController.dispose();
//     super.onClose();
//   }
// }
//
// // ── Models ────────────────────────────────────────────────────────────────────
//
// class CategoryConfig {
//   final int id;
//   final List<String> commonAttributes;
//   final List<String> variantAttributes;
//
//   CategoryConfig({
//     required this.id,
//     required this.commonAttributes,
//     required this.variantAttributes,
//   });
// }
//
// class CategoryApiModel {
//   final int id;
//   final String name;
//   final String image;
//   final List<String> commonAttributes;
//   final List<String> variantAttributes;
//
//   CategoryApiModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.commonAttributes,
//     required this.variantAttributes,
//   });
// }
//
// class OfferProductVariant {
//   Map<String, String> attributes;
//   double? price;
//   int? stock;
//   String? imagePath;
//
//   OfferProductVariant({
//     required this.attributes,
//     this.price,
//     this.stock,
//     this.imagePath,
//   });
//
//   String getDisplayName() {
//     if (attributes.isEmpty) return "Variant";
//     return attributes.values.join(" - ");
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddOfferProductController extends GetxController {
  final box = GetStorage();

  final int offerId;
  final double discountPercentage;

  AddOfferProductController({
    required this.offerId,
    required this.discountPercentage,
  });

  // ── API URLs ──────────────────────────────────────────────────────────────
  final String categoriesUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/categories";
  final String addOfferProductUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/offers/add-products";

  // ── Basic fields ──────────────────────────────────────────────────────────
  var productName = ''.obs;
  var selectedCategory = ''.obs;
  var selectedCategoryId = 0.obs;
  var productDescription = ''.obs;

  // ── Loading states ────────────────────────────────────────────────────────
  var isLoadingCategories = false.obs;
  var isSubmitting = false.obs;

  /// Total products successfully added to this offer so far.
  var totalProductsAdded = 0.obs;

  // ── Category data ─────────────────────────────────────────────────────────
  var apiCategories = <CategoryApiModel>[].obs;
  final Map<String, CategoryConfig> categoryConfigs = {};

  // ── Common attributes ─────────────────────────────────────────────────────
  var commonAttributes = <String, String>{}.obs;

  // ── Variant type selection ────────────────────────────────────────────────
  var selectedVariantType = ''.obs;
  var expandedVariantType = ''.obs;
  var currentVariantValues = <String>[].obs;
  final TextEditingController variantValueController =
  TextEditingController();
  var configuredVariantTypes = <String, List<String>>{}.obs;

  // ── Variants ──────────────────────────────────────────────────────────────
  var variants = <OfferProductVariant>[].obs;

  // ── Per-variant image path observables (index → path) ─────────────────────
  // This is a separate RxMap so the UI reacts to individual image changes
  // without rebuilding the entire variant list.
  var variantImagePaths = <int, String>{}.obs;

  // ── Image picker ──────────────────────────────────────────────────────────
  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // ── Fetch categories ──────────────────────────────────────────────────────
  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;

      final token = box.read("auth_token");
      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      final response = await http.get(
        Uri.parse(categoriesUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (_isSuccess(body['status'])) {
          final List<dynamic> categoriesData = body['data'] ?? [];

          apiCategories.clear();
          categoryConfigs.clear();

          for (var catData in categoriesData) {
            try {
              final int id = _parseInt(catData['id']);
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
                    variantAttrs =
                    List<String>.from(attributes['variant']);
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
          Get.snackbar(
              "Error", body['message'] ?? "Failed to fetch categories");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch categories: $e");
      debugPrint("fetchCategories error: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ── Category change ───────────────────────────────────────────────────────
  void onCategoryChanged(String category) {
    selectedCategory.value = category;

    final cat = apiCategories.firstWhere(
          (c) => c.name == category,
      orElse: () => CategoryApiModel(
          id: 0,
          name: '',
          image: '',
          commonAttributes: [],
          variantAttributes: []),
    );
    selectedCategoryId.value = cat.id;

    // Reset everything
    selectedVariantType.value = '';
    expandedVariantType.value = '';
    currentVariantValues.clear();
    configuredVariantTypes.clear();
    commonAttributes.clear();
    variants.clear();
    variantImagePaths.clear();
    variantValueController.clear();
  }

  bool hasVariantAttributes() {
    final config = categoryConfigs[selectedCategory.value];
    return config != null && config.variantAttributes.isNotEmpty;
  }

  // ── Common attribute management ───────────────────────────────────────────
  void setCommonAttribute(String attribute, String value) {
    commonAttributes[attribute] = value;
  }

  // ── Variant type selection ────────────────────────────────────────────────
  void onVariantTypeSelected(String variantType) {
    if (selectedVariantType.value.isNotEmpty &&
        currentVariantValues.isNotEmpty) {
      configuredVariantTypes[selectedVariantType.value] =
          List.from(currentVariantValues);
    }

    selectedVariantType.value = variantType;
    currentVariantValues.value =
        List.from(configuredVariantTypes[variantType] ?? []);

    variantValueController.clear();
    currentVariantValues.refresh();
  }

  void addVariantValue(String value) {
    if (value.trim().isEmpty) return;

    if (selectedVariantType.value.isEmpty) {
      Get.snackbar("Error", "Please select a variant type first",
          snackPosition: SnackPosition.BOTTOM);
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
      Get.snackbar("Duplicate", "Value already exists",
          snackPosition: SnackPosition.BOTTOM);
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
      Get.snackbar(
          "Error",
          "Please configure at least one variant type with values",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Save current editing state
    if (selectedVariantType.value.isNotEmpty &&
        currentVariantValues.isNotEmpty) {
      configuredVariantTypes[selectedVariantType.value] =
          List.from(currentVariantValues);
    }

    final newCombinations = _generateAllCombinations();

    final combinationsToAdd = newCombinations
        .where((combo) =>
    !variants.any((v) => _areMapsEqual(v.attributes, combo)))
        .toList();

    for (var combo in combinationsToAdd) {
      variants.add(OfferProductVariant(attributes: combo));
    }

    // Rebuild image path map to match new variants list indices
    _rebuildImagePathMap();

    if (combinationsToAdd.isNotEmpty) {
      Get.snackbar(
        "Success",
        "${combinationsToAdd.length} variant(s) added! Total: ${variants.length}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar("Info", "All variants already exist.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF3B82F6),
          colorText: Colors.white);
    }

    expandedVariantType.value = '';
  }

  bool _areMapsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final k in a.keys) {
      if (a[k] != b[k]) return false;
    }
    return true;
  }

  List<Map<String, String>> _generateAllCombinations() {
    if (configuredVariantTypes.isEmpty) return [];

    final types = configuredVariantTypes.keys.toList();
    final allValues =
    types.map((t) => configuredVariantTypes[t]!).toList();
    final results = <Map<String, String>>[];

    void generate(int index, Map<String, String> current) {
      if (index == types.length) {
        results.add(Map<String, String>.from(current));
        return;
      }
      for (final value in allValues[index]) {
        current[types[index]] = value;
        generate(index + 1, current);
      }
    }

    generate(0, {});
    return results;
  }

  // ── Sync variantImagePaths map with variants list ─────────────────────────
  /// Called whenever variants are added/removed to keep the image map
  /// indices consistent.
  void _rebuildImagePathMap() {
    final updated = <int, String>{};
    for (int i = 0; i < variants.length; i++) {
      final path = variants[i].imagePath;
      if (path != null) updated[i] = path;
    }
    variantImagePaths.assignAll(updated);
  }

  // ── Variant / image operations ────────────────────────────────────────────
  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants.removeAt(index);
      // Rebuild image map so indices remain correct after removal
      _rebuildImagePathMap();
    }
  }

  /// Pick an image for a specific variant [index].
  Future<void> pickImage(int index) async {
    if (index < 0 || index >= variants.length) return;

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      // Update both the variant model and the reactive map
      variants[index].imagePath = pickedFile.path;
      variantImagePaths[index] = pickedFile.path;
      variantImagePaths.refresh();
    }
  }

  /// Remove the image for a specific variant [index].
  void removeImage(int index) {
    if (index >= 0 && index < variants.length) {
      variants[index].imagePath = null;
      variantImagePaths.remove(index);
      variantImagePaths.refresh();
    }
  }

  // ── Offer price calculation ───────────────────────────────────────────────
  double? computeOfferPrice(double originalPrice) {
    if (originalPrice <= 0) return null;
    return originalPrice -
        (originalPrice * discountPercentage / 100);
  }

  // ── Validation ────────────────────────────────────────────────────────────
  bool validateForm() {
    if (productName.value.trim().isEmpty) {
      Get.snackbar("Validation Error", "Product name is required");
      return false;
    }

    if (selectedCategory.value.isEmpty) {
      Get.snackbar("Validation Error", "Category is required");
      return false;
    }

    final config = categoryConfigs[selectedCategory.value];
    if (config != null) {
      for (final attr in config.commonAttributes) {
        if (commonAttributes[attr]?.trim().isEmpty ?? true) {
          Get.snackbar("Validation Error", "$attr is required");
          return false;
        }
      }
    }

    if (variants.isEmpty) {
      Get.snackbar(
          "Validation Error", "At least one variant is required");
      return false;
    }

    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];
      final label =
          "Variant ${i + 1} (${variant.getDisplayName()})";

      if (variant.price == null || variant.price! <= 0) {
        Get.snackbar(
            "Validation Error", "$label: Valid price is required");
        return false;
      }
      if (variant.stock == null || variant.stock! < 0) {
        Get.snackbar(
            "Validation Error", "$label: Valid stock is required");
        return false;
      }
      if (variant.imagePath == null) {
        Get.snackbar(
            "Validation Error", "$label: Image is required");
        return false;
      }
    }

    if (totalProductsAdded.value >= 10) {
      Get.snackbar("Error", "Maximum 10 products limit reached!");
      return false;
    }

    return true;
  }

  // ── Save offer product ────────────────────────────────────────────────────
  Future<void> saveOfferProduct() async {
    if (!validateForm()) return;

    try {
      isSubmitting.value = true;

      final token = box.read("auth_token");
      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      // Build variants list — each variant carries its own base64 image
      final List<Map<String, dynamic>> variantsData = [];

      for (final variant in variants) {
        String? imageBase64;
        if (variant.imagePath != null) {
          final bytes =
          await File(variant.imagePath!).readAsBytes();
          final ext =
          variant.imagePath!.split('.').last.toLowerCase();
          final mime =
          ext == 'png' ? 'image/png' : 'image/jpeg';
          imageBase64 =
          "data:$mime;base64,${base64Encode(bytes)}";
        }

        variantsData.add({
          "attributes": variant.attributes,
          "price": variant.price,
          "stock": variant.stock,
          "image": imageBase64,
        });
      }

      final Map<String, dynamic> productEntry = {
        "product_name": productName.value.trim(),
        "category_id": selectedCategoryId.value,
        "common_attributes":
        Map<String, String>.from(commonAttributes),
        "variants": variantsData,
      };

      if (productDescription.value.trim().isNotEmpty) {
        productEntry["description"] =
            productDescription.value.trim();
      }

      final requestBody = {
        "offer_id": offerId,
        "products": [productEntry],
      };

      debugPrint("➡️ POST $addOfferProductUrl");
      debugPrint("Request body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(addOfferProductUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      debugPrint("⬅️ Status: ${response.statusCode}");
      debugPrint("Response: ${response.body}");

      final body =
      jsonDecode(response.body) as Map<String, dynamic>;

      final isOk = response.statusCode == 200 ||
          response.statusCode == 201 ||
          _isSuccess(body['status']);

      if (isOk) {
        final List<dynamic> savedProducts =
            (body['data'] as List<dynamic>?) ?? [];

        totalProductsAdded.value += savedProducts.isNotEmpty
            ? savedProducts.length
            : 1;

        Get.snackbar(
          "✅ Success",
          body['message'] ??
              "Product added to offer successfully!",
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        _clearForm();
      } else {
        Get.snackbar(
          "Error",
          body['message'] ?? "Failed to add product to offer",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      debugPrint("saveOfferProduct error: $e\n$stack");
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Finish offer ──────────────────────────────────────────────────────────
  void finishOffer() {
    if (totalProductsAdded.value == 0) {
      Get.snackbar(
          "Error", "Please add at least one product before finishing.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.back();
  }

  // ── Clear ─────────────────────────────────────────────────────────────────
  void _clearForm() {
    productName.value = '';
    selectedCategory.value = '';
    selectedCategoryId.value = 0;
    productDescription.value = '';
    variants.clear();
    variantImagePaths.clear();
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
        title: const Text("Reset Form"),
        content: const Text(
            "Are you sure you want to reset? All unsaved changes will be lost."),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              _clearForm();
              Get.back();
              Get.snackbar("Form Reset", "All fields have been cleared",
                  snackPosition: SnackPosition.BOTTOM);
            },
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  bool _isSuccess(dynamic status) =>
      status == true || status == 1 || status == '1';

  int _parseInt(dynamic value) =>
      value is int ? value : int.parse(value.toString());

  @override
  void onClose() {
    variantValueController.dispose();
    super.onClose();
  }
}

// ── Models ────────────────────────────────────────────────────────────────────

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

class OfferProductVariant {
  Map<String, String> attributes;
  double? price;
  int? stock;
  String? imagePath;

  OfferProductVariant({
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