

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class IntegratedOfferController extends GetxController {
  final box = GetStorage();

  // API URLs
  final String categoriesUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/categories";
  final String addOfferProductUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/offers/product";

  // ============== OFFER DETAILS ==============
  final TextEditingController discountPercentageCtrl = TextEditingController();
  var bannerImage = Rx<File?>(null);

  // ============== PRODUCT DETAILS ==============
  var productName = ''.obs;
  var selectedCategory = ''.obs;
  var selectedCategoryId = 0.obs;
  var productDescription = ''.obs;

  // Loading states
  var isLoadingCategories = false.obs;
  var isSubmitting = false.obs;

  // ============== CATEGORY DATA ==============
  var apiCategories = <OfferCategoryApiModel>[].obs;
  final Map<String, OfferCategoryConfig> categoryConfigs = {};

  // ============== COMMON ATTRIBUTES ==============
  var commonAttributes = <String, String>{}.obs;

  // ============== VARIANT CONFIGURATION ==============
  var variantTypeConfigurations = <String, Map<String, List<String>>>{}.obs;
  var selectedVariantType = ''.obs;
  var currentPrimaryValue = ''.obs;
  var currentSecondaryValues = <String>[].obs;

  final TextEditingController primaryValueController = TextEditingController();
  final TextEditingController secondaryValueController = TextEditingController();

  // ============== VARIANTS ==============
  var variants = <OfferProductVariant>[].obs;

  // ============== IMAGE PICKER ==============
  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // ============== PICK BANNER IMAGE ==============
  Future<void> pickBannerImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        bannerImage.value = File(pickedFile.path);
        Get.snackbar(
          "Success",
          "Banner image selected",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFF10B981),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick banner: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ============== FETCH CATEGORIES ==============
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
          final List categoriesData = body['data'];
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

              final category = OfferCategoryApiModel(
                id: id,
                name: name,
                image: image,
                commonAttributes: commonAttrs,
                variantAttributes: variantAttrs,
              );

              apiCategories.add(category);
              categoryConfigs[name] = OfferCategoryConfig(
                id: id,
                commonAttributes: commonAttrs,
                variantAttributes: variantAttrs,
              );

              print(
                  "✓ Loaded: $name (Common: ${commonAttrs.length}, Variant: ${variantAttrs.length})");
            } catch (e) {
              print("Error parsing category: $e");
            }
          }

          print("✓ Total categories loaded: ${apiCategories.length}");
        } else {
          Get.snackbar("Error", body['message'] ?? "Failed to fetch categories");
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

  // ============== CATEGORY CHANGE ==============
  void onCategoryChanged(String category) {
    selectedCategory.value = category;
    final cat = apiCategories.firstWhere(
          (c) => c.name == category,
      orElse: () => OfferCategoryApiModel(
        id: 0,
        name: '',
        image: '',
        commonAttributes: [],
        variantAttributes: [],
      ),
    );

    selectedCategoryId.value = cat.id;
    selectedVariantType.value = '';
    currentPrimaryValue.value = '';
    currentSecondaryValues.clear();
    variantTypeConfigurations.clear();
    commonAttributes.clear();
    variants.clear();
    primaryValueController.clear();
    secondaryValueController.clear();

    print("Category changed to: $category");
  }

  bool hasVariantAttributes() {
    final config = categoryConfigs[selectedCategory.value];
    return config != null && config.variantAttributes.isNotEmpty;
  }

  // ============== COMMON ATTRIBUTES ==============
  void setCommonAttribute(String attribute, String value) {
    commonAttributes[attribute] = value;
  }

  // ============== VARIANT TYPE SELECTION ==============
  void onVariantTypeSelected(String variantType) {
    selectedVariantType.value = variantType;
    currentPrimaryValue.value = '';
    currentSecondaryValues.clear();
    primaryValueController.clear();
    secondaryValueController.clear();
  }

  // ============== PRIMARY VALUE ==============
  void addPrimaryValue(String value) {
    if (value.trim().isEmpty) return;

    if (selectedVariantType.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a variant type first",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!variantTypeConfigurations.containsKey(selectedVariantType.value)) {
      variantTypeConfigurations[selectedVariantType.value] = {};
    }

    if (variantTypeConfigurations[selectedVariantType.value]!
        .containsKey(value)) {
      Get.snackbar(
        "Duplicate",
        "$value already exists",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    currentPrimaryValue.value = value;
    currentSecondaryValues.clear();
    primaryValueController.clear();
    variantTypeConfigurations.refresh();
  }

  // ============== SECONDARY VALUES ==============
  void addSecondaryValue(String value) {
    if (value.trim().isEmpty) return;

    if (currentPrimaryValue.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add a ${selectedVariantType.value} value first",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!currentSecondaryValues.contains(value)) {
      currentSecondaryValues.add(value);
      secondaryValueController.clear();
      currentSecondaryValues.refresh();
    } else {
      Get.snackbar(
        "Duplicate",
        "$value already exists",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeSecondaryValue(String value) {
    currentSecondaryValues.remove(value);
    currentSecondaryValues.refresh();
  }

  void savePrimaryWithSecondary() {
    if (currentPrimaryValue.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add a ${selectedVariantType.value} value",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (currentSecondaryValues.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add at least one secondary attribute",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    variantTypeConfigurations[selectedVariantType.value]!
    [currentPrimaryValue.value] =
        List.from(currentSecondaryValues);

    currentPrimaryValue.value = '';
    currentSecondaryValues.clear();
    primaryValueController.clear();
    secondaryValueController.clear();

    variantTypeConfigurations.refresh();

    Get.snackbar(
      "Success",
      "Configuration saved",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  void removePrimaryValue(String primaryKey) {
    variantTypeConfigurations[selectedVariantType.value]?.remove(primaryKey);
    if (variantTypeConfigurations[selectedVariantType.value]?.isEmpty ?? false) {
      variantTypeConfigurations.remove(selectedVariantType.value);
    }
    variantTypeConfigurations.refresh();
  }

  // ============== GENERATE VARIANTS ==============
  void generateVariantsFromConfiguration() {
    if (variantTypeConfigurations.isEmpty) {
      Get.snackbar(
        "Error",
        "Please configure at least one variant type",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    variants.clear();
    List<Map<String, String>> combinations = _generateValidCombinations();

    for (var combo in combinations) {
      variants.add(OfferProductVariant(
        attributes: combo,
        price: null,
        offerPrice: null,
        stock: null,
      ));
    }

    Get.snackbar(
      "Success",
      "${variants.length} variant(s) generated",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  List<Map<String, String>> _generateValidCombinations() {
    List<Map<String, String>> results = [];

    for (var typeEntry in variantTypeConfigurations.entries) {
      String variantType = typeEntry.key;
      Map<String, List<String>> primaryToSecondary = typeEntry.value;

      for (var primaryEntry in primaryToSecondary.entries) {
        String primaryValue = primaryEntry.key;
        List<String> secondaryValues = primaryEntry.value;

        if (variantTypeConfigurations.length == 1) {
          for (var secondaryValue in secondaryValues) {
            results.add({
              variantType: primaryValue,
              _getSecondaryAttributeName(): secondaryValue,
            });
          }
        } else {
          for (var secondaryValue in secondaryValues) {
            results.add({
              variantType: primaryValue,
              _getSecondaryAttributeName(): secondaryValue,
            });
          }
        }
      }
    }

    return results;
  }

  String _getSecondaryAttributeName() {
    final config = categoryConfigs[selectedCategory.value];
    if (config == null || config.variantAttributes.length < 2) return "size";

    return config.variantAttributes.length > 1
        ? config.variantAttributes[1]
        : "attribute";
  }

  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants.removeAt(index);
    }
  }

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

  // ============== UPDATE VARIANT PRICE ==============
  void updateVariantPrice(int index, double? price) {
    if (index >= 0 && index < variants.length) {
      variants[index].price = price;
      variants[index].offerPrice = calculateOfferPrice(price);
      variants.refresh();
    }
  }

  // ============== CALCULATE OFFER PRICE ==============
  double? calculateOfferPrice(double? price) {
    if (price == null || price <= 0) return null;
    final discount = double.tryParse(discountPercentageCtrl.text) ?? 0.0;
    if (discount <= 0 || discount > 100) return null;
    return price - (price * discount / 100);
  }

  // ============== VALIDATION ==============
  bool validateForm() {
    // Validate offer details
    final discountValue = double.tryParse(discountPercentageCtrl.text);
    if (discountValue == null || discountValue <= 0 || discountValue > 100) {
      Get.snackbar("Validation Error",
          "Valid discount percentage is required (1-100)");
      return false;
    }

    if (bannerImage.value == null) {
      Get.snackbar("Validation Error", "Offer banner is required");
      return false;
    }

    // Validate product details
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
          "Variant ${i + 1}: Valid original price is required",
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

  // ============== SUBMIT TO API ==============
  Future<void> saveOfferProduct() async {
    if (!validateForm()) return;

    try {
      isSubmitting.value = true;
      final token = box.read("auth_token");

      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      print("📤 Starting offer product submission...");

      // Convert offer banner to base64
      String? offerBannerBase64;
      if (bannerImage.value != null) {
        final bytes = await bannerImage.value!.readAsBytes();
        final extension =
        bannerImage.value!.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';
        if (extension == 'png') {
          mimeType = 'image/png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        }
        offerBannerBase64 = "data:$mimeType;base64,${base64Encode(bytes)}";
        print("✓ Banner converted to base64");
      }

      // Build variants data for API
      List<Map<String, dynamic>> variantsData = [];
      for (int i = 0; i < variants.length; i++) {
        final variant = variants[i];

        // Convert image to base64
        String? imageBase64;
        if (variant.imagePath != null) {
          final imageFile = File(variant.imagePath!);
          final bytes = await imageFile.readAsBytes();
          final extension = variant.imagePath!.split('.').last.toLowerCase();
          String mimeType = 'image/jpeg';
          if (extension == 'png') {
            mimeType = 'image/png';
          } else if (extension == 'jpg' || extension == 'jpeg') {
            mimeType = 'image/jpeg';
          }
          imageBase64 = "data:$mimeType;base64,${base64Encode(bytes)}";
        }

        // Calculate offer price
        // final offerPrice = variant.offerPrice ?? calculateOfferPrice(variant.price);
        //
        // variantsData.add({
        //   "attributes": variant.attributes,
        //   "price": variant.price,
        //   "offer_price": offerPrice,
        //   "stock": variant.stock,
        //   "image": imageBase64,
        // });

        // ✅ Calculate offer price ONLY here (final & correct)
        final double discount =
            double.tryParse(discountPercentageCtrl.text.trim()) ?? 0;

        double? offerPrice;
        if (discount > 0 && variant.price != null) {
          offerPrice = variant.price! - (variant.price! * discount / 100);
        }

        variantsData.add({
          "attributes": variant.attributes,
          "price": variant.price!.round(),
          if (offerPrice != null) "offer_price": offerPrice.round(),
          "stock": variant.stock,
          "image": imageBase64,
        });



      }
      print("✓ ${variantsData.length} variant(s) prepared");

      // Build request body according to API spec
      final requestBody = {
        "discount_percentage":
        int.parse(discountPercentageCtrl.text.trim()),
        "offer_banner": offerBannerBase64,
        "product_name": productName.value.trim(),
        "description": productDescription.value.trim(),
        "category_id": selectedCategoryId.value,
        "common_attributes": commonAttributes,
        "variants": variantsData,
      };

      print("🌐 Sending request to: $addOfferProductUrl");
      print("📦 Request body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(addOfferProductUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      print("📥 Response received");
      print("   - Status Code: ${response.statusCode}");
      print("   - Body: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200 || body['status'] == 1 || body['status'] == true) {
        print("✅ Success!");
        Get.snackbar(
          "Success",
          body['message'] ?? "Offer product created successfully",
          backgroundColor: Color(0xFF10B981),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // Clear form after successful submission
        _clearForm();

        // Navigate back with success result
        Get.back(result: {
          'success': true,
          'data': body['data'],
        });
      } else {
        print("❌ Error: ${body['message']}");

        // Check if there are validation errors
        String errorMessage = body['message'] ?? "Failed to create offer product";
        if (body['errors'] != null) {
          errorMessage += "\n${body['errors']}";
        }

        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
        );
      }
    } catch (e) {
      print("💥 Exception occurred: $e");
      Get.snackbar(
        "Error",
        "Failed to save offer product: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
  void _clearForm() {
    // Clear offer details
    discountPercentageCtrl.clear();
    bannerImage.value = null;

    // Clear product details
    productName.value = '';
    selectedCategory.value = '';
    selectedCategoryId.value = 0;
    productDescription.value = '';
    variants.clear();
    selectedVariantType.value = '';
    currentPrimaryValue.value = '';
    currentSecondaryValues.clear();
    variantTypeConfigurations.clear();
    commonAttributes.clear();
    primaryValueController.clear();
    secondaryValueController.clear();
  }

  @override
  void onClose() {
    discountPercentageCtrl.dispose();
    primaryValueController.dispose();
    secondaryValueController.dispose();
    super.onClose();
  }
}

// ============== MODELS ==============
class OfferCategoryConfig {
  final int id;
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  OfferCategoryConfig({
    required this.id,
    required this.commonAttributes,
    required this.variantAttributes,
  });
}

class OfferCategoryApiModel {
  final int id;
  final String name;
  final String image;
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  OfferCategoryApiModel({
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
  double? offerPrice;
  int? stock;
  String? imagePath;

  OfferProductVariant({
    required this.attributes,
    this.price,
    this.offerPrice,
    this.stock,
    this.imagePath,
  });

  String getDisplayName() {
    if (attributes.isEmpty) return "Variant";
    return attributes.values.join(" - ");
  }
}

