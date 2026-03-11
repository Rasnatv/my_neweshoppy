
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_offerdetailmodel.dart';
import '../../product/controller/cartcontroller.dart';
import '../../product/view/cartscreen.dart';

class UserOfferProductDetailController extends GetxController {
  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/offer-product/details";

  // Loading state
  var isLoading = false.obs;

  // Product data
  var productData = Rx<UserOfferProductDetail?>(null);

  // Selected variant attributes
  var selectedAttributes = <String, String>{}.obs;

  // Current selected variant
  var selectedVariant = Rx<ProductVariant?>(null);

  // Current image index for carousel
  var currentImageIndex = 0.obs;

  // Quantity
  var quantity = 1.obs;

  // Tracks whether this offer product has been added to cart
  var isAddedToCart = false.obs;

  // Worker reference — kept so we don't register duplicate listeners
  Worker? _cartWorker;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    _cartWorker?.dispose();
    super.onClose();
  }

  // ── Fetch product details ──────────────────────────────────
  Future<void> fetchProductDetails(int offerProductId) async {
    try {
      isLoading.value = true;
      isAddedToCart.value = false;
      productData.value = null;
      selectedAttributes.clear();
      selectedVariant.value = null;
      currentImageIndex.value = 0;
      quantity.value = 1;

      final token = box.read("auth_token");

      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "offer_product_id": offerProductId,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 1) {
          productData.value = UserOfferProductDetail.fromJson(body['data']);

          if (productData.value!.variants.isNotEmpty) {
            _initializeFirstVariant();
          }

          // ── Sync cart state & start watching for changes ──
          _syncCartState();
        } else {
          Get.snackbar(
              "Error", body['message'] ?? "Failed to fetch product details");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch product details");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch product details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ── Sync isAddedToCart with CartController in real-time ────
  //
  // 1. Immediately checks current cart items on screen open.
  // 2. Uses ever() to watch CartController.cartItems — so if the user
  //    removes this product from the cart screen, the button here
  //    automatically reverts from "Go to Cart" → "Add to Cart".
  void _syncCartState() {
    if (productData.value == null) return;

    final productId = productData.value!.id.toString();

    if (Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();

      // Step 1: Check immediately against current cart list
      isAddedToCart.value =
          cart.cartItems.any((item) => item.productId.toString() == productId);

      // Step 2: Dispose old worker if any, then watch for future changes
      _cartWorker?.dispose();
      _cartWorker = ever(cart.cartItems, (_) {
        if (productData.value != null) {
          isAddedToCart.value = cart.cartItems
              .any((item) => item.productId.toString() == productId);
        }
      });
    } else {
      // CartController not yet registered — fall back to direct API check
      _checkIfAlreadyInCart();
    }
  }

  // ── Fallback: check cart via API (used if CartController not found) ──
  Future<void> _checkIfAlreadyInCart() async {
    if (productData.value == null) return;
    try {
      final token = box.read("auth_token");
      if (token == null) return;

      final response = await http.get(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/cart"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          final List items = body['items'] ?? [];
          final productId = productData.value!.id.toString();
          isAddedToCart.value =
              items.any((item) => item['product_id'].toString() == productId);
        }
      }
    } catch (e) {
      debugPrint("⚠️ Could not check cart status: $e");
    }
  }

  // ── Initialize first variant ───────────────────────────────
  void _initializeFirstVariant() {
    if (productData.value == null || productData.value!.variants.isEmpty)
      return;

    final firstVariant = productData.value!.variants.first;
    selectedAttributes.value = Map.from(firstVariant.attributes);
    selectedVariant.value = firstVariant;
  }

  // ── Select variant attribute ───────────────────────────────
  void selectAttribute(String attributeName, String value) {
    selectedAttributes[attributeName] = value;
    _updateSelectedVariant();
  }

  // ── Update selected variant based on selected attributes ───
  void _updateSelectedVariant() {
    if (productData.value == null) return;

    final matchingVariant = productData.value!.variants.firstWhereOrNull(
          (variant) => _attributesMatch(variant.attributes, selectedAttributes),
    );

    selectedVariant.value = matchingVariant;
  }

  // ── Check if attributes match ──────────────────────────────
  bool _attributesMatch(
      Map<String, String> variantAttrs, Map<String, String> selectedAttrs) {
    if (variantAttrs.length != selectedAttrs.length) return false;
    for (var key in variantAttrs.keys) {
      if (variantAttrs[key] != selectedAttrs[key]) return false;
    }
    return true;
  }

  // ── Get available values for an attribute ──────────────────
  List<String> getAvailableValuesForAttribute(String attributeName) {
    if (productData.value == null) return [];
    return productData.value!.variants
        .map((v) => v.attributes[attributeName])
        .whereType<String>()
        .toSet()
        .toList();
  }

  // ── Get attribute display name ─────────────────────────────
  String getAttributeDisplayName(String key) {
    return key[0].toUpperCase() + key.substring(1);
  }

  // ── Increase quantity ──────────────────────────────────────
  void increaseQuantity() {
    if (selectedVariant.value != null) {
      if (quantity.value < selectedVariant.value!.stock) {
        quantity.value++;
      } else {
        Get.snackbar(
            "Max Stock", "Only ${selectedVariant.value!.stock} items available");
      }
    }
  }

  // ── Decrease quantity ──────────────────────────────────────
  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // ── Add to Cart ────────────────────────────────────────────
  Future<void> addToCart() async {
    if (selectedVariant.value == null) {
      Get.snackbar("Error", "Please select a variant");
      return;
    }

    if (selectedVariant.value!.stock <= 0) {
      Get.snackbar("Out of Stock", "This variant is currently out of stock");
      return;
    }

    isLoading.value = true;

    try {
      final token = box.read("auth_token");

      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/cart/add"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "product_id": productData.value!.id.toString(),
          "product_name": productData.value!.productName,
          "product_image": productData.value!.productImages.isNotEmpty
              ? productData.value!.productImages.first
              : '',
          "price": productData.value!.offerPrice.toString(),
          "quantity": quantity.value.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        // Flip button to "Go to Cart"
        isAddedToCart.value = true;

        // Refresh CartController — this also triggers the ever() listener
        // above, which reconfirms isAddedToCart stays true
        if (Get.isRegistered<CartController>()) {
          await Get.find<CartController>().fetchCart();
        }

        Get.snackbar(
          "Added to Cart",
          "${productData.value!.productName} (${quantity.value} item${quantity.value > 1 ? 's' : ''})",
          backgroundColor: const Color(0xFF009688),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to add to cart",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Navigate to Cart ───────────────────────────────────────
  void goToCart() {
    Get.to(CartScreen());
  }

  // ── Calculate discount amount ──────────────────────────────
  double getDiscountAmount() {
    if (productData.value == null || selectedVariant.value == null) return 0;
    return selectedVariant.value!.price - productData.value!.offerPrice;
  }
}