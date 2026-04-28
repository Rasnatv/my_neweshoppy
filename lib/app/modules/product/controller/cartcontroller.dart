
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../data/models/cartmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

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

  Future<void> refresh() async {
    cartItems.clear();
    total.value = 0.0;
    await fetchCart();
  }

  bool isProductInCart(int productId) {
    return cartItems.any((item) => item.productId == productId.toString());
  }

  bool isItemRemoving(String productId) => removingItems[productId] == true;

  Future<void> fetchCart() async {
    final token = box.read<String?>('auth_token') ?? "";

    // ✅ Silent return — no snackbar, no redirect
    if (token.isEmpty) {
      cartItems.clear();
      total.value = 0.0;
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(
            "https://eshoppy.co.in/api/cart"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          final items = body['items'] ?? [];
          cartItems.value =
              items.map<CartItem>((e) => CartItem.fromJson(e)).toList();
          total.value =
              double.tryParse(body['total'].toString()) ?? 0.0;
        } else {
          cartItems.clear();
          total.value = 0.0;
        }
      } else {
        // ✅ Don't call ApiErrorHandler here — silent fail for cart fetch
        // Avoids triggering handleUnauthorized() on background cart load
        debugPrint("Cart fetch failed: ${response.statusCode}");
        cartItems.clear();
        total.value = 0.0;
      }
    } catch (e) {
      debugPrint("Cart fetch error: $e");
      cartItems.clear();
      total.value = 0.0;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addToCart({
    required int productId,
    required int variantId,   // ✅ added
    required int type,
  }) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("https://eshoppy.co.in/api/cart/add"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": productId.toString(),
          "variant_id": variantId.toString(),   // ✅ added
          "type": type.toString(),
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          await fetchCart();
          return true;
        } else {
          AppSnackbar.error(data['message'] ?? "Failed to add product");
          return false;
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        return false;
      }
    } catch (e) {
       AppSnackbar.error(ApiErrorHandler.handleException(e));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQuantity(int productId, String action) async {
    final key = productId.toString();
    final index = cartItems.indexWhere((item) => item.productId == key);
    if (index == -1) return;

    final item = cartItems[index];

    // ✅ Decrement at qty 1 → remove
    if (action == "decrement" && item.quantity == 1) {
      await removeFromCart(productId);
      return;
    }

    // ✅ Block increment when quantity has reached stock limit
    if (action == "increment" && item.quantity >= item.stock) {
      // AppSnackbar.error("Only ${item.stock} units available in stock");
      return;
    }

    final newQuantity =
    action == "increment" ? item.quantity + 1 : item.quantity - 1;

    // Optimistic update
    cartItems[index] = item.copyWith(
      quantity: newQuantity,
      itemTotal: item.finalPrice * newQuantity,
    );
    _recalculateTotal();

    try {
      final response = await http.post(
        Uri.parse(
            "https://eshoppy.co.in/api/cart/update-quantity"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": key,
          "action": action,
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        _revertItem(index, item);
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      } else {
        final data = jsonDecode(response.body);
        if (data['status'] != true) {
          _revertItem(index, item);
          AppSnackbar.error(data['message'] ?? "Failed to update cart");
        }
      }
    } catch (e) {
      _revertItem(index, item);
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  Future<void> removeFromCart(int productId) async {
    final key = productId.toString();
    removingItems[key] = true;
    removingItems.refresh();

    try {
      final response = await http.delete(
        Uri.parse(
            "https://eshoppy.co.in/api/cart/remove"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {"product_id": key},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          cartItems.removeWhere((item) => item.productId == key);
          _recalculateTotal();

        } else {
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      removingItems.remove(key);
      removingItems.refresh();
    }
  }

  void _recalculateTotal() {
    total.value = cartItems.fold(
        0.0, (sum, item) => sum + (item.finalPrice * item.quantity));
  }

  void _revertItem(int index, CartItem oldItem) {
    cartItems[index] = oldItem;
    _recalculateTotal();
  }
}
