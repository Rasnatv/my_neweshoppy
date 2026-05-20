import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class GalleryController extends GetxController {
  final String restaurantId;

  GalleryController({required this.restaurantId});

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final restaurantImage = ''.obs;
  final additionalImages = <String>[].obs;

  final GetStorage box = GetStorage();

  final String apiUrl =
      "https://eshoppy.co.in/api/user/restaurant/images";

  @override
  void onInit() {
    super.onInit();
    fetchRestaurantImages();
  }

  Future<void> fetchRestaurantImages() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = box.read('auth_token');

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

      print("Gallery API Response Code: ${response.statusCode}");
      print("Gallery API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == '1') {
          final data = body['data'];

          restaurantImage.value = data['restaurant_image'] ?? '';

          if (data['additional_images'] != null) {
            additionalImages.value =
            List<String>.from(data['additional_images']);
          }
        } else {
          errorMessage(body['message'] ?? 'Failed to load images');

          // ✅ LOGICAL ERROR
          AppSnackbar.error(errorMessage.value);
        }
      } else {
        errorMessage(ApiErrorHandler.handleResponse(response));

        // ✅ API ERROR HANDLER
        AppSnackbar.error(errorMessage.value);
      }
    } catch (e) {
      print("Gallery Error: $e");

      errorMessage(ApiErrorHandler.handleException(e));

      // ✅ EXCEPTION HANDLER
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading(false);
    }
  }
}