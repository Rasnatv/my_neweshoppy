// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// //
// // class GalleryController extends GetxController {
// //   final String restaurantId;
// //
// //   GalleryController({required this.restaurantId});
// //
// //   var isLoading = true.obs;
// //   var additionalImages = <String>[].obs;
// //   var errorMessage = ''.obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     fetchGalleryImages();
// //   }
// //
// //   Future<void> fetchGalleryImages() async {
// //     try {
// //       final url = Uri.parse(
// //           "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurant/images");
// //
// //       final response = await http.post(
// //         url,
// //         body: {"restaurant_id": restaurantId},
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         if (data['status'] == "1") {
// //           final images = data['data']['additional_images'] as List<dynamic>;
// //           additionalImages.value = images.map((e) => e.toString()).toList();
// //         } else {
// //           errorMessage.value = data['message'] ?? 'Failed to fetch images';
// //         }
// //       } else {
// //         errorMessage.value = 'Server error: ${response.statusCode}';
// //       }
// //     } catch (e) {
// //       errorMessage.value = 'Error: $e';
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// // }
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class GalleryController extends GetxController {
//   final String restaurantId;
//
//   GalleryController({required this.restaurantId});
//
//   var isLoading = true.obs;
//   var restaurantImage = ''.obs; // ✅ MAIN IMAGE
//   var additionalImages = <String>[].obs;
//   var errorMessage = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchGalleryImages();
//   }
//
//   Future<void> fetchGalleryImages() async {
//     try {
//       final url = Uri.parse(
//         "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurant/images",
//       );
//
//       final response = await http.post(
//         url,
//         body: {
//           "restaurant_id": restaurantId,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['status'] == "1") {
//           // ✅ MAIN IMAGE
//           restaurantImage.value =
//               data['data']['restaurant_image'] ?? '';
//
//           // ✅ ADDITIONAL IMAGES
//           final images =
//           data['data']['additional_images'] as List<dynamic>;
//           additionalImages.value =
//               images.map((e) => e.toString()).toList();
//         } else {
//           errorMessage.value =
//               data['message'] ?? 'Failed to fetch images';
//         }
//       } else {
//         errorMessage.value =
//         'Server error: ${response.statusCode}';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class GalleryController extends GetxController {
  final String restaurantId;

  GalleryController({required this.restaurantId});

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final restaurantImage = ''.obs;
  final additionalImages = <String>[].obs;

  final GetStorage box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurant/images";

  @override
  void onInit() {
    super.onInit();
    fetchRestaurantImages();
  }

  Future<void> fetchRestaurantImages() async {
    try {
      isLoading(true);
      errorMessage('');

      /// 🔐 Get token from storage
      final token = box.read('auth_token');

      if (token == null || token.isEmpty) {
        errorMessage('Session expired. Please login again.');
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

      print("Gallery API Response Code: ${response.statusCode}");
      print("Gallery API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == '1') {
          final data = body['data'];

          // Set main restaurant image
          restaurantImage.value = data['restaurant_image'] ?? '';

          // Set additional images
          if (data['additional_images'] != null) {
            additionalImages.value = List<String>.from(data['additional_images']);
          }
        } else {
          errorMessage('Failed to load images');
        }
      } else if (response.statusCode == 401) {
        errorMessage('Unauthorized. Please login again.');
      } else {
        errorMessage('Failed to load gallery images');
      }
    } catch (e) {
      print("Gallery Error: $e");
      errorMessage('Error: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}
