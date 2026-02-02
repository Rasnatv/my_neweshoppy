//
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/models/user_category model.dart';
//
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
//     fetchCategoriesFromStorage();
//   }
//
//   Future<void> fetchCategoriesFromStorage() async {
//     final state = box.read('state') ?? '';
//     final district = box.read('district') ?? '';
//     final mainLocation = box.read('main_location') ?? '';
//
//     if (state.isEmpty || district.isEmpty || mainLocation.isEmpty) {
//       categories.clear();
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
//       final res = await http.post(
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
//       if (res.statusCode == 200) {
//         final List list = json.decode(res.body)['data'];
//         categories.value =
//             list.map((e) => UserCategoryModel.fromJson(e)).toList();
//       } else {
//         categories.clear();
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_category model.dart';
import 'district _controller.dart';

class UserCategoryController extends GetxController {
  final box = GetStorage();

  final String api =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/usercategoriesget";

  var isLoading = false.obs;
  var categories = <UserCategoryModel>[].obs;

  late UserLocationController locationController;

  @override
  void onInit() {
    super.onInit();

    // 🔗 Link location controller
    locationController = Get.find<UserLocationController>();

    // 🔥 React when location changes
    ever(locationController.selectedMainLocation, (_) {
      fetchCategoriesFromStorage();
    });

    // 🔁 Load categories on restart
    fetchCategoriesFromStorage();
  }

  Future<void> fetchCategoriesFromStorage() async {
    final token = box.read('auth_token');
    if (token == null) return;

    final state = box.read('state_$token') ?? '';
    final district = box.read('district_$token') ?? '';
    final mainLocation = box.read('main_location_$token') ?? '';

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
