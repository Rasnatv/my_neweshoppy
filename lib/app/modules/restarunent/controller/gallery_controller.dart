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
//           "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurant/images");
//
//       final response = await http.post(
//         url,
//         body: {"restaurant_id": restaurantId},
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == "1") {
//           final images = data['data']['additional_images'] as List<dynamic>;
//           additionalImages.value = images.map((e) => e.toString()).toList();
//         } else {
//           errorMessage.value = data['message'] ?? 'Failed to fetch images';
//         }
//       } else {
//         errorMessage.value = 'Server error: ${response.statusCode}';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GalleryController extends GetxController {
  final String restaurantId;

  GalleryController({required this.restaurantId});

  var isLoading = true.obs;
  var restaurantImage = ''.obs; // ✅ MAIN IMAGE
  var additionalImages = <String>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGalleryImages();
  }

  Future<void> fetchGalleryImages() async {
    try {
      final url = Uri.parse(
        "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurant/images",
      );

      final response = await http.post(
        url,
        body: {
          "restaurant_id": restaurantId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == "1") {
          // ✅ MAIN IMAGE
          restaurantImage.value =
              data['data']['restaurant_image'] ?? '';

          // ✅ ADDITIONAL IMAGES
          final images =
          data['data']['additional_images'] as List<dynamic>;
          additionalImages.value =
              images.map((e) => e.toString()).toList();
        } else {
          errorMessage.value =
              data['message'] ?? 'Failed to fetch images';
        }
      } else {
        errorMessage.value =
        'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
