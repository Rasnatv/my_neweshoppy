import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/restaurantmaincartmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../../userhome/widget/guestrole.dart';

class FinalCartController extends GetxController {
  static const int maxQty = 10;

  // ─────────────────────────────────────────────────────────────
  // STORAGE
  // ─────────────────────────────────────────────────────────────

  final _box = GetStorage();

  // ─────────────────────────────────────────────────────────────
  // OBSERVABLES
  // ─────────────────────────────────────────────────────────────

  final RxInt cartItemCount = 0.obs;
  final RxList<FinalCartRestaurantModel> restaurants =
      <FinalCartRestaurantModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ─────────────────────────────────────────────────────────────
  // DELETE LOADING STATES
  // ─────────────────────────────────────────────────────────────

  final RxSet<int> deletingRestaurants = <int>{}.obs;
  final RxSet<String> deletingCartItems = <String>{}.obs;

  // ─────────────────────────────────────────────────────────────
  // QUANTITY UPDATE STATES
  // ─────────────────────────────────────────────────────────────

  final RxSet<String> updatingQuantityItems = <String>{}.obs;

  // ─────────────────────────────────────────────────────────────
  // COMPUTED VALUES
  // ─────────────────────────────────────────────────────────────

  bool get isEmpty => restaurants.isEmpty;

  double get grandTotal =>
      restaurants.fold(0.0, (sum, r) => sum + r.restaurantTotal);

  int get totalBookingCount =>
      restaurants.fold(0, (sum, r) => sum + r.bookings.length);

  int get totalItemCount =>
      restaurants.fold(0, (sum, r) => sum + r.totalItemCount);

  // ─────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    // ✅ Fix stale guest flag — token presence is the source of truth.
    _fixStaleGuestFlag();

