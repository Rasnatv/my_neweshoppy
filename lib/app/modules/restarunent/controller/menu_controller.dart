import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/restaurant_menumodel.dart';


class RestaurantMenuController extends GetxController {
  var isLoading = false.obs;
  var menuItems = <RestaurantMenuItem>[].obs;
  var selectedMealType = 'breakfast'.obs;

  final box = GetStorage();
  final String apiUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/user/menu-by-meal';

  final List<Map<String, String>> mealTypes = [
    {'label': 'Breakfast', 'value': 'breakfast'},
    {'label': 'Lunch', 'value': 'lunch'},
    {'label': 'Dinner', 'value': 'dinner'},
  ];

  void init(String restaurantId) {
    fetchMenu(restaurantId);
  }

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

  void changeMealType(String restaurantId, String type) {
    selectedMealType.value = type;
    fetchMenu(restaurantId, mealType: type);
  }
}