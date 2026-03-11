
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/user_productdetailmodel.dart';
import 'cartcontroller.dart';
import '../view/cartscreen.dart';

class ProductDetailController extends GetxController {
  final box = GetStorage();
  final int productId;

  ProductDetailController({required this.productId});

  var isLoading = false.obs;
  var product = Rxn<ProductDetailModel>();
  var selectedVariant = Rxn<ProductVariantModel>();
  var quantity = 1.obs;
  var isAddedToCart = false.obs;

  // Worker reference — prevents duplicate listeners
  Worker? _cartWorker;

  final String api =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/product-details";

  @override
  void onInit() {
    super.onInit();
    fetchProduct(productId);
  }

  @override
  void onClose() {
    _cartWorker?.dispose();
    super.onClose();
  }

  // ── Fetch product details ──────────────────────────────────
  Future<void> fetchProduct(int productId) async {
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      isLoading.value = true;
      isAddedToCart.value = false;

      final response = await http.post(
        Uri.parse(api),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {"product_id": productId.toString()},
      );

      final decoded = json.decode(response.body);
      product.value = ProductDetailModel.fromJson(decoded['data']);

      if (product.value!.variants.isNotEmpty) {
        selectedVariant.value = product.value!.variants.first;
      }

      // ── Sync cart state & watch for changes ──
      _syncCartState();
    } catch (e) {
      product.value = null;
      debugPrint("Product detail error: $e");
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
    if (product.value == null) return;

    final pid = product.value!.productId.toString();

    if (Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();

      // Step 1: Check immediately against current cart list
      isAddedToCart.value =
          cart.cartItems.any((item) => item.productId.toString() == pid);

      // Step 2: Dispose old worker if any, then watch for future changes
      _cartWorker?.dispose();
      _cartWorker = ever(cart.cartItems, (_) {
        if (product.value != null) {
          isAddedToCart.value =
              cart.cartItems.any((item) => item.productId.toString() == pid);
        }
      });
    } else {
      // CartController not yet registered — fall back to API check
      _checkIfAlreadyInCart();
    }
  }

  // ── Fallback: check cart via API (if CartController not found) ──
  Future<void> _checkIfAlreadyInCart() async {
    if (product.value == null) return;
    try {
      final token = box.read('auth_token');
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
          final pid = product.value!.productId.toString();
          isAddedToCart.value =
              items.any((item) => item['product_id'].toString() == pid);
        }
      }
    } catch (e) {
      debugPrint("Could not check cart status: $e");
    }
  }

  // ── Add to Cart ────────────────────────────────────────────
  Future<void> addToCart() async {
    if (selectedVariant.value == null) {
      Get.snackbar("Error", "Please select a variant",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final stockCount = int.tryParse(selectedVariant.value!.stock) ?? 0;
    if (stockCount <= 0) {
      Get.snackbar("Out of Stock", "This variant is currently out of stock",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final token = box.read('auth_token');
      if (token == null) {
        Get.snackbar("Unauthorized", "Please login first",
            backgroundColor: Colors.red, colorText: Colors.white);
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
          "product_id": product.value!.productId.toString(),
          "product_name": product.value!.productName,
          "product_image": selectedVariant.value!.image,
          "price": selectedVariant.value!.price.toString(),
          "quantity": quantity.value.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        // Flip button to "Go to Cart"
        isAddedToCart.value = true;

        // Refresh CartController — also triggers ever() above to confirm
        if (Get.isRegistered<CartController>()) {
          await Get.find<CartController>().fetchCart();
        }

        Get.snackbar(
          "Added to Cart",
          data['message'] ?? "${product.value!.productName} added to cart",
          backgroundColor: const Color(0xFF009688),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to add product",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error adding to cart: $e");
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Navigate to Cart ───────────────────────────────────────
  void goToCart() {
    Get.to(() => CartScreen());
  }

  // ── Variant helpers ────────────────────────────────────────
  Map<String, Set<String>> getVariantAttributes() {
    final Map<String, Set<String>> attributeMap = {};
    final variants = product.value?.variants ?? [];
    for (var variant in variants) {
      variant.attributes.forEach((key, value) {
        attributeMap.putIfAbsent(key, () => <String>{});
        attributeMap[key]!.add(value.toString());
      });
    }
    return attributeMap;
  }

  void selectVariant(ProductVariantModel variant) {
    selectedVariant.value = variant;
    quantity.value = 1;
  }

  void increaseQty() {
    final stock = int.tryParse(selectedVariant.value?.stock ?? "0") ?? 0;
    if (quantity.value < stock) {
      quantity.value++;
    } else {
      Get.snackbar("Max Stock", "Only $stock items available");
    }
  }

  void decreaseQty() {
    if (quantity.value > 1) quantity.value--;
  }
}