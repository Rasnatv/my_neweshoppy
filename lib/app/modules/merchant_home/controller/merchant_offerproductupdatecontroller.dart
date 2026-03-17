import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../views/merchant_offerproductview.dart';

class KEditOfferProductController extends GetxController {
  final box = GetStorage();
  final int productId;
  final int offerId;

  KEditOfferProductController({
    required this.productId,
    required this.offerId,
  });

  // ── API endpoints ─────────────────────────────────────────────────────────
  static const String _fetchUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/get-updated-offer-product";
  static const String _updateUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/update-offer-product";
  static const String _categoriesUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/categories";

  static const String _imageBaseUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/storage/";

  // ── Auth ──────────────────────────────────────────────────────────────────
  String get _token => box.read("auth_token") ?? "";

  Map<String, String> get _headers => {
    "Accept": "application/json",
    "Authorization": "Bearer $_token",
    "Content-Type": "application/json",
  };

  // ── Loading / UI states ───────────────────────────────────────────────────
  final isLoadingProduct = false.obs;
  final isLoadingCategories = false.obs;
  final isSubmitting = false.obs;

  // ── Form text controllers ─────────────────────────────────────────────────
  late final TextEditingController productNameController;
  late final TextEditingController productDescriptionController;

  // ── Reactive form fields ──────────────────────────────────────────────────
  final productName = ''.obs;
  final productDescription = ''.obs;
  final selectedCategory = ''.obs;
  final selectedCategoryId = 0.obs;
  final discountPercentage = 0.0.obs;

  // ── Category data ─────────────────────────────────────────────────────────
  final apiCategories = <KEditCategoryApiModel>[].obs;
  final Map<String, KEditCategoryConfig> categoryConfigs = {};

  // ── Common attributes ─────────────────────────────────────────────────────
  final commonAttributes = <String, String>{}.obs;
  final Map<String, TextEditingController> commonAttrControllers = {};

  // ── Variant configuration ─────────────────────────────────────────────────
  final selectedVariantType = ''.obs;
  final currentVariantValues = <String>[].obs;
  final configuredVariantTypes = <String, List<String>>{}.obs;
  final variantValueController = TextEditingController();

  // ── Variants list ─────────────────────────────────────────────────────────
  final variants = <KEditOfferVariant>[].obs;

