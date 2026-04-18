import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/userrestaurantmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class RestaurantController extends GetxController {
  final restaurants = <Restaurant>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  final GetStorage box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurants";

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      isLoading(true);

      final token = box.read('auth_token');

      if (token == null || token.isEmpty) {
        AppSnackbar.error("Session expired. Please login again");
        return;
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List list = body['data'] ?? [];

        restaurants.value =
            list.map((e) => Restaurant.fromJson(e)).toList();
      } else {
        // ✅ API ERROR HANDLER (covers 401 also)
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      // ✅ EXCEPTION HANDLER
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading(false);
    }
  }

  /// 🔍 SEARCH FILTER
  List<Restaurant> get filteredRestaurants {
    if (searchQuery.value.isEmpty) {
      return restaurants;
    }
    return restaurants
        .where((r) =>
        r.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}