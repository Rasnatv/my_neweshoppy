// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
//
// class UpdateProductController extends GetxController {
//   final box = GetStorage();
//
//   // API URLs
//   final String categoriesUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/categories";
//   final String productDetailsUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/product/details";
//   final String updateProductUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/product/update";
//
//   // Product ID
//   var productId = 0.obs;
//
//   // Loading states
//   var isLoadingProduct = false.obs;
//   var isLoadingCategories = false.obs;
//   var isSubmitting = false.obs;
//
//   // ---------------- BASIC FIELDS ----------------
//   var productName = ''.obs;
//   var selectedCategory = ''.obs;
//   var selectedCategoryId = 0.obs;
//   var productDescription = ''.obs;
//
//   // ---------------- CATEGORY DATA FROM API ----------------
//   var apiCategories = <DCategoryApiModel>[].obs;
//
//   // ---------------- CATEGORY CONFIGURATION ----------------
//   final Map<String, DCategoryConfig> categoryConfigs = {};
//
//   // ---------------- COMMON & VARIANT ATTRIBUTES ----------------
//   var commonAttributes = <String, String>{}.obs;
//   var variantAttributeValues = <String, List<String>>{}.obs;
//
//   // ---------------- VARIANTS ----------------
//   var variants = <DProductVariant>[].obs;
//
//   // ---------------- IMAGE PICKER ----------------
//   final ImagePicker picker = ImagePicker();
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Get product ID from arguments
//     if (Get.arguments != null && Get.arguments['product_id'] != null) {
//       productId.value = Get.arguments['product_id'];
//     }
//
//     fetchCategories();
//   }
//
//   // ---------------- FETCH PRODUCT DETAILS ----------------
//   Future<void> fetchProductDetails() async {
//     try {
//       isLoadingProduct.value = true;
//
//       final token = box.read("auth_token");
//       if (token == null) {
//         Get.snackbar("Error", "Authentication token not found");
//         return;
//       }
//
//       print("Fetching product details for ID: ${productId.value}");
//
//       final response = await http.post(
//         Uri.parse(productDetailsUrl),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "product_id": productId.value,
//         }),
//       );
//
//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//
//         if (body['status'] == true) {
//           final productData = body['data'];
//
//           // Set basic info
//           productName.value = productData['name'] ?? '';
//           productDescription.value = productData['description'] ?? '';
//
//           // Set category
//           if (productData['category'] != null) {
//             selectedCategoryId.value = productData['category']['id'];
//             selectedCategory.value = productData['category']['name'];
//           }
//
//           // Wait for categories to load before setting attributes
//           await Future.delayed(Duration(milliseconds: 100));
//
//           // Set common attributes
//           if (productData['common_attributes'] != null) {
//             final Map<String, dynamic> commonAttrs = productData['common_attributes'];
//             commonAttributes.clear();
//             commonAttrs.forEach((key, value) {
//               commonAttributes[key] = value.toString();
//             });
//           }
//
//           // Set variants
//           if (productData['variants'] != null) {
//             variants.clear();
//
//             final List<dynamic> variantsData = productData['variants'];
//
//             // Extract variant attribute values and populate variants
//             Map<String, Set<String>> attributeValues = {};
//
//             for (var variantData in variantsData) {
//               Map<String, String> attributes = {};
//
//               if (variantData['attributes'] != null) {
//                 final Map<String, dynamic> attrs = variantData['attributes'];
//                 attrs.forEach((key, value) {
//                   attributes[key] = value.toString();
//
//                   // Collect unique values for each attribute
//                   if (!attributeValues.containsKey(key)) {
//                     attributeValues[key] = {};
//                   }
//                   attributeValues[key]!.add(value.toString());
//                 });
//               }
//
//               variants.add(DProductVariant(
//                 id: variantData['id'],
//                 attributes: attributes,
//                 price: double.tryParse(variantData['price']?.toString() ?? '0'),
//                 stock: int.tryParse(variantData['stock']?.toString() ?? '0'),
//                 imagePath: variantData['image'],
//                 isExisting: true,
//               ));
//             }
//
//             // Populate variantAttributeValues for display
//             variantAttributeValues.clear();
//             attributeValues.forEach((key, values) {
//               variantAttributeValues[key] = values.toList();
//             });
//           }
//
//           print("✓ Product loaded successfully");
//           print("Product: ${productName.value}");
//           print("Category: ${selectedCategory.value}");
//           print("Variants: ${variants.length}");
//
//         } else {
//           Get.snackbar("Error", body['message'] ?? "Failed to fetch product details");
//         }
//       } else {
//         Get.snackbar("Error", "Failed to fetch product: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error fetching product: $e");
//       Get.snackbar("Error", "Failed to fetch product: $e");
//     } finally {
//       isLoadingProduct.value = false;
//     }
//   }
//
//   // ---------------- FETCH CATEGORIES FROM API ----------------
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
//       print("Fetching categories...");
//
//       final response = await http.get(
//         Uri.parse(categoriesUrl),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       print("Response status: ${response.statusCode}");
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//
//         if (body['status'] == true) {
//           final List<dynamic> categoriesData = body['data'];
//
//           apiCategories.clear();
//           categoryConfigs.clear();
//
//           for (var catData in categoriesData) {
//             try {
//               final int id = catData['id'] is int
//                   ? catData['id']
//                   : int.parse(catData['id'].toString());
//
//               final String name = catData['name']?.toString() ?? '';
//               final String image = catData['image']?.toString() ?? '';
//
//               List<String> commonAttrs = [];
//               List<String> variantAttrs = [];
//
//               if (catData['attributes'] != null) {
//                 final attributes = catData['attributes'];
//
//                 if (attributes is Map) {
//                   if (attributes['common'] != null && attributes['common'] is List) {
//                     commonAttrs = List<String>.from(attributes['common']);
//                   }
//
//                   if (attributes['variant'] != null && attributes['variant'] is List) {
//                     variantAttrs = List<String>.from(attributes['variant']);
//                   }
//                 } else if (attributes is List) {
//                   variantAttrs = List<String>.from(attributes);
//                 }
//               }
//
//               final category = DCategoryApiModel(
//                 id: id,
//                 name: name,
//                 image: image,
//                 commonAttributes: commonAttrs,
//                 variantAttributes: variantAttrs,
//               );
//
//               apiCategories.add(category);
//
//               categoryConfigs[name] = DCategoryConfig(
//                 id: id,
//                 commonAttributes: commonAttrs,
//                 variantAttributes: variantAttrs,
//               );
//
//             } catch (e) {
//               print("Error parsing category: $e");
//             }
//           }
//
//           print("✓ Total categories loaded: ${apiCategories.length}");
//
//           // Fetch product details after categories are loaded
//           await fetchProductDetails();
//
//         } else {
//           Get.snackbar("Error", body['message'] ?? "Failed to fetch categories");
//         }
//       } else {
//         Get.snackbar("Error", "Failed to fetch categories: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to fetch categories: $e");
//       print("❌ Error fetching categories: $e");
//     } finally {
//       isLoadingCategories.value = false;
//     }
//   }
//
//   // ---------------- CATEGORY CHANGE ----------------
//   void onCategoryChanged(String category) {
//     selectedCategory.value = category;
//
//     final cat = apiCategories.firstWhere(
//           (c) => c.name == category,
//       orElse: () => DCategoryApiModel(
//         id: 0,
//         name: '',
//         image: '',
//         commonAttributes: [],
//         variantAttributes: [],
//       ),
//     );
//     selectedCategoryId.value = cat.id;
//
//     // Note: Don't clear existing data when changing category in edit mode
//     // variantAttributeValues.clear();
//     // commonAttributes.clear();
//     // variants.clear();
//   }
//
//   // ---------------- COMMON ATTRIBUTE MANAGEMENT ----------------
//   void setCommonAttribute(String attribute, String value) {
//     commonAttributes[attribute] = value;
//   }
//
//   // ---------------- VARIANT ATTRIBUTE VALUE MANAGEMENT ----------------
//   void addAttributeValue(String attribute, String value) {
//     if (value.trim().isEmpty) return;
//
//     if (!variantAttributeValues.containsKey(attribute)) {
//       variantAttributeValues[attribute] = [];
//     }
//
//     if (!variantAttributeValues[attribute]!.contains(value.trim())) {
//       variantAttributeValues[attribute]!.add(value.trim());
//       variantAttributeValues.refresh();
//     }
//   }
//
//   void removeAttributeValue(String attribute, String value) {
//     if (variantAttributeValues.containsKey(attribute)) {
//       variantAttributeValues[attribute]!.remove(value);
//       variantAttributeValues.refresh();
//     }
//   }
//
//   // ---------------- VARIANT GENERATION ----------------
//   void generateVariants() {
//     if (selectedCategory.value.isEmpty) {
//       Get.snackbar(
//         "Category Required",
//         "Please select a category first",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     final config = categoryConfigs[selectedCategory.value];
//     if (config == null) return;
//
//     bool hasVariantValues = false;
//     for (var attr in config.variantAttributes) {
//       if (variantAttributeValues[attr]?.isNotEmpty ?? false) {
//         hasVariantValues = true;
//         break;
//       }
//     }
//
//     if (!hasVariantValues) {
//       Get.snackbar(
//         "No Variant Attributes",
//         "Please add at least one value for variant attributes",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     List<Map<String, String>> combinations = _generateCombinations(config.variantAttributes);
//
//     // Keep existing variants
//     List<DProductVariant> existingVariants = List.from(variants);
//
//     variants.clear();
//
//     // Add existing variants first
//     variants.addAll(existingVariants);
//
//     // Add new combinations that don't match existing variants
//     for (var combo in combinations) {
//       bool exists = existingVariants.any((v) =>
//           _areAttributesEqual(v.attributes, combo)
//       );
//
//       if (!exists) {
//         variants.add(DProductVariant(
//           attributes: combo,
//           price: null,
//           stock: null,
//           isExisting: false,
//         ));
//       }
//     }
//
//     Get.snackbar(
//       "Variants Generated",
//       "${variants.length} variant(s) available",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Color(0xFF10B981),
//       colorText: Colors.white,
//     );
//   }
//
//   bool _areAttributesEqual(Map<String, String> a, Map<String, String> b) {
//     if (a.length != b.length) return false;
//     for (var key in a.keys) {
//       if (a[key] != b[key]) return false;
//     }
//     return true;
//   }
//
//   List<Map<String, String>> _generateCombinations(List<String> attributes) {
//     List<Map<String, String>> results = [];
//
//     List<String> activeAttrs = [];
//     List<List<String>> activeValues = [];
//
//     for (var attr in attributes) {
//       if (variantAttributeValues[attr]?.isNotEmpty ?? false) {
//         activeAttrs.add(attr);
//         activeValues.add(variantAttributeValues[attr]!);
//       }
//     }
//
//     if (activeAttrs.isEmpty) return results;
//
//     void generate(int index, Map<String, String> current) {
//       if (index == activeAttrs.length) {
//         results.add(Map<String, String>.from(current));
//         return;
//       }
//
//       for (var value in activeValues[index]) {
//         current[activeAttrs[index]] = value;
//         generate(index + 1, current);
//       }
//     }
//
//     generate(0, {});
//     return results;
//   }
//
//   // ---------------- MANUAL VARIANT OPERATIONS ----------------
//   void removeVariant(int index) {
//     if (index >= 0 && index < variants.length) {
//       variants.removeAt(index);
//     }
//   }
//
//   void duplicateVariant(int index) {
//     if (index >= 0 && index < variants.length) {
//       final original = variants[index];
//       final duplicate = DProductVariant(
//         price: original.price,
//         stock: original.stock,
//         imagePath: original.imagePath,
//         attributes: Map<String, String>.from(original.attributes),
//         isExisting: false,
//       );
//       variants.insert(index + 1, duplicate);
//       Get.snackbar(
//         "Variant Duplicated",
//         "A copy has been created",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   // ---------------- IMAGE OPERATIONS ----------------
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
//       variants[index].imageUpdated = true;
//       variants.refresh();
//     }
//   }
//
//   void removeImage(int index) {
//     if (index >= 0 && index < variants.length) {
//       variants[index].imagePath = null;
//       variants[index].imageUpdated = true;
//       variants.refresh();
//     }
//   }
//
//   // ---------------- VALIDATION ----------------
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
//     if (productDescription.value.trim().isEmpty) {
//       Get.snackbar("Validation Error", "Product description is required");
//       return false;
//     }
//
//     final config = categoryConfigs[selectedCategory.value];
//     if (config != null) {
//       for (var attr in config.commonAttributes) {
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
//
//       if (variant.price == null || variant.price! <= 0) {
//         Get.snackbar(
//           "Validation Error",
//           "Variant ${i + 1}: Valid price is required",
//         );
//         return false;
//       }
//
//       if (variant.stock == null || variant.stock! < 0) {
//         Get.snackbar(
//           "Validation Error",
//           "Variant ${i + 1}: Valid stock quantity is required",
//         );
//         return false;
//       }
//     }
//
//     return true;
//   }
//
//   // ---------------- PRODUCT UPDATE TO API ----------------
//   Future<void> updateProduct() async {
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
//       List<Map<String, dynamic>> variantsData = [];
//
//       for (var variant in variants) {
//         Map<String, dynamic> variantData = {
//           "attributes": variant.attributes,
//           "price": variant.price,
//           "stock": variant.stock,
//         };
//
//         // Include variant ID if it's an existing variant
//         if (variant.isExisting && variant.id != null) {
//           variantData["id"] = variant.id;
//         }
//
//         // Only include image if it was updated or it's a new variant with an image
//         if (variant.imageUpdated && variant.imagePath != null) {
//           // Check if it's a local file (new image) or URL (existing image)
//           if (!variant.imagePath!.startsWith('http')) {
//             final bytes = await File(variant.imagePath!).readAsBytes();
//             final extension = variant.imagePath!.split('.').last.toLowerCase();
//             String mimeType = 'image/jpeg';
//
//             if (extension == 'png') {
//               mimeType = 'image/png';
//             } else if (extension == 'jpg' || extension == 'jpeg') {
//               mimeType = 'image/jpeg';
//             }
//
//             variantData["image"] = "data:$mimeType;base64,${base64Encode(bytes)}";
//           }
//         }
//
//         variantsData.add(variantData);
//       }
//
//       final requestBody = {
//         "product_id": productId.value,
//         "name": productName.value.trim(),
//         "description": productDescription.value.trim(),
//         "common_attributes": commonAttributes,
//         "variants": variantsData,
//       };
//
//       print("Update request body: ${jsonEncode(requestBody)}");
//
//       final response = await http.post(
//         Uri.parse(updateProductUrl),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");
//
//       final body = jsonDecode(response.body);
//
//       if (response.statusCode == 200 || body['status'] == true) {
//         Get.snackbar(
//           "Success",
//           body['message'] ?? "Product updated successfully",
//           backgroundColor: Color(0xFF10B981),
//           colorText: Colors.white,
//           duration: Duration(seconds: 3),
//         );
//
//         // Navigate back
//         Get.back(result: true);
//       } else {
//         Get.snackbar(
//           "Error",
//           body['message'] ?? "Failed to update product",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       print("Error updating product: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to update product: $e",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
// }
//
// // ---------------- MODELS ----------------
//
// class DCategoryConfig {
//   final int id;
//   final List<String> commonAttributes;
//   final List<String> variantAttributes;
//   DCategoryConfig({
//     required this.id,
//     required this.commonAttributes,
//     required this.variantAttributes,
//   });
// }
//
// class DCategoryApiModel {
//   final int id;
//   final String name;
//   final String image;
//   final List<String> commonAttributes;
//   final List<String> variantAttributes;
//
//   DCategoryApiModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.commonAttributes,
//     required this.variantAttributes,
//   });
// }
//
// class DProductVariant {
//   int? id; // Variant ID from API (for existing variants)
//   Map<String, String> attributes;
//   double? price;
//   int? stock;
//   String? imagePath; // Can be URL or local file path
//   bool isExisting; // Flag to identify existing vs new variants
//   bool imageUpdated; // Flag to track if image was changed
//
//   DProductVariant({
//     this.id,
//     required this.attributes,
//     this.price,
//     this.stock,
//     this.imagePath,
//     this.isExisting = false,
//     this.imageUpdated = false,
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

