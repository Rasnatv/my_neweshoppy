
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

  // ───────────────── FETCH CART ─────────────────
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
          _allCartItems.clear();
          // AppSnackbar.error(data['message'] ?? "Failed to load cart");
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

  // ───────────────── ADD TO CART ─────────────────
  Future<bool> addToCart({
    required int restaurantId,
    required int menuId,
    required String itemName,
    required String image,
    required double price,
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
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 1) {
          await fetchCart();
          return true;
        } else {
          AppSnackbar.error(data['message'] ?? "Add to cart failed");
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
      debugPrint('addToCart error: $e');
    }
    return false;
  }

  // ───────────────── UPDATE QUANTITY ─────────────────
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
        } else {
          AppSnackbar.error(data['message'] ?? "Update failed");
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
        await fetchCart();
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
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