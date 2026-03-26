
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminEventGetController extends GetxController {
  var events = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/eventss";

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;

      final token = box.read('auth_token');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['data'] != null) {
        events.value =
        List<Map<String, dynamic>>.from(data['data']);
      } else {
        events.clear();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load events");
    } finally {
      isLoading.value = false;
    }
  }

}
