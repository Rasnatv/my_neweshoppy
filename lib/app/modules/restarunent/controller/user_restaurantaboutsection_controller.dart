
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_restaurantaboumodel.dart';
//
// class RestaurantAboutController extends GetxController {
//   final box = GetStorage();
//
//   var isLoading = false.obs;
//   var aboutData = {}.obs;
//
//   Future<void> fetchAbout(String restaurantId) async {
//     try {
//       isLoading(true);
//
//       final token = box.read("auth_token");
//
//       final response = await http.post(
//         Uri.parse(
//           "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurant/details",
//         ),
//         headers: {
//           "Authorization": "Bearer $token",
//         },
//         body: {
//           "restaurant_id": restaurantId,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         if (json['status'] == "1") {
//           aboutData.value = json['data'];
//         }
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
// }
class RestaurantAboutController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  Rxn<RestaurantAboutModel> about = Rxn<RestaurantAboutModel>();

  Future<void> fetchAbout(String restaurantId) async {
    try {
      isLoading(true);

      final token = box.read("auth_token");

      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/user/restaurant/details",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: {
          "restaurant_id": restaurantId,
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == "1") {
          about.value = RestaurantAboutModel.fromJson(json['data']);
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