import '../views/manageproducts.dart';

class UpdateProductController extends GetxController {
  final box = GetStorage();

  // API URLs
  final String categoriesUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/categories";
  final String productDetailsUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/product/details";
  final String updateProductUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/product/update";

  // Product ID
  var productId = 0.obs;

  // Loading states
  var isLoadingProduct = false.obs;
  var isLoadingCategories = false.obs;
  var isSubmitting = false.obs;

  // ---------------- BASIC FIELDS ----------------
  var productName = ''.obs;
  var selectedCategory = ''.obs;
  var selectedCategoryId = 0.obs;
  var productDescription = ''.obs;

  // ---------------- CATEGORY DATA FROM API ----------------
  var apiCategories = <DCategoryApiModel>[].obs;

  // ---------------- CATEGORY CONFIGURATION ----------------
  final Map<String, DCategoryConfig> categoryConfigs = {};

  // ---------------- COMMON & VARIANT ATTRIBUTES ----------------
  var commonAttributes = <String, String>{}.obs;
  var variantAttributeValues = <String, List<String>>{}.obs;

  // ---------------- VARIANTS ----------------
  var variants = <DProductVariant>[].obs;

  // ---------------- IMAGE PICKER ----------------
  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    // Get product ID from arguments
    if (Get.arguments != null && Get.arguments['product_id'] != null) {
      productId.value = Get.arguments['product_id'];
    }

