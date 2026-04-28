//
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../../../data/errors/api_error.dart';
// import '../../../../../data/models/adminrestmodel.dart';
// import '../../../../merchantlogin/widget/successwidget.dart';
//
// class AdminRestaurantController extends GetxController {
//   var restaurants = <NewRestaurantModel>[].obs;
//   var isLoading = true.obs;
//   var errorMessage = ''.obs;
//
//   final box = GetStorage();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchRestaurants();
//   }
//
//   Future<void> fetchRestaurants() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       restaurants.clear();
//
//       final token = box.read("auth_token");
//
//       final url = Uri.parse("https://eshoppy.co.in/api/admin/restaurants");
//
//       final response = await http.get(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         },
//       );
//
//       if (response.statusCode != 200) {
//         final error = ApiErrorHandler.handleResponse(response);
//         errorMessage.value = error;
//         if (error.isNotEmpty) AppSnackbar.error(error);
//         return;
//       }
//
//       final body = jsonDecode(response.body);
//
//       if (body["status"].toString() == "1") {
//         final data = body["data"];
//
//         // ✅ Guard: ensure "data" is a non-null List before mapping
//         if (data != null && data is List) {
//           restaurants.value = data
//               .whereType<Map<String, dynamic>>() // skip any null/bad entries
//               .map((e) => NewRestaurantModel.fromJson(e))
//               .toList();
//         } else {
//           restaurants.value = [];
//         }
//       } else {
//         final msg = body["message"] ?? "Failed to fetch restaurants";
//         errorMessage.value = msg;
//         AppSnackbar.error(msg);
//       }
//     } catch (e) {
//       final error = ApiErrorHandler.handleException(e);
//       errorMessage.value = error;
//       AppSnackbar.error(error);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> deleteRestaurant(String restaurantId) async {
//     try {
//       final token = box.read("auth_token");
//
//       final url =
//       Uri.parse("https://eshoppy.co.in/api/delete-Restaurant");
//
//       final response = await http.delete(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({"restaurant_id": int.parse(restaurantId)}),
//       );
//
//       if (response.statusCode != 200) {
//         final error = ApiErrorHandler.handleResponse(response);
//         if (error.isNotEmpty) AppSnackbar.error(error);
//         return;
//       }
//
//       final body = jsonDecode(response.body);
//
//       if (body['status'].toString() == "1") {
//         AppSnackbar.success(body['message'] ?? "Deleted successfully");
//         restaurants.removeWhere((r) => r.id == restaurantId);
//       } else {
//         AppSnackbar.error(
//             body['message'] ?? "Failed to delete restaurant");
//       }
//     } catch (e) {
//       final error = ApiErrorHandler.handleException(e);
//       AppSnackbar.error(error);
//     }
//   }
// }
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
      final url = Uri.parse("https://eshoppy.co.in/api/admin/restaurants");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode != 200) {
        final error = ApiErrorHandler.handleResponse(response);
        errorMessage.value = error;
        if (error.isNotEmpty) AppSnackbar.error(error);
        return;
      }

      final body = jsonDecode(response.body);

      if (body["status"].toString() == "1") {
        final data = body["data"];

        // ✅ Guard: ensure "data" is a non-null List before mapping
        if (data != null && data is List) {
          restaurants.value = data
              .whereType<Map<String, dynamic>>() // skip null/bad entries
              .map((e) => NewRestaurantModel.fromJson(e))
              .toList();
        } else {
          restaurants.value = [];
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
      final url =
      Uri.parse("https://eshoppy.co.in/api/delete-Restaurant");

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
        AppSnackbar.error(
            body['message'] ?? "Failed to delete restaurant");
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    }
  }
}