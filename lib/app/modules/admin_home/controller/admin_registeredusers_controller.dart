
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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
    if (authToken.isEmpty) {
      Get.snackbar("Session Expired", "Please login again");
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/users",
        ),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (body["status"] == 1 || body["status"] == "1")) {
        users.value = List<Map<String, dynamic>>.from(
          body["data"].map((user) {
            return {
              "id": user["id"],
              "name": user["full_name"] ?? "",
              "email": user["email"] ?? "",
              "phone": user["phone"] ?? "",
              "address": user["address"] ?? "-",
              "regDate": user["registered_on"] ?? "-",
            };
          }),
        );
      } else {
        Get.snackbar(
          "Error",
          body["message"] ?? "Failed to fetch users",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  void deleteUser(int index) {
    users.removeAt(index);
    Get.snackbar("Deleted", "User removed successfully");
  }
}
