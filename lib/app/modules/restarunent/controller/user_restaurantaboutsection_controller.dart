//
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// class RestaurantDetailsController extends GetxController {
//   final String restaurantId;
//
//   RestaurantDetailsController({required this.restaurantId});
//
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//
//   final restaurantName = ''.obs;
//   final address = ''.obs;
//   final phone = ''.obs;
//   final email = ''.obs;
//   final website = ''.obs;
//   final whatsapp = ''.obs;
//   final facebookLink = ''.obs;
//   final instagramLink = ''.obs;
//
//   final GetStorage box = GetStorage();
//
//   final String apiUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurant/details";
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchRestaurantDetails();
//   }
//
//   Future<void> fetchRestaurantDetails() async {
//     try {
//       isLoading(true);
//       errorMessage('');
//
//       /// 🔐 Get token from storage
//       final token = box.read('auth_token');
//
//       if (token == null || token.isEmpty) {
//         errorMessage('Session expired. Please login again.');
//         return;
//       }
//
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "restaurant_id": restaurantId,
//         }),
//       );
//
//       print("Details API Response Code: ${response.statusCode}");
//       print("Details API Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//
//         if (body['status'] == '1') {
//           final data = body['data'];
//
//           restaurantName.value = data['restaurant_name'] ?? '';
//           address.value = data['address'] ?? '';
//           phone.value = data['phone'] ?? '';
//           email.value = data['email'] ?? '';
//           website.value = data['website'] ?? '';
//           whatsapp.value = data['whatsapp'] ?? '';
//           facebookLink.value = data['facebook_link'] ?? '';
//           instagramLink.value = data['instagram_link'] ?? '';
//         } else {
//           errorMessage('Failed to load restaurant details');
//         }
//       } else if (response.statusCode == 401) {
//         errorMessage('Unauthorized. Please login again.');
//       } else {
//         errorMessage('Failed to load restaurant details');
//       }
//     } catch (e) {
//       print("Details Error: $e");
//       errorMessage('Error: ${e.toString()}');
//     } finally {
//       isLoading(false);
//     }
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class RestaurantDetailsController extends GetxController {
  final String restaurantId;

  RestaurantDetailsController({required this.restaurantId});

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final restaurantName = ''.obs;
  final address = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final website = ''.obs;
  final whatsapp = ''.obs;
  final facebookLink = ''.obs;
  final instagramLink = ''.obs;

  final GetStorage box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurant/details";

  @override
  void onInit() {
    super.onInit();
    fetchRestaurantDetails();
  }

  Future<void> fetchRestaurantDetails() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = box.read('auth_token');

      if (token == null || token.isEmpty) {
        final msg = "Session expired. Please login again.";
        errorMessage(msg);
        AppSnackbar.error(msg);
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "restaurant_id": restaurantId,
        }),
      );

      print("Details API Response Code: ${response.statusCode}");
      print("Details API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == '1' || body['status'] == 1) {
          final data = body['data'];

          restaurantName.value = data['restaurant_name'] ?? '';
          address.value = data['address'] ?? '';
          phone.value = data['phone'] ?? '';
          email.value = data['email'] ?? '';
          website.value = data['website'] ?? '';
          whatsapp.value = data['whatsapp'] ?? '';
          facebookLink.value = data['facebook_link'] ?? '';
          instagramLink.value = data['instagram_link'] ?? '';
        } else {
          final msg =
              body['message'] ?? "Failed to load restaurant details";
          errorMessage(msg);
          AppSnackbar.error(msg);
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        errorMessage(msg);
        AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      errorMessage(msg);
      AppSnackbar.error(msg);

      print("Details Error: $e");
    } finally {
      isLoading(false);
    }
  }
}