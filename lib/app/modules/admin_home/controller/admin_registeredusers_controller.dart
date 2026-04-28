import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class AdminUserController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final box = GetStorage();

  String get authToken => box.read('auth_token') ?? "";

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    /// ✅ Auth check
    // if (authToken.isEmpty) {
    //   AppSnackbar.error("Session expired. Please login again");
    //   Get.offAllNamed('/login');
    //   return;
    // }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(
          "https://eshoppy.co.in/api/admin/users",
        ),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      final body = jsonDecode(response.body);

      /// ✅ Success (same logic)
      if (response.statusCode == 200 &&
          (body["status"] == 1 || body["status"] == "1")) {
        users.value = List<Map<String, dynamic>>.from(
          body["data"].map((user) {
            return {
              "id": int.tryParse(user["user_id"].toString()) ?? 0,
              "name": user["full_name"] ?? "",
              "email": user["email"] ?? "",
              "phone": user["phone"] ?? "",
              "address": user["address"] ?? "-",
              "regDate": user["registered_on"] ?? "-",
            };
          }),
        );
      } else {
        /// ✅ API Error Handler
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      /// ✅ Exception Handling
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void deleteUser(int index) {
    users.removeAt(index);

    /// ✅ Snackbar updated
    AppSnackbar.success("User removed successfully");
  }
}