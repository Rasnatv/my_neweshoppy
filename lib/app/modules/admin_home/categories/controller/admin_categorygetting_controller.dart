// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../../data/models/admin_categorymodel.dart';
// import '../../../userhome/view/userhome.dart';
//
//
// class AdminCategoryListController extends GetxController {
//   var categories = <AdminCategoryModel>[].obs;
//   var isLoading = false.obs;
//
//   final box = GetStorage();
//   final String apiUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/categories";
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategories();
//   }
//
//   Future<void> fetchCategories() async {
//     isLoading.value = true;
//
//     final token = box.read("auth_token");
//     final role = box.read("role");
//
//     // Check if logged in as admin
//     if (token == null || token.isEmpty || role != 3) {
//       Get.snackbar("Unauthorized", "Please login as admin");
//       // Redirect to login
//       Get.offAll(() => Userhome()); // Replace with your login page if needed
//       isLoading.value = false;
//       return;
//     }
//
//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//
//         if (body['status'] == true) {
//           categories.value = List<AdminCategoryModel>.from(
//             body['data'].map((x) => AdminCategoryModel.fromJson(x)),
//           );
//         } else {
//           Get.snackbar('Error', body['message'] ?? 'Failed to fetch categories');
//         }
//       } else if (response.statusCode == 401) {
//         // Unauthorized → token expired or invalid
//         Get.snackbar("Unauthorized", "Session expired, please login again");
//         box.erase(); // Clear storage
//         Get.offAll(() => Userhome()); // Redirect to login
//       } else {
//         Get.snackbar('Error', 'Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/admin_categorymodel.dart';
import '../../../userhome/view/userhome.dart';

class AdminCategoryListController extends GetxController {
  var categories = <AdminCategoryModel>[].obs;
  var isLoading = false.obs;

  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/categories";

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;

    final token = box.read("auth_token");
    final role = box.read("role");

    if (token == null || token.isEmpty || role != 3) {
      Get.snackbar("Unauthorized", "Please login as admin");
      Get.offAll(() => Userhome());
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          categories.value = List<AdminCategoryModel>.from(
            body['data'].map((e) => AdminCategoryModel.fromJson(e)),
          );
        } else {
          Get.snackbar("Error", body['message'] ?? "Failed to load categories");
        }
      } else if (response.statusCode == 401) {
        box.erase();
        Get.snackbar("Session Expired", "Please login again");
        Get.offAll(() => Userhome());
      } else {
        Get.snackbar("Error", "Server Error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