    fetchCategories();
  }

  // ---------------- FETCH PRODUCT DETAILS ----------------
  Future<void> fetchProductDetails() async {
    try {
      isLoadingProduct.value = true;

      final token = box.read("auth_token");
      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      print("Fetching product details for ID: ${productId.value}");

      final response = await http.post(
        Uri.parse(productDetailsUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "product_id": productId.value,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          final productData = body['data'];

          // Set basic info
          productName.value = productData['name'] ?? '';
          productDescription.value = productData['description'] ?? '';

          // Set category
          if (productData['category'] != null) {
            selectedCategoryId.value = productData['category']['id'];
            selectedCategory.value = productData['category']['name'];
          }

          // Wait for categories to load before setting attributes
          await Future.delayed(Duration(milliseconds: 100));

          // Set common attributes
          if (productData['common_attributes'] != null) {
            final Map<String, dynamic> commonAttrs =
            productData['common_attributes'];
            commonAttributes.clear();
            commonAttrs.forEach((key, value) {
              commonAttributes[key] = value.toString();
            });
          }

          // Set variants
          if (productData['variants'] != null) {
            variants.clear();

            final List<dynamic> variantsData = productData['variants'];

            // Extract variant attribute values and populate variants
            Map<String, Set<String>> attributeValues = {};

            for (var variantData in variantsData) {
              Map<String, String> attributes = {};

              if (variantData['attributes'] != null) {
                final Map<String, dynamic> attrs = variantData['attributes'];
                attrs.forEach((key, value) {
                  attributes[key] = value.toString();

                  // Collect unique values for each attribute
                  if (!attributeValues.containsKey(key)) {
                    attributeValues[key] = {};
                  }
                  attributeValues[key]!.add(value.toString());
                });
              }

              variants.add(DProductVariant(
                id: variantData['id'],
                attributes: attributes,
                price:
                double.tryParse(variantData['price']?.toString() ?? '0'),
                stock: int.tryParse(variantData['stock']?.toString() ?? '0'),
                imagePath: variantData['image'],
                isExisting: true,
              ));
            }

            // Populate variantAttributeValues for display
            variantAttributeValues.clear();
            attributeValues.forEach((key, values) {
              variantAttributeValues[key] = values.toList();
            });
          }

          print("✓ Product loaded successfully");
          print("Product: ${productName.value}");
          print("Category: ${selectedCategory.value}");
          print("Variants: ${variants.length}");
        } else {
          Get.snackbar(
              "Error", body['message'] ?? "Failed to fetch product details");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to fetch product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching product: $e");
      Get.snackbar("Error", "Failed to fetch product: $e");
    } finally {
      isLoadingProduct.value = false;
    }
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

      final response = await http.get(
        Uri.parse(categoriesUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Response status: ${response.statusCode}");

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
                  if (attributes['common'] != null &&
                      attributes['common'] is List) {
                    commonAttrs = List<String>.from(attributes['common']);
                  }

                  if (attributes['variant'] != null &&
                      attributes['variant'] is List) {
                    variantAttrs = List<String>.from(attributes['variant']);
                  }
                } else if (attributes is List) {
                  variantAttrs = List<String>.from(attributes);
                }
              }

              final category = DCategoryApiModel(
                id: id,
                name: name,
                image: image,
                commonAttributes: commonAttrs,
                variantAttributes: variantAttrs,
              );

              apiCategories.add(category);

              categoryConfigs[name] = DCategoryConfig(
                id: id,
                commonAttributes: commonAttrs,
                variantAttributes: variantAttrs,
              );
            } catch (e) {
              print("Error parsing category: $e");
            }
          }

          print("✓ Total categories loaded: ${apiCategories.length}");

          // Fetch product details after categories are loaded
          await fetchProductDetails();
        } else {
          Get.snackbar(
              "Error", body['message'] ?? "Failed to fetch categories");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to fetch categories: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch categories: $e");
      print("❌ Error fetching categories: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ---------------- CATEGORY CHANGE ----------------
  void onCategoryChanged(String category) {
    selectedCategory.value = category;

    final cat = apiCategories.firstWhere(
          (c) => c.name == category,
      orElse: () => DCategoryApiModel(
        id: 0,
        name: '',
        image: '',
        commonAttributes: [],
        variantAttributes: [],
      ),
    );
    selectedCategoryId.value = cat.id;
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

    List<Map<String, String>> combinations =
    _generateCombinations(config.variantAttributes);

    // Keep existing variants
    List<DProductVariant> existingVariants = List.from(variants);

    variants.clear();

    // Add existing variants first
    variants.addAll(existingVariants);

    // Add new combinations that don't match existing variants
    for (var combo in combinations) {
      bool exists =
      existingVariants.any((v) => _areAttributesEqual(v.attributes, combo));

      if (!exists) {
        variants.add(DProductVariant(
          attributes: combo,
          price: null,
          stock: null,
          isExisting: false,
        ));
      }
    }

    Get.snackbar(
      "Variants Generated",
      "${variants.length} variant(s) available",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  bool _areAttributesEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (var key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
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
      final duplicate = DProductVariant(
        price: original.price,
        stock: original.stock,
        imagePath: original.imagePath,
        attributes: Map<String, String>.from(original.attributes),
        isExisting: false,
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
      variants[index].imageUpdated = true;
      variants.refresh();
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < variants.length) {
      variants[index].imagePath = null;
      variants[index].imageUpdated = true;
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
    }

    return true;
  }

  // ---------------- PRODUCT UPDATE TO API ----------------
  Future<void> updateProduct() async {
    if (!validateForm()) return;

    try {
      isSubmitting.value = true;

      final token = box.read("auth_token");
      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      List<Map<String, dynamic>> variantsData = [];

      for (var variant in variants) {
        Map<String, dynamic> variantData = {
          "attributes": variant.attributes,
          "price": variant.price,
          "stock": variant.stock,
        };

        // Include variant ID if it's an existing variant
        if (variant.isExisting && variant.id != null) {
          variantData["id"] = variant.id;
        }

        // Only include image if it was updated or it's a new variant with an image
        if (variant.imageUpdated && variant.imagePath != null) {
          if (!variant.imagePath!.startsWith('http')) {
            final bytes = await File(variant.imagePath!).readAsBytes();
            final extension =
            variant.imagePath!.split('.').last.toLowerCase();
            String mimeType = 'image/jpeg';

            if (extension == 'png') {
              mimeType = 'image/png';
            } else if (extension == 'jpg' || extension == 'jpeg') {
              mimeType = 'image/jpeg';
            }

            variantData["image"] =
            "data:$mimeType;base64,${base64Encode(bytes)}";
          }
        }

        variantsData.add(variantData);
      }

      final requestBody = {
        "product_id": productId.value,
        "name": productName.value.trim(),
        "description": productDescription.value.trim(),
        "common_attributes": commonAttributes,
        "variants": variantsData,
      };

      print("Update request body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(updateProductUrl),
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

      if (response.statusCode == 200 || body['status'] == true) {
        Get.snackbar(
          "Success",
          body['message'] ?? "Product updated successfully",
          backgroundColor: Color(0xFF10B981),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // Navigate back with result = true so manage page can refresh
        Get.offAll(()=> ManageProductsPage());
      } else {
        Get.snackbar(
          "Error",
          body['message'] ?? "Failed to update product",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error updating product: $e");
      Get.snackbar(
        "Error",
        "Failed to update product: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

// ---------------- MODELS ----------------

class DCategoryConfig {
  final int id;
  final List<String> commonAttributes;
  final List<String> variantAttributes;
  DCategoryConfig({
    required this.id,
    required this.commonAttributes,
    required this.variantAttributes,
  });
}

class DCategoryApiModel {
  final int id;
  final String name;
  final String image;
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  DCategoryApiModel({
    required this.id,
    required this.name,
    required this.image,
    required this.commonAttributes,
    required this.variantAttributes,
  });
}

class DProductVariant {
  int? id;
  Map<String, String> attributes;
  double? price;
  int? stock;
  String? imagePath;
  bool isExisting;
  bool imageUpdated;

  DProductVariant({
    this.id,
    required this.attributes,
    this.price,
    this.stock,
    this.imagePath,
    this.isExisting = false,
    this.imageUpdated = false,
  });

  String getDisplayName() {
    if (attributes.isEmpty) return "Variant";
    return attributes.values.join(" - ");
  }
}