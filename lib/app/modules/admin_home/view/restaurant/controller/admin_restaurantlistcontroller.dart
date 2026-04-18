
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../../data/errors/api_error.dart';
import '../../../../../data/models/adminrestmodel.dart';
import '../../../../merchantlogin/widget/successwidget.dart';

class AdminRestaurantController extends GetxController {
  var restaurants = <NewRestaurantModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      restaurants.clear();

      final token = box.read("auth_token");

      // ✅ Token check
      if (token == null || token
          .toString()
          .isEmpty) {
        errorMessage.value = "Session expired. Please login again";
        AppSnackbar.error(errorMessage.value);
        return;
      }

      final url = Uri.parse(
        "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurants",
      );

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      // ✅ Handle non-200 responses
      if (response.statusCode != 200) {
        final error = ApiErrorHandler.handleResponse(response);
        errorMessage.value = error;

        if (error.isNotEmpty) {
          AppSnackbar.error(error);
        }
        return;
      }

      final body = jsonDecode(response.body);

      if (body["status"].toString() == "1") {
        restaurants.value = (body["data"] as List)
            .map((e) => NewRestaurantModel.fromJson(e))
            .toList();

        // Optional UX improvement
        if (restaurants.isEmpty) {
          AppSnackbar.warning("No restaurants found");
        }
      } else {
        final msg = body["message"] ?? "Failed to fetch restaurants";
        errorMessage.value = msg;
        AppSnackbar.error(msg);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      errorMessage.value = error;
      AppSnackbar.error(error);
    } finally {
      isLoading.value = false;
    }
  }
    Future<void> deleteRestaurant(String restaurantId) async {
      try {
        final token = box.read("auth_token");

        final url = Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/delete-Restaurant",
        );

        final response = await http.delete(
          url,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: jsonEncode({"restaurant_id": int.parse(restaurantId)}),
        );

        if (response.statusCode != 200) {
          final error = ApiErrorHandler.handleResponse(response);
          if (error.isNotEmpty) AppSnackbar.error(error);
          return;
        }

        final body = jsonDecode(response.body);

        if (body['status'].toString() == "1") {
          AppSnackbar.success(body['message'] ?? "Deleted successfully");
          restaurants.removeWhere((r) => r.id == restaurantId);
        } else {
          AppSnackbar.error(body['message'] ?? "Failed to delete restaurant");
        }
      } catch (e) {
        final error = ApiErrorHandler.handleException(e);
        AppSnackbar.error(error);
      }
    }
  }

