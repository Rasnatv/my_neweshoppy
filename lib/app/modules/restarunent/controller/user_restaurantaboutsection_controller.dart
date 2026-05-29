//
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../../data/errors/api_error.dart';
// import '../../merchantlogin/widget/successwidget.dart';
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
//       "https://eshoppy.co.in/api/user/restaurant/details";
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
//       final token = box.read('auth_token');
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
//         if (body['status'] == '1' || body['status'] == 1) {
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
//           final msg =
//               body['message'] ?? "Failed to load restaurant details";
//           errorMessage(msg);
//           AppSnackbar.error(msg);
//         }
//       } else {
//         final msg = ApiErrorHandler.handleResponse(response);
//         errorMessage(msg);
//         AppSnackbar.error(msg);
//       }
//     } catch (e) {
//       final msg = ApiErrorHandler.handleException(e);
//       errorMessage(msg);
//       AppSnackbar.error(msg);
//
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
import '../../userhome/widget/guestrole.dart';

class RestaurantDetailsController extends GetxController {
  // ─────────────────────────────────────────────────────────────
  // CONSTRUCTOR
  // ─────────────────────────────────────────────────────────────

  final String restaurantId;

  RestaurantDetailsController({
    required this.restaurantId,
  });

  // ─────────────────────────────────────────────────────────────
  // OBSERVABLES
  // ─────────────────────────────────────────────────────────────

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

  // ─────────────────────────────────────────────────────────────
  // STORAGE
  // ─────────────────────────────────────────────────────────────

  final GetStorage box = GetStorage();

  // ─────────────────────────────────────────────────────────────
  // API
  // ─────────────────────────────────────────────────────────────

  final String apiUrl =
      "https://eshoppy.co.in/api/user/restaurant/details";

  // ─────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    fetchRestaurantDetails();
  }

  // ─────────────────────────────────────────────────────────────
  // TOKEN
  // ─────────────────────────────────────────────────────────────

  String get _authToken =>
      box.read<String>('auth_token') ?? '';

  // ─────────────────────────────────────────────────────────────
  // HEADERS
  // ─────────────────────────────────────────────────────────────

  Map<String, String> get _headers {
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    /// Add Authorization only for logged-in users
    if (!GuestService.isGuest &&
        _authToken.isNotEmpty) {
      headers["Authorization"] =
      "Bearer $_authToken";
    }

    return headers;
  }

  // ─────────────────────────────────────────────────────────────
  // FETCH RESTAURANT DETAILS
  // ─────────────────────────────────────────────────────────────

  Future<void> fetchRestaurantDetails() async {
    try {
      isLoading(true);

      errorMessage('');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: _headers,
        body: jsonEncode({
          "restaurant_id": restaurantId,
        }),
      );

      print(
        "Details API Response Code: ${response.statusCode}",
      );

      print(
        "Details API Response Body: ${response.body}",
      );

      if (response.statusCode == 200) {
        final body =
        jsonDecode(response.body);

        if (body['status'] == '1' ||
            body['status'] == 1) {
          final data = body['data'];

          restaurantName.value =
              data['restaurant_name'] ?? '';

          address.value =
              data['address'] ?? '';

          phone.value =
              data['phone'] ?? '';

          email.value =
              data['email'] ?? '';

          website.value =
              data['website'] ?? '';

          whatsapp.value =
              data['whatsapp'] ?? '';

          facebookLink.value =
              data['facebook_link'] ?? '';

          instagramLink.value =
              data['instagram_link'] ?? '';
        } else {
          final msg =
              body['message'] ??
                  "Failed to load restaurant details";

          errorMessage(msg);

          AppSnackbar.error(msg);
        }
      } else {
        final msg =
        ApiErrorHandler.handleResponse(
          response,
        );

        errorMessage(msg);

        AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg =
      ApiErrorHandler.handleException(
        e,
      );

      errorMessage(msg);

      AppSnackbar.error(msg);

      print(
        "Restaurant Details Error: $e",
      );
    } finally {
      isLoading(false);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────

  bool get hasWebsite =>
      website.value.isNotEmpty;

  bool get hasWhatsapp =>
      whatsapp.value.isNotEmpty;

  bool get hasFacebook =>
      facebookLink.value.isNotEmpty;

  bool get hasInstagram =>
      instagramLink.value.isNotEmpty;

  bool get isGuestUser =>
      GuestService.isGuest;

  bool get isLoggedInUser =>
      GuestService.isLoggedIn;
}