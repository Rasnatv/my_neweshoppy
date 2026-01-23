import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/user_eventmodel.dart';


class UserEventController extends GetxController {
  final RxList<UserEventModel> events = <UserEventModel>[].obs;
  final RxBool isLoading = false.obs;

  final GetStorage box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/userevents";

  @override
  void onInit() {
    super.onInit();
    fetchEvents(); // auto load
  }

  Future<void> fetchEvents() async {
    try {
      isLoading(true);

      final token = box.read("auth_token");

      if (token == null || token.toString().isEmpty) {
        events.clear();
        return;
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token", // 🔑 token used
        },
      );

      final decoded = jsonDecode(response.body);

      if (decoded['status'] == "1") {
        events.value = (decoded['data'] as List)
            .map((e) => UserEventModel.fromJson(e))
            .toList();
      } else {
        events.clear();
      }
    } catch (e) {
      Get.log("UserEvent error: $e");
    } finally {
      isLoading(false);
    }
  }
}