    fetchFinalCart();
  }

  /// Clears stale `is_guest=true` that may remain from a previous guest
  /// session when the user has since logged in and a token was saved.
  void _fixStaleGuestFlag() {
    final token = _authToken;
    if (token.isNotEmpty && GuestService.isGuest) {
      _box.remove('is_guest');
      _box.write('is_logged_in', true);
      debugPrint('🔧 Stale guest flag cleared — user has a valid token');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // TOKEN
  // ─────────────────────────────────────────────────────────────

  String get _authToken => _box.read<String>('auth_token') ?? '';

  // ─────────────────────────────────────────────────────────────
  // API BASE
  // ─────────────────────────────────────────────────────────────

  static const String _baseUrl = 'https://eshoppy.co.in/api';

  // ─────────────────────────────────────────────────────────────
  // HEADERS
  // ─────────────────────────────────────────────────────────────

  Map<String, String> get _headers {
    final token = _authToken;

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // ─────────────────────────────────────────────────────────────
  // FETCH FINAL CART
  // ─────────────────────────────────────────────────────────────

  Future<void> fetchFinalCart() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('$_baseUrl/restaurant-final-cart'),
        headers: _headers,
      );

      debugPrint('📦 Cart status: ${response.statusCode}');
      debugPrint('📦 Cart body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final FinalCartResponseModel cartResponse =
        FinalCartResponseModel.fromJson(jsonData);

        if (cartResponse.status == 1) {
          // ✅ Full reassign — forces GetX to detect the change
          restaurants.value = cartResponse.data;
          debugPrint('✅ Restaurants loaded: ${restaurants.length}');
        } else {
          // Empty cart — not an error
          restaurants.value = [];
          debugPrint('ℹ️ Cart empty: ${cartResponse.message}');
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        if (msg.isNotEmpty) {
          errorMessage.value = msg;
          AppSnackbar.error(msg);
        }
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) {
        errorMessage.value = msg;
        AppSnackbar.error(msg);
      }
      debugPrint('❌ fetchFinalCart error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Alias
  Future<void> fetchCart() => fetchFinalCart();

  // ─────────────────────────────────────────────────────────────
  // UPDATE QUANTITY
  // ─────────────────────────────────────────────────────────────

  Future<void> updateQuantity({
    required int restaurantId,
    required int? bookingId,
    required String cartId,
    required String action,
  }) async {
    // ── Local guard: max qty check ──────────────────────────────
    final rIndex =
    restaurants.indexWhere((r) => r.restaurantId == restaurantId);
    if (rIndex != -1) {
      final bIndex = restaurants[rIndex]
          .bookings
          .indexWhere((b) => b.bookingId == bookingId);
      if (bIndex != -1) {
        final iIndex = restaurants[rIndex]
            .bookings[bIndex]
            .items
            .indexWhere((i) => i.cartId == cartId);
        if (iIndex != -1) {
          final currentQty =
              restaurants[rIndex].bookings[bIndex].items[iIndex].quantity;
          if (action == 'increase' && currentQty >= maxQty) {
            AppSnackbar.warning(
              'Limit Reached. Maximum $maxQty items can be purchased at a time.',
            );
            return;
          }
        }
      }
    }

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

      debugPrint('🔄 Update qty status: ${response.statusCode}');
      debugPrint('🔄 Update qty body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 1) {
          // ✅ Re-fetch from server — always in sync
          await fetchFinalCart();
        } else {
          final msg =
              jsonData['message'] ?? 'Could not update quantity. Try again.';
          AppSnackbar.error(msg);
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        if (msg.isNotEmpty) AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) AppSnackbar.error(msg);
      debugPrint('❌ updateQuantity error: $e');
    } finally {
      updatingQuantityItems.remove(key);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // REMOVE RESTAURANT
  // ─────────────────────────────────────────────────────────────

  Future<void> removeRestaurant(int restaurantId) async {
    deletingRestaurants.add(restaurantId);

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/delete-restaurant-cart'),
        headers: _headers,
        body: jsonEncode({'restaurant_id': restaurantId}),
      );

      debugPrint('🗑️ Delete restaurant status: ${response.statusCode}');
      debugPrint('🗑️ Delete restaurant body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 1) {
          // ✅ Re-fetch — cart UI refreshes automatically
          await fetchFinalCart();
        } else {
          final msg = jsonData['message'] ?? 'Could not remove restaurant.';
          AppSnackbar.error(msg);
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        if (msg.isNotEmpty) AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) AppSnackbar.error(msg);
      debugPrint('❌ removeRestaurant error: $e');
    } finally {
      deletingRestaurants.remove(restaurantId);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // REMOVE CART ITEM
  // ─────────────────────────────────────────────────────────────

  Future<void> removeCartItem({
    required int restaurantId,
    required int? bookingId,
    required String cartId,
  }) async {
    deletingCartItems.add(cartId);

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/delete-cart-item'),
        headers: _headers,
        body: jsonEncode({'cart_id': int.tryParse(cartId) ?? cartId}),
      );

      debugPrint('🗑️ Delete item status: ${response.statusCode}');
      debugPrint('🗑️ Delete item body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 1) {

          await fetchFinalCart();
        } else {
          final msg = jsonData['message'] ?? 'Could not remove item.';
          AppSnackbar.error(msg);
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        if (msg.isNotEmpty) AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) AppSnackbar.error(msg);
      debugPrint('❌ removeCartItem error: $e');
    } finally {
      deletingCartItems.remove(cartId);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // REMOVE BOOKING
  // Deletes all items in a booking one by one.
  // Each removeCartItem call already re-fetches, so the UI
  // stays in sync after every item removal.
  // ─────────────────────────────────────────────────────────────

  Future<void> removeBooking(int restaurantId, int? bookingId) async {
    final rIndex =
    restaurants.indexWhere((r) => r.restaurantId == restaurantId);
    if (rIndex == -1) return;

    final booking = restaurants[rIndex]
        .bookings
        .firstWhereOrNull((b) => b.bookingId == bookingId);
    if (booking == null) return;

    // Copy item list before iterating — list mutates after each re-fetch
    final itemIds = booking.items.map((i) => i.cartId).toList();

    for (final cartId in itemIds) {
      await removeCartItem(
        restaurantId: restaurantId,
        bookingId: bookingId,
        cartId: cartId,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────

  static String formatPrice(double price) {
    return price % 1 == 0
        ? price.toInt().toString()
        : price.toStringAsFixed(2);
  }

  bool isDeletingRestaurant(int restaurantId) =>
      deletingRestaurants.contains(restaurantId);

  bool isDeletingItem(String cartId) => deletingCartItems.contains(cartId);

  bool isUpdatingQuantity(String cartId, String action) =>
      updatingQuantityItems.contains('${cartId}_$action');

  bool isAnyQuantityUpdating(String cartId) =>
      updatingQuantityItems.contains('${cartId}_increase') ||
          updatingQuantityItems.contains('${cartId}_decrease');

  bool get isGuestUser => GuestService.isGuest;
  bool get isLoggedInUser => GuestService.isLoggedIn;
}