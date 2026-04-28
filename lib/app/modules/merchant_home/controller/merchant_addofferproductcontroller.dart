
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../views/merchant_home.dart';
import '../views/merchant_offerviewpage.dart';
import 'merchant_offerbanner_controller.dart';

class AddOfferProductController extends GetxController {
  final box = GetStorage();

  final int offerId;
  final double discountPercentage;

  AddOfferProductController({
    required this.offerId,
    required this.discountPercentage,
  });

  // ── API URLs ───────────────────────────────────────────────
  static const String _categoriesUrl =
      "https://eshoppy.co.in/api/merchant/categories";
  static const String _addOfferProductUrl =
      "https://eshoppy.co.in/api/offers/add-products";

  String get _token => box.read("auth_token") ?? "";

  Map<String, String> get _headers => {
    "Accept"        : "application/json",
    "Content-Type"  : "application/json",
    "Authorization" : "Bearer $_token",
  };

  // ── Basic fields ───────────────────────────────────────────
  var productName        = ''.obs;
  var selectedCategory   = ''.obs;
  var selectedCategoryId = 0.obs;
  var productDescription = ''.obs;

  // ── Loading states ─────────────────────────────────────────
  var isLoadingCategories = false.obs;
  var isSubmitting        = false.obs;
  var totalProductsAdded  = 0.obs;

  // ── Category data ──────────────────────────────────────────
  var apiCategories = <CategoryApiModel>[].obs;
  final Map<String, CategoryConfig> categoryConfigs = {};

  // ── Common attributes (optional) ───────────────────────────
  var commonAttributes = <String, String>{}.obs;

  // ── Variant type selection ─────────────────────────────────
  var selectedVariantType    = ''.obs;
  var expandedVariantType    = ''.obs;
  var currentVariantValues   = <String>[].obs;
  final TextEditingController variantValueController =
  TextEditingController();
  var configuredVariantTypes = <String, List<String>>{}.obs;

  // ── Variants ───────────────────────────────────────────────
  var variants          = <OfferProductVariant>[].obs;
  var variantImagePaths = <int, String>{}.obs;

