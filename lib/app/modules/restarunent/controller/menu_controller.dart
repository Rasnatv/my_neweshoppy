
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/restaurant_menumodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class RestaurantMenuController extends GetxController {
  var isLoading         = false.obs;
  var isInitialized     = false.obs;
  var menuItems         = <RestaurantMenuItem>[].obs;
  var selectedMealType  = ''.obs;
  var emptyMessage      = 'No items available'.obs;

  /// ✅ Only meal types that actually returned data
  var availableMealTypes = <Map<String, String>>[].obs;

  final box    = GetStorage();
  final String apiUrl = 'https://eshoppy.co.in/api/user/menu-by-meal';

  final List<Map<String, String>> mealTypes = [
    {'label': 'Breakfast', 'value': 'breakfast'},
    {'label': 'Lunch',     'value': 'lunch'},
    {'label': 'Dinner',    'value': 'dinner'},
  ];

  Future<void> init(String restaurantId) async {
    if (isInitialized.value || isLoading.value) return;
    isInitialized(true);
    isLoading(true);

    final token = box.read('auth_token');

    // ── probe all 3 in parallel ──────────────────────────────────────────
    final futures = mealTypes.map((type) async {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept':        'application/json',
            'Content-Type':  'application/json',
          },
          body: jsonEncode({
            'restaurant_id': int.tryParse(restaurantId) ?? 0,
            'meal_type':     type['value'],
          }),
        );

        final decoded = jsonDecode(response.body);
        final hasData =
            (decoded['status'] == '1' || decoded['status'] == 1) &&
                (decoded['data'] as List?)?.isNotEmpty == true;

        return {
          'type':    type,
          'hasData': hasData,
          'decoded': decoded,
        };
      } catch (_) {
        return {'type': type, 'hasData': false, 'decoded': null};
      }
    }).toList();

    final results = await Future.wait(futures);

    // ── only keep types that have actual data ────────────────────────────
    final available = results.where((r) => r['hasData'] == true).toList();
    availableMealTypes.value = available
        .map((r) => r['type'] as Map<String, String>)
        .toList();

    if (available.isNotEmpty) {
      // auto-select first available and reuse its response (no extra call)
      final first   = available.first;
      final type    = first['type'] as Map<String, String>;
      final decoded = first['decoded'] as Map<String, dynamic>;

      selectedMealType.value = type['value']!;
      final List data = decoded['data'] ?? [];
      menuItems.value =
          data.map((e) => RestaurantMenuItem.fromJson(e)).toList();
    } else {
      menuItems.clear();
      emptyMessage.value = 'No menu available for this restaurant';
    }

    isLoading(false);
  }

  Future<void> fetchMenu(String restaurantId, {String? mealType}) async {
    try {
      isLoading(true);
      menuItems.clear();
      emptyMessage.value = 'No items available';

      final token = box.read('auth_token');
      final type  = mealType ?? selectedMealType.value;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept':        'application/json',
          'Content-Type':  'application/json',
        },
        body: jsonEncode({
          'restaurant_id': int.tryParse(restaurantId) ?? 0,
          'meal_type':     type,
        }),
      );

      final decoded = jsonDecode(response.body);
      final isSuccess =
          (decoded['status'] == '1' || decoded['status'] == 1) &&
              (decoded['data'] as List?)?.isNotEmpty == true;

      if (isSuccess) {
        final List data = decoded['data'] ?? [];
        menuItems.value =
            data.map((e) => RestaurantMenuItem.fromJson(e)).toList();
      } else {
        emptyMessage.value =
            decoded['message'] ?? 'No items available for this meal type';
        menuItems.clear();
      }
    } catch (e) {
      emptyMessage.value = 'Something went wrong. Please try again.';
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading(false);
    }
  }

  void changeMealType(String restaurantId, String type) {
    if (selectedMealType.value == type && menuItems.isNotEmpty) return;
    selectedMealType.value = type;
    fetchMenu(restaurantId, mealType: type);
  }
}