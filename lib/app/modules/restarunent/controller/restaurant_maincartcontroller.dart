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
// ── restaurant_maincartcontroller.dart ────────────────────────────────────────
//
// Requires:
//   get_storage: ^2.x  (GetStorage)
//   get: ^4.x          (GetX)
//   http: ^1.x
//
// GetStorage key expected:  'auth_token'  →  Bearer token string
// ─────────────────────────────────────────────────────────────────────────────
// ── restaurant_maincartcontroller.dart ────────────────────────────────────────
//
// Dependencies:
//   get: ^4.x
//   get_storage: ^2.x
//   http: ^1.x
//
// GetStorage key: 'auth_token' → Bearer token string
// ─────────────────────────────────────────────────────────────────────────────

// ── restaurant_finalcart_controller.dart ─────────────────────────────────────
//
// Usage:
//   final FinalCartController controller = Get.put(FinalCartController());
//
// Requires:  get_storage, get, http (or dio)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/restaurantmaincartmodel.dart';



class FinalCartController extends GetxController {
  // ── Storage ────────────────────────────────────────────────────────────────
  final  _box = GetStorage();

  // ── Observable state ───────────────────────────────────────────────────────
  final RxList<FinalCartRestaurantModel> restaurants =
      <FinalCartRestaurantModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Computed ───────────────────────────────────────────────────────────────
  bool get isEmpty => restaurants.isEmpty;

  double get grandTotal =>
      restaurants.fold(0.0, (sum, r) => sum + r.restaurantTotal);

  int get totalBookingCount =>
      restaurants.fold(0, (sum, r) => sum + r.bookings.length);

  int get totalItemCount =>
      restaurants.fold(0, (sum, r) => sum + r.totalItemCount);

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchFinalCart();
  }

  // ── Auth token helper ──────────────────────────────────────────────────────
  String get _authToken => _box.read('auth_token') ?? '';

  // ── API ────────────────────────────────────────────────────────────────────
  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  Future<void> fetchFinalCart() async {
    if (_authToken.isEmpty) {
      errorMessage.value = 'Authentication token not found. Please log in.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('$_baseUrl/restaurant-final-cart'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final FinalCartResponseModel cartResponse =
        FinalCartResponseModel.fromJson(jsonData);

        if (cartResponse.status == 1) {
          restaurants.assignAll(cartResponse.data);
        } else {
          errorMessage.value =
          cartResponse.message.isNotEmpty
              ? cartResponse.message
              : 'Failed to fetch cart.';
        }
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Session expired. Please log in again.';
      } else {
        errorMessage.value =
        'Server error (${response.statusCode}). Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Network error. Please check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Remove a single booking ────────────────────────────────────────────────
  Future<void> removeBooking(int restaurantId, int bookingId) async {
    if (_authToken.isEmpty) return;

    try {
      // Optimistic UI: remove locally first
      final rIndex =
      restaurants.indexWhere((r) => r.restaurantId == restaurantId);
      if (rIndex == -1) return;

      final updatedBookings = restaurants[rIndex]
          .bookings
          .where((b) => b.bookingId != bookingId)
          .toList();

      if (updatedBookings.isEmpty) {
        // Remove the entire restaurant card if no bookings remain
        restaurants.removeAt(rIndex);
      } else {
        restaurants[rIndex] = FinalCartRestaurantModel(
          restaurantId: restaurants[rIndex].restaurantId,
          restaurantName: restaurants[rIndex].restaurantName,
          restaurantLocation: restaurants[rIndex].restaurantLocation,
          bookings: updatedBookings,
        );
      }
      restaurants.refresh();

      // TODO: Add your delete booking API call here
      // await http.delete(
      //   Uri.parse('$_baseUrl/restaurant-booking/$bookingId'),
      //   headers: {'Authorization': 'Bearer $_authToken'},
      // );
    } catch (e) {
      errorMessage.value = 'Failed to remove booking.';
      fetchFinalCart(); // Re-sync on error
    }
  }


  void removeRestaurant(int restaurantId) {
    restaurants.removeWhere((r) => r.restaurantId == restaurantId);
    restaurants.refresh();
  }

  // ── Format price helper ────────────────────────────────────────────────────
  static String formatPrice(double price) =>
      price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);
}