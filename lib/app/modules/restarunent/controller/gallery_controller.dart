// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../../data/errors/api_error.dart';
// import '../../merchantlogin/widget/successwidget.dart';
//
// class GalleryController extends GetxController {
//   final String restaurantId;
//
//   GalleryController({required this.restaurantId});
//
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//   final restaurantImage = ''.obs;
//   final additionalImages = <String>[].obs;
//
//   final GetStorage box = GetStorage();
//
//   final String apiUrl =
//       "https://eshoppy.co.in/api/user/restaurant/images";
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchRestaurantImages();
//   }
//
//   Future<void> fetchRestaurantImages() async {
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
//       print("Gallery API Response Code: ${response.statusCode}");
//       print("Gallery API Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//
//         if (body['status'] == '1') {
//           final data = body['data'];
//
//           restaurantImage.value = data['restaurant_image'] ?? '';
//
//           if (data['additional_images'] != null) {
//             additionalImages.value =
//             List<String>.from(data['additional_images']);
//           }
//         } else {
//           errorMessage(body['message'] ?? 'Failed to load images');
//
//           // ✅ LOGICAL ERROR
//           AppSnackbar.error(errorMessage.value);
//         }
//       } else {
//         errorMessage(ApiErrorHandler.handleResponse(response));
//
//         // ✅ API ERROR HANDLER
//         AppSnackbar.error(errorMessage.value);
//       }
//     } catch (e) {
//       print("Gallery Error: $e");
//
//       errorMessage(ApiErrorHandler.handleException(e));
//
//       // ✅ EXCEPTION HANDLER
//       AppSnackbar.error(errorMessage.value);
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

class GalleryController extends GetxController {
  // ─────────────────────────────────────────────────────────────
  // CONSTRUCTOR
  // ─────────────────────────────────────────────────────────────

  final String restaurantId;

  GalleryController({
    required this.restaurantId,
  });

  // ─────────────────────────────────────────────────────────────
  // OBSERVABLES
  // ─────────────────────────────────────────────────────────────

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  final restaurantImage = ''.obs;

  final additionalImages = <String>[].obs;

  // ─────────────────────────────────────────────────────────────
  // STORAGE
  // ─────────────────────────────────────────────────────────────

  final GetStorage box = GetStorage();

  // ─────────────────────────────────────────────────────────────
  // API
  // ─────────────────────────────────────────────────────────────

  final String apiUrl =
      "https://eshoppy.co.in/api/user/restaurant/images";

  // ─────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    fetchRestaurantImages();
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
  // FETCH RESTAURANT IMAGES
  // ─────────────────────────────────────────────────────────────

  Future<void> fetchRestaurantImages() async {
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
        "Gallery API Response Code: ${response.statusCode}",
      );

      print(
        "Gallery API Response Body: ${response.body}",
      );

      if (response.statusCode == 200) {
        final body =
        jsonDecode(response.body);

        if (body['status'] == '1' ||
            body['status'] == 1) {
          final data = body['data'];

          restaurantImage.value =
              data['restaurant_image'] ?? '';

          if (data['additional_images'] !=
              null) {
            additionalImages.value =
            List<String>.from(
              data['additional_images'],
            );
          } else {
            additionalImages.clear();
          }
        } else {
          errorMessage(
            body['message'] ??
                'Failed to load images',
          );

          /// LOGICAL ERROR
          AppSnackbar.error(
            errorMessage.value,
          );
        }
      } else {
        errorMessage(
          ApiErrorHandler.handleResponse(
            response,
          ),
        );

        /// API ERROR
        AppSnackbar.error(
          errorMessage.value,
        );
      }
    } catch (e) {
      print("Gallery Error: $e");

      errorMessage(
        ApiErrorHandler.handleException(e),
      );

      /// EXCEPTION ERROR
      AppSnackbar.error(
        errorMessage.value,
      );
    } finally {
      isLoading(false);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────

  bool get hasMainImage =>
      restaurantImage.value.isNotEmpty;

  bool get hasAdditionalImages =>
      additionalImages.isNotEmpty;

  bool get isGuestUser =>
      GuestService.isGuest;

  bool get isLoggedInUser =>
      GuestService.isLoggedIn;
}