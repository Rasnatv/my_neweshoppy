
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../widgets/areaadminsuccesswidget.dart';


class DistrictAdminDashboardController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;

  var totalEvents = 0.obs;
  var totalAdvertisements = 0.obs;

  final String url =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/district-admin/dashboard-count";

  String get token => box.read('auth_token') ?? '';

  Map<String, String> get headers => {
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  };

  @override
  void onInit() {
    fetchDashboardCount();
    super.onInit();
  }

  Future<void> fetchDashboardCount() async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        totalEvents.value = data['data']['total_events'] ?? 0;
        totalAdvertisements.value =
            data['data']['total_advertisements'] ?? 0;

      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      print("ERROR: $e");
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading(false);
    }
  }
}