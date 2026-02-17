
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../../data/models/adminrestmodel.dart';


class AdminRestaurantController extends GetxController {
  var restaurants = <NewRestaurantModel>[].obs;
  var isLoading = true.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    isLoading.value = true;

    final token = box.read("auth_token");
    if (token == null) {
      Get.snackbar("Error", "Auth token not found. Please login again.");
      isLoading.value = false;
      return;
    }

    final url = Uri.parse(
      "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurants",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body["status"].toString() == "1") {
          restaurants.value = (body["data"] as List)
              .map((e) => NewRestaurantModel.fromJson(e))
              .toList();
        } else {
          Get.snackbar("Error", body["message"] ?? "Failed to fetch restaurants");
        }
      } else {
        Get.snackbar("Error", "Server returned ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
