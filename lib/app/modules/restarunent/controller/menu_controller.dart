
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/restaurant_menumodel.dart';

class RestaurantMenuController extends GetxController {
  var isLoading = false.obs;
  var menuItems = <RestaurantMenuItem>[].obs;
  var selectedMealType = ''.obs;

  /// ✅ Only the meal types that actually have items for this restaurant
  var availableMealTypes = <Map<String, String>>[].obs;

  final box = GetStorage();
  final String apiUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/user/menu-by-meal';

  /// Full list — used only for probing on init
  final List<Map<String, String>> mealTypes = [
    {'label': 'Breakfast', 'value': 'breakfast'},
    {'label': 'Lunch', 'value': 'lunch'},
    {'label': 'Dinner', 'value': 'dinner'},
  ];

  /// Called once when the tab is first opened.
  /// Probes all meal types in parallel, then loads the first available one.
  Future<void> init(String restaurantId) async {
    isLoading(true);

    await _detectAvailableMealTypes(restaurantId);

    if (availableMealTypes.isNotEmpty) {
      // Auto-select the first tab that has items
      selectedMealType.value = availableMealTypes.first['value']!;
      await fetchMenu(restaurantId, mealType: selectedMealType.value);
    } else {
      // No items at all for this restaurant
      menuItems.clear();
      isLoading(false);
    }
  }

  /// Silently calls the API for every meal type in parallel.
  /// Adds a type to [availableMealTypes] only if it returns at least 1 item.
  Future<void> _detectAvailableMealTypes(String restaurantId) async {
    final token = box.read('auth_token');
    if (token == null) return;

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
      } catch (_) {}
      return null;
    }).toList();

    final results = await Future.wait(futures);

    // Keep original order, skip nulls (empty types)
    availableMealTypes.value =
        results.whereType<Map<String, String>>().toList();
  }

  /// Fetches menu items for a specific meal type and updates [menuItems].
  Future<void> fetchMenu(String restaurantId, {String? mealType}) async {
    try {
      isLoading(true);
      final token = box.read('auth_token');

      if (token == null) {
        Get.snackbar('Error', 'Not authenticated');
        return;
      }

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
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menu');
    } finally {
      isLoading(false);
    }
  }

  /// Called when user taps a meal type chip.
  void changeMealType(String restaurantId, String type) {
    selectedMealType.value = type;
    fetchMenu(restaurantId, mealType: type);
  }
}