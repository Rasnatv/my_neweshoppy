
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/restaruantcartmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class Restaurantcartcontroller extends GetxController {
  static const String _baseUrl =
      'https://eshoppy.co.in/api';

  final RxList<RestaurantCartModel> _allCartItems =
      <RestaurantCartModel>[].obs;

  final RxInt currentRestaurantId = 0.obs;

  final RxDouble _grandTotal = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;

  final _box = GetStorage();

  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken.isNotEmpty) 'Authorization': 'Bearer $_authToken',
  };

  List<RestaurantCartModel> get cartItems => currentRestaurantId.value == 0
      ? _allCartItems.toList()
      : _allCartItems
      .where((item) => item.restaurantId == currentRestaurantId.value)
      .toList();

  List<RestaurantCartModel> itemsForRestaurant(int restaurantId) =>
      _allCartItems
          .where((item) => item.restaurantId == restaurantId)
          .toList();

  double get grandTotal =>
      cartItems.fold(0.0, (sum, i) => sum + i.totalPrice);

  double grandTotalForRestaurant(int restaurantId) =>
      itemsForRestaurant(restaurantId)
          .fold(0.0, (sum, i) => sum + i.totalPrice);

  bool get hasItems => cartItems.isNotEmpty;

  int get totalItems =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => grandTotal;

  bool hasItemsForRestaurant(int restaurantId) =>
      itemsForRestaurant(restaurantId).isNotEmpty;

  int totalItemsForRestaurant(int restaurantId) =>
      itemsForRestaurant(restaurantId)
          .fold(0, (sum, item) => sum + item.quantity);

  double totalAmountForRestaurant(int restaurantId) =>
      grandTotalForRestaurant(restaurantId);

  bool isInCart(int menuId) =>
      cartItems.any((item) => item.menuId == menuId);

  bool isInCartForRestaurant(int menuId, int restaurantId) =>
      itemsForRestaurant(restaurantId)
          .any((item) => item.menuId == menuId);

  int itemQty(int menuId) {
    try {
      return cartItems
          .firstWhere((item) => item.menuId == menuId)
          .quantity;
    } catch (_) {
      return 0;
    }
  }

  int itemQtyForRestaurant(int menuId, int restaurantId) {
    try {
      return itemsForRestaurant(restaurantId)
          .firstWhere((item) => item.menuId == menuId)
          .quantity;
    } catch (_) {
      return 0;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  void setRestaurant(int restaurantId) {
    currentRestaurantId.value = restaurantId;
  }

  Future<void> fetchCart() async {
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/getrestaurant-cart'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 1) {
          final List items = data['data'] ?? [];
          _allCartItems.value =
              items.map((e) => RestaurantCartModel.fromJson(e)).toList();
          _grandTotal.value =
              double.tryParse(data['grand_total']?.toString() ?? '0') ?? 0.0;
        } else {
          // ✅ FIX: status == 0 means empty cart — clear everything
          _allCartItems.clear();
          _grandTotal.value = 0.0;
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
      debugPrint('fetchCart error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> addToCart({
    required int restaurantId,
    required int menuId,
    required String itemName,
    required String image,
    required double price,
    bool forceReplace = false,          // ← new flag
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant-cart/add'),
        headers: _headers,
        body: jsonEncode({
          'restaurant_id': restaurantId,
          'menu_id': menuId,
          'item_name': itemName,
          'image': image,
          'price': price,
          if (forceReplace) 'force_replace': true,   // send to API if it supports it
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ── MEAL TYPE CONFLICT ──────────────────────────────────────────
        if (data['status'] == 0 &&
            (data['message'] as String? ?? '')
                .toLowerCase()
                .contains('meal type')) {
          final confirmed = await _showMealTypeConflictDialog(data['message']);

          if (confirmed == true) {
            // Clear existing cart, then retry
            await clearCartForRestaurant(restaurantId);
            return addToCart(
              restaurantId: restaurantId,
              menuId: menuId,
              itemName: itemName,
              image: image,
              price: price,
              forceReplace: true,
            );
          }
          return false;
        }

        // ── SUCCESS ─────────────────────────────────────────────────────
        if (data['status'] == 1) {
          await fetchCart();
          return true;
        }
      }
    } catch (e) {
      debugPrint('addToCart error: $e');
    }
    return false;
  }

// ───────────────── MEAL TYPE CONFLICT DIALOG ─────────────────
  Future<bool?> _showMealTypeConflictDialog(String apiMessage) {
    return Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: Color(0xFF0F5151),
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Switch meal type?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                apiMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF6B6B6B),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(color: Color(0xFFF0F0F0), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Keep current or please clear cart',
                        style: TextStyle(
                          color: Color(0xFF6B6B6B),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),



                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,   // user must choose
    );
  }


  // ✅ UPDATED
  Future<void> clearCartForRestaurant(
      int restaurantId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant-cart/clear'),
        headers: _headers,
        body: jsonEncode({
          'restaurant_id': restaurantId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 1) {
          _allCartItems.removeWhere(
                (item) =>
            item.restaurantId == restaurantId,
          );

          _grandTotal.value = 0.0;

          _allCartItems.refresh();
        }
      }
    } catch (e) {
      debugPrint(
        'clearCartForRestaurant error: $e',
      );
    }
  }
  Future<void> updateQuantity(int menuId, String type) async {
    _updateLocalQty(menuId, type);

    isUpdating.value = true;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/restaurant-cart/update-quantity'),
        headers: _headers,
        body: jsonEncode({
          'menu_id': menuId,
          'type': type,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 1 && data['data'] != null) {
          final updated = RestaurantCartModel.fromJson(data['data']);
          final idx =
          _allCartItems.indexWhere((i) => i.menuId == menuId);

          if (idx != -1) {
            _allCartItems[idx] = updated;
          }

          _allCartItems.refresh();
        }
      } else {
        await fetchCart();
      }
    } catch (e) {
      debugPrint('updateQuantity error: $e');
      await fetchCart();
    } finally {
      isUpdating.value = false;
    }
  }

  // ───────────────── LOCAL UPDATE ─────────────────
  void _updateLocalQty(int menuId, String type) {
    final idx = _allCartItems.indexWhere((i) => i.menuId == menuId);
    if (idx == -1) return;

    final item = _allCartItems[idx];
    int newQty =
    type == 'increment' ? item.quantity + 1 : item.quantity - 1;

    if (newQty <= 0) {
      _allCartItems.removeAt(idx);
    } else {
      _allCartItems[idx] = item.copyWith(
        quantity: newQty,
        totalPrice: item.price * newQty,
      );
    }

    _allCartItems.refresh();
  }

  // ───────────────── CLEAR CART ─────────────────
  void clearCart() {
    _allCartItems.clear();
    _grandTotal.value = 0.0;
  }
}