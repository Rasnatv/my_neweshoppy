import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AreaAdminDashboardController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;

  var totalEvents = 0.obs;
  var totalAdvertisements = 0.obs;

  final String url =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/dashboard-count";

  @override
  void onInit() {
    fetchDashboardCount();
    super.onInit();
  }

  Future<void> fetchDashboardCount() async {
    try {
      isLoading(true);

      String? token = box.read('auth_token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        totalEvents.value = data['data']['total_events'] ?? 0;
        totalAdvertisements.value =
            data['data']['total_advertisements'] ?? 0;
      } else {
        Get.snackbar("Error", "Failed to load dashboard data");
      }
    } catch (e) {
      print("ERROR: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }
}