  final ImagePicker _picker = ImagePicker();

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    productNameController = TextEditingController();
    productDescriptionController = TextEditingController();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await fetchCategories();
    await fetchProductDetail();
  }

  // ── Fetch categories ──────────────────────────────────────────────────────
  Future<void> fetchCategories() async {
    if (_token.isEmpty) {
      Get.snackbar("Error", "Token missing. Please login again.");
      return;
    }
    try {
      isLoadingCategories.value = true;
      final response = await http.get(
        Uri.parse(_categoriesUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      );
      debugPrint("📡 fetchCategories status : ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final status = body['status'];
        if (status == true || status == 1 || status == '1') {
          final List<dynamic> data = body['data'] ?? [];
          apiCategories.clear();
          categoryConfigs.clear();

          for (var catData in data) {
            try {
              final int id = catData['id'] is int
                  ? catData['id']
                  : int.parse(catData['id'].toString());
              final String name = catData['name']?.toString() ?? '';
              final String image = catData['image']?.toString() ?? '';

              List<String> commonAttrs = [];
              List<String> variantAttrs = [];

              if (catData['attributes'] != null) {
                final attrs = catData['attributes'];
                if (attrs is Map) {
                  if (attrs['common'] is List)
                    commonAttrs = List<String>.from(attrs['common']);
                  if (attrs['variant'] is List)
                    variantAttrs = List<String>.from(attrs['variant']);
                } else if (attrs is List) {
                  variantAttrs = List<String>.from(attrs);
                }
              }

              apiCategories.add(KEditCategoryApiModel(
                id: id,
                name: name,
                image: image,
                commonAttributes: commonAttrs,
                variantAttributes: variantAttrs,
              ));
              categoryConfigs[name] = KEditCategoryConfig(
                id: id,
                commonAttributes: commonAttrs,
                variantAttributes: variantAttrs,
              );
            } catch (e) {
              debugPrint("Category parse error: $e");
            }
          }
          debugPrint("✅ Loaded ${apiCategories.length} categories");
        }
      }
    } catch (e) {
      debugPrint("❌ fetchCategories error: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ── FIX: Send both product_id AND offer_product_id so server finds the
  //         exact offer-product record, not just the base catalog product.
  Future<void> fetchProductDetail() async {
    if (_token.isEmpty) {
      Get.snackbar("Error", "Token missing. Please login again.");
      return;
    }
    try {
      isLoadingProduct.value = true;

      final response = await http.post(
        Uri.parse(_fetchUrl),
        headers: _headers,
        body: jsonEncode({
          "product_id": productId,
          "offer_product_id": offerId, // ✅ FIX: was missing
        }),
      );

      debugPrint("📡 fetchProductDetail status : ${response.statusCode}");
      debugPrint("📥 body                      : ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final status = body['status'];
        if (status == 1 || status == true || status == '1') {
          _populateForm(body['data'] as Map<String, dynamic>);
        } else {
          Get.snackbar("Error", body['message'] ?? "Failed to load product");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ fetchProductDetail error: $e");
      Get.snackbar("Error", "Failed to load product: $e");
    } finally {
      isLoadingProduct.value = false;
    }
  }

  // ── Populate every form field from API response data ──────────────────────
  void _populateForm(Map<String, dynamic> data) {
    debugPrint("🔧 _populateForm: $data");

    final name = data['product_name']?.toString() ?? '';
    final desc = data['description']?.toString() ?? '';

    productName.value = name;
    productDescription.value = desc;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productNameController.text = name;
      productDescriptionController.text = desc;
    });

    // ── Category ──────────────────────────────────────────────────────
    final int catId =
        int.tryParse(data['category_id']?.toString() ?? '0') ?? 0;
    selectedCategoryId.value = catId;

    final matchedCat = apiCategories.firstWhereOrNull((c) => c.id == catId);
    if (matchedCat != null) {
      selectedCategory.value = matchedCat.name;
      debugPrint("✅ Category matched: '${matchedCat.name}' (id=$catId)");
    } else {
      debugPrint("⚠️ No category matched for id=$catId. "
          "Available: ${apiCategories.map((c) => '${c.id}:${c.name}').join(', ')}");
    }

    // ── Product attributes ────────────────────────────────────────────
    final productAttrs =
        data['product_attributes'] as Map<String, dynamic>? ?? {};

    commonAttributes.clear();
    _disposeCommonAttrControllers();

    final commonRaw =
        productAttrs['common_attributes'] as Map<String, dynamic>? ?? {};
    commonRaw.forEach((key, value) {
      final k = key.toString();
      final v = value?.toString() ?? '';
      commonAttributes[k] = v;
      commonAttrControllers[k] = TextEditingController(text: v);
    });

    final config = categoryConfigs[selectedCategory.value];
    if (config != null) {
      for (final attr in config.commonAttributes) {
        commonAttrControllers.putIfAbsent(
          attr,
              () => TextEditingController(text: commonAttributes[attr] ?? ''),
        );
      }
    }

    // ── Variants ──────────────────────────────────────────────────────
    for (var v in variants) v.disposeControllers();
    variants.clear();

    final rawVariants = productAttrs['variants'] as List? ?? [];
    debugPrint("🔧 variants from API: ${rawVariants.length}");

    if (rawVariants.isNotEmpty) {
      final first = rawVariants[0] as Map<String, dynamic>;
      final price = (first['price'] as num?)?.toDouble() ?? 0.0;
      final finalPrice = (first['final_price'] as num?)?.toDouble() ?? 0.0;
      if (price > 0) {
        discountPercentage.value =
            ((price - finalPrice) / price * 100).clamp(0.0, 100.0);
        debugPrint(
            "🔧 discount: ${discountPercentage.value.toStringAsFixed(1)}%");
      }
    }

    for (final rv in rawVariants) {
      final vm = rv as Map<String, dynamic>;

      final Map<String, String> attrs = {};
      (vm['attributes'] as Map<String, dynamic>? ?? {}).forEach((k, v) {
        attrs[k.toString()] = v?.toString() ?? '';
      });

      final double price = (vm['price'] as num?)?.toDouble() ?? 0.0;
      final int stock = (vm['stock'] as num?)?.toInt() ?? 0;
      final double finalPrice = (vm['final_price'] as num?)?.toDouble() ?? 0.0;
      final String? imageUrl = _toFullUrl(vm['image']?.toString());

      debugPrint(
          "🔧 variant: attrs=$attrs price=$price stock=$stock img=$imageUrl");

      variants.add(KEditOfferVariant(
        attributes: attrs,
        price: price,
        stock: stock,
        finalPrice: finalPrice,
        newImagePath: null,
        existingImageUrl: imageUrl,
      ));
    }

    if (variants.isEmpty) {
      debugPrint("⚠️ No variants from API — adding empty slot");
      variants.add(KEditOfferVariant(
        attributes: {},
        price: 0,
        stock: 0,
        finalPrice: 0,
        newImagePath: null,
        existingImageUrl: null,
      ));
    }

    configuredVariantTypes.clear();
    for (var variant in variants) {
      variant.attributes.forEach((key, value) {
        configuredVariantTypes.update(
          key,
              (existing) {
            if (!existing.contains(value)) existing.add(value);
            return existing;
          },
          ifAbsent: () => [value],
        );
      });
    }

    variants.refresh();
    commonAttributes.refresh();
    configuredVariantTypes.refresh();

    debugPrint("✅ _populateForm done — "
        "name='${productName.value}' "
        "cat='${selectedCategory.value}' "
        "variants=${variants.length}");
  }

  String? _toFullUrl(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '$_imageBaseUrl$path';
  }

  // ── Category change ───────────────────────────────────────────────────────
  void onCategoryChanged(String category) {
    selectedCategory.value = category;
    final cat = apiCategories.firstWhereOrNull((c) => c.name == category);
    selectedCategoryId.value = cat?.id ?? 0;
    selectedVariantType.value = '';
    currentVariantValues.clear();
    commonAttributes.clear();
    variantValueController.clear();
    _disposeCommonAttrControllers();
    final config = categoryConfigs[category];
    if (config != null) {
      for (final attr in config.commonAttributes) {
        commonAttrControllers[attr] = TextEditingController();
      }
    }
  }

  TextEditingController getCommonAttrController(String attr) {
    return commonAttrControllers.putIfAbsent(
        attr,
            () =>
            TextEditingController(text: commonAttributes[attr] ?? ''));
  }

  void _disposeCommonAttrControllers() {
    for (final c in commonAttrControllers.values) c.dispose();
    commonAttrControllers.clear();
  }

  bool hasVariantAttributes() {
    final config = categoryConfigs[selectedCategory.value];
    return config != null && config.variantAttributes.isNotEmpty;
  }

  void setCommonAttribute(String attribute, String value) =>
      commonAttributes[attribute] = value;

  // ── Variant type management ───────────────────────────────────────────────
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
    final values = value
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
      Get.snackbar("Error", "Please configure at least one variant type",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (selectedVariantType.value.isNotEmpty &&
        currentVariantValues.isNotEmpty) {
      configuredVariantTypes[selectedVariantType.value] =
          List.from(currentVariantValues);
    }
    final toAdd = _generateAllCombinations()
        .where(
            (combo) => !variants.any((v) => _areMapsEqual(v.attributes, combo)))
        .toList();
    for (var combo in toAdd) {
      variants.add(KEditOfferVariant(
        attributes: combo,
        price: null,
        stock: null,
        finalPrice: null,
        newImagePath: null,
        existingImageUrl: null,
      ));
    }
    if (toAdd.isNotEmpty) {
      Get.snackbar("Success", "${toAdd.length} new variant(s) added!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white);
    } else {
      Get.snackbar("Info", "All variants already exist.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF3B82F6),
          colorText: Colors.white);
    }
  }

  bool _areMapsEqual(Map<String, String> m1, Map<String, String> m2) {
    if (m1.length != m2.length) return false;
    for (var k in m1.keys) {
      if (m1[k] != m2[k]) return false;
    }
    return true;
  }

  List<Map<String, String>> _generateAllCombinations() {
    if (configuredVariantTypes.isEmpty) return [];
    final types = configuredVariantTypes.keys.toList();
    final allValues = types.map((t) => configuredVariantTypes[t]!).toList();
    final results = <Map<String, String>>[];
    void generate(int index, Map<String, String> current) {
      if (index == types.length) {
        results.add(Map.from(current));
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

  // ── Variant / image operations ────────────────────────────────────────────
  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants[index].disposeControllers();
      variants.removeAt(index);
    }
  }

  Future<void> pickImage(int index) async {
    if (index < 0 || index >= variants.length) return;
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      variants[index].newImagePath = pickedFile.path;
      variants.refresh();
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < variants.length) {
      variants[index].newImagePath = null;
      variants[index].existingImageUrl = null;
      variants.refresh();
    }
  }

  double? computeOfferPrice(double originalPrice) {
    if (originalPrice <= 0) return null;
    return originalPrice - (originalPrice * discountPercentage.value / 100);
  }

  // ── Validation ────────────────────────────────────────────────────────────
  bool validateForm() {
    if (productNameController.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Product name is required");
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar("Validation Error", "Category is required");
      return false;
    }
    final config = categoryConfigs[selectedCategory.value];
    if (config != null) {
      for (var attr in config.commonAttributes) {
        final ctrl = commonAttrControllers[attr];
        if (ctrl == null || ctrl.text.trim().isEmpty) {
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
      final v = variants[i];
      final price = double.tryParse(v.priceController.text.trim());
      final stock = int.tryParse(v.stockController.text.trim());
      if (price == null || price <= 0) {
        Get.snackbar(
            "Validation Error", "Variant ${i + 1}: Valid price is required");
        return false;
      }
      if (stock == null || stock < 0) {
        Get.snackbar(
            "Validation Error", "Variant ${i + 1}: Valid stock is required");
        return false;
      }
      if (!v.hasImage) {
        Get.snackbar(
            "Validation Error", "Variant ${i + 1}: Image is required");
        return false;
      }
    }
    return true;
  }

  // ── Submit update ─────────────────────────────────────────────────────────
  Future<void> updateOfferProduct() async {
    if (!validateForm()) return;
    if (_token.isEmpty) {
      Get.snackbar("Error", "Token missing.");
      return;
    }
    try {
      isSubmitting.value = true;

      productName.value = productNameController.text.trim();
      productDescription.value = productDescriptionController.text.trim();
      for (final entry in commonAttrControllers.entries) {
        commonAttributes[entry.key] = entry.value.text.trim();
      }

      final List<Map<String, dynamic>> variantsList = [];

      for (final variant in variants) {
        final double price =
            double.tryParse(variant.priceController.text.trim()) ?? 0.0;
        final int stock =
            int.tryParse(variant.stockController.text.trim()) ?? 0;

        String? imagePayload;
        if (variant.newImagePath != null) {
          final bytes = await File(variant.newImagePath!).readAsBytes();
          final ext = variant.newImagePath!.split('.').last.toLowerCase();
          final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
          imagePayload = "data:$mime;base64,${base64Encode(bytes)}";
        } else if (variant.existingImageUrl != null) {
          imagePayload = variant.existingImageUrl;
        }

        variantsList.add({
          "attributes": Map<String, String>.from(variant.attributes),
          "price": price,
          "stock": stock,
          "image": imagePayload,
        });
      }

      // ✅ FIX 1: "offer_product_id" must be offerId (e.g. 67),
      //           NOT productId (e.g. 93).
      //           productId = base catalog product
      //           offerId   = the offer-product join record the API updates
      final Map<String, dynamic> requestBody = {
        "offer_product_id": offerId,       // ✅ was wrongly set to productId
        "product_name": productName.value,
        "category_id": selectedCategoryId.value,
        if (productDescription.value.isNotEmpty)
          "description": productDescription.value,
        "product_attributes": {
          if (commonAttributes.isNotEmpty)
            "common_attributes": Map<String, String>.from(commonAttributes),
          "variants": variantsList,
        },
      };

      debugPrint("📤 updateOfferProduct body: ${jsonEncode(requestBody)}");

      final response = await http.put(
        Uri.parse(_updateUrl),
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      debugPrint("📡 update status : ${response.statusCode}");
      debugPrint("📥 update body   : ${response.body}");

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final status = body['status'];
      final isSuccess = status == 1 || status == true || status == '1';

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          isSuccess) {
        Get.rawSnackbar(
          messageText: Row(children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 15),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Successfully Updated!',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    body['message'] ?? 'Product changes have been saved.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85), fontSize: 11),
                  ),
                ],
              ),
            ),
          ]),
          backgroundColor: const Color(0xFF0D9488),
          borderRadius: 12,
          margin:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          snackStyle: SnackStyle.FLOATING,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          animationDuration: const Duration(milliseconds: 350),
          boxShadows: [
            BoxShadow(
              color: const Color(0xFF0D9488).withOpacity(0.45),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        );
        await Future.delayed(const Duration(milliseconds: 600));
        Get.offAll(() => OfferProductScreen(offerId: offerId));
      } else {
        Get.snackbar("Error", body['message'] ?? "Failed to update product",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("❌ updateOfferProduct error: $e");
      Get.snackbar("Error", "Failed to update product: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Cleanup ───────────────────────────────────────────────────────────────
  @override
  void onClose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    _disposeCommonAttrControllers();
    variantValueController.dispose();
    for (var v in variants) v.disposeControllers();
    super.onClose();
  }
}

// ── Models ────────────────────────────────────────────────────────────────────

class KEditCategoryConfig {
  final int id;
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  KEditCategoryConfig({
    required this.id,
    required this.commonAttributes,
    required this.variantAttributes,
  });
}

class KEditCategoryApiModel {
  final int id;
  final String name;
  final String image;
  final List<String> commonAttributes;
  final List<String> variantAttributes;

  KEditCategoryApiModel({
    required this.id,
    required this.name,
    required this.image,
    required this.commonAttributes,
    required this.variantAttributes,
  });
}

/// One variant row in the edit form.
///
/// Image state:
///   [newImagePath]     — local file path set when user picks a new image.
///   [existingImageUrl] — full URL built from the API's relative image path.
///
///   Display → File.image(newImagePath)        if isLocalImage
///           → Image.network(existingImageUrl)  otherwise
///   Submit  → base64 data URI                 if newImagePath != null
///           → existingImageUrl as-is           otherwise
///   Remove  → clear BOTH fields
class KEditOfferVariant {
  Map<String, String> attributes;
  String? newImagePath;
  String? existingImageUrl;
  final double? finalPrice;

  late final TextEditingController priceController;
  late final TextEditingController stockController;

  KEditOfferVariant({
    required this.attributes,
    double? price,
    int? stock,
    this.finalPrice,
    this.newImagePath,
    this.existingImageUrl,
  }) {
    priceController = TextEditingController(
        text: (price != null && price > 0) ? price.toStringAsFixed(0) : '');
    stockController =
        TextEditingController(text: stock != null ? stock.toString() : '');
  }

  double? get price => double.tryParse(priceController.text.trim());
  int? get stock => int.tryParse(stockController.text.trim());

  bool get hasImage => newImagePath != null || existingImageUrl != null;
  String? get displayImagePath => newImagePath ?? existingImageUrl;
  bool get isLocalImage => newImagePath != null;

  String getDisplayName() {
    if (attributes.isEmpty) return "Variant";
    return attributes.values.join(" - ");
  }

  void disposeControllers() {
    priceController.dispose();
    stockController.dispose();
  }
}