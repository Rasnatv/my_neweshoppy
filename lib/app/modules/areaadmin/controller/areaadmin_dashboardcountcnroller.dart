
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../widgets/areaadminsuccesswidget.dart';

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

      /// ✅ 1. Token check
      String? token = box.read('auth_token');

      // if (token == null || token.toString().isEmpty) {
      //   ApiErrorHandler.handleUnauthorized();
      //   return;
      // }

      /// ✅ 2. API Call
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );


      /// ✅ 3. Success
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        totalEvents.value = data['data']['total_events'] ?? 0;
        totalAdvertisements.value =
            data['data']['total_advertisements'] ?? 0;

      } else {
        /// ❌ 4. Handle API Errors centrally
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbarss.error(errorMessage);
      }

    } catch (e) {

      /// ❌ 6. Other Exceptions
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbarss.error(errorMessage);

    } finally {
      isLoading(false);
    }
  }
}