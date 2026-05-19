
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/user_productdetailmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class ProductDetailController extends GetxController {
  final box = GetStorage();
  final int productId;
  final int? preSelectedVariantId;

  ProductDetailController({
    required this.productId,
    this.preSelectedVariantId,
  });

  var isLoading = false.obs;
  var product = Rxn<ProductDetailModel>();
  var selectedVariant = Rxn<ProductVariantModel>();
  var currentImageIndex = 0.obs;

  /// Tracks the user's currently chosen value per attribute key.
  /// e.g. {"size": "m", "color": "blue"}
  final RxMap<String, String> selectedAttributes = <String, String>{}.obs;

  late final PageController pageController;

  /// Guard flag — true while we are programmatically jumping the PageView.
  /// Prevents onPageChanged from overwriting the chip-driven selection.
  bool _isProgrammaticJump = false;

  final String _baseUrl = "https://entenaadu.co.in/api";

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    fetchProduct(productId);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Network
  // ---------------------------------------------------------------------------

  Future<void> fetchProduct(int productId) async {
    final token = box.read('auth_token');
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse("$_baseUrl/product-details"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {"product_id": productId.toString()},
      );

      if (response.statusCode != 200) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        product.value = null;
        return;
      }

      final decoded = json.decode(response.body);
      if (decoded['status'] == true) {
        final productData = ProductDetailModel.fromJson(decoded['data']);
        product.value = productData;

        if (productData.variants.isNotEmpty) {
          ProductVariantModel targetVariant = productData.variants.first;

          if (preSelectedVariantId != null) {
            final matched = productData.variants.firstWhereOrNull(
                  (v) => v.variantId == preSelectedVariantId,
            );
            if (matched != null) targetVariant = matched;
          }

          _applyVariant(targetVariant, productData, animate: false);
        }
      } else {
        product.value = null;
        AppSnackbar.error(
            decoded['message']?.toString() ?? "Failed to load product");
      }
    } catch (e) {
      product.value = null;
      AppSnackbar.error(ApiErrorHandler.handleException(e));
      debugPrint("Product detail error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Attribute helpers
  // ---------------------------------------------------------------------------

  /// Returns every unique attribute key found across all variants.
  List<String> getAttributeKeys() {
    final keys = <String>{};
    for (final v in product.value?.variants ?? []) {
      keys.addAll(v.attributes.keys);
    }
    return keys.toList();
  }

  /// Returns all unique values for a given attribute key across ALL variants.
  List<String> getValuesForAttribute(String attributeKey) {
    final values = <String>{};
    for (final v in product.value?.variants ?? []) {
      final val = v.attributes[attributeKey]?.toString();
      if (val != null) values.add(val);
    }
    return values.toList();
  }

  /// Returns true if a variant exists that satisfies ALL of [selectedAttributes]
  /// with [attributeKey] overridden to [value].
  bool isValueSelectable(String attributeKey, String value) {
    final desired = Map<String, String>.from(selectedAttributes);
    desired[attributeKey] = value;

    return product.value?.variants.any((v) {
      return desired.entries.every(
            (e) => v.attributes[e.key]?.toString() == e.value,
      );
    }) ??
        false;
  }

  // ---------------------------------------------------------------------------
  // Selection
  // ---------------------------------------------------------------------------

  /// Called when the user taps an attribute chip.
  void tapAttribute(String attributeKey, String value) {
    if (product.value == null) return;

    selectedAttributes[attributeKey] = value;

    final matched = _findBestMatch(selectedAttributes);
    if (matched != null) {
      _applyVariant(matched, product.value!, animate: true);
    }
  }

  /// Called ONLY when the user manually swipes the PageView.
  /// Ignored during programmatic jumps so chips don't get overwritten.
  void onUserSwiped(int index) {
    if (_isProgrammaticJump) return;
    final variants = product.value?.variants ?? [];
    if (index < 0 || index >= variants.length) return;
    _applyVariant(variants[index], product.value!, animate: false);
  }

  /// Finds the variant that best matches [desired] attributes.
  ProductVariantModel? _findBestMatch(Map<String, String> desired) {
    final variants = product.value?.variants ?? [];

    // 1. Exact match on all attributes
    final exact = variants.firstWhereOrNull((v) {
      return desired.entries.every(
            (e) => v.attributes[e.key]?.toString() == e.value,
      );
    });
    if (exact != null) return exact;

    // 2. Best partial match (most matching attribute values)
    ProductVariantModel? best;
    int bestScore = -1;
    for (final v in variants) {
      int score = 0;
      for (final e in desired.entries) {
        if (v.attributes[e.key]?.toString() == e.value) score++;
      }
      if (score > bestScore) {
        bestScore = score;
        best = v;
      }
    }
    return best;
  }

  /// Single source of truth for applying a variant.
  /// [animate] true  → chip tap (smooth slide to new image)
  /// [animate] false → swipe or initial load (no feedback loop)
  void _applyVariant(
      ProductVariantModel variant,
      ProductDetailModel data, {
        required bool animate,
      }) {
    selectedVariant.value = variant;

    // Sync attribute map from the resolved variant
    selectedAttributes.assignAll(
      variant.attributes.map((k, v) => MapEntry(k, v.toString())),
    );

    final index = data.variants.indexOf(variant);
    currentImageIndex.value = index;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!pageController.hasClients) return;
      if (pageController.page?.round() == index) return; // already on this page

      _isProgrammaticJump = true;

      if (animate) {
        pageController
            .animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
            .whenComplete(() => _isProgrammaticJump = false);
      } else {
        pageController.jumpToPage(index);
        // jumpToPage is sync but onPageChanged fires on next frame
        Future.delayed(
          const Duration(milliseconds: 100),
              () => _isProgrammaticJump = false,
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Legacy helpers
  // ---------------------------------------------------------------------------

  void selectVariant(ProductVariantModel variant) {
    if (product.value == null) return;
    _applyVariant(variant, product.value!, animate: false);
  }

  void selectVariantById(int variantId) {
    if (product.value == null) return;
    final matched = product.value!.variants.firstWhereOrNull(
          (v) => v.variantId == variantId,
    );
    if (matched != null) selectVariant(matched);
  }

  Map<String, Set<String>> getVariantAttributes() {
    final Map<String, Set<String>> map = {};
    for (var v in product.value?.variants ?? []) {
      v.attributes.forEach((key, value) {
        map.putIfAbsent(key, () => {});
        map[key]!.add(value.toString());
      });
    }
    return map;
  }
}