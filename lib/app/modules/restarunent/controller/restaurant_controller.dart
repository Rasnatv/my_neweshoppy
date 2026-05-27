
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/userrestaurantmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../../userhome/widget/guestrole.dart';

class RestaurantController extends GetxController {
  // ─────────────────────────────────────────────────────────────
  // OBSERVABLES
  // ─────────────────────────────────────────────────────────────

  final restaurants = <Restaurant>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  // ─────────────────────────────────────────────────────────────
  // STORAGE
  // ─────────────────────────────────────────────────────────────

  final GetStorage box = GetStorage();

  // ─────────────────────────────────────────────────────────────
  // API
  // ─────────────────────────────────────────────────────────────

  static const String apiUrl =
      "https://eshoppy.co.in/api/user/restaurants";

  // ─────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  // ─────────────────────────────────────────────────────────────
  // TOKEN
  // ─────────────────────────────────────────────────────────────

  String get _authToken =>
      box.read<String>('auth_token') ?? '';

  // ─────────────────────────────────────────────────────────────
  // HEADERS
  // ─────────────────────────────────────────────────────────────

  Map<String, String> get _headers {
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    /// Add Authorization only for logged-in users
    if (!GuestService.isGuest &&
        _authToken.isNotEmpty) {
      headers["Authorization"] = "Bearer $_authToken";
    }

    return headers;
  }

  // ─────────────────────────────────────────────────────────────
  // FETCH RESTAURANTS
  // ─────────────────────────────────────────────────────────────

  Future<void> fetchRestaurants() async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final List list = body['data'] ?? [];

        restaurants.value =
            list.map((e) => Restaurant.fromJson(e)).toList();
      } else {
        /// API ERROR HANDLER
        final errorMessage =
        ApiErrorHandler.handleResponse(response);

        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      /// EXCEPTION HANDLER
      final errorMessage =
      ApiErrorHandler.handleException(e);

      AppSnackbar.error(errorMessage);
    } finally {
      isLoading(false);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SEARCH FILTER
  // ─────────────────────────────────────────────────────────────

  List<Restaurant> get filteredRestaurants {
    if (searchQuery.value.isEmpty) {
      return restaurants;
    }

    return restaurants.where((restaurant) {
      final name = restaurant.name.toLowerCase();
      final query = searchQuery.value.toLowerCase();

      return name.contains(query);
    }).toList();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────

  bool get isGuestUser => GuestService.isGuest;

  bool get isLoggedInUser => GuestService.isLoggedIn;
}