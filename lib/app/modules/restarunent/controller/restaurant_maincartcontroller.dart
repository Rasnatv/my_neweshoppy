// ── CART CONTROLLER ────────────────────────────────────────────────────────────
// File: lib/controllers/cart_controller.dart
//
// Dependencies: get, get_storage, http
// Run: flutter pub add get get_storage http
// Init in main.dart: await GetStorage.init();

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/restaurantmaincartmodel.dart';



class MainCartController extends GetxController {
  // ── GetStorage ─────────────────────────────────────────────────────────────
  final box = GetStorage();

  // ── State ──────────────────────────────────────────────────────────────────
  final RxList<MainCartRestaurantModel> restaurants = <MainCartRestaurantModel>[].obs;
  final RxDouble grandTotal = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ── API Config ─────────────────────────────────────────────────────────────
  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  // ── Auth Token from GetStorage ─────────────────────────────────────────────
  String get _authToken => box.read('auth_token') ?? '';

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  // ── Fetch Cart ─────────────────────────────────────────────────────────────
  Future<void> fetchCart() async {
    if (_authToken.isEmpty) {
      errorMessage.value = 'User not authenticated. Please log in.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('$_baseUrl/final-cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final cartResponse = MainCartResponseModel.fromJson(json);

        if (cartResponse.status == 1) {
          restaurants.assignAll(cartResponse.restaurants);
          grandTotal.value = cartResponse.grandTotal;
        } else {
          errorMessage.value = cartResponse.message;
        }
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Session expired. Please log in again.';
        box.remove('auth_token'); // clear invalid token
      } else {
        errorMessage.value =
        'Server error: ${response.statusCode}. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Network error. Please check your connection.';
      debugPrint('CartController.fetchCart error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Remove Restaurant ──────────────────────────────────────────────────────
  void removeRestaurant(int restaurantId) {
    restaurants.removeWhere((r) => r.restaurantId == restaurantId);
    _recalculateGrandTotal();
  }

  // ── Remove Item ────────────────────────────────────────────────────────────
  void removeItem(int restaurantId, String itemName) {
    final idx = restaurants.indexWhere((r) => r.restaurantId == restaurantId);
    if (idx == -1) return;

    final restaurant = restaurants[idx];
    final updatedItems =
    restaurant.items.where((i) => i.itemName != itemName).toList();

    if (updatedItems.isEmpty) {
      restaurants.removeAt(idx);
    } else {
      final updatedSubtotal =
      updatedItems.fold(0.0, (sum, i) => sum + i.totalPrice);
      restaurants[idx] = MainCartRestaurantModel(
        restaurantId: restaurant.restaurantId,
        restaurantName: restaurant.restaurantName,
        restaurantLocation: restaurant.restaurantLocation,
        subtotal: updatedSubtotal,
        items: updatedItems,
      );
    }
    _recalculateGrandTotal();
  }

  // ── Increment Item ─────────────────────────────────────────────────────────
  void incrementItem(int restaurantId, String itemName) {
    _updateItemQuantity(restaurantId, itemName, 1);
  }

  // ── Decrement Item ─────────────────────────────────────────────────────────
  void decrementItem(int restaurantId, String itemName) {
    final idx = restaurants.indexWhere((r) => r.restaurantId == restaurantId);
    if (idx == -1) return;

    final restaurant = restaurants[idx];
    final item =
    restaurant.items.firstWhereOrNull((i) => i.itemName == itemName);
    if (item == null) return;

    if (item.quantity <= 1) {
      removeItem(restaurantId, itemName);
    } else {
      _updateItemQuantity(restaurantId, itemName, -1);
    }
  }

  // ── Internal: Update Quantity ──────────────────────────────────────────────
  void _updateItemQuantity(int restaurantId, String itemName, int delta) {
    final rIdx = restaurants.indexWhere((r) => r.restaurantId == restaurantId);
    if (rIdx == -1) return;

    final restaurant = restaurants[rIdx];
    final updatedItems = restaurant.items.map((item) {
      if (item.itemName == itemName) {
        final newQty = item.quantity + delta;
        return MainCartItemModel(
          itemName: item.itemName,
          image: item.image,
          price: item.price,
          quantity: newQty,
          totalPrice: item.price * newQty,
        );
      }
      return item;
    }).toList();

    final updatedSubtotal =
    updatedItems.fold(0.0, (sum, i) => sum + i.totalPrice);

    restaurants[rIdx] = MainCartRestaurantModel(
      restaurantId: restaurant.restaurantId,
      restaurantName: restaurant.restaurantName,
      restaurantLocation: restaurant.restaurantLocation,
      subtotal: updatedSubtotal,
      items: updatedItems,
    );

    _recalculateGrandTotal();
  }

  // ── Internal: Recalculate Grand Total ─────────────────────────────────────
  void _recalculateGrandTotal() {
    grandTotal.value = restaurants.fold(0.0, (sum, r) => sum + r.total);
  }

  // ── Getters ────────────────────────────────────────────────────────────────
  int get totalItemCount =>
      restaurants.fold(0, (sum, r) => sum + r.itemCount);

  bool get isEmpty => restaurants.isEmpty;
}