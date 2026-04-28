import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/restaurant_menumodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class RestaurantMenuController extends GetxController {
  var isLoading = false.obs;
  var menuItems = <RestaurantMenuItem>[].obs;
  var selectedMealType = ''.obs;

  var availableMealTypes = <Map<String, String>>[].obs;

  final box = GetStorage();
  final String apiUrl =
      'https://eshoppy.co.in/api/user/menu-by-meal';

  final List<Map<String, String>> mealTypes = [
    {'label': 'Breakfast', 'value': 'breakfast'},
    {'label': 'Lunch', 'value': 'lunch'},
    {'label': 'Dinner', 'value': 'dinner'},
  ];

  Future<void> init(String restaurantId) async {
    isLoading(true);

    await _detectAvailableMealTypes(restaurantId);

    if (availableMealTypes.isNotEmpty) {
      selectedMealType.value = availableMealTypes.first['value']!;
      await fetchMenu(restaurantId, mealType: selectedMealType.value);
    } else {
      menuItems.clear();
      isLoading(false);
    }
  }

  Future<void> _detectAvailableMealTypes(String restaurantId) async {
    final token = box.read('auth_token');

    final futures = mealTypes.map((type) async {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'restaurant_id': int.tryParse(restaurantId) ?? 0,
            'meal_type': type['value'],
          }),
        );

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final hasData =
              (decoded['status'] == '1' || decoded['status'] == 1) &&
                  (decoded['data'] as List?)?.isNotEmpty == true;
          return hasData ? type : null;
        }
      } catch (_) {
        // ❌ silent (no UI error — as per original logic)
      }
      return null;
    }).toList();

    final results = await Future.wait(futures);
    availableMealTypes.value =
        results.whereType<Map<String, String>>().toList();
  }

  Future<void> fetchMenu(String restaurantId, {String? mealType}) async {
    try {
      isLoading(true);
      final token = box.read('auth_token');

      final type = mealType ?? selectedMealType.value;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'restaurant_id': int.tryParse(restaurantId) ?? 0,
          'meal_type': type,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == '1' || decoded['status'] == 1) {
          final List data = decoded['data'] ?? [];
          menuItems.value =
              data.map((e) => RestaurantMenuItem.fromJson(e)).toList();
        } else {
          menuItems.clear();

          // ✅ logical error
          final message = decoded['message'] ?? 'No menu found';
          AppSnackbar.error(message);
        }
      } else {
        // ✅ API error handler
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      // ✅ exception handler
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading(false);
    }
  }

  void changeMealType(String restaurantId, String type) {
    selectedMealType.value = type;
    fetchMenu(restaurantId, mealType: type);
  }
}