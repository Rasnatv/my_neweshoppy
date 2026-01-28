// //
// // import 'dart:convert';
// // import 'package:get/get.dart';
// // import 'package:get_storage/get_storage.dart';
// // import 'package:http/http.dart' as http;
// // import '../../../data/models/user_category model.dart';
// //
// // class UserCategoryController extends GetxController {
// //   final box = GetStorage();
// //
// //   final String api =
// //       "https://rasma.astradevelops.in/e_shoppyy/public/api/usercategoriesget";
// //
// //   var isLoading = false.obs;
// //   var categories = <UserCategoryModel>[].obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     fetchCategoriesFromStorage(); // fetch automatically on app start
// //   }
// //
// //   /// Fetch categories based on saved location in GetStorage
// //   Future<void> fetchCategoriesFromStorage() async {
// //     final state = box.read('state') ?? '';
// //     final district = box.read('district') ?? '';
// //     final mainLocation = box.read('main_location') ?? '';
// //
// //     if (state.isEmpty || district.isEmpty || mainLocation.isEmpty) {
// //       categories.clear(); // no location selected yet
// //       return;
// //     }
// //
// //     await fetchCategories(
// //       state: state,
// //       district: district,
// //       mainLocation: mainLocation,
// //     );
// //   }
// //
// //   /// Fetch categories by sending state/district/mainLocation
// //   Future<void> fetchCategories({
// //     required String state,
// //     required String district,
// //     required String mainLocation,
// //   }) async {
// //     final token = box.read("auth_token");
// //     if (token == null) return;
// //
// //     try {
// //       isLoading.value = true;
// //
// //       final response = await http.post(
// //         Uri.parse(api),
// //         headers: {
// //           "Accept": "application/json",
// //           "Authorization": "Bearer $token",
// //         },
// //         body: {
// //           "state": state,
// //           "district": district,
// //           "main_location": mainLocation,
// //         },
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final decoded = json.decode(response.body);
// //         final List list = decoded['data'];
// //         categories.value =
// //             list.map((e) => UserCategoryModel.fromJson(e)).toList();
// //       } else {
// //         categories.clear();
// //       }
// //     } catch (e) {
// //       categories.clear();
// //       print("Category fetch error: $e");
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   void clearCategories() {
// //     categories.clear();
// //   }
// // }
// //
// //
// //
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../../data/models/user_category model.dart';
//
// class UserCategoryController extends GetxController {
//   final box = GetStorage();
//
//   final String api =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/usercategoriesget";
//
//   var isLoading = false.obs;
//   var categories = <UserCategoryModel>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategoriesFromStorage(); // Fetch categories automatically on app start
//   }
//
//   /// Fetch categories from saved location
//   Future<void> fetchCategoriesFromStorage() async {
//     final state = box.read('state') ?? '';
//     final district = box.read('district') ?? '';
//     final mainLocation = box.read('main_location') ?? '';
//
//     if (state.isEmpty || district.isEmpty || mainLocation.isEmpty) {
//       categories.clear(); // No location selected
//       return;
//     }
//
//     await fetchCategories(
//       state: state,
//       district: district,
//       mainLocation: mainLocation,
//     );
//   }
//
//   /// Fetch categories using POST API
//   Future<void> fetchCategories({
//     required String state,
//     required String district,
//     required String mainLocation,
//   }) async {
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
//           "state": state,
//           "district": district,
//           "main_location": mainLocation,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final List list = decoded['data'];
//         categories.value =
//             list.map((e) => UserCategoryModel.fromJson(e)).toList();
//       } else {
//         categories.clear();
//       }
//     } catch (e) {
//       categories.clear();
//       print("Category fetch error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void clearCategories() {
//     categories.clear();
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_category model.dart';


class UserCategoryController extends GetxController {
  final box = GetStorage();

  final String api =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/usercategoriesget";

  var isLoading = false.obs;
  var categories = <UserCategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoriesFromStorage();
  }

  Future<void> fetchCategoriesFromStorage() async {
    final state = box.read('state') ?? '';
    final district = box.read('district') ?? '';
    final mainLocation = box.read('main_location') ?? '';

    if (state.isEmpty || district.isEmpty || mainLocation.isEmpty) {
      categories.clear();
      return;
    }

    await fetchCategories(
      state: state,
      district: district,
      mainLocation: mainLocation,
    );
  }

  Future<void> fetchCategories({
    required String state,
    required String district,
    required String mainLocation,
  }) async {
    final token = box.read("auth_token");
    if (token == null) return;

    try {
      isLoading.value = true;

      final res = await http.post(
        Uri.parse(api),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "state": state,
          "district": district,
          "main_location": mainLocation,
        },
      );

      if (res.statusCode == 200) {
        final List list = json.decode(res.body)['data'];
        categories.value =
            list.map((e) => UserCategoryModel.fromJson(e)).toList();
      } else {
        categories.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
