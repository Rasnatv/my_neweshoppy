// lib/app/modules/restarunent/controller/restaurantcartcontroller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/restaruantcartmodel.dart';


class Restaurantcartcontroller extends GetxController {
  // ── Base URL ──────────────────────────────────────────────────────────────
  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  // ── Observable State ──────────────────────────────────────────────────────
  // All cart items (all restaurants combined from API)
  final RxList<RestaurantCartModel> _allCartItems = <RestaurantCartModel>[].obs;

  // Current active restaurant id (set when user opens a restaurant)
  final RxInt currentRestaurantId = 0.obs;

  final RxDouble _grandTotal = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;

  // ── Storage ───────────────────────────────────────────────────────────────
  final _box = GetStorage();

  // ── Auth Token ────────────────────────────────────────────────────────────
  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken.isNotEmpty) 'Authorization': 'Bearer $_authToken',
  };

  // ── Filtered items for CURRENT restaurant ────────────────────────────────
  List<RestaurantCartModel> get cartItems => currentRestaurantId.value == 0
      ? _allCartItems.toList()
      : _allCartItems
      .where((item) => item.restaurantId == currentRestaurantId.value)
      .toList();

  // ── Items for a SPECIFIC restaurant (for icon badge) ─────────────────────
  List<RestaurantCartModel> itemsForRestaurant(int restaurantId) =>
      _allCartItems
          .where((item) => item.restaurantId == restaurantId)
          .toList();

  // ── Grand total for CURRENT restaurant only ───────────────────────────────
  double get grandTotal => cartItems.fold(0.0, (sum, i) => sum + i.totalPrice);

  // ── Grand total for a SPECIFIC restaurant ────────────────────────────────
  double grandTotalForRestaurant(int restaurantId) => itemsForRestaurant(restaurantId)
      .fold(0.0, (sum, i) => sum + i.totalPrice);

  // ── Computed for CURRENT restaurant ──────────────────────────────────────
  bool get hasItems => cartItems.isNotEmpty;

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => grandTotal;

  // ── hasItems for a SPECIFIC restaurant (for menu tab floating bar) ────────
  bool hasItemsForRestaurant(int restaurantId) =>
      itemsForRestaurant(restaurantId).isNotEmpty;

  int totalItemsForRestaurant(int restaurantId) =>
      itemsForRestaurant(restaurantId)
          .fold(0, (sum, item) => sum + item.quantity);

  double totalAmountForRestaurant(int restaurantId) =>
      grandTotalForRestaurant(restaurantId);

  // ── isInCart / itemQty scoped to a restaurant ─────────────────────────────
  bool isInCart(int menuId) =>
      cartItems.any((item) => item.menuId == menuId);

  bool isInCartForRestaurant(int menuId, int restaurantId) =>
      itemsForRestaurant(restaurantId).any((item) => item.menuId == menuId);

  int itemQty(int menuId) {
    try {
      return cartItems.firstWhere((item) => item.menuId == menuId).quantity;
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

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  // ── Set active restaurant (call when opening restaurant page) ─────────────
  void setRestaurant(int restaurantId) {
    currentRestaurantId.value = restaurantId;
  }

  // ── Fetch ALL cart items from API ─────────────────────────────────────────
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
          // grand total from API is global; we compute per-restaurant locally
          _grandTotal.value =
              double.tryParse(data['grand_total']?.toString() ?? '0') ?? 0.0;
        }
      }
    } catch (e) {
      debugPrint('fetchCart error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Add To Cart ───────────────────────────────────────────────────────────
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
        }
      }
      return false;
    } catch (e) {
      debugPrint('addToCart error: $e');
      return false;
    }
  }

  // ── Update Quantity ───────────────────────────────────────────────────────
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
          final idx = _allCartItems.indexWhere((i) => i.menuId == menuId);
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

  // ── Local optimistic update ───────────────────────────────────────────────
  void _updateLocalQty(int menuId, String type) {
    final idx = _allCartItems.indexWhere((i) => i.menuId == menuId);
    if (idx == -1) return;

    final item = _allCartItems[idx];
    int newQty = type == 'increment' ? item.quantity + 1 : item.quantity - 1;

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

  // ── Clear Cart ────────────────────────────────────────────────────────────
  void clearCart() {
    _allCartItems.clear();
    _grandTotal.value = 0.0;
  }
}