  final ImagePicker picker = ImagePicker();
  // Add these two declarations with your other TextEditingControllers
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    variantValueController.dispose();
    super.onClose();
  }


  // ── Fetch categories ───────────────────────────────────────
  Future<void> fetchCategories() async {

    isLoadingCategories.value = true;

    try {
      final response = await http.get(
        Uri.parse(_categoriesUrl),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        return;
      }

      final body = jsonDecode(response.body);

      if (_isSuccess(body['status'])) {
        final List<dynamic> categoriesData = body['data'] ?? [];

        apiCategories.clear();
        categoryConfigs.clear();

        for (var catData in categoriesData) {
          try {
            final int    id    = _parseInt(catData['id']);
            final String name  = catData['name']?.toString() ?? '';
            final String image = catData['image']?.toString() ?? '';

            List<String> commonAttrs  = [];
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

            apiCategories.add(CategoryApiModel(
              id               : id,
              name             : name,
              image            : image,
              commonAttributes : commonAttrs,
              variantAttributes: variantAttrs,
            ));

            categoryConfigs[name] = CategoryConfig(
              id               : id,
              commonAttributes : commonAttrs,
              variantAttributes: variantAttrs,
            );
          } catch (e) {
            debugPrint("Error parsing category: $e");
          }
        }
      } else {
        AppSnackbar.error(
          body['message']?.toString().isNotEmpty == true
              ? body['message']
              : 'Failed to fetch categories.',
        );
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ── Category change ────────────────────────────────────────
  void onCategoryChanged(String category) {
    selectedCategory.value = category;

    final cat = apiCategories.firstWhere(
          (c) => c.name == category,
      orElse: () => CategoryApiModel(
          id: 0, name: '', image: '',
          commonAttributes: [], variantAttributes: []),
    );
    selectedCategoryId.value = cat.id;

    selectedVariantType.value = '';
    expandedVariantType.value = '';
    currentVariantValues.clear();
    configuredVariantTypes.clear();
    commonAttributes.clear();
    variants.clear();
    variantImagePaths.clear();
    variantValueController.clear();
   // ← ADD
  }

  bool hasVariantAttributes() {
    final config = categoryConfigs[selectedCategory.value];
    return config != null && config.variantAttributes.isNotEmpty;
  }

  // ── Common attributes (optional — just store if filled) ────
  void setCommonAttribute(String attribute, String value) {
    if (value.trim().isEmpty) {
      commonAttributes.remove(attribute);
    } else {
      commonAttributes[attribute] = value.trim();
    }
  }

  // ── Variant type selection ─────────────────────────────────
  void onVariantTypeSelected(String variantType) {
    if (selectedVariantType.value.isNotEmpty &&
        currentVariantValues.isNotEmpty) {
      configuredVariantTypes[selectedVariantType.value] =
          List.from(currentVariantValues);
    }

    selectedVariantType.value   = variantType;
    currentVariantValues.value  =
        List.from(configuredVariantTypes[variantType] ?? []);

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

    final newCombinations   = _generateAllCombinations();
    final combinationsToAdd = newCombinations
        .where((combo) =>
    !variants.any((v) => _areMapsEqual(v.attributes, combo)))
        .toList();

    for (var combo in combinationsToAdd) {
      variants.add(OfferProductVariant(attributes: combo));
    }

    _rebuildImagePathMap();

    if (combinationsToAdd.isNotEmpty) {
      AppSnackbar.success(
          "${combinationsToAdd.length} variant(s) added! Total: ${variants.length}");
    } else {
      AppSnackbar.warning("All variants already exist.");
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

    final types     = configuredVariantTypes.keys.toList();
    final allValues = types.map((t) => configuredVariantTypes[t]!).toList();
    final results   = <Map<String, String>>[];

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

  void _rebuildImagePathMap() {
    final updated = <int, String>{};
    for (int i = 0; i < variants.length; i++) {
      final path = variants[i].imagePath;
      if (path != null) updated[i] = path;
    }
    variantImagePaths.assignAll(updated);
  }

  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants.removeAt(index);
      _rebuildImagePathMap();
    }
  }

  Future<void> pickImage(int index) async {
    if (index < 0 || index >= variants.length) return;

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        variants[index].imagePath   = pickedFile.path;
        variantImagePaths[index]    = pickedFile.path;
        variantImagePaths.refresh();
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < variants.length) {
      variants[index].imagePath = null;
      variantImagePaths.remove(index);
      variantImagePaths.refresh();
    }
  }

  double? computeOfferPrice(double originalPrice) {
    if (originalPrice <= 0) return null;
    return originalPrice - (originalPrice * discountPercentage / 100);
  }

  // ── Validation ─────────────────────────────────────────────
  // Common attributes are OPTIONAL — only variant fields are mandatory
  bool validateForm() {
    if (productName.value.trim().isEmpty) {
      AppSnackbar.warning("Product name is required");
      return false;
    }

    if (selectedCategory.value.isEmpty) {
      AppSnackbar.warning("Please select a category");
      return false;
    }

    // ✅ Variant attribute — at least one variant required
    if (variants.isEmpty) {
      AppSnackbar.warning(
          "Please generate at least one variant");
      return false;
    }

    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];
      final label   =
          "Variant ${i + 1} (${variant.getDisplayName()})";

      if (variant.price == null || variant.price! <= 0) {
        AppSnackbar.warning("$label: Valid price is required");
        return false;
      }
      if (variant.imagePath == null) {
        AppSnackbar.warning("$label: Image is required");
        return false;
      }
    }

    if (totalProductsAdded.value >= 10) {
      AppSnackbar.warning("Maximum 10 products limit reached!");
      return false;
    }

    return true;
  }

  // ── Save offer product ─────────────────────────────────────
  Future<void> saveOfferProduct() async {
    if (!validateForm()) return;

    isSubmitting.value = true;

    try {
      final List<Map<String, dynamic>> variantsData = [];

      for (final variant in variants) {
        String? imageBase64;
        if (variant.imagePath != null) {
          final bytes = await File(variant.imagePath!).readAsBytes();
          final ext   = variant.imagePath!.split('.').last.toLowerCase();
          final mime  = ext == 'png' ? 'image/png' : 'image/jpeg';
          imageBase64 = "data:$mime;base64,${base64Encode(bytes)}";
        }

        variantsData.add({
          "attributes": variant.attributes,
          "price"     : variant.price,
          "stock"     : variant.stock,
          "image"     : imageBase64,
        });
      }

      final Map<String, dynamic> productEntry = {
        "product_name": productName.value.trim(),
        "category_id" : selectedCategoryId.value,
        "variants"    : variantsData,
      };

      // ✅ Common attributes — only include if any were filled
      if (commonAttributes.isNotEmpty) {
        productEntry["common_attributes"] =
        Map<String, String>.from(commonAttributes);
      }

      if (productDescription.value.trim().isNotEmpty) {
        productEntry["description"] = productDescription.value.trim();
      }

      final requestBody = {
        "offer_id": offerId,
        "products": [productEntry],
      };

      final response = await http.post(
        Uri.parse(_addOfferProductUrl),
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        return;
      }

      final body  = jsonDecode(response.body) as Map<String, dynamic>;
      final isOk  = _isSuccess(body['status']);

      if (isOk) {
        final List<dynamic> savedProducts =
            (body['data'] as List<dynamic>?) ?? [];

        // ── Parse server response → hydrate variants with
        //    server-assigned IDs and final (discounted) prices ──
        if (savedProducts.isNotEmpty) {
          final productWrapper =
          savedProducts.first as Map<String, dynamic>;
          final productData =
          productWrapper['product'] as Map<String, dynamic>?;

          if (productData != null) {
            final int? returnedProductId =
            productData['product_id'] as int?;

            final List<dynamic> returnedVariants =
                (productData['variants'] as List<dynamic>?) ?? [];

            for (int i = 0; i < variants.length; i++) {
              if (i < returnedVariants.length) {
                final rv =
                returnedVariants[i] as Map<String, dynamic>;

                variants[i].variantId  = rv['variant_id'] as int?;
                variants[i].productId  = returnedProductId;
                variants[i].finalPrice =
                    double.tryParse(rv['final_price']?.toString() ?? '');
                variants[i].serverImage =
                    rv['image']?.toString();
              }
            }
            variants.refresh();
          }
        }

        // Each API call saves exactly 1 product
        totalProductsAdded.value += 1;

        AppSnackbar.success(
          body['message']?.toString().isNotEmpty == true
              ? body['message']
              : 'Product added to offer successfully.',
        );

        _clearForm();
      }

      else {
        AppSnackbar.error(
          body['message']?.toString().isNotEmpty == true
              ? body['message']
              : 'Failed to add product to offer.',
        );
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Finish offer → go back & refresh offer list ────────────
  void finishOffer() {
    if (totalProductsAdded.value == 0) {
      AppSnackbar.warning("Please add at least one product before finishing.");
      return;
    }

    // ✅ Navigate directly to the widget — no named route needed
    // Get.off(() =>  MerchantOfferViewPage());
    Get.offAll(()=>MerchantDashboardPage());

    if (Get.isRegistered<MerchantOfferBannerController>()) {
      Get.find<MerchantOfferBannerController>().fetchOffers();
    }
  }

  // ── Reset form ─────────────────────────────────────────────
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
              AppSnackbar.warning("All fields have been cleared");
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    productNameController.clear();        // ← ADD
    productDescriptionController.clear();
    productName.value        = '';
    selectedCategory.value   = '';
    selectedCategoryId.value = 0;
    productDescription.value = '';
    variants.clear();
    variantImagePaths.clear();
    selectedVariantType.value    = '';
    expandedVariantType.value    = '';
    currentVariantValues.clear();
    configuredVariantTypes.clear();
    commonAttributes.clear();
    variantValueController.clear();
  }

  // ── Helpers ────────────────────────────────────────────────
  bool _isSuccess(dynamic status) =>
      status == true || status == 1 || status == '1';

  int _parseInt(dynamic value) =>
      value is int ? value : int.parse(value.toString());
}

// ── Models ─────────────────────────────────────────────────────────────────

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
  int?    stock;
  String? imagePath;

  // ── Server-returned fields (populated after save) ──
  int?    variantId;
  double? finalPrice;   // ← discounted price from API
  int?    productId;
  String? serverImage;  // ← URL returned by server

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