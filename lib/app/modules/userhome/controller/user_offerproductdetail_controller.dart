
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/user_offerdetailmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class UserOfferProductDetailController extends GetxController {
  final box = GetStorage();

  final String apiUrl = "https://eshoppy.co.in/api/offer-product/details";

  var isLoading = false.obs;
  var productData = Rx<UserOfferProductDetail?>(null);

  var selectedAttributes = <String, String>{}.obs;
  var selectedVariant = Rx<ProductVariant?>(null);
  var currentImageIndex = 0.obs;

  /// Guard — true while we are programmatically animating the carousel.
  /// Prevents onPageChanged from overwriting the chip-driven selection.
  bool _isProgrammaticJump = false;

  // ---------------------------------------------------------------------------
  // Network
  // ---------------------------------------------------------------------------

  Future<void> fetchProductDetails(int productId) async {
    try {
      isLoading.value = true;
      productData.value = null;
      selectedAttributes.clear();
      selectedVariant.value = null;
      currentImageIndex.value = 0;

      final token = box.read("auth_token");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"offer_product_id": productId}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 1) {
          productData.value = UserOfferProductDetail.fromJson(body['data']);

          if (productData.value!.variants.isNotEmpty) {
            _applyVariant(productData.value!.variants.first, programmatic: false);
          }
        } else {
          AppSnackbar.error(body['message'] ?? "Failed to fetch product details");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Attribute / variant selection
  // ---------------------------------------------------------------------------

  /// Called when user taps an attribute chip.
  void selectAttribute(String attributeName, String value) {
    selectedAttributes[attributeName] = value;
    _updateSelectedVariant();
  }

  void _updateSelectedVariant() {
    if (productData.value == null) return;

    // Exact match first
    final exact = productData.value!.variants.firstWhereOrNull(
          (v) => _attributesMatch(v.attributes, selectedAttributes),
    );

    if (exact != null) {
      _applyVariant(exact, programmatic: true);
      return;
    }

    // Best partial match (most matching keys)
    ProductVariant? best;
    int bestScore = -1;
    for (final v in productData.value!.variants) {
      int score = 0;
      for (final e in selectedAttributes.entries) {
        if (v.attributes[e.key] == e.value) score++;
      }
      if (score > bestScore) {
        bestScore = score;
        best = v;
      }
    }
    if (best != null) _applyVariant(best, programmatic: true);
  }

  /// Called when the user manually swipes the carousel.
  /// Ignored during programmatic jumps.
  void onUserSwiped(int index) {
    if (_isProgrammaticJump) return;
    final variants = productData.value?.variants ?? [];

    // ✅ KEY FIX: find which variant owns the image at this carousel index
    final imageUrl = _imageAtIndex(index);
    if (imageUrl == null) return;

    final matched = variants.firstWhereOrNull((v) => v.image == imageUrl);
    if (matched != null) {
      _applyVariant(matched, programmatic: false);
    } else {
      // image doesn't map to a variant — just update dot indicator
      currentImageIndex.value = index;
    }
  }

  // ---------------------------------------------------------------------------
  // Core apply
  // ---------------------------------------------------------------------------

  /// Single source of truth for applying a variant and syncing all state.
  /// [programmatic] true  → chip tap  → animate carousel
  /// [programmatic] false → swipe / initial load → no animation needed
  void _applyVariant(ProductVariant variant, {required bool programmatic}) {
    selectedVariant.value = variant;
    selectedAttributes.value = Map.from(variant.attributes);

    final targetIndex = _imageIndexForVariant(variant);
    currentImageIndex.value = targetIndex;

    // Notify the view to jump the carousel via the callback
    if (programmatic && targetIndex >= 0) {
      _isProgrammaticJump = true;
      onCarouselJumpRequested?.call(targetIndex);
    }
  }

  // ---------------------------------------------------------------------------
  // Image index resolution — THE ROOT FIX
  // ---------------------------------------------------------------------------

  /// ✅ Resolves carousel index for a variant.
  ///
  /// Strategy (in order):
  ///  1. Find exact URL match in productImages list.
  ///  2. Fall back to the variant's position in the variants list
  ///     (handles cases where each variant maps to one image slot).
  ///  3. Default to 0.
  int _imageIndexForVariant(ProductVariant variant) {
    final images = productData.value?.productImages ?? [];

    // 1. Exact URL match
    final exactIdx = images.indexOf(variant.image);
    if (exactIdx != -1) return exactIdx;

    // 2. Positional fallback — variant index == image index
    final variants = productData.value?.variants ?? [];
    final variantIdx = variants.indexWhere((v) => v.variantId == variant.variantId);
    if (variantIdx != -1 && variantIdx < images.length) return variantIdx;

    return 0;
  }

  String? _imageAtIndex(int index) {
    final images = productData.value?.productImages ?? [];
    if (index < 0 || index >= images.length) return null;
    return images[index];
  }

  // ---------------------------------------------------------------------------
  // Carousel jump callback
  // ---------------------------------------------------------------------------

  /// The view sets this callback so the controller can trigger a carousel jump.
  /// Using a callback avoids importing flutter/widgets in the controller.
  void Function(int index)? onCarouselJumpRequested;

  /// Called by the view after the carousel has finished animating.
  void onCarouselJumpDone() {
    Future.delayed(
      const Duration(milliseconds: 100),
          () => _isProgrammaticJump = false,
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool _attributesMatch(
      Map<String, String> variantAttrs,
      Map<String, String> selectedAttrs,
      ) {
    if (variantAttrs.length != selectedAttrs.length) return false;
    for (final key in variantAttrs.keys) {
      if (variantAttrs[key] != selectedAttrs[key]) return false;
    }
    return true;
  }

  List<String> getAvailableValuesForAttribute(String attributeName) {
    return productData.value?.variants
        .map((v) => v.attributes[attributeName])
        .whereType<String>()
        .toSet()
        .toList() ??
        [];
  }

  String getAttributeDisplayName(String key) =>
      key[0].toUpperCase() + key.substring(1);

  double getDiscountAmount() {
    if (selectedVariant.value == null) return 0;
    return selectedVariant.value!.price - selectedVariant.value!.offerPrice;
  }

  void selectVariantById(int variantId) {
    if (productData.value == null) return;
    final matched = productData.value!.variants.firstWhereOrNull(
          (v) => v.variantId == variantId,
    );
    if (matched != null) _applyVariant(matched, programmatic: false);
  }
}