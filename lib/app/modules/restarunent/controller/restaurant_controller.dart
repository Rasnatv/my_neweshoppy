import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/userrestaurantmodel.dart';

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

      /// 🔐 Get token from storage
      final token = box.read('auth_token');

      if (token == null || token.isEmpty) {
        Get.snackbar("Session Expired", "Please login again");
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
        final List list = body['data'];

        restaurants.value =
            list.map((e) => Restaurant.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        Get.snackbar("Unauthorized", "Login required");
      } else {
        Get.snackbar("Error", "Failed to load restaurants");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
