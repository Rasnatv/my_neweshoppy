
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../data/models/cartmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';

class CartController extends GetxController {
  final box = GetStorage();

  var cartItems = <CartItem>[].obs;
  var total = 0.0.obs;
  var isLoading = false.obs;

  /// key => productId_variantId
  var removingItems = <String, bool>{}.obs;

  String get authToken => box.read('auth_token') ?? "";

  /// ✅ unique key for each cart item (important for variants)
  String _itemKey(String productId, int? variantId) {
    return "${productId}_${variantId ?? 0}";
  }

  bool isItemRemoving(String productId, int? variantId) {
    return removingItems[_itemKey(productId, variantId)] == true;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  /// ✅ FETCH CART
  Future<void> fetchCart() async {
    final token = authToken;

    if (token.isEmpty) {
      cartItems.clear();
      total.value = 0.0;
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse("https://eshoppy.co.in/api/cart"),
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

          /// calculate total safely
          total.value = cartItems.fold(
            0.0,
                (sum, item) => sum + (item.finalPrice * item.quantity),
          );
        } else {
          cartItems.clear();
          total.value = 0.0;
        }
      } else {
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

  /// ✅ ADD TO CART (WITH VARIANT)
  Future<bool> addToCart({
    required int productId,
    required int variantId,
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
          "variant_id": variantId.toString(),
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
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }

    return false;
  }

  /// ✅ UPDATE QUANTITY (VARIANT SAFE)
  Future<void> updateQuantity(
      int productId,
      String action, {
        int? variantId,
      }) async {
    final key = productId.toString();

    final index = cartItems.indexWhere((item) =>
    item.productId == key && item.variantId == variantId);

    if (index == -1) return;

    final item = cartItems[index];

    /// if qty = 1 and decrement → remove
    if (action == "decrement" && item.quantity == 1) {
      await removeFromCart(productId, variantId: variantId);
      return;
    }

    /// prevent exceeding stock
    if (action == "increment" && item.quantity >= item.stock) return;

    final newQty =
    action == "increment" ? item.quantity + 1 : item.quantity - 1;

    /// optimistic update
    cartItems[index] = item.copyWith(
      quantity: newQty,
      itemTotal: item.finalPrice * newQty,
    );

    _recalculateTotal();

    try {
      final response = await http.post(
        Uri.parse("https://eshoppy.co.in/api/cart/update-quantity"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": productId.toString(),
          if (variantId != null) "variant_id": variantId.toString(),
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

  /// ✅ REMOVE ITEM (VARIANT SAFE)
  Future<void> removeFromCart(
      int productId, {
        int? variantId,
      }) async {
    final key = _itemKey(productId.toString(), variantId);

    removingItems[key] = true;
    removingItems.refresh();

    try {
      final response = await http.delete(
        Uri.parse("https://eshoppy.co.in/api/cart/remove"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": productId.toString(),
          if (variantId != null) "variant_id": variantId.toString(),
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true) {
          cartItems.removeWhere((item) =>
          item.productId == productId.toString() &&
              item.variantId == variantId);

          _recalculateTotal();
        } else {
          AppSnackbar.error(data['message'] ?? "Remove failed");
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

  /// ✅ TOTAL CALCULATION
  void _recalculateTotal() {
    total.value = cartItems.fold(
      0.0,
          (sum, item) => sum + (item.finalPrice * item.quantity),
    );
  }

  void _revertItem(int index, CartItem oldItem) {
    cartItems[index] = oldItem;
    _recalculateTotal();
  }
}