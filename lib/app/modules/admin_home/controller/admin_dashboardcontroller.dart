
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class AdminDashboardController extends GetxController {
  final RxString totalMerchants = '0'.obs;
  final RxString totalUsers = '0'.obs;
  final RxString totalProducts = '0'.obs;
  final RxBool isLoading = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardCounts();
  }

  Future<void> fetchDashboardCounts() async {
    try {
      isLoading.value = true;

      final String? token = box.read('auth_token');

      /// ✅ TOKEN EMPTY → FORCE LOGIN
      if (token == null || token.toString().isEmpty) {
        AppSnackbar.error("Session expired. Please login again");
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://eshoppy.co.in/api/dashboard-counts',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      /// ✅ SUCCESS
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          totalMerchants.value =
              data['total_merchants']?.toString() ?? '0';
          totalUsers.value =
              data['total_users']?.toString() ?? '0';
          totalProducts.value =
              data['total_products']?.toString() ?? '0';

          AppSnackbar.success("Dashboard loaded successfully");
        } else {
          AppSnackbar.warning(
            jsonData['message'] ?? "No data available",
          );
        }
      }

      /// ❌ HANDLE ALL API ERRORS FROM ONE PLACE
      else {
        final errorMessage =
        ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      /// ❌ HANDLE EXCEPTIONS (NO INTERNET etc.)
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}