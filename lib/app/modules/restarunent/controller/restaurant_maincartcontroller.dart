// // ── CART CONTROLLER ────────────────────────────────────────────────────────────
// // File: lib/controllers/cart_controller.dart
// //
// // Dependencies: get, get_storage, http
// // Run: flutter pub add get get_storage http
// // Init in main.dart: await GetStorage.init();
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/models/restaurantmaincartmodel.dart';
//
//
//
// class MainCartController extends GetxController {
//   // ── GetStorage ─────────────────────────────────────────────────────────────
//   final box = GetStorage();
//
//   // ── State ──────────────────────────────────────────────────────────────────
//   final RxList<MainCartRestaurantModel> restaurants = <MainCartRestaurantModel>[].obs;
//   final RxDouble grandTotal = 0.0.obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//
//   // ── API Config ─────────────────────────────────────────────────────────────
//   static const String _baseUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api';
//
//   // ── Auth Token from GetStorage ─────────────────────────────────────────────
//   String get _authToken => box.read('auth_token') ?? '';
//
//   // ── Lifecycle ──────────────────────────────────────────────────────────────
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCart();
//   }
//
//   // ── Fetch Cart ─────────────────────────────────────────────────────────────
//   Future<void> fetchCart() async {
//     if (_authToken.isEmpty) {
//       errorMessage.value = 'User not authenticated. Please log in.';
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final response = await http.get(
//         Uri.parse('$_baseUrl/final-cart'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_authToken',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         final cartResponse = MainCartResponseModel.fromJson(json);
//
//         if (cartResponse.status == 1) {
//           restaurants.assignAll(cartResponse.restaurants);
//           grandTotal.value = cartResponse.grandTotal;
//         } else {
//           errorMessage.value = cartResponse.message;
//         }
//       } else if (response.statusCode == 401) {
//         errorMessage.value = 'Session expired. Please log in again.';
//         box.remove('auth_token'); // clear invalid token
//       } else {
//         errorMessage.value =
//         'Server error: ${response.statusCode}. Please try again.';
//       }
//     } catch (e) {
//       errorMessage.value = 'Network error. Please check your connection.';
//       debugPrint('CartController.fetchCart error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ── Remove Restaurant ──────────────────────────────────────────────────────
//   void removeRestaurant(int restaurantId) {
//     restaurants.removeWhere((r) => r.restaurantId == restaurantId);
//     _recalculateGrandTotal();
//   }
//
//   // ── Remove Item ────────────────────────────────────────────────────────────
//   void removeItem(int restaurantId, String itemName) {
//     final idx = restaurants.indexWhere((r) => r.restaurantId == restaurantId);
//     if (idx == -1) return;
//
//     final restaurant = restaurants[idx];
//     final updatedItems =
//     restaurant.items.where((i) => i.itemName != itemName).toList();
//
//     if (updatedItems.isEmpty) {
//       restaurants.removeAt(idx);
//     } else {
//       final updatedSubtotal =
//       updatedItems.fold(0.0, (sum, i) => sum + i.totalPrice);
//       restaurants[idx] = MainCartRestaurantModel(
//         restaurantId: restaurant.restaurantId,
//         restaurantName: restaurant.restaurantName,
//         restaurantLocation: restaurant.restaurantLocation,
//         subtotal: updatedSubtotal,
//         items: updatedItems,
//       );
//     }
//     _recalculateGrandTotal();
//   }
//
//   // ── Increment Item ─────────────────────────────────────────────────────────
//   void incrementItem(int restaurantId, String itemName) {
//     _updateItemQuantity(restaurantId, itemName, 1);
//   }
//
//   // ── Decrement Item ─────────────────────────────────────────────────────────
//   void decrementItem(int restaurantId, String itemName) {
//     final idx = restaurants.indexWhere((r) => r.restaurantId == restaurantId);
//     if (idx == -1) return;
//
//     final restaurant = restaurants[idx];
//     final item =
//     restaurant.items.firstWhereOrNull((i) => i.itemName == itemName);
//     if (item == null) return;
//
//     if (item.quantity <= 1) {
//       removeItem(restaurantId, itemName);
//     } else {
//       _updateItemQuantity(restaurantId, itemName, -1);
//     }
//   }
//
//   // ── Internal: Update Quantity ──────────────────────────────────────────────
//   void _updateItemQuantity(int restaurantId, String itemName, int delta) {
//     final rIdx = restaurants.indexWhere((r) => r.restaurantId == restaurantId);
//     if (rIdx == -1) return;
//
//     final restaurant = restaurants[rIdx];
//     final updatedItems = restaurant.items.map((item) {
//       if (item.itemName == itemName) {
//         final newQty = item.quantity + delta;
//         return MainCartItemModel(
//           itemName: item.itemName,
//           image: item.image,
//           price: item.price,
//           quantity: newQty,
//           totalPrice: item.price * newQty,
//         );
//       }
//       return item;
//     }).toList();
//
//     final updatedSubtotal =
//     updatedItems.fold(0.0, (sum, i) => sum + i.totalPrice);
//
//     restaurants[rIdx] = MainCartRestaurantModel(
//       restaurantId: restaurant.restaurantId,
//       restaurantName: restaurant.restaurantName,
//       restaurantLocation: restaurant.restaurantLocation,
//       subtotal: updatedSubtotal,
//       items: updatedItems,
//     );
//
//     _recalculateGrandTotal();
//   }
//
//   // ── Internal: Recalculate Grand Total ─────────────────────────────────────
//   void _recalculateGrandTotal() {
//     grandTotal.value = restaurants.fold(0.0, (sum, r) => sum + r.total);
//   }
//
//   // ── Getters ────────────────────────────────────────────────────────────────
//   int get totalItemCount =>
//       restaurants.fold(0, (sum, r) => sum + r.itemCount);
//
//   bool get isEmpty => restaurants.isEmpty;

// ── restaurant_maincartcontroller.dart ───────────────────────────────────────
// POST /restaurant/final-cart  { "restaurant_id": <id> }
// ─────────────────────────────────────────────────────────────────────────────
// ── restaurant_maincartcontroller.dart ───────────────────────────────────────

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/restaurantmaincartmodel.dart';

class MainCartController extends GetxController {
  // ── restaurantId passed directly — never from Get.arguments ───────────────
  final int restaurantId;
  MainCartController({required this.restaurantId});

  // ── State ──────────────────────────────────────────────────────────────────
  final Rx<FinalCartData?> cartData    = Rx<FinalCartData?>(null);
  final RxBool             isLoading   = false.obs;
  final RxString           errorMessage = ''.obs;

  // ── Config ─────────────────────────────────────────────────────────────────
  static const String _base =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';
  static const String _imageBase =
      'https://rasma.astradevelops.in/e_shoppyy/public/';

  String imageUrl(String path) => '$_imageBase$path';

  final _box = GetStorage();
  String get _token => _box.read<String>('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    debugPrint('── MainCartController.onInit  restaurantId=$restaurantId');
    fetchCart();
  }

  // ── Fetch ──────────────────────────────────────────────────────────────────
  Future<void> fetchCart() async {
    try {
      isLoading.value    = true;
      errorMessage.value = '';
      cartData.value     = null;   // clear stale data while loading

      final body = jsonEncode({'restaurant_id': restaurantId});
      debugPrint('── FINAL CART REQUEST  body=$body  token=${_token.isNotEmpty}');

      final res = await http.post(
        Uri.parse('$_base/restaurant/final-cart'),
        headers: {
          'Content-Type': 'application/json',
          'Accept':       'application/json',
          if (_token.isNotEmpty) 'Authorization': 'Bearer $_token',
        },
        body: body,
      );

      debugPrint('── FINAL CART RESPONSE status=${res.statusCode}');
      debugPrint('── FINAL CART RESPONSE body=${res.body}');

      final json   = _safe(res.body);
      final parsed = FinalCartResponse.fromJson(json);

      debugPrint('── parsed.status=${parsed.status}  parsed.message=${parsed.message}');
      debugPrint('── parsed.data=${parsed.data}');

      if (parsed.status == 1 && parsed.data != null) {
        cartData.value = parsed.data;
        debugPrint('── cartItems count=${parsed.data!.cartItems.length}');
      } else {
        errorMessage.value = parsed.message.isNotEmpty
            ? parsed.message
            : 'Could not load cart.';
      }
    } catch (e, st) {
      errorMessage.value = 'Network error. Please check your connection.';
      debugPrint('── fetchCart ERROR: $e');
      debugPrintStack(stackTrace: st, label: 'fetchCart');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Local qty controls (no network call) ──────────────────────────────────
  void incrementItem(int itemId) => _changeQty(itemId, 1);

  void decrementItem(int itemId) {
    final item = cartData.value?.cartItems
        .firstWhereOrNull((i) => i.id == itemId);
    if (item != null && item.quantity <= 1) {
      removeItem(itemId);
    } else {
      _changeQty(itemId, -1);
    }
  }

  void removeItem(int itemId) {
    if (cartData.value == null) return;
    _updateItems(
      cartData.value!.cartItems.where((i) => i.id != itemId).toList(),
    );
  }

  void _changeQty(int itemId, int delta) {
    if (cartData.value == null) return;
    final updated = cartData.value!.cartItems.map((i) {
      if (i.id == itemId) return i.copyWith(quantity: i.quantity + delta);
      return i;
    }).toList();
    _updateItems(updated);
  }

  void _updateItems(List<FinalCartItem> items) {
    final old = cartData.value!;
    cartData.value = FinalCartData(
      restaurant:     old.restaurant,
      bookingDetails: old.bookingDetails,
      cartItems:      items,
      grandTotal:     items.fold(0.0, (s, i) => s + i.totalPrice),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  bool get isEmpty =>
      cartData.value == null || cartData.value!.cartItems.isEmpty;

  Map<String, dynamic> _safe(String body) {
    try {
      final d = jsonDecode(body);
      return d is Map<String, dynamic>
          ? d
          : {'status': 0, 'message': 'Unexpected response'};
    } catch (_) {
      return {'status': 0, 'message': 'Invalid JSON'};
    }
  }
}
