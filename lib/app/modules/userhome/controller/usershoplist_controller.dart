// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/models/categoryshoplistmodel.dart';
//
//
// class UserShoplistController extends GetxController {
//   final box = GetStorage();
//
//   final String api =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/user/shops-by-category";
//
//   var isLoading = false.obs;
//   var shops = <ShoplistModel>[].obs;
//
//   Future<void> fetchShopsByCategory(int categoryId) async {
//     final token = box.read("auth_token");
//     if (token == null) return;
//
//     try {
//       isLoading.value = true;
//
//       final response = await http.post(
//         Uri.parse(api),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: {
//           "category_id": categoryId.toString(),
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final List list = decoded['data'];
//
//         shops.value =
//             list.map((e) => ShoplistModel.fromJson(e)).toList();
//       } else {
//         shops.clear();
//       }
//     } catch (e) {
//       shops.clear();
//       print("Shop fetch error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void clearShops() {
//     shops.clear();
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/categoryshoplistmodel.dart';

class UserShoplistController extends GetxController {
  final box = GetStorage();

  final String api =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/user/shops-by-category";

  var isLoading = false.obs;
  var shops = <ShoplistModel>[].obs;

  /// Fetch shops for a category
  Future<void> fetchShopsByCategory(int categoryId) async {
    final token = box.read("auth_token");
    if (token == null) return;

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(api),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "category_id": categoryId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data'];

        // ✅ parse merchant_id as well
        shops.value = list.map((e) => ShoplistModel.fromJson(e)).toList();
      } else {
        shops.clear();
      }
    } catch (e) {
      shops.clear();
      print("Shop fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearShops() {
    shops.clear();
  }
}
