
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/cartmodel.dart';
import 'package:flutter/material.dart';

class CartController extends GetxController {
  final box = GetStorage();

  var cartItems = <CartItem>[].obs;
  var total = 0.0.obs;
  var isLoading = false.obs;
  var removingItems = <String, bool>{}.obs;

  String get authToken => box.read('auth_token') ?? "";

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  bool isProductInCart(int productId) {
    return cartItems.any((item) => item.productId == productId.toString());
  }

  bool isItemRemoving(String productId) => removingItems[productId] == true;

  Future<void> fetchCart() async {
    if (authToken.isEmpty) {
      cartItems.clear();
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/cart"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == true) {
          final List<dynamic> items = body['items'] ?? [];
          cartItems.value = items.map((e) => CartItem.fromJson(e)).toList();
          total.value = double.tryParse(body['total'].toString()) ?? 0.0;
        } else {
          cartItems.clear();
          total.value = 0.0;
        }
      } else if (response.statusCode == 401) {
        cartItems.clear();
        total.value = 0.0;
      } else {
        cartItems.clear();
        total.value = 0.0;
        Get.snackbar("Error", "Failed to fetch cart",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 12);
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
      cartItems.clear();
      total.value = 0.0;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addToCart({
    required int productId,
    required String name,
    required String image,
    required double price,
  }) async {
    if (authToken.isEmpty) {
      Get.snackbar("Unauthorized", "Please login first",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return false;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/cart/add"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": productId.toString(),
          "product_name": name,
          "product_image": image,
          "price": price.toString(),
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == true) {
        Get.snackbar(
          "Added to Cart",
          data['message'] ?? "Product added successfully",
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        await fetchCart();
        return true;
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to add product",
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return false;
      }
    } catch (e) {
      debugPrint("Error adding to cart: $e");
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update quantity — pure optimistic UI
  /// Only reverts from server if API call fails
  Future<void> updateQuantity(int productId, String action) async {
    final key = productId.toString();
    final index = cartItems.indexWhere((item) => item.productId == key);

    if (index == -1) return;

    final item = cartItems[index];

    // If decrement at qty 1 → remove instead
    if (action == "decrement" && item.quantity == 1) {
      await removeFromCart(productId);
      return;
    }

    // Save old quantity in case we need to revert
    final oldQuantity = item.quantity;
    final newQuantity =
    action == "increment" ? item.quantity + 1 : item.quantity - 1;

    // Instant UI update — no flicker, no spinner
    cartItems[index] = CartItem(
      productId: item.productId,
      productName: item.productName,
      productImage: item.productImage,
      price: item.price,
      quantity: newQuantity,
    );
    _recalculateTotal();

    try {
      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/cart/update-quantity"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": key,
          "action": action,
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] != true) {
        // Revert to old quantity on failure
        final revertIndex =
        cartItems.indexWhere((i) => i.productId == key);
        if (revertIndex != -1) {
          cartItems[revertIndex] = CartItem(
            productId: item.productId,
            productName: item.productName,
            productImage: item.productImage,
            price: item.price,
            quantity: oldQuantity,
          );
          _recalculateTotal();
        }
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to update cart",
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
      // ✅ On success: do nothing — optimistic update is already correct
    } catch (e) {
      // Revert on network error
      final revertIndex =
      cartItems.indexWhere((i) => i.productId == key);
      if (revertIndex != -1) {
        cartItems[revertIndex] = CartItem(
          productId: item.productId,
          productName: item.productName,
          productImage: item.productImage,
          price: item.price,
          quantity: oldQuantity,
        );
        _recalculateTotal();
      }
      debugPrint("Error updating quantity: $e");
    }
  }

  /// Remove product — fades card, no full-screen spinner
  Future<void> removeFromCart(int productId) async {
    final key = productId.toString();
    removingItems[key] = true;
    removingItems.refresh();

    try {
      final response = await http.delete(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/cart/remove"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": key,
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        cartItems.removeWhere((item) => item.productId == key);
        _recalculateTotal();
        Get.snackbar(
          "Removed",
          data['message'] ?? "Item removed from cart",
          backgroundColor: Colors.grey.shade800,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to remove",
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      debugPrint("Error removing from cart: $e");
    } finally {
      removingItems.remove(key);
      removingItems.refresh();
    }
  }

  void _recalculateTotal() {
    total.value =
        cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}