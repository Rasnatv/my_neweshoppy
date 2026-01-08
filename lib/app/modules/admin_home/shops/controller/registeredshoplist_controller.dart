import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../data/models/registeredshopsmodel.dart';

class AdminShopController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var shopList = <Shop>[].obs;

  final String apiUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/merc/reg/shop';

  @override
  void onInit() {
    super.onInit();
    fetchShops();
  }

  Future<void> fetchShops() async {
    try {
      isLoading(true);

      final token = box.read('auth_token');

      if (token == null) {
        Get.snackbar("Error", "Auth token missing. Please login again.");
        return;
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token", // 🔥 REQUIRED
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true) {
          shopList.value = List<Shop>.from(
            decoded['data'].map((e) => Shop.fromJson(e)),
          );
        } else {
          Get.snackbar("Error", decoded['message'] ?? "Failed to load shops");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Unauthorized", "Session expired. Login again.");
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
