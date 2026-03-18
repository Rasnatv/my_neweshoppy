
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/restaurantmaincartmodel.dart';

class FinalCartController extends GetxController {
  // ── Storage ────────────────────────────────────────────────────────────────
  final _box = GetStorage();

  // ── Observable state ───────────────────────────────────────────────────────
  final RxList<FinalCartRestaurantModel> restaurants =
      <FinalCartRestaurantModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Deletion loading states ────────────────────────────────────────────────
  final RxSet<int> deletingRestaurants = <int>{}.obs;
  final RxSet<String> deletingCartItems = <String>{}.obs;

  // ── Quantity update loading states ─────────────────────────────────────────
  // Key: "$cartId_increase" or "$cartId_decrease"
  final RxSet<String> updatingQuantityItems = <String>{}.obs;

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

  // ── API base ───────────────────────────────────────────────────────────────
  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_authToken',
  };

  // ── Fetch Final Cart ───────────────────────────────────────────────────────
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
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final FinalCartResponseModel cartResponse =
        FinalCartResponseModel.fromJson(jsonData);

        if (cartResponse.status == 1) {
          restaurants.assignAll(cartResponse.data);
        } else {
          errorMessage.value = cartResponse.message.isNotEmpty
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
      debugPrint('fetchFinalCart error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Update Quantity (increase / decrease) ──────────────────────────────────
  // POST /update-final-cart-quantity  { "cart_id": <id>, "action": "increase"|"decrease" }
  Future<void> updateQuantity({
    required int restaurantId,
    required int bookingId,
    required String cartId,
    required String action, // "increase" or "decrease"
  }) async {
    if (_authToken.isEmpty) return;

    final key = '${cartId}_$action';
    updatingQuantityItems.add(key);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/update-final-cart-quantity'),
        headers: _headers,
        body: jsonEncode({
          'cart_id': int.tryParse(cartId) ?? cartId,
          'action': action,
        }),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == 1) {
        final data = jsonData['data'] as Map<String, dynamic>;

        final newQuantity = (data['quantity'] as num).toInt();
        final newTotalPrice = (data['total_price'] as num).toDouble();
        final newPrice = (data['price'] as num).toDouble();

        // If decrease brought quantity to 0, remove item locally
        if (newQuantity <= 0) {
          _removeItemLocally(
            restaurantId: restaurantId,
            bookingId: bookingId,
            cartId: cartId,
          );
        } else {
          _updateItemLocally(
            restaurantId: restaurantId,
            bookingId: bookingId,
            cartId: cartId,
            newQuantity: newQuantity,
            newTotalPrice: newTotalPrice,
            newPrice: newPrice,
          );
        }
      } else {
        _showSnackbar(
          'Update Failed',
          jsonData['message'] ?? 'Could not update quantity. Try again.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('updateQuantity error: $e');
      _showSnackbar(
        'Network Error',
        'Could not connect. Please check your connection.',
        isError: true,
      );
    } finally {
      updatingQuantityItems.remove(key);
    }
  }

  // ── Internal: update item quantity/price in local list ────────────────────
  void _updateItemLocally({
    required int restaurantId,
    required int bookingId,
    required String cartId,
    required int newQuantity,
    required double newTotalPrice,
    required double newPrice,
  }) {
    final rIndex =
    restaurants.indexWhere((r) => r.restaurantId == restaurantId);
    if (rIndex == -1) return;

    final restaurant = restaurants[rIndex];
    final bIndex =
    restaurant.bookings.indexWhere((b) => b.bookingId == bookingId);
    if (bIndex == -1) return;

    final booking = restaurant.bookings[bIndex];
    final iIndex = booking.items.indexWhere((i) => i.cartId == cartId);
    if (iIndex == -1) return;

    // Build updated item
    final oldItem = booking.items[iIndex];
    final updatedItem = FinalCartItemModel(
      cartId: oldItem.cartId,
      itemName: oldItem.itemName,
      itemImage: oldItem.itemImage,
      price: newPrice,
      quantity: newQuantity,
      totalPrice: newTotalPrice,
    );

    // Build updated items list
    final updatedItems = List<FinalCartItemModel>.from(booking.items);
    updatedItems[iIndex] = updatedItem;

    // Build updated booking
    final updatedBooking = FinalCartBookingModel(
      bookingId: booking.bookingId,
      bookingDate: booking.bookingDate,
      timeSlot: booking.timeSlot,
      tableNo: booking.tableNo,
      items: updatedItems,
      bookingTotal: updatedItems.fold(0.0, (s, i) => s + i.totalPrice),
    );

    // Build updated bookings list
    final updatedBookings = List<FinalCartBookingModel>.from(restaurant.bookings);
    updatedBookings[bIndex] = updatedBooking;

    restaurants[rIndex] = FinalCartRestaurantModel(
      restaurantId: restaurant.restaurantId,
      restaurantName: restaurant.restaurantName,
      restaurantLocation: restaurant.restaurantLocation,
      bookings: updatedBookings,
    );

    restaurants.refresh();
  }

  // ── Delete Entire Restaurant ───────────────────────────────────────────────
  // DELETE /delete-restaurant-cart  { "restaurant_id": <id> }
  Future<void> removeRestaurant(int restaurantId) async {
    if (_authToken.isEmpty) return;

    deletingRestaurants.add(restaurantId);

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/delete-restaurant-cart'),
        headers: _headers,
        body: jsonEncode({'restaurant_id': restaurantId}),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == 1) {
        restaurants.removeWhere((r) => r.restaurantId == restaurantId);
        restaurants.refresh();
        _showSnackbar(
          'Restaurant Removed',
          jsonData['message'] ?? 'Restaurant removed from cart.',
          isError: false,
        );
      } else {
        _showSnackbar(
          'Failed',
          jsonData['message'] ?? 'Could not remove restaurant. Try again.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('removeRestaurant error: $e');
      _showSnackbar(
        'Network Error',
        'Could not connect. Please check your connection.',
        isError: true,
      );
    } finally {
      deletingRestaurants.remove(restaurantId);
    }
  }

  // ── Delete Single Cart Item ────────────────────────────────────────────────
  // DELETE /delete-cart-item  { "cart_id": <id> }
  Future<void> removeCartItem({
    required int restaurantId,
    required int bookingId,
    required String cartId,
  }) async {
    if (_authToken.isEmpty) return;

    deletingCartItems.add(cartId);

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/delete-cart-item'),
        headers: _headers,
        body: jsonEncode({'cart_id': int.tryParse(cartId) ?? cartId}),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == 1) {
        _removeItemLocally(
            restaurantId: restaurantId,
            bookingId: bookingId,
            cartId: cartId);
        _showSnackbar(
          'Item Removed',
          jsonData['message'] ?? 'Item removed from cart.',
          isError: false,
        );
      } else {
        _showSnackbar(
          'Failed',
          jsonData['message'] ?? 'Could not remove item. Try again.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('removeCartItem error: $e');
      _showSnackbar(
        'Network Error',
        'Could not connect. Please check your connection.',
        isError: true,
      );
    } finally {
      deletingCartItems.remove(cartId);
    }
  }

  // ── Internal: remove item from local list ─────────────────────────────────
  void _removeItemLocally({
    required int restaurantId,
    required int bookingId,
    required String cartId,
  }) {
    final rIndex =
    restaurants.indexWhere((r) => r.restaurantId == restaurantId);
    if (rIndex == -1) return;

    final restaurant = restaurants[rIndex];
    final bIndex =
    restaurant.bookings.indexWhere((b) => b.bookingId == bookingId);
    if (bIndex == -1) return;

    final booking = restaurant.bookings[bIndex];
    final updatedItems =
    booking.items.where((i) => i.cartId != cartId).toList();

    final updatedBooking = FinalCartBookingModel(
      bookingId: booking.bookingId,
      bookingDate: booking.bookingDate,
      timeSlot: booking.timeSlot,
      tableNo: booking.tableNo,
      items: updatedItems,
      bookingTotal: updatedItems.fold(0.0, (s, i) => s + i.totalPrice),
    );

    final updatedBookings = List<FinalCartBookingModel>.from(restaurant.bookings);
    if (updatedItems.isEmpty) {
      updatedBookings.removeAt(bIndex);
    } else {
      updatedBookings[bIndex] = updatedBooking;
    }

    if (updatedBookings.isEmpty) {
      restaurants.removeAt(rIndex);
    } else {
      restaurants[rIndex] = FinalCartRestaurantModel(
        restaurantId: restaurant.restaurantId,
        restaurantName: restaurant.restaurantName,
        restaurantLocation: restaurant.restaurantLocation,
        bookings: updatedBookings,
      );
    }

    restaurants.refresh();
  }

  // ── Remove Booking (all items in a booking) ────────────────────────────────
  Future<void> removeBooking(int restaurantId, int bookingId) async {
    final rIndex =
    restaurants.indexWhere((r) => r.restaurantId == restaurantId);
    if (rIndex == -1) return;

    final booking = restaurants[rIndex]
        .bookings
        .firstWhereOrNull((b) => b.bookingId == bookingId);
    if (booking == null) return;

    for (final item in booking.items) {
      await removeCartItem(
        restaurantId: restaurantId,
        bookingId: bookingId,
        cartId: item.cartId,
      );
    }
  }

  // ── Snackbar helper ────────────────────────────────────────────────────────
  void _showSnackbar(String title, String message, {required bool isError}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red : const Color(0xFF0F5151),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: Icon(
        isError
            ? Icons.error_outline_rounded
            : Icons.check_circle_outline_rounded,
        color: Colors.white,
      ),
    );
  }

  // ── Format price helper ────────────────────────────────────────────────────
  static String formatPrice(double price) =>
      price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);

  // ── Helpers for UI ─────────────────────────────────────────────────────────
  bool isDeletingRestaurant(int restaurantId) =>
      deletingRestaurants.contains(restaurantId);

  bool isDeletingItem(String cartId) => deletingCartItems.contains(cartId);

  bool isUpdatingQuantity(String cartId, String action) =>
      updatingQuantityItems.contains('${cartId}_$action');

  bool isAnyQuantityUpdating(String cartId) =>
      updatingQuantityItems.contains('${cartId}_increase') ||
          updatingQuantityItems.contains('${cartId}_decrease');
}