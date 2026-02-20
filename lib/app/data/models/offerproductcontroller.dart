//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
//
// import '../../modules/merchant_home/offermodel.dart';
//
//
// class IntegratedOfferController extends GetxController {
//   final box = GetStorage();
//
//   final String categoriesUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/categories";
//   final String createOfferUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/offers/create";
//   final String addOfferProductUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/offers/add-products";
//
//   // ============== OFFER STATE ==============
//   var offerCreated = false.obs;
//   var createdOfferId = Rx<int?>(null);             // ✅ set ONCE from API response
//   var createdOfferBannerUrl = ''.obs;              // ✅ set ONCE from API response
//   var createdDiscountPercentage = Rx<int?>(null);  // ✅ set ONCE from API response
//   var totalProductsAdded = 0.obs;
//
//   // ============== OFFER FORM (Step 1 only) ==============
//   final TextEditingController discountPercentageCtrl = TextEditingController();
//   var bannerImage = Rx<File?>(null);
//
//   // ============== PRODUCT FORM (Step 2) ==============
//   var productName = ''.obs;
//   var selectedCategory = ''.obs;
//   var selectedCategoryId = 0.obs;
//   var productDescription = ''.obs;
//
//   // ============== LOADING STATES ==============
//   var isLoadingCategories = false.obs;
//   var isCreatingOffer = false.obs;
//   var isSubmitting = false.obs;
//
//   // ============== CATEGORY DATA ==============
//   var apiCategories = <OfferCategoryApiModel>[].obs;
//   final Map<String, OfferCategoryConfig> categoryConfigs = {};
//
//   // ============== COMMON ATTRIBUTES ==============
//   var commonAttributes = <String, String>{}.obs;
//
//   // ============== VARIANT CONFIGURATION ==============
//   var variantTypeConfigurations = <String, Map<String, List<String>>>{}.obs;
//   var selectedVariantType = ''.obs;
//   var currentPrimaryValue = ''.obs;
//   var currentSecondaryValues = <String>[].obs;
//   final TextEditingController primaryValueController = TextEditingController();
//   final TextEditingController secondaryValueController = TextEditingController();
//
//   // ============== VARIANTS ==============
//   var variants = <OfferProductVariant>[].obs;
//   final ImagePicker picker = ImagePicker();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategories();
//   }
//
//   // ============== PICK BANNER IMAGE ==============
//   Future<void> pickBannerImage() async {
//     try {
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1920,
//         maxHeight: 1920,
//         imageQuality: 85,
//       );
//       if (pickedFile != null) {
//         bannerImage.value = File(pickedFile.path);
//         Get.snackbar(
//           "Success", "Banner image selected",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: const Color(0xFF10B981),
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to pick banner: $e",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     }
//   }
//
//   // ============== FETCH CATEGORIES ==============
//   Future<void> fetchCategories() async {
//     try {
//       isLoadingCategories.value = true;
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
//         if (body['status'] == true) {
//           final List categoriesData = body['data'];
//           apiCategories.clear();
//           categoryConfigs.clear();
//
//           for (var catData in categoriesData) {
//             try {
//               final int id = catData['id'] is int
//                   ? catData['id']
//                   : int.parse(catData['id'].toString());
//               final String name = catData['name']?.toString() ?? '';
//               final String image = catData['image']?.toString() ?? '';
//
//               List<String> commonAttrs = [];
//               List<String> variantAttrs = [];
//
//               if (catData['attributes'] != null) {
//                 final attributes = catData['attributes'];
//                 if (attributes is Map) {
//                   if (attributes['common'] != null && attributes['common'] is List) {
//                     commonAttrs = List<String>.from(attributes['common']);
//                   }
//                   if (attributes['variant'] != null && attributes['variant'] is List) {
//                     variantAttrs = List<String>.from(attributes['variant']);
//                   }
//                 } else if (attributes is List) {
//                   variantAttrs = List<String>.from(attributes);
//                 }
//               }
//
//               final category = OfferCategoryApiModel(
//                 id: id,
//                 name: name,
//                 image: image,
//                 commonAttributes: commonAttrs,
//                 variantAttributes: variantAttrs,
//               );
//
//               apiCategories.add(category);
//               categoryConfigs[name] = OfferCategoryConfig(
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
//         Get.snackbar("Error", "Failed to fetch categories: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to fetch categories: $e");
//     } finally {
//       isLoadingCategories.value = false;
//     }
//   }
//
//   // ============================================================
//   //  STEP 1 — CREATE OFFER
//   //
//   //  REQUEST  → { "discount_percentage": 20, "offer_banner": "base64..." }
//   //  RESPONSE → { "status": 1, "data": { "offer_id": 252,
//   //                                       "discount_percentage": 20,
//   //                                       "offer_banner": "url" } }
//   //
//   //  ✅ After this call:
//   //     - offer_id   is stored in createdOfferId
//   //     - discount % is stored in createdDiscountPercentage
//   //     - banner URL is stored in createdOfferBannerUrl
//   //     - The text field & banner picker are LOCKED — never re-sent
//   // ============================================================
//   Future<void> createOffer() async {
//     if (isCreatingOffer.value || offerCreated.value) return;
//
//     final discountValue = double.tryParse(discountPercentageCtrl.text.trim());
//     if (discountValue == null || discountValue <= 0 || discountValue > 100) {
//       Get.snackbar("Validation Error", "Valid discount percentage is required (1-100)");
//       return;
//     }
//
//     if (bannerImage.value == null) {
//       Get.snackbar("Validation Error", "Offer banner is required");
//       return;
//     }
//
//     try {
//       isCreatingOffer.value = true;
//
//       final token = box.read("auth_token");
//       if (token == null) {
//         Get.snackbar("Error", "Authentication token not found");
//         return;
//       }
//
//       final bytes = await bannerImage.value!.readAsBytes();
//       final extension = bannerImage.value!.path.split('.').last.toLowerCase();
//       final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
//       final offerBannerBase64 = "data:$mimeType;base64,${base64Encode(bytes)}";
//
//       // ✅ ONLY send discount_percentage + offer_banner
//       final requestBody = {
//         "discount_percentage": discountValue.toInt(),
//         "offer_banner": offerBannerBase64,
//       };
//
//       final response = await http.post(
//         Uri.parse(createOfferUrl),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       final body = jsonDecode(response.body);
//
//       if (body['status'] == 1 || body['status'] == true) {
//         final data = body['data'];
//
//         // ✅ Save offer_id — this is ALL that gets passed to Step 2
//         createdOfferId.value = data['offer_id'] is int
//             ? data['offer_id']
//             : int.parse(data['offer_id'].toString());
//
//         // ✅ Save discount % from API (not from text field)
//         createdDiscountPercentage.value = data['discount_percentage'] is int
//             ? data['discount_percentage']
//             : int.tryParse(data['discount_percentage'].toString());
//
//         // ✅ Save banner URL for display only
//         createdOfferBannerUrl.value = data['offer_banner']?.toString() ?? '';
//
//         offerCreated.value = true;
//         totalProductsAdded.value = 0;
//
//         Get.snackbar(
//           "Offer Created! 🎉",
//           "ID: #${createdOfferId.value} | ${createdDiscountPercentage.value}% off. Now add products.",
//           backgroundColor: const Color(0xFF10B981),
//           colorText: Colors.white,
//           duration: const Duration(seconds: 4),
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       } else {
//         String errorMessage = body['message'] ?? "Failed to create offer";
//         if (body['errors'] != null) errorMessage += "\n${body['errors']}";
//         Get.snackbar("Error", errorMessage,
//             backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to create offer: $e",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isCreatingOffer.value = false;
//     }
//   }
//
//   // ============================================================
//   //  STEP 2 — ADD PRODUCT TO OFFER
//   //
//   //  REQUEST  → {
//   //    "offer_id": 252,          ← ONLY link to Step 1
//   //    "products": [
//   //      {
//   //        "product_name": "...",
//   //        "category_id": 19,    ← int
//   //        "description": "...",
//   //        "common_attributes": { "material": "Cotton", ... },
//   //        "variants": [
//   //          {
//   //            "attributes": { "color": "Red", "size": "M" },
//   //            "price": 1000,    ← int
//   //            "offer_price": 800,
//   //            "stock": 10,
//   //            "image": "base64..."
//   //          }
//   //        ]
//   //      }
//   //    ]
//   //  }
//   //
//   //  ✅ Does NOT send discount_percentage or offer_banner again
//   //     Those are already saved in the offers table via Step 1
//   // ============================================================
//   Future<void> saveOfferProduct() async {
//     if (isSubmitting.value) return;
//
//     if (createdOfferId.value == null) {
//       Get.snackbar("Error", "Please create the offer first before adding products.");
//       return;
//     }
//
//     if (!validateProductForm()) return;
//
//     if (totalProductsAdded.value >= 10) {
//       Get.snackbar(
//         "Limit Reached", "Maximum 10 products allowed per offer.",
//         backgroundColor: const Color(0xFFEF4444),
//         colorText: Colors.white,
//       );
//       return;
//     }
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
//       // ✅ Use discount from API response — NOT from the text field
//       //    Text field is locked after Step 1 and should not be read again
//       final double discount = createdDiscountPercentage.value?.toDouble() ?? 0.0;
//
//       // Build variants
//       final List<Map<String, dynamic>> variantsData = [];
//
//       for (int i = 0; i < variants.length; i++) {
//         final variant = variants[i];
//
//         String? imageBase64;
//         if (variant.imagePath != null) {
//           final imageFile = File(variant.imagePath!);
//           final bytes = await imageFile.readAsBytes();
//           final extension = variant.imagePath!.split('.').last.toLowerCase();
//           final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
//           imageBase64 = "data:$mimeType;base64,${base64Encode(bytes)}";
//         }
//
//         // Calculate offer_price using the locked discount from API
//         double? offerPrice;
//         if (discount > 0 && variant.price != null && variant.price! > 0) {
//           offerPrice = variant.price! - (variant.price! * discount / 100);
//         }
//
//         final variantMap = <String, dynamic>{
//           "attributes": variant.attributes,     // {"color": "Red", "size": "M"}
//           "price": variant.price!.round(),      // int
//           "stock": variant.stock,
//         };
//
//         if (offerPrice != null) {
//           variantMap["offer_price"] = offerPrice.round();
//         }
//         if (imageBase64 != null) {
//           variantMap["image"] = imageBase64;
//         }
//
//         variantsData.add(variantMap);
//       }
//
//       // ✅ Final request — offer_id + products array ONLY
//       //    No banner, no discount_percentage — already in DB from Step 1
//       final requestBody = {
//         "offer_id": createdOfferId.value,
//         "products": [
//           {
//             "product_name": productName.value.trim(),
//             "category_id": selectedCategoryId.value,   // int
//             "description": productDescription.value.trim(),
//             "common_attributes": Map<String, dynamic>.from(commonAttributes),
//             "variants": variantsData,
//           }
//         ],
//       };
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
//       final body = jsonDecode(response.body);
//
//       if (body['status'] == 1 || body['status'] == true) {
//         totalProductsAdded.value++;
//         final remaining = 10 - totalProductsAdded.value;
//
//         Get.snackbar(
//           "Product ${totalProductsAdded.value} Added! ✓",
//           remaining > 0
//               ? "${body['message'] ?? 'Product added successfully'} · $remaining slot(s) left"
//               : "All 10 slots used. Tap Done to finish.",
//           backgroundColor: const Color(0xFF10B981),
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//           snackPosition: SnackPosition.BOTTOM,
//         );
//
//         // ✅ Clear only the product form — offer_id & discount stay intact
//         _clearProductForm();
//       } else {
//         String errorMessage = body['message'] ?? "Failed to add product";
//         if (body['errors'] != null) errorMessage += "\n${body['errors']}";
//         Get.snackbar("Error", errorMessage,
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//             duration: const Duration(seconds: 4));
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to add product: $e",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
//
//   // ============== CATEGORY HELPERS ==============
//   void onCategoryChanged(String category) {
//     selectedCategory.value = category;
//
//     final cat = apiCategories.firstWhere(
//           (c) => c.name == category,
//       orElse: () => OfferCategoryApiModel(
//           id: 0, name: '', image: '', commonAttributes: [], variantAttributes: []),
//     );
//
//     selectedCategoryId.value = cat.id;
//     selectedVariantType.value = '';
//     currentPrimaryValue.value = '';
//     currentSecondaryValues.clear();
//     variantTypeConfigurations.clear();
//     commonAttributes.clear();
//     variants.clear();
//     primaryValueController.clear();
//     secondaryValueController.clear();
//   }
//
//   bool hasVariantAttributes() {
//     final config = categoryConfigs[selectedCategory.value];
//     return config != null && config.variantAttributes.isNotEmpty;
//   }
//
//   void setCommonAttribute(String attribute, String value) {
//     commonAttributes[attribute] = value;
//   }
//
//   // ============== VARIANT HELPERS ==============
//   void onVariantTypeSelected(String variantType) {
//     selectedVariantType.value = variantType;
//     currentPrimaryValue.value = '';
//     currentSecondaryValues.clear();
//     primaryValueController.clear();
//     secondaryValueController.clear();
//   }
//
//   void addPrimaryValue(String value) {
//     if (value.trim().isEmpty) return;
//     if (selectedVariantType.value.isEmpty) {
//       Get.snackbar("Error", "Please select a variant type first",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//     if (!variantTypeConfigurations.containsKey(selectedVariantType.value)) {
//       variantTypeConfigurations[selectedVariantType.value] = {};
//     }
//     if (variantTypeConfigurations[selectedVariantType.value]!.containsKey(value)) {
//       Get.snackbar("Duplicate", "$value already exists",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//     currentPrimaryValue.value = value;
//     currentSecondaryValues.clear();
//     primaryValueController.clear();
//     variantTypeConfigurations.refresh();
//   }
//
//   void addSecondaryValue(String value) {
//     if (value.trim().isEmpty) return;
//     if (currentPrimaryValue.value.isEmpty) {
//       Get.snackbar("Error", "Please add a ${selectedVariantType.value} value first",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//     if (!currentSecondaryValues.contains(value)) {
//       currentSecondaryValues.add(value);
//       secondaryValueController.clear();
//       currentSecondaryValues.refresh();
//     } else {
//       Get.snackbar("Duplicate", "$value already exists",
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   void removeSecondaryValue(String value) {
//     currentSecondaryValues.remove(value);
//     currentSecondaryValues.refresh();
//   }
//
//   void savePrimaryWithSecondary() {
//     if (currentPrimaryValue.value.isEmpty) {
//       Get.snackbar("Error", "Please add a ${selectedVariantType.value} value",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//     if (currentSecondaryValues.isEmpty) {
//       Get.snackbar("Error", "Please add at least one secondary attribute",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     variantTypeConfigurations[selectedVariantType.value]![currentPrimaryValue.value] =
//         List.from(currentSecondaryValues);
//
//     currentPrimaryValue.value = '';
//     currentSecondaryValues.clear();
//     primaryValueController.clear();
//     secondaryValueController.clear();
//     variantTypeConfigurations.refresh();
//
//     Get.snackbar("Saved", "Configuration saved",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: const Color(0xFF10B981),
//         colorText: Colors.white);
//   }
//
//   void removePrimaryValue(String primaryKey) {
//     variantTypeConfigurations[selectedVariantType.value]?.remove(primaryKey);
//     if (variantTypeConfigurations[selectedVariantType.value]?.isEmpty ?? false) {
//       variantTypeConfigurations.remove(selectedVariantType.value);
//     }
//     variantTypeConfigurations.refresh();
//   }
//
//   void generateVariantsFromConfiguration() {
//     if (variantTypeConfigurations.isEmpty) {
//       Get.snackbar("Error", "Please configure at least one variant type",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     variants.clear();
//
//     for (var typeEntry in variantTypeConfigurations.entries) {
//       final String variantType = typeEntry.key;
//       for (var primaryEntry in typeEntry.value.entries) {
//         final String primaryValue = primaryEntry.key;
//         for (var secondaryValue in primaryEntry.value) {
//           variants.add(OfferProductVariant(
//             attributes: {
//               variantType: primaryValue,
//               _getSecondaryAttributeName(): secondaryValue,
//             },
//             price: null,
//             offerPrice: null,
//             stock: null,
//           ));
//         }
//       }
//     }
//
//     Get.snackbar("Success", "${variants.length} variant(s) generated",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: const Color(0xFF10B981),
//         colorText: Colors.white);
//   }
//
//   String _getSecondaryAttributeName() {
//     final config = categoryConfigs[selectedCategory.value];
//     if (config == null || config.variantAttributes.length < 2) return "size";
//     return config.variantAttributes[1];
//   }
//
//   void removeVariant(int index) {
//     if (index >= 0 && index < variants.length) {
//       variants.removeAt(index);
//     }
//   }
//
//   Future<void> pickImage(int index) async {
//     if (index < 0 || index >= variants.length) return;
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 1920,
//       maxHeight: 1920,
//       imageQuality: 85,
//     );
//     if (pickedFile != null) {
//       variants[index].imagePath = pickedFile.path;
//       variants.refresh();
//     }
//   }
//
//   void updateVariantPrice(int index, double? price) {
//     if (index >= 0 && index < variants.length) {
//       variants[index].price = price;
//       variants[index].offerPrice = _calculateOfferPrice(price);
//       variants.refresh();
//     }
//   }
//
//   // ✅ After offer is created → uses createdDiscountPercentage (from API)
//   //    Before offer is created → uses text field value (for preview only)
//   double? _calculateOfferPrice(double? price) {
//     if (price == null || price <= 0) return null;
//     final discount = offerCreated.value
//         ? (createdDiscountPercentage.value?.toDouble() ?? 0.0)
//         : (double.tryParse(discountPercentageCtrl.text) ?? 0.0);
//     if (discount <= 0 || discount > 100) return null;
//     return price - (price * discount / 100);
//   }
//
//   // ============== VALIDATION ==============
//   bool validateProductForm() {
//     if (productName.value.trim().isEmpty) {
//       Get.snackbar("Validation Error", "Product name is required");
//       return false;
//     }
//     if (selectedCategory.value.isEmpty) {
//       Get.snackbar("Validation Error", "Category is required");
//       return false;
//     }
//     if (productDescription.value.trim().isEmpty) {
//       Get.snackbar("Validation Error", "Product description is required");
//       return false;
//     }
//     final config = categoryConfigs[selectedCategory.value];
//     if (config != null) {
//       for (var attr in config.commonAttributes) {
//         if (commonAttributes[attr]?.trim().isEmpty ?? true) {
//           Get.snackbar("Validation Error", "$attr is required");
//           return false;
//         }
//       }
//     }
//     if (variants.isEmpty) {
//       Get.snackbar("Validation Error", "At least one variant is required");
//       return false;
//     }
//     for (int i = 0; i < variants.length; i++) {
//       final v = variants[i];
//       if (v.price == null || v.price! <= 0) {
//         Get.snackbar("Validation Error", "Variant ${i + 1}: Valid price is required");
//         return false;
//       }
//       if (v.stock == null || v.stock! < 0) {
//         Get.snackbar("Validation Error", "Variant ${i + 1}: Valid stock is required");
//         return false;
//       }
//       if (v.imagePath == null) {
//         Get.snackbar("Validation Error", "Variant ${i + 1}: Image is required");
//         return false;
//       }
//     }
//     return true;
//   }
//
//   // ============== CLEAR HELPERS ==============
//
//   // ✅ Resets product form only — offer_id, discount, banner URL stay intact
//   //    Called after each successful product add
//   void _clearProductForm() {
//     productName.value = '';
//     selectedCategory.value = '';
//     selectedCategoryId.value = 0;
//     productDescription.value = '';
//     variants.clear();
//     selectedVariantType.value = '';
//     currentPrimaryValue.value = '';
//     currentSecondaryValues.clear();
//     variantTypeConfigurations.clear();
//     commonAttributes.clear();
//     primaryValueController.clear();
//     secondaryValueController.clear();
//   }
//
//   // ✅ Full reset — called only when user taps Done (finishOffer)
//   void _clearAll() {
//     discountPercentageCtrl.clear();
//     bannerImage.value = null;
//     offerCreated.value = false;
//     createdOfferId.value = null;
//     createdOfferBannerUrl.value = '';
//     createdDiscountPercentage.value = null;
//     totalProductsAdded.value = 0;
//     _clearProductForm();
//   }
//
//   void finishOffer() {
//     final result = {
//       'success': true,
//       'offer_id': createdOfferId.value,
//       'total_products': totalProductsAdded.value,
//     };
//     _clearAll();
//     Get.back(result: result);
//     Get.delete<IntegratedOfferController>();
//   }
//
//   @override
//   void onClose() {
//     discountPercentageCtrl.dispose();
//     primaryValueController.dispose();
//     secondaryValueController.dispose();
//     super.onClose();
//   }
// }